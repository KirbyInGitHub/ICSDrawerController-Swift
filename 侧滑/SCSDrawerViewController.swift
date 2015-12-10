//
//  SCSDrawerViewController.swift
//  侧滑
//
//  Created by 张鹏 on 15/12/5.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

private let kICSDrawerControllerDrawerDepth:CGFloat = UIScreen.mainScreen().bounds.width - 90
private let kICSDrawerControllerLeftViewInitialOffset:CGFloat = -60.0
private let kICSDrawerControllerAnimationDuration:NSTimeInterval = 0.5
private let kICSDrawerControllerOpeningAnimationSpringDamping:CGFloat = 0.7
private let kICSDrawerControllerOpeningAnimationSpringInitialVelocity:CGFloat = 0.1
private let kICSDrawerControllerClosingAnimationSpringDamping:CGFloat = 1.0
private let kICSDrawerControllerClosingAnimationSpringInitialVelocity:CGFloat = 0.5

enum SCSDrawerControllerState {
    case Closed
    case Opening
    case Open
    case Closing
}

protocol SCSDrawerControllerChild:NSObjectProtocol {
    
    var drawer:SCSDrawerViewController? {get set}
}

protocol SCSDrawerControllerPresenting:NSObjectProtocol {
    
    func drawerControllerWillOpen(drawerController:SCSDrawerViewController)
    
    func drawerControllerDidOpen(drawerController:SCSDrawerViewController)
    
    func drawerControllerWillClose(drawerController:SCSDrawerViewController)
    
    func drawerControllerDidClose(drawerController:SCSDrawerViewController)
}

class SCSDrawerViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var leftViewController:protocol<SCSDrawerControllerChild,SCSDrawerControllerPresenting>!
    var centerViewController:protocol<SCSDrawerControllerChild,SCSDrawerControllerPresenting>!
    
    private var leftView:UIView!
    private var centerView:SCSDropShadowView!
    
    private var tapGestureRecognizer:UITapGestureRecognizer!
    private var screenEdgepanGestureRecognizer:UIScreenEdgePanGestureRecognizer!
    private var panGestureRecognizer:UIPanGestureRecognizer!
    
    private var panGestureStartLocation:CGPoint?
    
    private var drawerState:SCSDrawerControllerState?
    
    init(leftViewController:protocol<SCSDrawerControllerChild,SCSDrawerControllerPresenting>,centerViewController:protocol<SCSDrawerControllerChild,SCSDrawerControllerPresenting>!) {
        super.init(nibName: nil, bundle: nil)
        
        self.leftViewController = leftViewController
        self.centerViewController = centerViewController
        
        drawerState = SCSDrawerControllerState.Closed
        
        if self.leftViewController.respondsToSelector("setDrawer:") {
            self.leftViewController.drawer = self
        }
        if self.centerViewController.respondsToSelector("setDrawer:") {
            self.centerViewController.drawer = self
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCenterViewController() {
        
        addChildViewController(self.centerViewController as! UIViewController)
        (centerViewController as! UIViewController).view.frame = self.view.bounds
        centerView.addSubview((centerViewController as! UIViewController).view)
        (centerViewController as! UIViewController).didMoveToParentViewController(self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.autoresizingMask = UIViewAutoresizing.init(rawValue: 2 | 5)
//        self.view.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.leftView = UIView(frame: view.bounds)
        self.centerView = SCSDropShadowView(frame: view.bounds)
        self.leftView.autoresizingMask = self.view.autoresizingMask
        self.centerView.autoresizingMask = self.view.autoresizingMask
        
        view.addSubview(centerView)
        addCenterViewController()
        
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGestureRecognized:")
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        
        screenEdgepanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "panGestureRecognized:")
        screenEdgepanGestureRecognizer.edges = UIRectEdge.Left
//        screenEdgepanGestureRecognizer.cancelsTouchesInView = true
        screenEdgepanGestureRecognizer.delegate = self
        
//        centerView.addGestureRecognizer(panGestureRecognizer)
        centerView.addGestureRecognizer(screenEdgepanGestureRecognizer)
    }
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        
        if drawerState == SCSDrawerControllerState.Opening {
            return leftViewController as? UIViewController
        }
        return centerViewController as? UIViewController
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        
        if drawerState == SCSDrawerControllerState.Opening {
            return leftViewController as? UIViewController
        }
        return centerViewController as? UIViewController
    }
    
    private func addClosingGestureRecognizers() {
    
        centerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func removeClosingGestureRecognizers() {
        
        centerView.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    func removeOpeningGestureRecognizers() {
        
        centerView.removeGestureRecognizer(panGestureRecognizer)
    }
    
    func addOpeningGestureRecognizers() {
        
        centerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func tapGestureRecognized(tapGestureRecognizer:UITapGestureRecognizer) {
        
        if tapGestureRecognizer.state == UIGestureRecognizerState.Ended {
            close()
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let velocity = (gestureRecognizer as? UIPanGestureRecognizer)?.velocityInView(view)
        
        if drawerState == SCSDrawerControllerState.Closed && velocity?.x > 0.0 {
            return true
        } else if drawerState == SCSDrawerControllerState.Open && velocity?.x < 0.0 {
            return true
        }
        return false
    }
    
    @objc private func panGestureRecognized(panGestureRecognizer:UIPanGestureRecognizer) {
        
        let state = panGestureRecognizer.state
        let location = panGestureRecognizer.locationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        switch(state) {
        case UIGestureRecognizerState.Began:
            panGestureStartLocation = location
            if drawerState == SCSDrawerControllerState.Closed {
                willOpen()
            } else {
                willClose()
            }
            break
            
        case UIGestureRecognizerState.Changed:
            var delta:CGFloat = 0.0
            if drawerState == SCSDrawerControllerState.Opening {
                delta = location.x - self.panGestureStartLocation!.x
            } else if drawerState == SCSDrawerControllerState.Closing {
                delta = kICSDrawerControllerDrawerDepth - (self.panGestureStartLocation!.x - location.x)
            }
            var l = leftView.frame
            var c = centerView.frame
            if delta > kICSDrawerControllerDrawerDepth {
                l.origin.x = 0.0
                c.origin.x = kICSDrawerControllerDrawerDepth;
            }
            else if delta < 0.0 {
                l.origin.x = kICSDrawerControllerLeftViewInitialOffset;
                c.origin.x = 0.0
            }
            else {
                l.origin.x = kICSDrawerControllerLeftViewInitialOffset
                    - (delta * kICSDrawerControllerLeftViewInitialOffset) / kICSDrawerControllerDrawerDepth
                
                c.origin.x = delta
            }
            self.leftView.frame = l
            self.centerView.frame = c
            break
            
        case UIGestureRecognizerState.Ended:
            if drawerState == SCSDrawerControllerState.Opening {
                let centerViewLocation = centerView.frame.origin.x
                if centerViewLocation == kICSDrawerControllerDrawerDepth {
                    setNeedsStatusBarAppearanceUpdate()
                    didOpen()

                } else if (centerViewLocation > self.view.bounds.size.width / 3 && velocity.x > 0.0) {
                    animateOpening()
                    
                } else {
                    didOpen()
                    willClose()
                    animateClosing()
                }
                
            } else if drawerState == SCSDrawerControllerState.Closing {
                let centerViewLocation = self.centerView.frame.origin.x
                if centerViewLocation == 0.0 {

                    setNeedsStatusBarAppearanceUpdate()
                    didClose()
                } else if centerViewLocation < (2 * self.view.bounds.size.width) / 3 && velocity.x < 0.0 {

                        animateClosing()
                } else {

                    didClose()

                    let l = self.leftView.frame
                    willOpen()
                    self.leftView.frame = l
                    
                    animateOpening()
                }
            }
            break
            
        default :break
        }
        
    }
    
    private func animateOpening() {
        
        let leftViewFinalFrame = self.view.bounds;
        var centerViewFinalFrame = self.view.bounds;
        centerViewFinalFrame.origin.x = kICSDrawerControllerDrawerDepth;
        
        UIView.animateWithDuration(kICSDrawerControllerAnimationDuration, delay: 0, usingSpringWithDamping: kICSDrawerControllerOpeningAnimationSpringDamping, initialSpringVelocity: kICSDrawerControllerOpeningAnimationSpringInitialVelocity, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.centerView.frame = centerViewFinalFrame
            self.leftView.frame = leftViewFinalFrame
            
            self.setNeedsStatusBarAppearanceUpdate()
            
            }) { (finished) -> Void in
                
                self.didOpen()
        }
        
    }
    
    private func animateClosing() {
        
        var leftViewFinalFrame = self.leftView.frame
        leftViewFinalFrame.origin.x = kICSDrawerControllerLeftViewInitialOffset
        let centerViewFinalFrame = self.view.bounds
        
        UIView.animateWithDuration(kICSDrawerControllerAnimationDuration, delay: 0, usingSpringWithDamping: kICSDrawerControllerClosingAnimationSpringDamping, initialSpringVelocity: kICSDrawerControllerClosingAnimationSpringInitialVelocity, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.centerView.frame = centerViewFinalFrame
            self.leftView.frame = leftViewFinalFrame
            
            self.setNeedsStatusBarAppearanceUpdate()
            
            }) { (finished) -> Void in

                self.didClose()
        }
        
    }

    func open() {
        
        willOpen()
        
        animateOpening()
    }
    
    private func willOpen() {

        self.drawerState = SCSDrawerControllerState.Opening

        var f = self.view.bounds
        f.origin.x = kICSDrawerControllerLeftViewInitialOffset;
        
        self.leftView.frame = f

        addChildViewController(leftViewController as! UIViewController)
        (leftViewController as! UIViewController).view.frame = self.leftView.bounds
        leftView.addSubview((leftViewController as! UIViewController).view)

        view.insertSubview(self.leftView ,belowSubview:self.centerView)
        
        if leftViewController.respondsToSelector("drawerControllerWillOpen:") {
            leftViewController.drawerControllerWillOpen(self)
        }
        if centerViewController.respondsToSelector("drawerControllerWillOpen:") {
            centerViewController.drawerControllerWillOpen(self)
        }
    }
    
    private func didOpen() {
        
        (leftViewController as! UIViewController).didMoveToParentViewController(self)
        
        addClosingGestureRecognizers()
        addOpeningGestureRecognizers()
        
        drawerState = SCSDrawerControllerState.Open
        
        if leftViewController.respondsToSelector("drawerControllerDidOpen:") {
            leftViewController.drawerControllerDidOpen(self)
        }
        if centerViewController.respondsToSelector("drawerControllerDidOpen:") {
            centerViewController.drawerControllerDidOpen(self)
        }
    }
    
    func close() {
        
        willClose()
        
        animateClosing()
    }
    
    private func willClose() {
        
        (leftViewController as! UIViewController).willMoveToParentViewController(nil)
        
        drawerState = SCSDrawerControllerState.Closing
        
        if leftViewController.respondsToSelector("drawerControllerWillClose:") {
            leftViewController.drawerControllerWillClose(self)
        }
        if centerViewController.respondsToSelector("drawerControllerWillClose:") {
            centerViewController.drawerControllerWillClose(self)
        }
        
    }
    
    private func didClose() {
        
        (leftViewController as! UIViewController).view.removeFromSuperview()
        (leftViewController as! UIViewController).removeFromParentViewController()
        
        leftView.removeFromSuperview()
        
        removeClosingGestureRecognizers()
        removeOpeningGestureRecognizers()
        
        drawerState = SCSDrawerControllerState.Closed
        
        if leftViewController.respondsToSelector("drawerControllerDidClose:") {
            leftViewController.drawerControllerDidClose(self)
        }
        if centerViewController.respondsToSelector("drawerControllerDidClose:") {
            centerViewController.drawerControllerDidClose(self)
        }
        
    }
    
    func reloadCenterViewControllerUsingBlock(reloadBlock:() -> ()) {
        
        willClose()
        
        var f = self.centerView.frame
        f.origin.x = self.view.bounds.size.width
        
        UIView.animateWithDuration(kICSDrawerControllerAnimationDuration / 2 , animations: { () -> Void in
            
            self.centerView.frame = f
            
            }) { (finished) -> Void in
                
                reloadBlock()
                
                self.animateClosing()
        }
        
    }

    func replaceCenterViewControllerWithViewController(viewController:protocol<SCSDrawerControllerChild, SCSDrawerControllerPresenting>) {
        
        willClose()
        
        var f = self.centerView.frame
        f.origin.x = self.view.bounds.size.width
        
        (centerViewController as! UIViewController).willMoveToParentViewController(nil)
        
        UIView.animateWithDuration(kICSDrawerControllerAnimationDuration / 3, animations: { () -> Void in
            
            self.centerView.frame = f
            
            }) { (finished) -> Void in
                
                if self.centerViewController.respondsToSelector("setDrawer:") {
                    
                    self.centerViewController.drawer = nil
                }
                (self.centerViewController as! UIViewController).view.removeFromSuperview()
                (self.centerViewController as! UIViewController).removeFromParentViewController()
                
                self.centerViewController = viewController
                if self.centerViewController.respondsToSelector("setDrawer:") {
                    self.centerViewController.drawer = self
                }
                self.addCenterViewController()
                
                self.animateClosing()
        }
    }
    
    func replaceCenterViewControllerWithViewControllerNoanimate(viewController:protocol<SCSDrawerControllerChild, SCSDrawerControllerPresenting>) {
        
        willClose()
        
        if self.centerViewController.respondsToSelector("setDrawer:") {
            
            self.centerViewController.drawer = nil
        }
        (self.centerViewController as! UIViewController).view.removeFromSuperview()
        (self.centerViewController as! UIViewController).removeFromParentViewController()
        
        self.centerViewController = viewController
        if self.centerViewController.respondsToSelector("setDrawer:") {
            self.centerViewController.drawer = self
        }
        self.addCenterViewController()
        
        self.animateClosing()
        
    }
    
    
}

class SCSDropShadowView: UIView {
    
    override func drawRect(rect: CGRect) {
        
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowOpacity = 0.7
        
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.shadowPath = shadowPath.CGPath
    }
}

//
//  SCSPlainColorViewController.swift
//  侧滑
//
//  Created by 张鹏 on 15/12/5.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

class SCSPlainColorViewController: UIViewController {
    
    private var openDrawerButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.yellowColor()
        
        self.openDrawerButton = UIButton(type: UIButtonType.System)
        
        self.openDrawerButton.frame = CGRectMake(10.0, 20.0, 35, 35)
        self.openDrawerButton.setTitle("侧滑", forState: UIControlState.Normal)
        self.openDrawerButton.addTarget(self, action: "openDrawer", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(openDrawerButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func openDrawer() {
        
        let appdelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        appdelegate!.drawerVc.close()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        print(event?.allTouches())
    }

}

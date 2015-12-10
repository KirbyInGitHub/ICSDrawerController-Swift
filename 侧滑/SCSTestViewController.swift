//
//  SCSTestViewController.swift
//  侧滑
//
//  Created by 张鹏 on 15/12/5.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

class SCSTestViewController: UIViewController,SCSDrawerControllerChild,SCSDrawerControllerPresenting {
    
    var drawer:SCSDrawerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.grayColor()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func drawerControllerDidOpen(drawerController: SCSDrawerViewController) {
        
        
    }
    func drawerControllerDidClose(drawerController: SCSDrawerViewController) {
        
        self.view.userInteractionEnabled = true
    }
    func drawerControllerWillOpen(drawerController: SCSDrawerViewController) {
        
        self.view.userInteractionEnabled = false
    }
    func drawerControllerWillClose(drawerController: SCSDrawerViewController) {
        
        
    }


}

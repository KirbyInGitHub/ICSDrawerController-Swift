//
//  NavViewController.swift
//  侧滑
//
//  Created by 张鹏 on 15/12/7.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController,SCSDrawerControllerChild,SCSDrawerControllerPresenting {
    
    var drawer:SCSDrawerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

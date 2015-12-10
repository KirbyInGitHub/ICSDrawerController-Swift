//
//  SCSColorsViewController.swift
//  侧滑
//
//  Created by 张鹏 on 15/12/5.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

class SCSColorsViewController: UITableViewController,SCSDrawerControllerChild,SCSDrawerControllerPresenting {
    
    var drawer:SCSDrawerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.redColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = "菜单"

        // Configure the cell...

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 2 {
            
            let test = SCSTestViewController()
            
            drawer?.replaceCenterViewControllerWithViewController(test)
        } else if indexPath.row == 3 {
            
            drawer?.reloadCenterViewControllerUsingBlock({ [weak self] () -> () in
                
                (self?.drawer!.centerViewController as! UIViewController).view.backgroundColor = UIColor.blueColor()
                
                })
        } else {
            
            drawer?.replaceCenterViewControllerWithViewController(SCSTestViewController())
        }
        

    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    func drawerControllerDidOpen(drawerController: SCSDrawerViewController) {
        
        self.view.userInteractionEnabled = true
        
    }
    func drawerControllerDidClose(drawerController: SCSDrawerViewController) {
        
        self.view.userInteractionEnabled = true 
        
    }
    func drawerControllerWillOpen(drawerController: SCSDrawerViewController) {
        
        self.view.userInteractionEnabled = false
    }
    func drawerControllerWillClose(drawerController: SCSDrawerViewController) {
        
        self.view.userInteractionEnabled = false
        
    }
}

//
//  TabBarViewController.swift
//  Transmission control
//
//  Created by Mialin Valentin on 15.06.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("e")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        

        
        let segue = segue.destination as! TabBarViewController
        var TrackersTableViewController = tabBarController?.viewControllers?[2] as! TrackersTableViewController
        TrackersTableViewController.ids = 5
        
       // let tabBarController = segue.destination as! TabBarViewController
      //  let destinationViewController = tabBarController.viewControllers?[4] as! TrackersTableViewController // or whatever tab index you're trying to access
      //  destinationViewController.ids = 5
    }
    

}

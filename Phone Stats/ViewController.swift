//
//  ViewController.swift
//  Phone Stats
//
//  Created by Thomas Elliott on 6/10/16.
//  Copyright © 2016 Tom Elliott. All rights reserved.
//

import UIKit
import WatchConnectivity
import RFAboutView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func aboutPressed(sender: AnyObject){
        let aboutView: RFAboutViewController = RFAboutViewController(
            appName: "Phone Status Glance",
            appVersion: nil,
            appBuild: nil,
            copyrightHolderName: "Tom Elliott",
            contactEmail: "tom.w.elliott@gmail.com",
            titleForEmail: "Tom Elliott",
            websiteURL: NSURL(string: "http://telliott.io"),
            titleForWebsiteURL: "telliott.io",
            andPublicationYear: nil)
        aboutView.navigationBarBarTintColor = UINavigationBar.appearance().barTintColor
        aboutView.navigationBarTintColor = UINavigationBar.appearance().tintColor
        aboutView.blurStyle = .Dark
        aboutView.headerBackgroundImage = UIImage(named: "icon-transparent")
        
        self.navigationController?.pushViewController(aboutView, animated: true)
    }
    
}


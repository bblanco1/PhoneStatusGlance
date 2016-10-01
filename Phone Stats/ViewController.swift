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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func aboutPressed(_ sender: AnyObject){
        let aboutView: RFAboutViewController = RFAboutViewController(
            appName: "Phone Status Glance",
            appVersion: nil,
            appBuild: nil,
            copyrightHolderName: "Tom Elliott",
            contactEmail: "tom.w.elliott@gmail.com",
            titleForEmail: "Tom Elliott",
            websiteURL: URL(string: "http://telliott.io"),
            titleForWebsiteURL: "telliott.io",
            andPublicationYear: nil)
        aboutView.navigationBarBarTintColor = UINavigationBar.appearance().barTintColor
        aboutView.navigationBarTintColor = UINavigationBar.appearance().tintColor
        aboutView.blurStyle = .dark
        aboutView.headerBackgroundImage = UIImage(named: "icon-transparent")
        
        aboutView.addAdditionalButton(
            withTitle: "Image Sources",
                                               subtitle: "Asset creators",
                                               andContent:
            "Internet Browsing by Creative Stall from the Noun Project\n\n" +
            "Smartphone by Sherrinford from the Noun Project\n\n" +
            "Watch Activity indicator by mikeswanson\n\t(https://github.com/mikeswanson/JBWatchActivityIndicator"
        )
        
        self.navigationController?.pushViewController(aboutView, animated: true)
    }
    
    @IBAction func openWatchApp(){
        UIApplication.shared.openURL(URL(string:"itms-watch://")!)
    }
    
}


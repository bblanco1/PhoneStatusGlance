//
//  ExtensionDelegate.swift
//  Phone Stats WatchKit Extension
//
//  Created by Thomas Elliott on 6/10/16.
//  Copyright © 2016 Tom Elliott. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        print("Finished launching")
    }

    func applicationDidBecomeActive() {
        print("Became active")
    }

    func applicationWillResignActive() {
        print("Resigning active")
    }

}

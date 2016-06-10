//
//  InterfaceController.swift
//  Phone Stats WatchKit Extension
//
//  Created by Thomas Elliott on 6/10/16.
//  Copyright © 2016 Tom Elliott. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    // Our WatchConnectivity Session for communicating with the iOS app
    var watchSession : WCSession?
    
    @IBOutlet var signalLabel: WKInterfaceLabel?
    @IBOutlet var batteryLabel: WKInterfaceLabel?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            // Add self as a delegate of the session so we can handle messages
            watchSession!.delegate = self
            watchSession!.activateSession()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        watchSession?.sendMessage(["request" : "update"], replyHandler: { (response: [String : AnyObject]) in
            let battery : String = response["battery"] as! String
            self.batteryLabel?.setText(battery)
            let signal : String = response["signal"] as! String
            self.signalLabel?.setText(signal)
            }, errorHandler: { (error: NSError) in
                self.batteryLabel?.setText("Error!")
            }
        )
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

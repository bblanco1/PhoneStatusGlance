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
    
    var hasData: Bool = false
    var hasError: Bool = false
    
    var active: Bool = false
    
    @IBOutlet var signalLabel: WKInterfaceLabel?
    @IBOutlet var batteryLabel: WKInterfaceLabel?
    
    @IBOutlet var loadingGroup: WKInterfaceGroup?
    @IBOutlet var infoGroup: WKInterfaceGroup?
    
    @IBOutlet var iconImage: WKInterfaceImage?
    
    @IBOutlet var batteryImage: WKInterfaceImage?
    
    @IBOutlet var loadingLabel: WKInterfaceLabel?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        hasData = false
        hasError = false
        
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
        loadData()
        active = true;
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        active = false
    }
    
    func setLoading(isLoading: Bool){
        if isLoading {
            self.iconImage?.setImageNamed("Activity")
            self.iconImage?.startAnimatingWithImagesInRange(NSMakeRange(0,15), duration: 1.0, repeatCount: 0)
        } else {
            self.iconImage?.stopAnimating()
            self.iconImage?.setImageNamed("icon-transparent-50x50")
        }
        
        if hasError {
            loadingGroup?.setHidden(false)
            infoGroup?.setHidden(true)
            return
        }
        
        loadingLabel?.setText("Loading")
        
        if hasData {
            loadingGroup?.setHidden(true)
            infoGroup?.setHidden(false)
        } else {
            loadingGroup?.setHidden(!isLoading)
            infoGroup?.setHidden(isLoading)
        }
        
    }
    
    func loadData(){
        setLoading(true)
        watchSession?.sendMessage(["request" : "update"], replyHandler: { (response: [String : AnyObject]) in
            let battery : String = response["battery"] as! String
            self.batteryLabel?.setText(battery)
            let signal : String = response["signal"] as! String
            self.signalLabel?.setText(signal)
            
            let charging: Bool = response["charging"] as! Bool
            
            if charging {
                self.batteryImage?.setImageNamed("battery_charging")
            } else {
                self.batteryImage?.setImageNamed("battery")
            }
            
            self.setLoading(false)
            self.hasData = true
            self.hasError = false
            }, errorHandler: { (error: NSError) in
                print(error.description)
                self.hasError = true
                self.loadingLabel?.setText("Error. Will retry shortly")
                self.delay(3.0, closure: {
                    if self.active {
                        self.loadData()
                    }
                })
            }
        )
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}

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
import CocoaLumberjack

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
    
    var tryCount: Int = 0
    let MAX_TRIES: Int = 5
    
    override func awake(withContext context: Any?) {
        DDLog.add(DDTTYLogger.sharedInstance()) // TTY = Xcode console
        DDLog.add(DDASLLogger.sharedInstance()) // ASL = Apple System Logs

        DDLogInfo("Interface awaking")
        super.awake(withContext: context)
        
        hasData = false
        hasError = false
        
        // Configure interface objects here.
        if(WCSession.isSupported()){
            DDLogInfo("Setting up watch session")
            watchSession = WCSession.default()
            // Add self as a delegate of the session so we can handle messages
            watchSession!.delegate = self
            watchSession!.activate()
        } else {
            DDLogWarn("Watch session not supported")
        }
        
        configureSessionLogging()
    }
    
    override func willActivate() {
        DDLogInfo("Activating interface")
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        tryCount = 0
        loadData()
        active = true;
    }
    
    override func didDeactivate() {
        DDLogInfo("Interface deactivating")
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        active = false
    }
    
    func setLoading(_ isLoading: Bool){
        if isLoading {
            self.iconImage?.setImageNamed("Activity")
            self.iconImage?.startAnimatingWithImages(in: NSMakeRange(0,15), duration: 1.0, repeatCount: 0)
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
        DDLogInfo("Loading data, attempt \(self.tryCount) of \(self.MAX_TRIES)")
        
        if let r = watchSession?.isReachable , !r {
            DDLogWarn("Companion app not reachable, request may not succeed.")
        }
        
        setLoading(true)
        watchSession?.sendMessage(["request" : "update"], replyHandler: { (response: [String : Any]) in
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
            self.tryCount = 0
            DDLogInfo("Data loaded successfully")
            }, errorHandler: { (error: Error) in
                DDLogInfo("Loading data failed: \(error.localizedDescription)")
                self.tryCount += 1
                
                if self.tryCount < self.MAX_TRIES {
                    self.delay(0.1, closure: {
                        self.loadData()
                    })
                } else {
                    DDLogInfo("Exceeded max attempts, waiting to try again")
                    self.hasError = true
                    self.loadingLabel?.setText("Error. Will retry shortly")
                    self.delay(1.0, closure: {
                        DDLogInfo("Retrying after delay")
                        if self.active {
                            self.tryCount = 0
                            self.loadData()
                        } else {
                            DDLogInfo("No longer active")
                        }
                    })
                }
            }
        )
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func configureSessionLogging(){
        if let wc = watchSession {
            DDLog.add(WatchSessionLogger(watchSession: wc))
        } else {
            DDLogWarn("Could not set up watch session logging")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
}

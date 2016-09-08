//
//  AppDelegate.swift
//  Phone Stats
//
//  Created by Thomas Elliott on 6/10/16.
//  Copyright © 2016 Tom Elliott. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreTelephony
import ReachabilitySwift
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var watchSession : WCSession?
    
    var window: UIWindow?

    var reachability: Reachability?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        configureLogging()
        
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        
        if(WCSession.isSupported()){
            DDLogInfo("Configuring watch session")
            watchSession = WCSession.defaultSession()
            watchSession!.delegate = self
            watchSession!.activateSession()
        } else {
            DDLogWarn("Watch sessions not supported")
        }
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            DDLogError("Unable to create Reachability")
        }
        
        return true
    }
    
    func getReachabilityString(r : Reachability) -> String {
        if r.isReachableViaWiFi() {
            return r.currentReachabilityString
        } else if r.isReachableViaWWAN() {
            let networkInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
            if let t = networkInfo.currentRadioAccessTechnology {
                switch t {
                case CTRadioAccessTechnologyLTE:
                    return "LTE"
                case CTRadioAccessTechnologyEdge:
                    return "Edge"
                case CTRadioAccessTechnologyGPRS:
                    return "GPRS"
                case CTRadioAccessTechnologyeHRPD:
                    return "3G"
                case CTRadioAccessTechnologyHSDPA:
                    return "3G"
                case CTRadioAccessTechnologyHSUPA:
                    return "3G"
                case CTRadioAccessTechnologyWCDMA:
                    return "3G"
                case CTRadioAccessTechnologyCDMA1x:
                    return "3G"
                case CTRadioAccessTechnologyCDMAEVDORev0:
                    return "3G"
                case CTRadioAccessTechnologyCDMAEVDORevB:
                    return "3G"
                default:
                    return t
                }
            }
            return "Cellular"
        } else if !r.isReachable() {
            return "Offline"
        }
        return "Unknown"
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let req = message["request"] as? String where req == "update" {
            DDLogInfo("Received update request from watch")
            
            let batteryFloat = UIDevice.currentDevice().batteryLevel
            var batteryString = "\(batteryFloat*100)%"
            
            var batteryCharging: Bool = false
            switch UIDevice.currentDevice().batteryState {
            case UIDeviceBatteryState.Unknown:
                batteryString = "Unknown"
            case UIDeviceBatteryState.Charging, UIDeviceBatteryState.Full:
                batteryCharging = true
            case UIDeviceBatteryState.Unplugged:
                batteryCharging = false
            }
           
            var reachabilityString = "Offline"
            
            if let r = reachability {
                reachabilityString = getReachabilityString(r)
            }
            
            replyHandler([
                "battery" : batteryString,
                "charging": batteryCharging,
                "signal": reachabilityString
                ])
            return
        }
        
        if let log = message["message"] as? String {
            DDLogInfo("[Watch] \(log)")
            replyHandler([:])
            return
        }
        
        DDLogWarn("Received unexpected request: \(message)")
        replyHandler([:])
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func configureLogging(){
        DDLog.addLogger(DDTTYLogger.sharedInstance()) // TTY = Xcode console
        DDLog.addLogger(DDASLLogger.sharedInstance()) // ASL = Apple System Logs
        if let container = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.phonestatusglance.telliott.io") {
            let logPath: NSURL = container.URLByAppendingPathComponent("phone_logs")!
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(logPath.path!, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                DDLogWarn(error.localizedDescription);
            }
            
            let fileLogger: DDFileLogger = DDFileLogger(logFileManager: DDLogFileManagerDefault(logsDirectory: logPath.path!)) // File Logger
            fileLogger.rollingFrequency = 60*60*24  // 24 hours
            fileLogger.logFileManager.maximumNumberOfLogFiles = 7
            
            DDLogInfo("Logging to \(logPath.absoluteString)")
            
            DDLog.addLogger(fileLogger)
        } else {
            DDLogWarn("Could not get group container")
        }
    }
    
    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {}

    func sessionDidDeactivate(session: WCSession){}
    
    func sessionDidBecomeInactive(session: WCSession){}
    
}


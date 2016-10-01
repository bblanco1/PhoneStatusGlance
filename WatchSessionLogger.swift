//
//  WatchSessionLogger.swift
//  Phone Status Glance
//
//  Created by Thomas Elliott on 7/31/16.
//  Copyright © 2016 Tom Elliott. All rights reserved.
//

import Foundation
import WatchConnectivity
import CocoaLumberjack

class WatchSessionLogger: NSObject, DDLogger {

    var watchSession : WCSession
    var logFormatter: DDLogFormatter?

    init(watchSession: WCSession){
        self.watchSession = watchSession
    }
    
    func log(message logMessage: DDLogMessage!) {
        var messageText = logMessage.message
        if let lf = logFormatter {
            messageText = lf.format(message: logMessage)
        }
        watchSession.sendMessage(["message" : messageText], replyHandler: { (reply: [String : Any]) in
        }) { (error: Error) in
            print("Last log message could not be recorded")
        }
    }
    
}

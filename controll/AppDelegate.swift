//
//  AppDelegate.swift
//  controll
//
//  Created by Serghey Vice on 2/2/17.
//  Copyright © 2017 Purple i2p. All rights reserved.
//

import Cocoa
//let i2pcontrol = I2PControl()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    /*@IBAction func StartI2PD(_ sender: NSMenuItem) {
        //i2pcontrol.startDaemon()
        print(i2pcontrol.getStatus())
        redTitle()
    }*/
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        //UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

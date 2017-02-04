//
//  StatusMenuController.swift
//  controll
//
//  Created by Serghey Vice on 2/2/17.
//  Copyright © 2017 Purple i2p. All rights reserved.
//

import Cocoa
var timer: DispatchSourceTimer?

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        //let icon = NSImage(named: "StatusIcon")
        //icon?.template = true // best for dark mode
        //statusItem.image = icon
        statusItem.title = "I2PD"
        statusItem.menu = statusMenu
        
        
    }
    @IBAction func StopI2PD(_ sender: NSMenuItem) {
        i2pcontrol.stopDaemon()
        stopTimer()
        statusItem.menu?.item(at: 3)?.isEnabled = false
        statusItem.menu?.item(at: 2)?.isEnabled = true
    }
    @IBAction func StartI2PD(_ sender: NSMenuItem) {
        i2pcontrol.startDaemon()
        yellowTitle()
        //statusMenu.item(at: 2)?.isEnabled = false
        //statusItem.
        //print(statusMenu.item(at: 2)?.isEnabled)
        statusItem.menu?.item(at: 2)?.isEnabled = false
        //print(statusMenu.item(at: 2)?.isEnabled)
        //statusMenu.item(at: 2).isEnabled = false
        //var timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.isConnected), userInfo: nil, repeats: true);
        startTimer()
    }
    func startTimer() {
        let queue = DispatchQueue(label: "com.i2pd.control.timer")  // you can also use `DispatchQueue.main`, if you want
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.scheduleRepeating(deadline: .now(), interval: .seconds(10))
        timer!.setEventHandler { [weak self] in
            self?.isConnected()
        }
        timer!.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        self.stopTimer()
    }

    
    func redTitle() {
        let style = NSMutableParagraphStyle()
        statusItem.attributedTitle = NSAttributedString(string: "I2PD", attributes: [ NSForegroundColorAttributeName : NSColor.red, NSParagraphStyleAttributeName : style ])
    }
    func greenTitle() {
        let style = NSMutableParagraphStyle()
        statusItem.attributedTitle = NSAttributedString(string: "I2PD", attributes: [ NSForegroundColorAttributeName : NSColor.green, NSParagraphStyleAttributeName : style ])
    }
    func blackTitle() {
        let style = NSMutableParagraphStyle()
        statusItem.attributedTitle = NSAttributedString(string: "I2PD", attributes: [ NSForegroundColorAttributeName : NSColor.black, NSParagraphStyleAttributeName : style ])
    }
    func yellowTitle() {
        let style = NSMutableParagraphStyle()
        statusItem.attributedTitle = NSAttributedString(string: "I2PD", attributes: [ NSForegroundColorAttributeName : NSColor.yellow, NSParagraphStyleAttributeName : style ])
    }

    func isConnected(){
        i2pcontrol.get_all()
        if Settings.status == "1"{
            print ("I2pD is ready")
            greenTitle()
        } else if Settings.status == "0" {
            print ("I2pD is not ready")
            yellowTitle()
        } else {
            blackTitle()
            print("I2PD is down")
        }
    }

    @IBAction func quitAppI2PD(_ sender: NSMenuItem) {
        i2pcontrol.exitApp()
    }
}

//
//  StatusMenuController.swift
//  controll
//
//  Created by Serghey Vice on 2/2/17.
//  Copyright © 2017 Purple i2p. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: "StatusIcon")
        //icon?.template = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
}

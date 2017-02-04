//
//  ViewController.swift
//  controll
//
//  Created by Serghey Vice on 2/2/17.
//  Copyright © 2017 Purple i2p. All rights reserved.
//

import Cocoa
import Alamofire
let i2pcontrol = I2PControl()
class ViewController: NSViewController {

    
    //let statusItem = StatusMenuController.statusItem.self
    @IBOutlet weak var version: NSTextField!
    @IBOutlet weak var status: NSTextField!
    @IBOutlet weak var success: NSTextField!
    @IBOutlet weak var speedin: NSTextField!
    @IBOutlet weak var speedout: NSTextFieldCell!
    @IBOutlet weak var received: NSTextField!
    @IBOutlet weak var sent: NSTextField!
    
    @IBOutlet weak var netstatus: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        i2pcontrol.get_all()
        print("Fdsfsd",Settings.status)
        // Do any additional setup after loading the view.
    
    }
    func UpdateInfo() {
        let queue = DispatchQueue(label: "com.i2pd.control.info")  // you can also use `DispatchQueue.main`, if you want
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.scheduleRepeating(deadline: .now(), interval: .seconds(5))
        timer!.setEventHandler { [weak self] in
            //self?.version.text = Settings.version
            self?.updateInfo()
            
            
        }
        timer!.resume()
    }
    
    func stopUpdateInfo() {
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        self.stopUpdateInfo()
    }
    
    func updateInfo() {
        self.version.stringValue = Settings.version
        self.status.stringValue = Settings.status
        self.success.stringValue = Settings.successrate
        self.speedin.stringValue = Settings.inbound
        self.speedout.stringValue = Settings.outbound
        self.received.stringValue = Settings.received
        self.sent.stringValue = Settings.sent
        print("Window refreshed")
    }

    override func viewDidAppear() {
        print("Window opened")
        UpdateInfo()
        //NSStatusItem.menu?.item(at: 1)?.isEnabled = false
        
    }
    override func viewWillDisappear() {
        stopUpdateInfo()
        print("Window closed")
        //NSStatusItem.menu?.item(at: 1)?.isEnabled = true
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


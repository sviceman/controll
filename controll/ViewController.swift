//
//  ViewController.swift
//  controll
//
//  Created by Serghey Vice on 2/2/17.
//  Copyright © 2017 Purple i2p. All rights reserved.
//

import Cocoa
import Alamofire



var UpdateTime: DispatchSourceTimer?

let i2pcontrol = I2PControl()
extension TimeInterval {
    func timeIntervalAsString(_ format : String = "dd days, hh hours, mm minutes, ss seconds, sss ms") -> String {
        var asInt   = NSInteger(self)
        let ago = (asInt < 0)
        if (ago) {
            asInt = -asInt
        }
        let ms = Int(self.truncatingRemainder(dividingBy: 1) * (ago ? -1000 : 1000))
        let s = asInt % 60
        let m = (asInt / 60) % 60
        let h = ((asInt / 3600))%24
        let d = (asInt / 86400)
        
        var value = format
        value = value.replacingOccurrences(of: "hh", with: String(format: "%0.2d", h))
        value = value.replacingOccurrences(of: "mm",  with: String(format: "%0.2d", m))
        value = value.replacingOccurrences(of: "sss", with: String(format: "%0.3d", ms))
        value = value.replacingOccurrences(of: "ss",  with: String(format: "%0.2d", s))
        value = value.replacingOccurrences(of: "dd",  with: String(format: "%d", d))
        if (ago) {
            value += " ago"
        }
        return value
    }
    
}

class ViewController: NSViewController {

    
    //let statusItem = StatusMenuController.statusItem.self
    @IBOutlet weak var version: NSTextField!
    @IBOutlet weak var status: NSTextField!
    @IBOutlet weak var success: NSTextField!
    @IBOutlet weak var speedin: NSTextField!
    @IBOutlet weak var speedout: NSTextFieldCell!
    @IBOutlet weak var received: NSTextField!
    @IBOutlet weak var sent: NSTextField!
    @IBOutlet weak var uptime: NSTextField!
    @IBOutlet weak var netstatus: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        i2pcontrol.get_all()
        print("Fdsfsd",Settings.status)
        // Do any additional setup after loading the view.
    
    }
    func UpdateInfo() {
        let queue = DispatchQueue.main  // you can also use `DispatchQueue.main`, if you want
        UpdateTime = DispatchSource.makeTimerSource(queue: queue)
        UpdateTime!.scheduleRepeating(deadline: .now(), interval: .seconds(10))
        UpdateTime!.setEventHandler { [weak self] in
            //self?.version.text = Settings.version
            self?.updateInfo()
            
            
        }
        UpdateTime!.resume()
    }
    
    func stopUpdateInfo() {
        UpdateTime?.cancel()
        UpdateTime = nil
    }
    
    deinit {
        self.stopUpdateInfo()
    }
    func convertTime(miliseconds: Int) -> String {
        
        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        var days: Int = 0
        var secondsTemp: Int = 0
        var minutesTemp: Int = 0
        var hoursTemp: Int = 0
        
        if miliseconds < 1000 {
            return ""
        } else if miliseconds < 1000 * 60 {
            seconds = miliseconds / 1000
            return "\(seconds) sec"
        } else if miliseconds < 1000 * 60 * 60 {
            secondsTemp = miliseconds / 1000
            minutes = secondsTemp / 60
            seconds = (miliseconds - minutes * 60 * 1000) / 1000
            return "\(minutes) m, \(seconds) s"
        } else if miliseconds < 1000 * 60 * 60 * 24 {
            minutesTemp = miliseconds / 1000 / 60
            hours = minutesTemp / 60
            minutes = (miliseconds - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(hours) h, \(minutes) m, \(seconds) s"
        } else {
            hoursTemp = miliseconds / 1000 / 60 / 60
            days = hoursTemp / 24
            hours = (miliseconds - days * 24 * 60 * 60 * 1000) / 1000 / 60 / 60
            minutes = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(days) d, \(hours) h, \(minutes) m, \(seconds) s"
        }
    }
    func updateInfo() {
        self.version.stringValue = Settings.version
        self.status.stringValue = Settings.status
        switch Settings.status {
        case "0":
            self.status.stringValue="Not ready"
        case "1":
            self.status.stringValue="OK"
        default:
            self.status.stringValue="Down"
        }
        switch Settings.netstatus {
        case "0":
            self.netstatus.stringValue="OK"
        case "1":
            self.netstatus.stringValue="Testing"
        case "2":
            self.netstatus.stringValue="Firewalled"
        case "3":
            self.netstatus.stringValue="Firewalled"
        case "4":
            self.netstatus.stringValue="Firewalled"
        case "5":
            self.netstatus.stringValue="Firewalled"
        case "6":
            self.netstatus.stringValue="Firewalled"
        case "7":
            self.netstatus.stringValue="Firewalled"
        case "8":
            self.netstatus.stringValue="Firewalled"
        case "9":
            self.netstatus.stringValue="Firewalled"
        case "10":
            self.netstatus.stringValue="Firewalled"
        case "11":
            self.netstatus.stringValue="Firewalled"
        case "12":
            self.netstatus.stringValue="Firewalled"
        case "13":
            self.netstatus.stringValue="Firewalled"
        case "14":
            self.netstatus.stringValue="Firewalled"
            
        default:
            self.netstatus.stringValue="Connecting"
        }
        /*
        switch (Int(Settings.status)) {
        case ?0:
            self.status.stringValue="OK";
            break;
        case 1:
            self.status.stringValue="Testing";
            break;
        case 2:
            self.status.stringValue="FIREWALLED";
            break;
        case 3:
            self.status.stringValue="HIDDEN";
        case 4:
            self.status.stringValue="WARN";
        case 5:
            self.status.stringValue="WARN";
        case 6:
            self.status.stringValue="WARN";
        case 7:
            self.status.stringValue="WARN";
        case 8:
            self.status.stringValue="ERROR";
        case 9:
            self.status.stringValue="ERROR";
        case 10:
            self.status.stringValue="ERROR";
        case 11:
            self.status.stringValue="ERROR";
        case 12:
            self.status.stringValue="ERROR";
        case 13:
            self.status.stringValue="ERROR";
        case 14:
            self.status.stringValue="ERROR";
            
        default:
            self.status.stringValue="Connecting";
 */
        self.success.stringValue = Settings.successrate
        self.success.stringValue = self.success.stringValue+" %"
        self.speedin.stringValue = String(Int(Settings.inbound)!/1024)
        self.speedin.stringValue = self.speedin.stringValue+" kb/s"
        self.speedout.stringValue = String(Int(Settings.outbound)!/1024)
        self.speedout.stringValue = self.speedout.stringValue+" kb/s"
        self.received.stringValue = String(Int(Settings.received)!/1024)
        self.received.stringValue = self.received.stringValue+" kb"
        self.sent.stringValue = String(Int(Settings.sent)!/1024)
        self.sent.stringValue = self.sent.stringValue+" kb"
        //self.netstatus.stringValue = Settings.netstatus
        let uptimeTime = convertTime(miliseconds: Int(Settings.uptime)!)
        self.uptime.stringValue = uptimeTime
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


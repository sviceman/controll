//
//  I2PCoontrol.swift
//  controll
//
//  Created by Serghey Vice on 2/2/17.
//  Copyright © 2017 Purple i2p. All rights reserved.
//

import Cocoa
import Alamofire
import Foundation
//import SwiftyJSON
struct Settings {
    static var uptime = String();
    static var version = String();
    static var knownpeers = String();
    static var activepeers = String();
    static var inbound = String();
    static var outbound = String();
    static var successrate = String();
    static var received = String();
    static var sent = String();
    static var status = String();
    static var participating = String();
    static var netstatus = String();
    static var isEnabled = Bool();
}

class I2PControl:NSObject{
    
    
    public let i2pcurl = "https://127.0.0.1:7650/jsonrpc"
    //var version : String
    private static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "127.0.0.1": .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
    func i2pcreq(parameters: Parameters, completionHandler:  @escaping (AnyObject?, NSError?) -> ()) {
        PostCall(url: i2pcurl, parameters: parameters,completionHandler: completionHandler)
    }
    
    func PostCall(url: String, parameters: Parameters, completionHandler:  @escaping (AnyObject?, NSError?) -> ()) {
            I2PControl.Manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding(options: []))
                .responseJSON { response  in
                switch response.result {
                case .success(let value):
                    completionHandler(value as AnyObject?,nil)
                case .failure(let error):
                    completionHandler(nil, error as NSError?)
                }
        }
    }
    
    func get_all()  {
        let parameters: Parameters = [
            "id": 1,
            "method":"RouterInfo",
            "params": [
                "i2p.router.uptime": "",
                "i2p.router.version": "",
                "i2p.router.status": "",
                "i2p.router.netdb.knownpeers": "",
                "i2p.router.netdb.activepeers": "",
                "i2p.router.net.bw.inbound.1s": "",
                "i2p.router.net.bw.outbound.1s": "",
                "i2p.router.net.status": "",
                "i2p.router.net.tunnels.participating": "",
                "i2p.router.net.tunnels.successrate": "",
                "i2p.router.net.total.received.bytes": "",
                "i2p.router.net.total.sent.bytes": "",
                
            ],
            "jsonrpc":"2.0"
        ]
        i2pcreq(parameters: parameters) { responseObject, error in
            let json = JSON(responseObject as Any)
            //let i2pdv = json["result","i2p.router.version"].stringValue
            //self.version.stringValue = i2pdv
            Settings.version = json["result","i2p.router.version"].stringValue
            Settings.uptime = json["result","i2p.router.uptime"].stringValue
            Settings.status = json["result","i2p.router.status"].stringValue
            Settings.knownpeers = json["result","i2p.router.netdb.knownpeers"].stringValue
            Settings.activepeers = json["result","i2p.router.netdb.activepeers"].stringValue
            Settings.inbound = json["result","i2p.router.net.bw.inbound.1s"].stringValue
            Settings.outbound = json["result","i2p.router.net.bw.outbound.1s"].stringValue
            Settings.netstatus = json["result","i2p.router.net.status"].stringValue
            Settings.participating = json["result","i2p.router.net.tunnels.participating"].stringValue
            Settings.successrate = json["result","i2p.router.net.tunnels.successrate"].stringValue
            Settings.received = json["result","i2p.router.net.total.received.bytes"].stringValue
            Settings.sent = json["result","i2p.router.net.total.sent.bytes"].stringValue
            //print(json)
            //print(Settings.successrate)
        }
    }
    
    func stopDaemon() {
        let parameters: Parameters = [
            "id": 1,
            "method":"RouterManager",
            "params": [
                "Shutdown": ""
            ],
            "jsonrpc":"2.0"
        ]
        
        i2pcreq(parameters: parameters) { responseObject, error in
            let json = JSON(responseObject as Any)
            let Shutdown = json["result","Shutdown"].stringValue
            //self.version.stringValue = i2pdv
            if Shutdown == "null" {
                Settings.isEnabled = false
            }
            //print(json)
            //print(Settings.successrate)
        }
        
        
        
    }
    func exitApp() {
        let parameters: Parameters = [
            "id": 1,
            "method":"RouterManager",
            "params": [
                "Shutdown": ""
            ],
            "jsonrpc":"2.0"
        ]
        
        i2pcreq(parameters: parameters) { responseObject, error in
            //let json = JSON(responseObject as Any)
            //let Shutdown = json["result","Shutdown"].stringValue
            //self.version.stringValue = i2pdv
            NSApplication.shared().terminate(self)
            //print(json)
            //print(Settings.successrate)
        }
    }
    
    func startDaemon() {
        

        let task = Process()
        task.launchPath = Bundle.main.resourcePath!+"/i2pd"
        let tunnconf = "--tunconf="+Bundle.main.resourcePath!+"/tunnel.conf"
    
        task.arguments = ["--i2pcontrol.enabled=1","--loglevel=error",tunnconf,"--daemon"]
        task.launch()
    
    }
    func getStatus() -> String {
        get_all()
        return Settings.status
    }
    
    }

//
//  ViewController.swift
//  test_OSC
//
//  Created by 荒川陸 on 2017/06/19.
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import UIKit

class OscSendViewController: UIViewController {
    
    //osc送信のためのoscClientの初期化
    let oscClient = F53OSCClient.init()
    
    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let address = getWiFiAddress() else {fatalError()}
        print("IP Address: ", address)
        //OSCを送りたい先のIPアドレスを指定
        oscClient.host = address
        //贈りたい先のport番号を指定
        oscClient.port = 3333
        addressLabel.text = address
    }
    
    @IBAction func sendOSC(){
        //123というメッセージをOSCで送信
        self.sendMessage(client: oscClient, addressPattern: "/value", arguments: [123 as AnyObject])
        //複数の値を送る場合はarguments:[123,231,312]
    }
    
    //osc送信のためのメソッド
    func sendMessage(client: F53OSCClient, addressPattern: String, arguments: [AnyObject]) {
        let message = F53OSCMessage(addressPattern: addressPattern, arguments: arguments)
        client.send(message)
        print("Sent '\(String(describing: message!))' to \(client.host!):\(client.port)")
    }
    
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}

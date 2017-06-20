//
//  OscReceiveViewController.swift
//  test_OSC
//
//  Created by 荒川陸 on 2017/06/19.
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import UIKit

//デリゲートまわりでF53OSCPacketDestinationの追加
class OscRecieveViewController: UIViewController,F53OSCPacketDestination {
    
    //osc受信のためのoscServerの初期化
    let oscServer = F53OSCServer.init()
    
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //portの指定など
        oscServer.port = 3333
        oscServer.delegate = self
        if oscServer.startListening() {
            print("Listening for messages on port \(oscServer.port)")
        } else {
            print("Error: Server was unable to start listening on port \(oscServer.port)")
        }
    }
    
    //OSC受信するためのメソッド
    func take(_ message: F53OSCMessage!) {
        
        print("receive: ", message)
        messageLabel.text = String(describing: message.arguments[0])
        //OSCmessageによる比較
        if message.addressPattern == "/value" {
            
            //OSCargumentsによる比較
            if message.arguments[0] as! Int == 123{
                print("hello 123")
            }else if message.arguments[0] as! Int == 321{
                print("hello 321")
            }
        }
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    
}

//
//  IOSocket.swift
//  i_launched
//
//  Created by MAC MINI on 06/03/2018.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import SocketIO

typealias GetSocketCompletion = ([[String : Any]]) -> ()
typealias SendSocketCompletion = () -> ()
//var SocketURL = "http://139.162.37.73:3000/"
var SocketURL = "https://healingbudz.com:3000/"
//var SocketURL = "https://healingbudz.cannablazeed.com:3000/"
class IOSocket: NSObject {
    var SocketReceivedMsgFunctionName = "message_send"
    var SocketSendMsgFunctionName = "message_get"
    var socket: SocketIOClient = SocketIOClient(socketURL: URL.init(string: SocketURL)!)
    static let sharedInstance = IOSocket()
    override init() {
        socket.connect()
    }
    func Get(completion: @escaping GetSocketCompletion) {
        socket.on(SocketReceivedMsgFunctionName) {data, ack in
            print(data)
            let rsp_dt = data as! [[String : Any]]
                completion(rsp_dt)
          }
    }
    
    func Send(withParm parm : [String : AnyObject] ,completion: @escaping SendSocketCompletion )  {
            socket.emit(SocketSendMsgFunctionName, parm)
            completion()
    }
}

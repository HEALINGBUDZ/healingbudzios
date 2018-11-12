//
//  IOSocket.swift
//  i_launched
//
//  Created by MAC MINI on 06/03/2018.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import SocketIO
class IOSocketBudz: NSObject {
    var SocketReceivedMsgFunctionName = "message_send_budz"
    var SocketSendMsgFunctionName = "message_get_budz"
    var socket: SocketIOClient = SocketIOClient(socketURL: URL.init(string: SocketURL)!)
    static let sharedInstance = IOSocketBudz()
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

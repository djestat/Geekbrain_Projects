//
//  MessageViewController.swift
//  ProjectVK
//
//  Created by Igor on 08/08/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    let request = VKAPIRequests()
    
    public var senderID: Int?
    public var senderType: String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sendRequest()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Send request to got history
    
    func sendRequest() {
        
        switch senderType {
        case "user":
            let userID = String(self.senderID!)
            let peerID = ""
            request.getMessages(userID, peerID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let messages):
                    print(messages.items.count)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case "chat":
            let userID = ""
            let peerID = String(self.senderID!)
            request.getMessages(userID, peerID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let messages):
                    print(messages.items.count)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case "group":
            let userID = ""
            let peerID = String(self.senderID!)
            request.getMessages(userID, peerID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let messages):
                    print(messages.items.count)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            print("Strangely")
        }
    
    }


}

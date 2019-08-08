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
    var messages = [Messages]()
    
    var backgroundColorForCell: UIColor = .blue
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //register tableview
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseID)
        
        // Do any additional setup after loading the view.
        sendRequest()
        print("👤 \(senderID!) and \(senderType!)")
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
            request.getMessages(userID, peerID)
        case "chat":
            let userID = ""
            let peerID = String(self.senderID!)
            request.getMessages(userID, peerID)
        case "group":
            let userID = ""
            let peerID = String(self.senderID!)
            request.getMessages(userID, peerID)
        default:
            print("Strangely")
        }
    
    }

    //MARK: - IBAction

    @IBAction func attachFileButtonAction(_ sender: Any) {
        
        
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        
            
    }
    
}

extension MessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseID, for: indexPath) as? MessageCell else { fatalError("Cell cannot be dequeued") }
        
        if backgroundColorForCell == UIColor.blue {
            backgroundColorForCell = .green
            cell.backgroundColor = backgroundColorForCell
        } else if backgroundColorForCell == UIColor.green {
            backgroundColorForCell = .red
            cell.backgroundColor = backgroundColorForCell
        } else if backgroundColorForCell == UIColor.red {
            backgroundColorForCell = .blue
            cell.backgroundColor = backgroundColorForCell
        }
        
        tableView.rowHeight = CGFloat(121)
        
        return cell
    }

}

extension MessageViewController: UITableViewDelegate {
    
}

extension MessageViewController: UITextFieldDelegate {
    
    
//    textFie
    
}

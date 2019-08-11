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
    public var senderName: String?
    var messages = [MessageItems]()
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        sendRequest()
        print("👤 \(senderID!) and \(senderType!)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Controller Title
        title = senderName
        
        //Revert Table
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)

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
                    self.messages = messages.items
                    self.tableView.reloadData()
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
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
        
        if messages[indexPath.row].text.count != 0 {
            cell.messageTextLabel.text = messages[indexPath.row].text
        } else {
            cell.messageTextLabel.text = "NOT TEXT \nAttachment OR nil \n \(messages[indexPath.row].id)"
        }
        
        if messages[indexPath.row].fromID == Session.authData.userid {
            cell.messageTextLabel.backgroundColor = .green
            cell.messageTextLabel.textAlignment = .right
        } else {
            cell.messageTextLabel.backgroundColor = .orange
            cell.messageTextLabel.textAlignment = .left

        }
        
//        tableView.rowHeight = CGFloat(150)
        //Revert Content
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }

}

extension MessageViewController: UITableViewDelegate {
    
}

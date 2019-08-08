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
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var messageTextField: UITextField!
    
    
    @IBOutlet weak var sendButtonOutlet: UIButton! {
        didSet {
            if messageTextField.text == nil {
                sendButtonOutlet.isEnabled = false
                sendButtonOutlet.backgroundColor = .green
            }
        }
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //register tableview
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseID)
        
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

    
    @IBAction func attachFileButtonAction(_ sender: Any) {
        
        
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        
            
    }
    
}

extension MessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseID, for: indexPath) as? MessageCell else { fatalError("Cell cannot be dequeued") }
        
        
        
        return cell
    }

}

extension MessageViewController: UITableViewDelegate {
    
}
/*
extension MessageViewController: UITextFieldDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groupsList = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)).objects(Group.self).filter("isMember == %i", 1)
            view.endEditing(true)
            tableView.reloadData()
            return
        }
        let searchingGroup = RealmProvider.searchInGroup(Group.self, searchText).filter("isMember == %i", 1)
        groupsList = searchingGroup
        tableView.reloadData()
    }
    
}*/

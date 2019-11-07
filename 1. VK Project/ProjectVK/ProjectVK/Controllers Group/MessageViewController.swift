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
    var keyboardHeightWas: CGFloat = 0
    var messages = [MessageItems]()
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet var messageSuperView: UIView!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        sendRequest()
        print("📨 <= 👤 \(senderID!) and \(senderType!)")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //Controller Title
        title = senderName
        
        //Revert Table for message listing
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)

        //Gesture
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tapGR)
        
        //Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        showTabBar()
    }
    
    // MARK: - Helpers
    
    @objc private func keyboardChange(notification: Notification) {
        let info = notification.userInfo as NSDictionary?
        let keyboardHeight = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size.height
        var contentInsets: UIEdgeInsets?

        print("⌨️ Keyboard Height Was => \(self.keyboardHeightWas)")

        if notification.name == UIResponder.keyboardWillShowNotification {
            contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            print("⌨️ will show")
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardHeight, right: 0)
            messageSuperView.frame = messageSuperView.frame.inset(by: contentInsets!)
            self.keyboardHeightWas = 0
            print("⌨️ will hide")
        } else if notification.name == UIResponder.keyboardWillChangeFrameNotification {
            if self.keyboardHeightWas == 0 {
                contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                messageSuperView.frame = messageSuperView.frame.inset(by: contentInsets!)
                self.keyboardHeightWas = keyboardHeight
                print("⌨️ will add \(keyboardHeight)")
            } else if self.keyboardHeightWas == keyboardHeight {
                print("⌨️ no need change")
            } else if self.keyboardHeightWas < keyboardHeight {
                let differenceHeight = keyboardHeight - self.keyboardHeightWas
                contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: differenceHeight, right: 0)
                messageSuperView.frame = messageSuperView.frame.inset(by: contentInsets!)
                self.keyboardHeightWas = keyboardHeight
                print("⌨️ will change view for \(differenceHeight)")
            } else if self.keyboardHeightWas > keyboardHeight {
                let differenceHeight = self.keyboardHeightWas - keyboardHeight
                contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: -differenceHeight, right: 0)
                messageSuperView.frame = messageSuperView.frame.inset(by: contentInsets!)
                self.keyboardHeightWas = keyboardHeight
                print("⌨️ will change view for -\(differenceHeight)")
            }
        }
        print("⌨️ Keyboard Height Now => \(self.keyboardHeightWas)")
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    func showTabBar() {
        tabBarController?.delegate = self as? UITabBarControllerDelegate
        self.tabBarController?.tabBar.isHidden = false

        UIView.animate(withDuration: 1.0, animations: {
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }

    
    // MARK: - Navigation

    
    // MARK: - Send request to get history
    
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
        case "group":
            let userID = ""
            let peerID = String(self.senderID!)
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
        default:
            print("Strangely")
        }
    
    }
    
    // MARK: - Send message

    func sendMessage() {
        let message = messageTextField.text!
        if !message.isEmpty {
            let randomID = Int64.random(in: Int64.min...Int64.max)
            print("Рандомное число \(randomID)")
            let peerID = self.senderID!
            request.sendMessagesTest(peerID, message, randomID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    if response.response > 0 {
                        print("📮 отправлено успешно с результатом", response.response)
                        self.messageTextField.text?.removeAll()
                    } else if response.error.errorCode > 0 {
                        print("📮 отправлено некорректно, код ошибки: \(response.error.errorCode)\nТекст ошибки:\(response.error.errorMsg)")
                    }
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        } else if message.isEmpty {
            messageTextField.backgroundColor = .red
            let dispatchTime = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                self.messageTextField.backgroundColor = .clear
            }
        }
    }

    //MARK: - IBAction

    @IBAction func attachFileButtonAction(_ sender: Any) {
        
        
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        print("👤 => ✉️ \(senderID!) and \(senderName!)")
        sendMessage()
        let dispatchTime = DispatchTime.now() + 0.5
        print("⏱ before 0.5 sec?")
        DispatchQueue.global().asyncAfter(deadline: dispatchTime) {
            self.sendRequest()
            print("⏱ after 0.5 sec?")
        }
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
            cell.messageTextLabel.text = "NOT TEXT \n🌄 OR 🎥 OR 🌐 OR nil \n \(messages[indexPath.row].id)"
        }
        
        let offset = CGFloat(15)
        
        if messages[indexPath.row].fromID == Session.authData.userid {
            cell.messageTextLabel.backgroundColor = .clear
            cell.messageView.backgroundColor = .chatMyMessageBackgroundColor
            cell.messageTextLabel.textAlignment = .right
            cell.messageView.transform = CGAffineTransform(translationX: offset, y: 0)
        } else {
            cell.messageTextLabel.backgroundColor = .clear
            cell.messageView.backgroundColor = .chatSenderMessageBackgroundColor
            cell.messageTextLabel.textAlignment = .left
            cell.messageView.transform = CGAffineTransform(translationX: -offset, y: 0)
        }
        cell.contentView.backgroundColor = .chatBackgroundColor
        //Revert Table for message listing
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }

}

extension MessageViewController: UITableViewDelegate {
    
}

extension MessageViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}

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
    
    @IBOutlet var messageSuperView: UIView!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        sendRequest()
        print("📨 <= 👤 \(senderID!) and \(senderType!)")
        hideTabBar()
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        showTabBar()
    }
    
    // MARK: - Helpers
    
    @objc private func keyboardWasShow(notification: Notification) {
        let info = notification.userInfo as NSDictionary?
        let keyboardHeight = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        messageSuperView.frame = messageSuperView.frame.inset(by: contentInsets)
    }
    
    @objc private func keyboardWasHidden(notification: Notification) {
        let info = notification.userInfo as NSDictionary?
        let keyboardHeight = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardHeight, right: 0)
        
        messageSuperView.frame = messageSuperView.frame.inset(by: contentInsets)
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
//        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
//        messageSuperView.frame = messageSuperView.frame.inset(by: contentInsets)
    }
    
    func hideTabBar() {
        tabBarController?.delegate = self as? UITabBarControllerDelegate
        let width = tabBarController?.tabBar.frame.width
        UIView.animate(withDuration: 0.75, animations: {
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: -width!, y: 0)
        }) { _ in
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    func showTabBar() {
        tabBarController?.delegate = self as? UITabBarControllerDelegate
        self.tabBarController?.tabBar.isHidden = false

        UIView.animate(withDuration: 1.0, animations: {
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        let randomID = Int64.random(in: Int64.min...Int64.max)
        print("Рандомное число \(randomID)")
//        switch senderType {
//        case "user":
            let peerID = self.senderID!
            request.sendMessagesTest(peerID, message, randomID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    if response.response > 0 {
                        print("📮 отправлено с результатом", response.response)
                        self.messageTextField.text?.removeAll()
                    } else if response.error.errorCode > 0 {
                        print("📮 отправлено но не принято, код ошибки: \(response.error.errorCode)\nТекст ошибки:\(response.error.errorMsg)")
                    }
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
            
        /*  case "chat":
            print("chat")
//            let userID = ""
//            let peerID = self.senderID!
//            request.getMessages(userID, peerID)
        case "group":
            print("group")
//            let userID = ""
//            let peerID = self.senderID!
//           request.getMessages(userID, peerID)
        default:
            print("Strangely")
        }*/
        
    }

    //MARK: - IBAction

    @IBAction func attachFileButtonAction(_ sender: Any) {
        
        
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        print("👤 => ✉️ \(senderID!) and \(senderName!)")
        
        sendMessage()
        
//        print("TEXTFIELD TEXT =>\(messageTextField.text!)<=")
//        print("TEXTFIELD TEXT IS EMPTY =>\(messageTextField.text!.isEmpty)<=")

        let dispatchTime = DispatchTime.now() + 1
        print("⏱ before 1sec?")
        DispatchQueue.global().asyncAfter(deadline: dispatchTime) {
            self.sendRequest()
            print("⏱ after 1sec?")
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
            cell.messageTextLabel.text = "NOT TEXT \nAttachment OR nil \n \(messages[indexPath.row].id)"
        }
        
        let offset = CGFloat(15)
        
        if messages[indexPath.row].fromID == Session.authData.userid {
            cell.messageTextLabel.backgroundColor = .clear
            cell.messageView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.6784313725, blue: 0.9215686275, alpha: 1)
            cell.messageTextLabel.textAlignment = .right
            cell.messageView.transform = CGAffineTransform(translationX: offset, y: 0)
        } else {
            cell.messageTextLabel.backgroundColor = .clear
            cell.messageView.backgroundColor = #colorLiteral(red: 0, green: 0.8167479038, blue: 0.2984552681, alpha: 1)
            cell.messageTextLabel.textAlignment = .left
            cell.messageView.transform = CGAffineTransform(translationX: -offset, y: 0)
        }
        cell.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.4982398152, blue: 0.8465595841, alpha: 1)
        //Revert Table for message listing
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }

}

extension MessageViewController: UITableViewDelegate {
    
}

//
//  LoginViewController.swift
//  ProjectVK
//
//  Created by Igor on 30/03/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - transition animator
    private let transitionAnimator = Animator()

    //MARK: - Outlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGR)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: - Actions
    @IBAction func autorizationButton(_ sender: UIButton) {
        //CustomPushAnimator
//        let currentVKcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrentVKcontroller")
//        currentVKcontroller.transitioningDelegate = self
//
        
        if loginTextField.text == "", passwordTextField.text == "" {
            //Segue transition
            self.performSegue(withIdentifier: "Show Tab Bar Controller", sender: sender)
            //CustomPushAnimator
//            present(currentVKcontroller, animated: true)
        } else {
            showLoginError()
        }
        
    }
    
    //MARK: - Private API
    @objc private func keyboardWasShow(notification: Notification) {
        let info = notification.userInfo as NSDictionary?
        let keyboardSize = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWasHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func hideKeyboard() {
        scrollView.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "Show Tab Bar Controller" else { return true }
        
        if loginTextField.text == "", passwordTextField.text == "" {
            return true
        } else {
            showLoginError()
            return false
        }
    }
    
    private func showLoginError() {
        let loginAlert = UIAlertController(title: "Error!", message: "Login or Password is incorrect!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.passwordTextField.text = ""
        }
        loginAlert.addAction(action)
        present(loginAlert, animated: true)
    }
}

// MARK: - Property transition animator
extension LoginViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
}

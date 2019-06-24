//
//  VKLoginViewController.swift
//  ProjectVK
//
//  Created by Igor on 19/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import WebKit

class VKLoginViewController: UIViewController {

    @IBOutlet weak var authPage: WKWebView! {
        didSet {
            authPage.navigationDelegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6981695"),
            URLQueryItem(name: "scope", value: "275479"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        authPage.load(request)
        
    }
    
}

extension VKLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else { decisionHandler(.allow); return }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        guard let token = params["access_token"],
            let userIdString = params["user_id"],
            let userId = Int(userIdString) else {
                decisionHandler(.allow)
                return
        }
        
        Session.authData.token = token
        Session.authData.userid = userId
        
        
        // performSegue(withIdentifier:)
        
        if Session.authData.token != "", Session.authData.userid != 0 {
            self.performSegue(withIdentifier: "Present Tab Bar Controller", sender: nil)
        } else {
            return
        }
        
        decisionHandler(.cancel)
    }
}

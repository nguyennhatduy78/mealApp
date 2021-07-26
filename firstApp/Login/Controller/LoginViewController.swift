//
//  LoginViewController.swift
//  firstApp
//
//  Created by ChinhPV on 3/22/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    //Service
    let group : DispatchGroup = DispatchGroup()
    let apis: fetchAPIs = fetchAPIs()
    let helper = Helper()
    let loginPersist: LoginPersist = LoginPersist()
    
    //Outlet constant
    @IBOutlet var loginView: LoginView!
    
    var username: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if username != "" && password != "" {
            self.loginView.username.text = username
            self.loginView.password.text = password
            self.loginBtn()
        }
        self.loginView.login.addTarget(self, action: #selector(loginBtn), for: .touchUpInside)
        self.loginView.register.addTarget(self, action: #selector(registerBtn), for: .touchUpInside)
        self.loginView.resetPsw.addTarget(self, action: #selector(resetPsw), for: .touchUpInside)
    }
    
    
    //Priv func
    @objc func loginBtn(){
        let loading_alert = helper.loading_alert()
        if self.loginView.username.text!.isEmpty || self.loginView.password.text!.isEmpty {
            self.present(self.helper.non_action_alert(msg: "Password/Username must not be empty", title: "FIELD EMPTY"), animated: true, completion: nil)
        } else {
            group.enter()
            self.present(loading_alert, animated: true, completion: nil)
            apis.login(username: self.loginView.username.text!, password: self.loginView.password.text!) { (user, error) in
                if error != nil || user == nil{
                    loading_alert.dismiss(animated: true) {
                        self.present(self.helper.non_action_alert(msg: "Check your password / username and try again", title: "LOGIN FAILED"),
                                     animated: true, completion: nil)
                    }
                }else{
                    loading_alert.dismiss(animated: true) {
                        self.loginSuccess(user: user!)
                    }
                    self.group.leave()
                }
            }
            self.group.notify(queue: .main) {
                print("API load user done")
                loading_alert.dismiss(animated: true, completion: nil)
            }
        }
    }

    @objc func registerBtn(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let registerView = storyboard.instantiateViewController(identifier: "RegisterView") as! RegisterViewController
        registerView.modalPresentationStyle = .popover
        self.present(registerView, animated: true, completion: nil)
    }
    
    @objc func resetPsw(){
        self.apis.getNews { (result, data) in
            print("Data: \(data)")
        }
    }
    
    
    func loginSuccess(user: User) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let userView = storyboard.instantiateViewController(identifier: "UserView") as! UserViewController
        userView.user = user
        if self.loginView.saveLogin.isCheck {
            self.loginPersist.saveLoginInfo(forUserID: "loginInfo", username: self.loginView.username.text! , password: self.loginView.password.text!)
        }
        userView.modalPresentationStyle = .fullScreen
        self.present(userView, animated: true, completion: nil)
    }
}

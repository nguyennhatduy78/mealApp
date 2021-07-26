//
//  RegisterViewController.swift
//  firstApp
//
//  Created by Nguyen Nhat Duy on 22/03/2021.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    //Services
    let apis : fetchAPIs = fetchAPIs()
    let group : DispatchGroup = DispatchGroup()
    let helper :Helper = Helper()
    
    @IBOutlet weak var nextBtn: loginButton!
    @IBOutlet weak var registerView: RegisterView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func nextState(_ sender: loginButton) {
        let username = self.registerView.username.text!
        let password = self.registerView.password.text!
        let alert = helper.loading_alert()
        if username.isEmpty || password.isEmpty {
            self.present(self.helper.non_action_alert(msg: "Password/Username must not be empty", title: "FIELD EMPTY"), animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
            group.enter()
            apis.validate(username: username) { (check) in
                if check {
                    alert.dismiss(animated: true) {
                        self.loadNextRegisterView()
                        self.group.leave()
                    }
                } else {
                    alert.dismiss(animated: true) {
                        self.present(self.helper.non_action_alert(msg: "Username has been taken", title: "Unavailable username"), animated: true, completion: nil)
                    }
                }
            }
        }
        
        
    }
    
    
    func loadNextRegisterView(){
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let userView = sb.instantiateViewController(identifier: "UserView") as! UserViewController
        userView.modalPresentationStyle = .popover
         userView.username = self.registerView.username.text!
         userView.password = self.registerView.password.text!
         userView.flagRegister = true
         userView.flagEdit = true
        self.present(userView, animated: true)
    }
    
}

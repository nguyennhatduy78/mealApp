//
//  UserViewController.swift
//  firstApp
//
//  Created by ChinhPV on 3/22/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit
import Kingfisher

class UserViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    //service
    let apis: fetchAPIs = fetchAPIs()
    let helper : Helper = Helper()
    let group: DispatchGroup = DispatchGroup()
    let loginPersist : LoginPersist = LoginPersist()
    
    //var
    var flagRegister: Bool = false
    var flagEdit: Bool = false
    var meals : [Meal] = [Meal]()
    var user: User?
    var username: String = ""
    var password: String = ""
    
    //property
    @IBOutlet weak var userView: UserView!
    @IBOutlet weak var mealList: loginButton!
    @IBOutlet weak var logout: loginButton!
    @IBOutlet weak var edit: loginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if flagRegister {
            self.isRegister()
        }
        if user != nil {
            self.userView.name.text = user?.name
            self.userView.phone.text = user?.phone
            self.userView.address.text = user?.address
            if user?.photo == "" {
                self.userView.profileImage.image = UIImage(named: "emptyProfileImg")
            } else {
                self.userView.profileImage.kf.setImage(with: URL(string: user!.photo))
            }
            self.meals = user!.meals
        }
        self.userView.profileImgPicker.addTarget(self, action: #selector(imgChoose), for: .touchUpInside)
    }
    
    
    @IBAction func getMealList(_ sender: loginButton) {
        let loading_alert = helper.loading_alert()
        self.present(loading_alert, animated: true, completion: nil)
        loading_alert.dismiss(animated: true) {
            self.loadMealView(user: self.user!)
        }
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        loginPersist.removeLoginInfo(forUserID: "loginInfo")
//        let loading_alert = self.helper.loading_alert()
//        self.present(loading_alert, animated: true, completion: nil)
//        if let user = self.user {
//            self.apis.updateLogout(user: user) { (result) in
//                loading_alert.dismiss(animated: true) {
//                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
//                }
//            }
//        } else {
//            loading_alert.dismiss(animated: true) {
//                self.present(self.helper.non_action_alert(msg: "User not saved. Try again later", title: "USER LOGOUT"), animated: true) {
//                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
//                }
//            }
//        }
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userEdit(_ sender: Any) {
        let loading_alert = helper.loading_alert()
        if flagRegister {
            var profileImg : String = ""
            self.present(loading_alert, animated: true, completion: nil)
            if let image = self.userView.profileImage.image {
                let x = helper.IMG_NAME()
                profileImg = IMG.NAME+x+".jpeg"
                helper.imgUpload(image: image, name: x)
            }
            if let newUser = User(id: 0, username: self.username, password: self.password,
                                  name: self.userView.name.text,
                                  phone: self.userView.phone.text,
                                  address: self.userView.address.text,
                                  photo: profileImg,
                                  meals: []) {
                self.group.enter()
                apis.register(user: newUser) { (result) in
                    if result {
                        loading_alert.dismiss(animated: true) {
                            self.loadUserView(user: newUser)
                        }
                        self.group.leave()
                    } else {
                        loading_alert.dismiss(animated: true) {
                            self.present(self.helper.non_action_alert(msg: "Register failed. Please try again", title: "Register fail"), animated: true, completion: nil)
                        }
                    }
                }
            } else {
                loading_alert.dismiss(animated: true) {
                    self.present(self.helper.non_action_alert(msg: "Fields can not be empty", title: "FIELD EMPTY"), animated: true, completion: nil)
                }
            }
        }else if flagEdit {
            var profileImg : String = ""
            self.present(loading_alert, animated: true, completion: nil)
            if let image = self.userView.profileImage.image {
                let x = helper.IMG_NAME()
                profileImg = IMG.NAME+x+".jpeg"
                helper.imgUpload(image: image, name: x)
            }
            let username = self.user?.username
            let password = self.user?.password
            let name = self.userView.name.text!
            let phone = self.userView.phone.text!
            let address = self.userView.address.text!
            if let updateUser = User(id: 0, username: username!, password: password!,
                                     name: name,
                                     phone: phone,
                                     address: address,
                                     photo: profileImg,
                                     meals: []) {
                self.apis.update(user: updateUser) { (result) in
                    if result {
                        loading_alert.dismiss(animated: true) {
                            self.present(self.helper.non_action_alert(msg: "Update success", title: "USER UPDATE"), animated: true) {
                                self.isEdit(edit: false)
                                self.flagEdit = false
                            }
                        }
                    } else {
                        loading_alert.dismiss(animated: true) {
                            self.present(self.helper.non_action_alert(msg: "Update failed", title: "USER UPDATE"), animated: true) {
                                self.isEdit(edit: false)
                                self.flagEdit = false
                            }
                        }
                    }
                }
            } else {
                loading_alert.dismiss(animated: true) {
                    self.present(self.helper.non_action_alert(msg: "User undefined", title: "USER UPDATE"), animated: true, completion: nil)
                }
            }
        } else {
            self.isEdit(edit: true)
            print("edit true")
            flagEdit = true
        }
    }
   
    
    //HELPER
    
    func loadUserView(user: User){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let userView = storyboard.instantiateViewController(identifier: "UserView") as! UserViewController
        userView.modalPresentationStyle = .fullScreen
        userView.user = user
        self.present(userView, animated: true, completion: nil)
    }
    func loadMealView(user: User){
        let storyboard = UIStoryboard(name: "MealList", bundle: nil)
        let mealView = storyboard.instantiateViewController(identifier: "TestView") as! UINavigationController
        mealView.modalPresentationStyle = .fullScreen
        let mealTableView = mealView.viewControllers.first as! MealTableController
        mealTableView.user_id = user.id
        mealTableView.meals = user.meals
        mealTableView.updateMeal = { (meals : [Meal]) in
            self.user?.meals = meals
        }
        self.present(mealView, animated: true, completion: nil)
    }
    func isRegister(){
        self.userView.isEditing(edit: true)
        self.logout.isHidden = true
        self.mealList.isHidden = true
        self.edit.setTitle("Done", for: .normal)
    }
    func isEdit(edit: Bool){
        self.userView.isEditing(edit: edit)
        if edit {
            self.edit.setTitle("Done", for: .normal)
            self.logout.isHidden = true
            self.mealList.isHidden = true
        } else {
            self.edit.setTitle("Edit", for: .normal)
            self.logout.isHidden = false
            self.mealList.isHidden = false
        }
    }
    
    
    @objc func imgChoose() {
        print("profile button touch")
        let imgPickerController = UIImagePickerController()
        imgPickerController.sourceType = .photoLibrary
        imgPickerController.delegate = self
        self.present(imgPickerController, animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            fatalError()
        }
        self.userView.profileImage.image = selectedImage
        self.userView.profileImgPicker.setImage(.none, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}

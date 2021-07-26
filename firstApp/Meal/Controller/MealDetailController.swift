//
//  MealDetailController.swift
//  firstApp
//
//  Created by Nguyen Nhat Duy on 06/04/2021.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit

class MealDetailController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //service
    let apis: fetchAPIs = fetchAPIs()
    let helper: Helper = Helper()
    let group: DispatchGroup = DispatchGroup()
    
    //property
    @IBOutlet weak var mealDetail: MealDetail!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var rightBtn: UIBarButtonItem!
    
    //var
    var row: Int = 0
    var meal: Meal?
    var user_id : Int = 0
    var flagCreate: Bool = false
    var flagEdit: Bool = false
    var update: ((_ meal: Meal, _ row: Int) -> Void)?
    var create: ((_ meal: Meal) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meal = self.meal {
            self.navigationItem.title = meal.name
            self.mealDetail.mealName.text = meal.name
            self.mealDetail.mealAddress.text = meal.address
            self.mealDetail.mealRating.rating = meal.rating
            if meal.photo == ""{
                self.mealDetail.mealImg.image = UIImage(named: "emptyMealImg")
            } else {
                self.mealDetail.mealImg.kf.setImage(with: URL(string: meal.photo))
            }
        }
        self.mealDetail.getAddress.addTarget(self, action: #selector(getAddress), for: .touchUpInside)
        self.mealDetail.addImg.addTarget(self, action: #selector(getImg), for: .touchUpInside)
        isCreate(create: flagCreate)
    }
    
    
    
    //function
    @IBAction func leftBtnPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
 
    @IBAction func rightBtnPress(_ sender: Any) {
        if self.rightBtn.title == "Save"{
            self.saveBtn()
        }
        if !flagCreate {
            self.edit()
        }
    }
    
    @objc func getAddress(){
        let storyboard = UIStoryboard(name: "MealList", bundle: nil)
        let addressView = storyboard.instantiateViewController(identifier: "Address") as! AddressViewController
        addressView.modalPresentationStyle = .popover
        addressView.updateAddress = { (address: String) in
            self.mealDetail.mealAddress.text = address
        }
        self.present(addressView, animated: true, completion: nil)
    }
    
    @objc func getImg(){
        let imgPickerController = UIImagePickerController()
        imgPickerController.sourceType = .photoLibrary
        imgPickerController.delegate = self
        self.present(imgPickerController, animated: true, completion: nil)
    }
    
    func edit() {
        if flagEdit{
            self.rightBtn.title = "Edit"
            self.isEdit(edit: false)
            self.saveBtn()
            
        } else {
            self.isEdit(edit: true)
            self.rightBtn.title = "Done"
        }
        self.flagEdit = !self.flagEdit
    }
    
    func saveBtn() {
        let loading_alert = self.helper.loading_alert()
        let name = self.mealDetail.mealName.text
        let address = self.mealDetail.mealAddress.text
        let rating = self.mealDetail.mealRating.rating
        self.present(loading_alert, animated: true, completion: nil)
        if let image = self.mealDetail.mealImg.image {
            let x = self.helper.IMG_NAME()
            let mealImg = IMG.NAME + x + ".jpeg"
            self.apis.createImage(image: image, name: x) { (result) in
                if let meal = Meal(id: 0, name: name!,
                                   photo: mealImg, rating: rating, address: address ?? "No address", user_id: self.user_id) {
                    if self.flagCreate{
                        self.isCreate(create: false)
                        self.create?(meal)
                    } else {
                        self.update?(meal, self.row)
                    }
                    loading_alert.dismiss(animated:true){
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    loading_alert.dismiss(animated:true){
                        self.present(self.helper.non_action_alert(msg: "Meal nil", title: "Meal"), animated: true, completion: nil)
                    }
                }
            }
        } else {
            if let meal = Meal(id: 0, name: name!,
                               photo: "", rating: rating, address: address ?? "No address", user_id: self.user_id) {
                if self.flagCreate{
                    self.isCreate(create: false)
                    self.create?(meal)
                } else {
                    self.update?(meal, self.row)
                }
                loading_alert.dismiss(animated:true){
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                loading_alert.dismiss(animated:true){
                    self.present(self.helper.non_action_alert(msg: "Meal nil", title: "Meal"), animated: true, completion: nil)
                }
            }
        }
        
    }
    
  
    
    
    //HELPER
    
    private func isCreate(create:Bool){
        self.mealDetail.mealRating.isUserInteractionEnabled = create
        self.mealDetail.addImg.isHidden = !create
        self.mealDetail.getAddress.isEnabled = create
        self.mealDetail.mealName.isEnabled = create
        self.mealDetail.mealAddress.isEditable = create
        if create{
            self.rightBtn.title = "Save"
            self.mealDetail.mealName.layer.borderColor = UIColor.black.cgColor
            self.mealDetail.mealAddress.layer.borderColor = UIColor.black.cgColor
        } else {
            self.mealDetail.mealName.layer.borderColor = UIColor.lightGray.cgColor
            self.mealDetail.mealAddress.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    private func isEdit(edit: Bool){
        self.mealDetail.mealName.isEnabled = edit
        self.mealDetail.getAddress.isEnabled = edit
        self.mealDetail.mealAddress.isEditable = edit
        self.mealDetail.mealRating.isUserInteractionEnabled = edit
        self.mealDetail.addImg.isHidden = !edit
        if edit{
            self.mealDetail.mealName.layer.borderColor = UIColor.black.cgColor
            self.mealDetail.mealAddress.layer.borderColor = UIColor.black.cgColor
        } else {
            self.mealDetail.mealName.layer.borderColor = UIColor.lightGray.cgColor
            self.mealDetail.mealAddress.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError()
        }
        self.mealDetail.mealImg.image = selectedImage
        self.mealDetail.addImg.setImage(.none, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
}

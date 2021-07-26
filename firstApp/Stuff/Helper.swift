//
//  Helper.swift
//  firstApp
//
//  Created by Nguyen Nhat Duy on 29/03/2021.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Helper: NSObject{
    
    let apis : fetchAPIs = fetchAPIs()
    let group: DispatchGroup = DispatchGroup()
    
    func IMG_NAME() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<15).map{ _ in letters.randomElement()! })
    }
    
    func non_action_alert( msg: String, title: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        return alert
    }
    
    func loading_alert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait", preferredStyle: .alert)
        let loading = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loading.hidesWhenStopped = true
        loading.style = UIActivityIndicatorView.Style.medium
        loading.startAnimating()
        alert.view.addSubview(loading)
        return alert
    }
    
    
    func imgUpload(image: UIImage, name : String) {
        self.apis.createImage(image: image, name: name) { (result) in
            if !result {
                print("Img upload failed")
            }
        }
    }
}

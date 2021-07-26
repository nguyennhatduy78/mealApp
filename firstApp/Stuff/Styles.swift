//
//  styles.swift
//  firstApp
//
//  Created by ChinhPV on 3/18/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class loginButton: UIButton {
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = borderRadius
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
    }
}

@IBDesignable class profileImage: UIImageView{
    @IBInspectable var borderRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = borderRadius
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}

@IBDesignable class inputTextView: UITextView {
    @IBInspectable var borderRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = borderRadius
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}

@IBDesignable class checkBox : UIButton{
    @IBInspectable var borderRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = borderRadius
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = .clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    var isCheck: Bool = false {
        didSet{
            if isCheck == true {
                layer.backgroundColor = UIColor.green.cgColor
            } else {
                layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.isCheck = false
    }
    
    @objc func buttonClick(sender: UIButton){
        if sender == self {
            isCheck = !isCheck
        }
    }
}

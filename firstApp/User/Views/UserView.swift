//
//  User.swift
//  firstApp
//
//  Created by ChinhPV on 3/22/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit

@IBDesignable class UserView: UIView {

    
    let nibName = "UserView"
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var profileImgPicker: UIButton!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var phone: UITextView!
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    func viewInit() {
        contentView = loadView()
        contentView.frame = self.bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(contentView)
        self.profileImage.contentMode = .scaleToFill
        self.name.layer.cornerRadius = 5
        self.phone.layer.cornerRadius = 5
        self.address.layer.cornerRadius = 15
        self.profileImgPicker.isHidden = true
    }
    func loadView() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func isEditing(edit: Bool){
        self.name.isEditable = edit
        self.phone.isEditable = edit
        self.address.isEditable = edit
        self.profileImgPicker.isHidden = !edit
        if edit {
            self.name.layer.borderWidth = 1
            self.name.layer.borderColor = UIColor.lightGray.cgColor
            self.phone.layer.borderWidth = 1
            self.phone.layer.borderColor = UIColor.lightGray.cgColor
            self.address.layer.borderWidth = 1
            self.address.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            self.name.layer.borderWidth = 0
            self.phone.layer.borderWidth = 0
            self.address.layer.borderWidth = 0
        }
    }
}

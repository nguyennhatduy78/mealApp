//
//  LoginView.swift
//  firstApp
//
//  Created by ChinhPV on 3/16/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class LoginView: UIView {
    
    //var
    let nibName = "LoginView"
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var saveLogin: checkBox!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var resetPsw: loginButton!
    @IBOutlet weak var login: loginButton!
    
    @IBOutlet weak var register: UIButton!
    @IBOutlet var contentView: UIView!
    
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
    }
    func loadView() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}



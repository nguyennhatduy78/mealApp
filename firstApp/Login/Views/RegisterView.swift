//
//  RegisterView.swift
//  firstApp
//
//  Created by ChinhPV on 3/22/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit

@IBDesignable class RegisterView: UIView {
    
    let nibName = "RegisterView"
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet var contentView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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


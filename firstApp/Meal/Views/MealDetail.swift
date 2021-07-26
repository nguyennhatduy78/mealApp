//
//  MeaDetail.swift
//  firstApp
//
//  Created by Nguyen Nhat Duy on 06/04/2021.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit

@IBDesignable class MealDetail: UIView {

    let nibName = "MealDetail"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var mealAddress: inputTextView!
    @IBOutlet weak var mealImg: UIImageView!
    @IBOutlet weak var getAddress: UIButton!
    @IBOutlet weak var mealRating: RatingControl!
    @IBOutlet weak var addImg: UIButton!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    override init(frame: CGRect){
        super.init(frame: frame)
        viewInit()
    }

    func viewInit(){
        contentView = loadView()
        contentView.frame =  self.bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(contentView)
        self.mealName.layer.borderWidth = 1
        self.mealName.layer.borderColor = UIColor.lightGray.cgColor
        self.mealImg.contentMode = .scaleToFill
        self.mealRating.isUserInteractionEnabled = false
    }
    
    func loadView() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

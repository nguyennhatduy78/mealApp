//
//  MealCell.swift
//  firstApp
//
//  Created by Nguyen Nhat Duy on 13/04/2021.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {

    var meal_id: Int = 0
    @IBOutlet weak var mealRating: RatingControl!
    @IBOutlet weak var mealAddress: UITextView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func cellInit(){
//        self.accessoryType = .detailButton
        mealRating.frame = CGRect(x: 144, y: 24, width: 216, height: 49)
        mealRating.distribution = .fillEqually
        mealImg.image = UIImage(named: "photo.fill")
        mealImg.frame = CGRect(x: 10, y: 25, width: 126, height: 87)
        mealName.frame = CGRect(x: 10, y: 121, width: 126, height: 30)
        mealName.textAlignment = .center
        mealAddress.frame = CGRect(x: 144, y: 89, width: 216, height: 62)
        mealAddress.isEditable = false
    }
}

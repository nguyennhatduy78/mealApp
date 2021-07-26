//
//  EmptyCell.swift
//  firstApp
//
//  Created by Nguyen Nhat Duy on 08/04/2021.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit

@IBDesignable class EmptyCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellInit(){
        self.cellLabel.frame = CGRect(x: 20, y: 36, width: 374, height: 99)
        self.cellLabel.text = "MEAL EMPTY"
        print("Empty cell called")
    }
}

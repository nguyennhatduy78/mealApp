//
//  AddressTableViewCell.swift
//  firstApp
//
//  Created by ChinhPV on 3/6/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit
import MapKit

class AddressTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var addressMapView: MKMapView!
}

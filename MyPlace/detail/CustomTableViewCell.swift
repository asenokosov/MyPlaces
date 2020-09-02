//
//  CustomTableViewCell.swift
//  MyPlace
//
//  Created by User on 12/08/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLAbel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var mainTableRating: mainTableRatingStar!
    
}


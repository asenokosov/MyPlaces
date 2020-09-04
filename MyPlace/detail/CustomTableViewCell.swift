//
//  CustomTableViewCell.swift
//  MyPlace
//
//  Created by User on 12/08/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet {
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2.5
            imageOfPlace.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLAbel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var mainTableRating: mainTableRatingStar!
    
    @IBOutlet var cosmocView: CosmosView! {
        didSet {
            cosmocView.settings.updateOnTouch = false
        }
    }
}


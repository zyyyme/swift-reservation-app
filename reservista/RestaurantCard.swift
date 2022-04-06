//
//  RestaurantCard.swift
//  reservista
//
//  Created by Владислав Левченко on 03.04.2022.
//

import Foundation
import UIKit


class RestaurantCard: UITableViewCell {
    
    @IBOutlet var restaurantImage: UIImageView!
    @IBOutlet var restaurantName: UILabel!
    @IBOutlet var restaurantAddress: UILabel!
    @IBOutlet var restaurantPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

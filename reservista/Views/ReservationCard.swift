//
//  ReservationCard.swift
//  reservista
//
//  Created by Владислав Левченко on 04.04.2022.
//

import Foundation
import UIKit

class ReservationCard: UICollectionViewCell {
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var restaurantImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

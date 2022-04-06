//
//  RestaurantInfoController.swift
//  reservista
//
//  Created by Владислав Левченко on 03.04.2022.
//

import Foundation
import UIKit


class RestaurantInfoController: UITableViewController {
    var restaurant: Restaurant!
    
    @IBOutlet weak var cell: RestaurantInfo!
    
    init?(coder: NSCoder, restaurant: Restaurant) {
      self.restaurant = restaurant
      super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let restaurant = restaurant {
            cell.restaurantName.text = restaurant.name
            cell.restaurantAddress.text = restaurant.address
            cell.restaurantPrice.text = String(repeating: "₽", count: restaurant.price)
            cell.restaurantImage.loadurl(url: URL(string: restaurant.image)!)
            cell.restaurantDescription.text = restaurant.description
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    @IBSegueAction func makeReservation(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> ReservationsPicker? {
        return ReservationsPicker(coder: coder, restaurant: restaurant)
    }
}

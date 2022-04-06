//
//  RestaurantTableController.swift
//  reservista
//
//  Created by Владислав Левченко on 03.04.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func loadurl(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


class RestaurantTableController: UITableViewController {
    var restaurants = [Restaurant]()
    var selectedRestaurant = 0
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCellIdentifier", for: indexPath) as! RestaurantCard
        
        let restaurant = restaurants[indexPath.row]
        cell.restaurantName.text = restaurant.name
        cell.restaurantAddress.text = restaurant.address
        cell.restaurantPrice.text = String(repeating: "₽", count: restaurant.price)
        cell.restaurantPrice.textColor = .white
        if restaurant.image != "" {
            cell.restaurantImage.loadurl(url: URL(string: restaurant.image)!)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedRestaurant = indexPath.row
            print(selectedRestaurant)
            performSegue(withIdentifier: "ShowRestaurant", sender: self)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Restaurant.loadRestaurants { (data, error) -> Void in
            self.restaurants = data
            print(self.restaurants)
            DispatchQueue.main.async{
              self.tableView.reloadData()
            }
        }
        if self.restaurants.isEmpty {
            restaurants = Restaurant.loadSampleRestaurants()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
    }
    
    
    @IBSegueAction private func showRestaurant(coder: NSCoder, sender: Any?, segueIdentifier: String?)
        -> RestaurantInfoController? {
            print(selectedRestaurant)
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
                return nil
            }
            tableView.deselectRow(at: indexPath, animated: true)
            return RestaurantInfoController(coder: coder, restaurant: restaurants[indexPath.row])
    }
}


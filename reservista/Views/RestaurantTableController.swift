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

extension UIImage
{
    func resizedImage(Size sizeImage: CGSize) -> UIImage?
    {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sizeImage.width, height: sizeImage.height))
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        self.draw(in: frame)
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.withRenderingMode(.alwaysOriginal)
        return resizedImage
    }
}


class RestaurantTableController: UITableViewController {
    var restaurants = [Restaurant]()
    var profileImageUrl: URL?
    var selectedRestaurant = 0

    @IBOutlet var profileButton: UIButton!
    
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
        
        ReservationController.shared.fetchRestaurants { (result) -> Void in
            switch result {
            case .success(let data):
                DispatchQueue.main.async{
                    self.restaurants = data
                    print(self.restaurants)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.displayError(error, title: "There was an error :(")
            }
            
           
        }
        
        if self.restaurants.isEmpty {
            restaurants = Restaurant.loadSampleRestaurants()
        }
        
        ReservationController.shared.fetchUser() { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async{ [self] in
                    self.profileImageUrl = URL(string: data.image)!
                    let image = try? UIImage(data: Data(contentsOf: self.profileImageUrl!))
                    let smallerImage = image?.resizedImage(Size: CGSize(width: 40, height: 40))
                    try? self.profileButton.setImage(smallerImage, for: .normal)
                    self.profileButton.contentMode = .scaleAspectFit
                    self.profileButton.imageView?.contentMode = .scaleAspectFit
                    self.profileButton.imageView?.layer.masksToBounds = true
                    self.profileButton.imageView?.layer.cornerRadius = 20
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.displayError(error, title: "There was an error :(")
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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


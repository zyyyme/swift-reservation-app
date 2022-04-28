//
//  ProfileController.swift
//  reservista
//
//  Created by Владислав Левченко on 04.04.2022.
//

import Foundation
import UIKit

class ProfileController: UITableViewController {
    var reservations = [Reservation]()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ReservationCard {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCard", for: indexPath) as! ReservationCard
//
//        let reservation = reservations[indexPath.row]
//        cell.placeLabel.text = reservation.restaurant.name
//        cell.dateLabel.text = reservation.date
//        if reservation.restaurant.image != "" {
//            cell.restaurantImage.loadurl(url: URL(string: reservation.restaurant.image)!)
//        }
//        
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ReservationController.shared.fetchReservations() { (result) -> Void in
            switch result{
            case .success (let data):
                DispatchQueue.main.async{
                    self.reservations = data
                    print(self.reservations)
                      self.tableView.reloadData()
                    }
            case .failure(let error):
                self.displayError(error, title: "There was an error :(")
            }
        }
        if self.reservations.isEmpty {
            self.reservations = Reservation.loadSampleReservations()
        }
        print(reservations)

    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

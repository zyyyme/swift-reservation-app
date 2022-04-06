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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ReservationCard {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCard", for: indexPath) as! ReservationCard

        let reservation = reservations[indexPath.row]
        cell.placeLabel.text = reservation.restaurant.name
        cell.dateLabel.text = reservation.date
        cell.restaurantImage.loadurl(url: URL(string: reservation.restaurant.image)!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Reservation.loadReservations { (data, error) -> Void in
            self.reservations = data
            print(self.reservations)
            DispatchQueue.main.async{
              self.tableView.reloadData()
            }
        }
        if self.reservations.isEmpty {
            self.reservations = Reservation.loadSampleReservations()
        }
        print(reservations)

    }
}

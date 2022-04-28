//
//  ReservationsPicker.swift
//  reservista
//
//  Created by Владислав Левченко on 03.04.2022.
//

import Foundation
import UIKit


class ReservationsPicker: UITableViewController {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var peopleCounter: UISegmentedControl!
    
    var peopleAmount: String = "1-2"
    var restaurant: Restaurant
    
    init?(coder: NSCoder, restaurant: Restaurant) {
      self.restaurant = restaurant
    
      super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    func updateDateLabel(date: Date) {
        dateLabel.text = dueDateFormatter.string(from: date)
    }
    
    override func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath) {
        updateDateLabel(date: datePicker.date)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        datePicker.date = Date().addingTimeInterval(24*60*60)
        datePicker.minuteInterval = 15
        updateDateLabel(date: datePicker.date)
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        updateDateLabel(date: sender.date)
    }
    
    
    @IBAction func makeReservation(_ sender: UIButton) {
        if peopleCounter.selectedSegmentIndex == 0 {
            peopleAmount = "1-2"
        } else if peopleCounter.selectedSegmentIndex == 1 {
            peopleAmount = "3-5"
        } else if peopleCounter.selectedSegmentIndex == 2 {
            peopleAmount = "6-7"
        } else {
            peopleAmount = "8+"

        }

        _ = Reservation(restaurant: self.restaurant, date: self.dateLabel.text!, people: self.peopleAmount)

        ReservationController.shared.makeReservation(restaurant: restaurant.id, date: dateLabel.text!, people: peopleAmount) { (result) in
            switch result {
            case .success(_): do {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "Reservation Complete!", preferredStyle: UIAlertController.Style.alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when){
                        alert.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "reservationSuccess", sender: nil)
                    }
                }
                
            }
            case .failure(let error):
                self.displayError(error, title: "Error making a reservation :(")
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
}

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

        _ = Reservation(restaurant: restaurant, date: dateLabel.text!, people: peopleAmount)
        postReservation()
        
        let alert = UIAlertController(title: "Success", message: "Reservation Complete!", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }

        
    }
    
    func postReservation() {
        var data = Dictionary<String, String>()
        data["user_id"] = Constants().userId
        data["restaurant_id"] = restaurant.id
        data["date"] = dateLabel.text!
        data["people"] = peopleAmount
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        let url = URL(string: "http://localhost:8000/api/v1/reservations")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData!
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }

        task.resume()
    }
}

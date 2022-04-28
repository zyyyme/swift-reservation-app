//
//  ProfileViewController.swift
//  reservista
//
//  Created by Владислав Левченко on 19.04.2022.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var username: UILabel!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var reservationsTable: UICollectionView!
    var reservations = [Reservation]()
    
    @IBAction func logOut(_ sender: Any) {
        ReservationController.shared.accessToken = ""
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.reservationsTable = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
        self.reservationsTable.dataSource = self
        self.reservationsTable.delegate = self
        
        ReservationController.shared.fetchUser() { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async{ [self] in
                    self.userImage.loadurl(url: URL(string: data.image)!)
                    let greetingString = "\(data.name)"
                    print(greetingString)
                    self.username.text = greetingString
                }
            case .failure(let error):
                self.displayError(error, title: "There was an error :(")
            }
        }
        
        ReservationController.shared.fetchReservations() { (result) -> Void in
            switch result{
            case .success (let data):
                DispatchQueue.main.async{
                    self.reservations = data
                    print(self.reservations)
                    self.reservationsTable.reloadData()
                    }
            case .failure(let error):
                self.displayError(error, title: "There was an error :(")
            }
        }
        if self.reservations.isEmpty {
            self.reservations = Reservation.loadSampleReservations()
        }
        
        self.reservationsTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func collectionView(_ tableView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.reservationsTable.dequeueReusableCell(withReuseIdentifier: "ReservationCard", for: indexPath) as! ReservationCard

        let reservation = self.reservations[indexPath.row]
        cell.placeLabel!.text = reservation.restaurant.name
        cell.dateLabel!.text = reservation.date
        if reservation.restaurant.image != "" {
            cell.restaurantImage!.loadurl(url: URL(string: reservation.restaurant.image)!)
        }
        
        return cell
    }

    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  RegisterViewController.swift
//  reservista
//
//  Created by Владислав Левченко on 18.04.2022.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var registerButton: UIButton!
    
    @IBAction func buttonPressed(_ sender: Any) {
        let name = username.text!
        let password = password.text!
        print(name, password)
        ReservationController.shared.registerUser(username: name, password: password) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    print(data)
                    self.performSegue(withIdentifier: "registerSuccess", sender: nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.displayError(error, title: "Registration Failed")
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

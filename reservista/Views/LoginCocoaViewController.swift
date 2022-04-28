//
//  LoginCocoaViewController.swift
//  reservista
//
//  Created by Владислав Левченко on 18.04.2022.
//

import UIKit

class LoginCocoaViewController: UIViewController {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    @IBAction func buttonPressed(_ sender: Any) {
        let name = username.text!
        let password = password.text!
        ReservationController.shared.loginUser(username: name, password: password) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    UserDefaults.standard.set(self.username.text!, forKey: "username")
                    UserDefaults.standard.set(self.password.text!, forKey: "password")
                    self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                }
            case .failure(let error):
                self.displayError(error, title: "Login Failed")
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
        
        let username = UserDefaults.standard.string(forKey: "username")
        let password = UserDefaults.standard.string(forKey: "password")
        if let username = username, let password = password {
            ReservationController.shared.loginUser(username: username, password: password) { (result) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(password, forKey: "password")
                        self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                    }
                case .failure(let error):
                    self.displayError(error, title: "Login Failed")
                }
            }
        }
        
        
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

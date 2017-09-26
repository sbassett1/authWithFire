//
//  ViewController.swift
//  AuthenticationUsingFirebase
//
//  Created by Mac on 9/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var logIn: UIButton!
    var signUpMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var error:NSError?
        let localAuthContext = LAContext()
        guard localAuthContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:&error) else {return}
        localAuthContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Without your fingerprint you need a code"){
            [unowned self](success,error) in
            if success {
                print("whoo!! we did it (cheating bastard!)")
                //log in with the user name and password code below
                
            } else {
                self.displayAlert(title: "of course im not cheating", message: "Damn it Daniel you're caught")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpClicked(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "Please enter email and password")
        } else {
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    if signUpMode {
                        // SIGN UP
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                print("Sign Up Success")
                            }
                        })
                    } else {
                        // LOG IN
                        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                print("Log In Success")
                                let localAuthContext = LAContext()
                                var error:NSError?      //inout so need & when calling variable in below guard
                                guard localAuthContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:&error) else {return}
                                self.sendAlert(message: "Touch ID", title: "Do you want to keep hiding this information from your girlfriend by using Touch ID instead of password") 
                            }
                        })
                    }
                }
            }
        }
    }
    @IBAction func logInClicked(_ sender: Any) {
        if signUpMode {
            signUp.setTitle("Log In", for: .normal)
            logIn.setTitle("Switch to Sign Up", for: .normal)
            signUpMode = false
        } else {
            signUp.setTitle("Sign Up", for: .normal)
            logIn.setTitle("Switch to Log In", for: .normal)
            signUpMode = true
        }
    }
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func sendAlert(message:String,title:String,completion:(() -> ())? = nil){
        let alert = UIAlertController(title:title, message:message,preferredStyle: .alert)
        let ok = UIAlertAction(title:"ok",style: .default){
            alert in completion?()
        }
        alert.addAction(ok)
        if let _ = completion {
            let no = UIAlertAction(title: "No", style: .cancel)
            alert.addAction(no)
        }
        self.present(alert,animated: true)
    }
    
}





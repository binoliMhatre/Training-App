//
//  LoginViewController.swift
//  Heart Rate App
//
//  Created by Nghiem Le on 11/24/16.
//  Updated by Kyle Hammerschmidt on 3/11/2017
//  Copyright © 2016 Matt Leccadito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var inputTextField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        if self.userEmailTextField.text == "" || self.userPasswordTextField.text == "" {
            //Alert to tell the user that there was an error 
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }else{
            FIRAuth.auth()?.signIn(withEmail: self.userEmailTextField.text!, password: self.userPasswordTextField.text!) { (user, error) in
                if error == nil{
                    //printing to console
                    print("You have successfully logged in")
                    
                    //Go to HomeViewController if the login is sucessfull
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Level")
                    self.present(vc!, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }
    }
}


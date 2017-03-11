//
//  SignUpPageViewController.swift
//  Heart Rate App
//
//  Created by Nghiem Le on 11/12/16.
//  Updated by Kyle Hammerschmidt on 3/11/2017
//  Copyright © 2016 Matt Leccadito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpPageViewController: UIViewController, UITextFieldDelegate {
     @IBOutlet weak var inputTextField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var setusernameTextField: UITextField!
    
    @IBOutlet weak var useremailTextField: UITextField!
    
    @IBOutlet weak var userpasswordTextField: UITextField!
    
    @IBOutlet weak var usercomfirmpasswordTextField: UITextField!
    
    @IBOutlet weak var userspecialtyTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignupButtonTapped(_ sender: Any)
    {
        if useremailTextField.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }else{
            FIRAuth.auth()?.createUser(withEmail: useremailTextField.text!, password: userpasswordTextField.text!){ (user, error) in
                if error == nil{
                    print("you have successfully signed up")
                    //Goes to the setup page whic lets the user do w/e
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Level")
                    self.present(vc!,animated: true, completion: nil)
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

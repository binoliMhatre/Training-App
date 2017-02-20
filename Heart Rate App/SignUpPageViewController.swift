//
//  SignUpPageViewController.swift
//  Heart Rate App
//
//  Created by Nghiem Le on 11/12/16.
//  Copyright © 2016 Matt Leccadito. All rights reserved.
//

import UIKit

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
        let createusername = setusernameTextField.text;
        let userEmail = useremailTextField.text;
        let userPassword = userpasswordTextField.text;
        let userRepeatPassword = usercomfirmpasswordTextField.text;
        let userSpecialty = userspecialtyTextField.text;
        
    
        // Check for  empty fields
         if((createusername?.isEmpty)! || (userEmail?.isEmpty)! || (userPassword?.isEmpty)! || userRepeatPassword!.isEmpty || (userSpecialty?.isEmpty)!)
                {
                    displayMyAlertMessage(userMesssage: "All field are required");
                    
                    return;
                    
                }
        
        // Check if passwords match
        if (userPassword != userRepeatPassword)
        {
            // display an alert message
            displayMyAlertMessage(userMesssage: "Passwords do not match");
            return;
            
        }
        
        // Store data
        UserDefaults.standard.set(userEmail, forKey:"userEmail");
        UserDefaults.standard.set(userPassword, forKey:"userPassword");
        UserDefaults.standard.synchronize();
        
        
        
        // display alert message with confirmation
        let myAlert = UIAlertController(title:"Alert", message:" Registration is sucessful. Thank you!", preferredStyle: UIAlertControllerStyle.alert);
        
        let OkAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default){
            action in
            self.dismiss (animated: true, completion:nil);
            
        }
        myAlert.addAction(OkAction);
        self.present(myAlert,animated: true, completion: nil);
        
    }
    
    func displayMyAlertMessage(userMesssage: String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMesssage, preferredStyle: UIAlertControllerStyle.alert);
        let OkAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(OkAction);
        self.present(myAlert,animated:true, completion:nil);
        
    }
}

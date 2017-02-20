//
//  LoginViewController.swift
//  Heart Rate App
//
//  Created by Nghiem Le on 11/24/16.
//  Copyright © 2016 Matt Leccadito. All rights reserved.
//

import UIKit


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
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        
        let userEmailStored = UserDefaults.standard.string(forKey: "userEmail");
        
        let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword");
    
        if(userEmailStored == userEmail)
        {
            if(userPasswordStored == userPassword)
                
            {
                // Login is Sucessful
                
                UserDefaults.standard.set(true,forKey:"isUserLoggedin");
                UserDefaults.standard.synchronize();
                self.dismiss(animated: true,completion:nil);
                
                
            }
        }
    }
}


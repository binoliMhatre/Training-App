//
//  ResetPasswordViewController.swift
//  Heart Rate App
//
//  Created by student on 3/11/17.
//  Copyright © 2017 Matt Leccadito. All rights reserved.
//

/*
import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 
 
@IBAction func submitAction(_ sender: AnyObject){
    if self.emailTextField.text == ""{
        let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
    }else{
        FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailTextField.text!, completion:{ (error) in
            var title = ""
            var message = ""
            
            if error != nil{
                title = "Error"
                message = (error?.localizedDescription)
                
            }else{
                title = "Success!"
                message = "Password reset email sent"
                self.emailTextField.text = ""
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
}

}

*/

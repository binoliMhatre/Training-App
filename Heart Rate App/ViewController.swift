

import UIKit
//import Firebase
import FirebaseAuth

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NewGame()
    {
        let alert = UIAlertController(title: "NEW GAME",
            message: "A NEW GAME SHOULD OPEN", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ResumeGame()
    {
        let alert = UIAlertController(title: "RESUME GAME",
            message: "THE GAME IN SESSION SHOULD BE RESUMED", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func About()
    {
        let AboutTitle = "ABOUT"
        let msg1 = "SIM Anesthesia allows you go through a case with your patient from start to finish. \n\n"
        let msg2 = "You will choose your plan for your anesthetic, initiate your treatments, order various therapies, and ultimately determine the survival of your patient. \n\n"
        let msg3 = "You will have the benefit of on-screen monitors providing real time information about your patient that responds to your actions. \n\n"
        let msg4 = "You will be scored on your choices and given feedback for improvement. \n\n"
        let msg5 = "See if you can navigate the unpredictable world of anesthesia and keep your patient safe! \n\n"
        let msg6 = "GOOD LUCK!"
        let aboutMessage = msg1 + msg2 + msg3 + msg4 + msg5 + msg6
        
        let alert = UIAlertController(title: AboutTitle,
            message: aboutMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func Logout(sender: AnyObject){
        if FIRAuth.auth()?.currentUser != nil{
            do{
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcomepageview")
                present(vc, animated: true, completion: nil)
                
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    
    
    
}


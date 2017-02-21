//
//  PatientInfoViewController.swift
//  Heart Rate App
//
//  Created by Binoli Mhatre on 6/14/16.
//  Copyright © 2016 Matt Leccadito. All rights reserved.
//

import UIKit

class PatientInfoViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var infoTableView: UITableView!
  var cellDescriptors: NSMutableDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doneButtnClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if let path = Bundle.main.path(forResource: "PatientData", ofType: "plist") {
            cellDescriptors = NSMutableDictionary(contentsOfFile: path)
            infoTableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDescriptors.allKeys.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cellIdentifier = "InfoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)as! InfoCell
        let title=cellDescriptors.allKeys[(indexPath as NSIndexPath).row] as? String;
        
        cell.lblTitle.text=title;
        
        cell.txtInfo.text=cellDescriptors.value(forKey: title!)as? String
        
        // Configure the cell...
        
        return cell
    }

}

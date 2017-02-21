//
//  SelectedCaseViewController.swift
//  Heart Rate App
//
//  Created by Coffee Bourne on 11/4/16.
//  Copyright © 2016 Matt Leccadito. All rights reserved.
//

import Foundation
import UIKit

class SelectedCaseViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    var cases: [String] = ["Burns", "Cardiac", "Neurology", "Obstetrics", "Pediatrics", "Trauma"]

    @IBOutlet var tableView: UITableView!
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
    
    // MARK: - TableView DataSource and Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.cases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "CellID"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)as! CaseCell
        
        var selectedCase = self.cases[(indexPath as NSIndexPath).row]
        // Configure Cell
        cell.lblTitle.text=selectedCase;
        
        selectedCase += ".png"
                
            cell.imgCase.image = UIImage(named:selectedCase);
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         UserDefaults.standard.removeObject(forKey: "selectedOrders")
      
//        let selectedCase = self.cases[(indexPath as NSIndexPath).row]
//        if(selectedCase=="PRE-OP")
//        {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScatterPlotController")
       //self.navigationController?.pushViewController(vc!, animated: true)
        self.present(vc!, animated: false, completion: nil)
//        }
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
}


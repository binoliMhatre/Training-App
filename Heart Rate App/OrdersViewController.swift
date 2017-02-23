

import UIKit

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: IBOutlet Properties
    
    @IBOutlet weak var tblExpandable: UITableView!
    
    
    // MARK: Variables
    
    var cellDescriptors: NSMutableArray!
    
    var visibleRowsPerSection = [[Int]]()
    var selectedOrders = [String]()
    var existingOrders = [String]()
    
    //MARK: - View loading methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if((UserDefaults.standard.stringArray(forKey: "existingOrders")) != nil)
        {
             existingOrders = UserDefaults.standard.stringArray(forKey: "existingOrders")!
        }
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTableView()
        
        loadCellDescriptors()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Custom Functions
    
    func configureTableView() {
        tblExpandable.delegate = self
        tblExpandable.dataSource = self
        tblExpandable.tableFooterView = UIView(frame: CGRect.zero)
        tblExpandable.register(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
        tblExpandable.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        
    }
    
    
    func loadCellDescriptors() {
        if let path = Bundle.main.path(forResource: "Orders", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            tblExpandable.reloadData()
        }
    }
  
    
    
    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        
        for currentSectionCells in cellDescriptors.objectEnumerator().allObjects as! [[[String:Any]]]{
            var visibleRows = [Int]()
 
            for row in 0..<currentSectionCells.count {
                if currentSectionCells[row]["isVisible"] as! Bool == true {
                    visibleRows.append(row)
                }
            }
            
            visibleRowsPerSection.append(visibleRows)
        }
    }
    
    
    func getCellDescriptorForIndexPath(_ indexPath: IndexPath) -> [String: AnyObject]
    {
        let indexOfVisibleRow = visibleRowsPerSection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let cellDescriptor = (cellDescriptors.object(at: (indexPath as NSIndexPath).section) as AnyObject).object(at: indexOfVisibleRow) as! [String: AnyObject]
       // let cellDescriptor = cellDescriptors[indexPath.section][indexOfVisibleRow] as! [String: AnyObject]
        return cellDescriptor
    }
    
    
    // MARK: UITableView Delegate and Datasource Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellDescriptors != nil
        {
            return cellDescriptors.count
        }
        else
        {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return visibleRowsPerSection[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
          let cell = tableView.dequeueReusableCell(withIdentifier: currentCellDescriptor["cellIdentifier"] as! String, for: indexPath) as! CustomCell
      
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal"
        {
            if let primaryTitle = currentCellDescriptor["primaryTitle"]
            {
                cell.textLabel?.text = primaryTitle as? String
                
            }
            
            if let secondaryTitle = currentCellDescriptor["secondaryTitle"]
            {
                cell.detailTextLabel?.text = secondaryTitle as? String
            }
        }
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellValuePicker"
        {
            let selected = currentCellDescriptor["secondaryTitle"] as! String
           
           if(selectedOrders.contains(selected))
            {
                cell.accessoryType = .checkmark
            } else 
            {
                cell.accessoryType = .none
            }
            cell.textLabel?.textColor=UIColor.brown;
            cell.textLabel?.text = currentCellDescriptor["secondaryTitle"] as? String
          //  cell.detailTextLabel?.text=currentCellDescriptor["primaryTitle"] as? String;
            }
        if currentCellDescriptor["cellIdentifier"] as! String == "idCategoryCell"
        {
        cell.lblCategory.text=currentCellDescriptor["primaryTitle"] as? String
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44.0
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfTappedRow = visibleRowsPerSection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let drugsArr=cellDescriptors[(indexPath as NSIndexPath).section] as? NSArray;
       
        let drugDict=drugsArr?[indexOfTappedRow] as? NSDictionary;
        let drug=drugDict?.value(forKey: "cellIdentifier")as? String;
    
       
       if drug == "idCellNormal"
       {
        let isExpandable=drugDict?.value(forKey: "isExpandable")as? Bool;
        if isExpandable == true
        {
            var shouldExpandAndShowSubRows = false
            let isExpanded=drugDict?.value(forKey: "isExpanded")as? Bool;
            if isExpanded == false
            {
                // In this case the cell should expand.
                shouldExpandAndShowSubRows = true
            }
            
            drugDict?.setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            
            for var i in (indexOfTappedRow + 1)...(indexOfTappedRow + (drugDict?["additionalRows"] as! Int)) {
                (drugsArr?[i] as! NSDictionary).setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        }
        }
        else {
            if drug == "idCellValuePicker"
            {
                var indexOfParentCell: Int!
              
                for i in (0...indexOfTappedRow - 1).reversed() {
                    let mainArr=drugsArr?[i] as? NSDictionary;

                    let isExpandable=mainArr?.value(forKey: "isExpandable")as? Bool;
                    if isExpandable == true {
                        indexOfParentCell = i
                        break
                    }
                }
                
             
                let selected = (tblExpandable.cellForRow(at: indexPath)?.textLabel?.text)! as String
                let cell = tableView.cellForRow(at: indexPath)
               // print((cellDescriptors.object(at: (indexPath as NSIndexPath).section) as AnyObject).object(at: indexOfParentCell))
                //print(cellDescriptors[indexPath.section][indexOfParentCell])
                let category = drugsArr?[indexOfParentCell] as? NSDictionary;
                
                let type=category?.value(forKey: "primaryTitle")as? String;
                print(type as Any);
//                 if type == "Drugs"
//                 {
//                    existingOrders.append(selected)
//                }
                
                if(selectedOrders.contains(selected))
                {
                   cell!.accessoryType = .none
                 selectedOrders.remove(at: selectedOrders.index(of: selected)!)
                    
                }
                else
                {
                     cell!.accessoryType = .checkmark
                    selectedOrders.append(selected)
                }
                (drugsArr?[indexOfParentCell] as! NSDictionary).setValue(false, forKey: "isExpanded")
                }
        }
        
        getIndicesOfVisibleRows()
        tblExpandable.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: UITableViewRowAnimation.fade)
    }
    
  //MARK: -  Done button clicked
  
    @IBAction func doneBtnClicked(_ sender: AnyObject)
    {
        if(selectedOrders.count>0)
        {
        for index in 0...(selectedOrders.count-1)
        {
            existingOrders.append(selectedOrders[index])
        }
        UserDefaults.standard.set(existingOrders, forKey: "existingOrders")
        UserDefaults.standard.set(selectedOrders, forKey: "selectedOrders")
            
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ordersUpdated notification"), object: self)

        }
        self.dismiss(animated: true, completion: nil)
    }
}



import UIKit

class AssessmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var txtViewDetails: UITextView!
    
    // MARK: IBOutlet Properties
    
    @IBOutlet weak var tblExpandable: UITableView!
    
    
    // MARK: Variables
    
    var cellDescriptors: NSMutableArray!
    
    var visibleRowsPerSection = [[Int]]()
    
    @IBAction func doneClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    @IBAction func doneBtnClicked(_ sender: Any) {
    }
    
    func configureTableView() {
        tblExpandable.delegate = self
        tblExpandable.dataSource = self
        tblExpandable.tableFooterView = UIView(frame: CGRect.zero)
        tblExpandable.register(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
        tblExpandable.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        
    }
    
    
    func loadCellDescriptors() {
        if let path = Bundle.main.path(forResource: "Assessment", ofType: "plist") {
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
    
    
    func getCellDescriptorForIndexPath(_ indexPath: IndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRowsPerSection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let cellDescriptor = (cellDescriptors.object(at: (indexPath as NSIndexPath).section) as AnyObject).object(at: indexOfVisibleRow)as! [String: AnyObject]
//        let cellDescriptor = cellDescriptors[indexPath.section][indexOfVisibleRow] as! [String: AnyObject]
        

        
        return cellDescriptor
    }
    
    
    // MARK: UITableView Delegate and Datasource Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellDescriptors != nil {
            return cellDescriptors.count
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRowsPerSection[section].count
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: currentCellDescriptor["cellIdentifier"] as! String, for: indexPath) as! CustomCell
        //  let cell = tableView.dequeueReusableCellWithIdentifier("idCellValuePicker" , forIndexPath: indexPath) as! CustomCell
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal" {
            if let primaryTitle = currentCellDescriptor["primaryTitle"] {
                cell.textLabel?.text = primaryTitle as? String
                
            }
            
            if let secondaryTitle = currentCellDescriptor["secondaryTitle"] {
                cell.detailTextLabel?.text = secondaryTitle as? String
            }
        }
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellValuePicker"
        {
            cell.textLabel?.textColor=UIColor.brown;
            cell.textLabel?.text = currentCellDescriptor["secondaryTitle"] as? String
          //  cell.detailTextLabel?.text=currentCellDescriptor["primaryTitle"] as? String;
            
        }
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellDetail"
        {
           cell.txtViewDetails?.text=currentCellDescriptor["secondaryTitle"] as? String
        }
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let indexOfTappedRow = visibleRowsPerSection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let drugsArr=cellDescriptors[(indexPath as NSIndexPath).section] as? NSArray;
        let drugDict=drugsArr?[indexOfTappedRow] as? NSDictionary;
        let drug=drugDict?.value(forKey: "cellIdentifier")as? String;
        if drug == "idCellDetail"
        {
            return 60.0
        }
    return 44.0
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let indexOfTappedRow = visibleRowsPerSection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let drugsArr=cellDescriptors[(indexPath as NSIndexPath).section] as? NSArray;
        let drugDict=drugsArr?[indexOfTappedRow] as? NSDictionary;
        let drug=drugDict?.value(forKey: "cellIdentifier")as? String;

        
        if drugDict?["isExpandable"] as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if drugDict?["isExpanded"] as! Bool == false {
                // In this case the cell should expand.
                shouldExpandAndShowSubRows = true
            }
            
          drugDict?.setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            
            for var i in (indexOfTappedRow + 1)...(indexOfTappedRow + (drugDict?["additionalRows"] as! Int)) {
                (drugsArr?[i] as! NSDictionary).setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
            
        }
        else {
            
            if drugDict?["cellIdentifier"] as! String == "idCellValuePicker"
            {
//                var indexOfParentCell: Int!
//                
//                for var i=indexOfTappedRow - 1; i>=0; i -= 1 {
//                    if cellDescriptors[indexPath.section][i]["isExpandable"] as! Bool == true {
//                        indexOfParentCell = i
//                        break
//                    }
//                }
//    
//                cellDescriptors[indexPath.section][indexOfParentCell].setValue(false, forKey: "isExpanded")
//                
//                for i in (indexOfParentCell + 1)...(indexOfParentCell + (cellDescriptors[indexPath.section][indexOfParentCell]["additionalRows"] as! Int)) {
//                    cellDescriptors[indexPath.section][i].setValue(false, forKey: "isVisible")
//                }
            }
        }
        
        getIndicesOfVisibleRows()
        tblExpandable.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: UITableViewRowAnimation.fade)
    }
    
    

    
    
}


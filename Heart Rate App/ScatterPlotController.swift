import UIKit
import Darwin
import OpenGLES

@objc class ScatterPlotController : UIViewController, CPTScatterPlotDataSource ,UITableViewDataSource,UITableViewDelegate
{
    struct Constants
    {
        static let MAX_CURVE_POINT_NO = 180
        static let PI = 3.141592653589793
        static let USE_DEPTH_BUFFER = 1
        static let GRID_LINES_HORZ=30
        static let GRID_LINES_VERT=30
    }
    @IBOutlet  var lblTitle: UILabel!
    //Transport Popup
   @IBOutlet var transferPopupView: UIView!
    @IBOutlet var transferPopupInnerView: UIView!
    
    // Vent Screen
    @IBOutlet var popUpInnerView: UIView!
    @IBOutlet var popUpView: UIView!
    
    @IBOutlet  var lblN2O: UILabel!
    @IBOutlet  var lblAir: UILabel!
    @IBOutlet  var lblO2: UILabel!
    
    @IBOutlet  var lblSevo: UILabel!
    @IBOutlet  var lblIso: UILabel!
    @IBOutlet  var lblDes: UILabel!
    
    @IBOutlet  var lblPEEP: UILabel!
    @IBOutlet  var lblTidalVolume: UILabel!
    @IBOutlet  var lblRespirationRate: UILabel!
    
    @IBOutlet  var sliderN2O: UISlider!
    @IBOutlet  var sliderAir:UISlider!
    @IBOutlet  var sliderO2:UISlider!
    @IBOutlet  var sliderSevo: UISlider!
    @IBOutlet  var sliderIso:UISlider!
    @IBOutlet  var sliderDes:UISlider!
    @IBOutlet  var sliderPEEP: UISlider!
    @IBOutlet  var sliderTidalVolume:UISlider!
    @IBOutlet  var sliderRespirationRate:UISlider!
    
    //Vent View (Monitor) Popup
    
    @IBOutlet  var lblO2_I: UILabel!
    @IBOutlet  var lblO2_E: UILabel!
    @IBOutlet  var lblO2_MAC: UILabel!
    @IBOutlet  var lblISO_I: UILabel!
    @IBOutlet  var lblISO_E: UILabel!
    @IBOutlet  var lblISO_MAC: UILabel!
    @IBOutlet  var lblSEVO_I: UILabel!
    @IBOutlet  var lblSEVO_E: UILabel!
    @IBOutlet  var lblSEVO_MAC: UILabel!
    @IBOutlet  var lblDES_I: UILabel!
    @IBOutlet  var lblDES_E: UILabel!
    @IBOutlet  var lblDES_MAC: UILabel!
    @IBOutlet  var lblN2O_I: UILabel!
    @IBOutlet  var lblN2O_E: UILabel!
    @IBOutlet  var lblN2O_MAC: UILabel!
    
    
    @IBOutlet  var lblPEEPVent: UILabel!
    @IBOutlet  var lblPIP: UILabel!
    @IBOutlet  var lblTV: UILabel!
    @IBOutlet  var lblRR: UILabel!
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btn_PlaceMonitor: UIButton!
    @IBOutlet var imgViewPatient: UIImageView!
 
    @IBOutlet var ventMonitorView: UIView!
    
    fileprivate var scatterGraph : CPTXYGraph? = nil
    var orders: [String] = [] ;
    
    typealias plotDataType = [CPTScatterPlotField : Double]
    fileprivate var dataForPlot = [plotDataType]()
    fileprivate var dataForPlotYellow = [plotDataType]()
    fileprivate var dataForRedPlot = [plotDataType]()

  
    var counter :Double = 0.0
    var counterVent :Double = 0
    var timer = Timer()
    let lblHeartRateGreen=UILabel(frame: CGRect(x: 0, y: 15, width: 50, height: 20))
    let lblBlue = UILabel(frame: CGRect(x: 0, y: 35, width: 50, height: 20))
    let LblRed = UILabel(frame: CGRect(x: 0, y: 55, width: 50, height: 20))
    let lblYellow = UILabel(frame: CGRect(x: 0, y: 75, width: 50, height: 20))
    let lblTemperature = UILabel(frame: CGRect(x: 0, y: 92, width: 30, height: 20))
    let lblTOFTitle = UILabel(frame: CGRect(x: 100, y: 10, width: 50, height: 20))
    let lblTOF = UILabel(frame: CGRect(x: 0, y: 112, width: 30, height: 20))


    var contentArray = [plotDataType]()

    var ind : UInt = 0
    var indexVent : UInt = 0

    let firstVital = CPTScatterPlot(frame: CGRect.zero)
    let secondVital = CPTScatterPlot(frame: CGRect.zero)
    let thirdVital = CPTScatterPlot(frame: CGRect.zero)


    let dataMax = 200
    
    var first = true
    
    var plotSpace = CPTXYPlotSpace()
    
    let kFrameRate = 1.0
    
    let plotSymbol = CPTPlotSymbol.ellipse()

    let borderPadding : CGFloat = 0.1

    let screenSize: CGRect = UIScreen.main.bounds
    
    var graphHostView = CPTGraphHostingView(frame:CGRect(x: UIScreen.main.bounds.width - 200, y: 100, width: 150, height: 60) )
    var DynamicView=UIView(frame: CGRect.zero)
    var blackView=UIView(frame: CGRect.zero)
    var  gl_View=EAGLView(frame: CGRect(x: UIScreen.main.bounds.width - 200,y: 48,width: 150,height: 50))

    var isPreOp = true
    var randomNum : Double = 1.0
    
    var tlay = CPTTextLayer()
    var caseDescriptors:NSMutableDictionary!
    var caseType :NSMutableDictionary!

    // MARK: - Initialization
    override func viewDidLoad()
    {
        isPreOp=true
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated : Bool)
    {
        super.viewDidAppear(animated)
        loadCases()
        //Check The orders
        //        let userDefaults : UserDefaults = UserDefaults.standard
        //
        //        if (userDefaults.object(forKey: "selectedOrders") != nil)
        //        {
        //            orders = UserDefaults.standard.stringArray(forKey: "selectedOrders")!
        //            tableView.reloadData();
        //        }
        self.lblTitle.text="PRE-OP";
        if((UserDefaults.standard.stringArray(forKey: "selectedOrders")) != nil)
        {
            
            orders = UserDefaults.standard.stringArray(forKey: "selectedOrders")!
            tableView.reloadData();
        }
        
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
    }
    
    func loadCases() {
        if let path = Bundle.main.path(forResource: "Cases", ofType: "plist") {
            caseDescriptors = NSMutableDictionary(contentsOfFile: path)
            print(caseDescriptors);
            caseType = self.caseDescriptors["Pilot Scenario"]! as! NSMutableDictionary
            
        }
    }
    
    // MARK: - Quit Clicked
 

    @IBAction func quitClicked(_ sender: Any)
    {
//        self.dismiss(animated: true, completion: nil)
        
        
        let alertController = UIAlertController(title: "Transfer", message: "Do you want to quit?", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            //print("Destructive")
        }
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }

    
    //MARK: - Vent Popup Button
   
    @IBAction func showPopupClicked(_ sender: AnyObject)
    {
    
      //  circleSlider.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
        if (popUpView != nil)
        {
            self.popUpView.removeFromSuperview()
        }
        sliderN2O.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        sliderAir.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        sliderO2.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        sliderDes.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        sliderIso.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        sliderSevo.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        sliderPEEP.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        sliderTidalVolume.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        sliderRespirationRate.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        

        // self.popUpView.frame = CGRectMake(10 , 50, self.view.frame.width-10, 500)
        self.popUpInnerView.layer.cornerRadius = 5
        self.popUpInnerView.layer.shadowOpacity = 0.8
        self.popUpInnerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
      
        lblN2O.text = NSString(format:"%.1f", sliderN2O.value) as String
        lblAir.text = NSString(format:"%.1f", sliderAir.value) as String
        lblO2.text = NSString(format:"%.1f", sliderO2.value) as String
        lblPEEP.text = NSString(format:"%.0f", sliderPEEP.value) as String
        lblTidalVolume.text = NSString(format:"%.0f", sliderTidalVolume.value) as String
        lblRespirationRate.text = NSString(format:"%.0f", sliderRespirationRate.value) as String
        lblSevo.text = NSString(format:"%.1f", sliderSevo.value) as String
        lblIso.text = NSString(format:"%.1f", sliderIso.value) as String
        lblDes.text = NSString(format:"%.1f", sliderDes.value) as String
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);

        self.view.addSubview(popUpView)
        self.popUpView.alpha = 0;
        _ = [UIView .animate(withDuration: 0.25, animations:
            {
            self.popUpView.alpha = 1;
            self.popUpView.transform = CGAffineTransform(scaleX: 1, y: 1);
            })]
       }
    
    @IBAction func doneButtonClicked(_ sender: AnyObject)
    {
        lblPEEPVent.text=lblPEEP.text;
        lblTV.text=lblTidalVolume.text;
        lblRR.text=lblRespirationRate.text;
        lblO2_I.text=lblO2.text
        lblN2O_I.text=lblN2O.text
        lblSEVO_I.text=lblSevo.text
        lblISO_I.text=lblIso.text
        lblDES_I.text=lblDes.text
        
//        lblAir.text
//        lblN2O.text
        
        UIView.animate(withDuration: 0.25, animations:
            {
            self.popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.popUpView.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                 self.navigationController?.setNavigationBarHidden(false, animated: true)
                 self.popUpView.removeFromSuperview()                }
        });
    }
    
    //MARK: - Slider Functions
    
    @IBAction func sliderValueChanged(_ sender: UISlider)
    {
        let step: Float = 0.25
        var roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        var currentValue = Float(sender.value)
        switch sender.tag
        {
           
        case 111:
           
            lblN2O.text = NSString(format:"%.1f", currentValue) as String
            
        case 222:
            
            lblAir.text = NSString(format:"%.1f", currentValue) as String
            
        case 333:
            
            lblO2.text = NSString(format:"%.1f", currentValue) as String
            
        case 444:
            let step1: Float = 0.5
            roundedValue = round(sender.value / step1) * step1
            sender.value = roundedValue
            currentValue = Float(sender.value)
            lblSevo.text = NSString(format:"%.1f", currentValue) as String

        case 555:
            lblIso.text = NSString(format:"%.1f", currentValue) as String
            
        case 666:
            lblDes.text = NSString(format:"%.1f", currentValue) as String
        
        case 777:
            let step1: Float = 5.0
            roundedValue = round(sender.value / step1) * step1
            sender.value = roundedValue
            currentValue = Float(sender.value)
            lblPEEP.text = NSString(format:"%.0f", currentValue) as String
            
        case 888:
            let step1: Float = 5.0
            roundedValue = round(sender.value / step1) * step1
            sender.value = roundedValue
            currentValue = Float(sender.value)
            lblRespirationRate.text = NSString(format:"%.0f", currentValue) as String
            
        case 999:
            let step1: Float = 10.0
            roundedValue = round(sender.value / step1) * step1
            sender.value = roundedValue
            currentValue = Float(sender.value)
            lblTidalVolume.text = NSString(format:"%.0f", currentValue) as String

        default:
            lblAir.text = NSString(format:"%.1f", currentValue) as String

        }
    }
    
    //MARK: - Transport Button
    
    
    
    @IBAction func transportToICU(_ sender: UIButton)
    {
        
    }
   
    @IBAction func transportToFloor(_ sender: UIButton) {
    }

   
    
    @IBAction func transportToOR(_ sender: UIButton)
    {
        isPreOp=false
        let alertController = UIAlertController(title: "Transfer", message: "Do you want to transfer patient to OR?", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            //print("Destructive")
        }
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.lblTitle.text="OR";
            self.placeMonitorClicked(sender)
            if (self.ventMonitorView != nil)
            {
                self.ventMonitorView.removeFromSuperview()
            }
            self.ventMonitorView.frame = CGRect(x: self.view.frame.width-200 , y: 178, width: 200, height: 165)
            let OR = self.caseType["OR"]! as! NSDictionary
            self.lblTemperature.text = OR["Temperature"] as? String
            self.LblRed.text=OR["BP"] as? String
            self.lblBlue.text=OR["Spo2"] as? String
            self.lblYellow.text="35"
            self.lblHeartRateGreen.text=OR["HR"] as? String
            self.view .addSubview(self.ventMonitorView)
            self.imgViewPatient.image = UIImage(named: ("patient male.png"))
            
        }
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        self.closeTransPopup(sender);
        
    }
   
    @IBAction func transportToPACU(_ sender: UIButton) {
    }
   

    @IBAction func transportToHome(_ sender: UIButton) {
    }


  
    @IBAction func closeTransPopup(_ sender: Any)
    {
        UIView.animate(withDuration: 0.25, animations:
            {
                self.transferPopupView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.transferPopupView.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.transferPopupView.removeFromSuperview()                }
        });
        
    }
    
    @IBAction func TransportButtonClicked(_ sender: UIButton)
    {
        self.transferPopupInnerView.layer.cornerRadius = 5
        self.transferPopupInnerView.layer.shadowOpacity = 0.8
        self.transferPopupInnerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.transferPopupView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
        
        self.view.addSubview(transferPopupView)
        self.transferPopupView.alpha = 0;
       _ = [UIView .animate(withDuration: 0.25, animations:
            {
                self.transferPopupView.alpha = 1;
                self.transferPopupView.transform = CGAffineTransform(scaleX: 1, y: 1);
        })]
        
    }
    

    //MARK: - OR Button 
    @IBAction func ORButtonClicked(_ sender: UIButton)
    {
        if(sender.titleLabel?.text=="OR")
        {
        
        isPreOp=false
        let alertController = UIAlertController(title: "Transfer", message: "Do you want to transfer patient to OR?", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            //print("Destructive")
        }
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.lblTitle.text="OR";
            self.placeMonitorClicked(sender)
            if (self.ventMonitorView != nil)
            {
                self.ventMonitorView.removeFromSuperview()
            }
            self.ventMonitorView.frame = CGRect(x: self.view.frame.width-200 , y: 178, width: 200, height: 165)
            let OR = self.caseType["OR"]! as! NSDictionary
            self.lblTemperature.text = OR["Temperature"] as? String
            self.LblRed.text=OR["BP"] as? String
            self.lblBlue.text=OR["Spo2"] as? String
            self.lblYellow.text="35"
            self.lblHeartRateGreen.text=OR["HR"] as? String
            self.view .addSubview(self.ventMonitorView)
            sender.setTitle("Pre-Op", for: UIControlState())
            self.imgViewPatient.image = UIImage(named: ("patient male.png"))
            
        }
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            
            isPreOp=true
            

            let alertController = UIAlertController(title: "Transfer", message: "Do you want to transfer patient back to PRE-OP?", preferredStyle: UIAlertControllerStyle.alert)
            let DestructiveAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                //print("Destructive")
            }
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                //print("OK")
                self.lblTitle.text="Pre-OP";
                
                if(self.view.subviews.contains(self.gl_View))
                {
                    let preOp = self.caseType["Pre-op"]! as! NSDictionary
                    self.lblTemperature.text = preOp["Temperature"] as? String
                    self.LblRed.text=preOp["BP"] as? String
                    self.lblBlue.text=preOp["Spo2"] as? String
                    self.lblYellow.text="35"
                    self.lblHeartRateGreen.text=preOp["HR"] as? String
                    self.graphHostView.isHidden=true
                    self.gl_View.isHidden=true
                    
                    self.DynamicView.isHidden=true;
                    self.blackView.isHidden=true;
                    self.ventMonitorView .removeFromSuperview()
                }
                sender.setTitle("OR", for: UIControlState())
                self.imgViewPatient.image = UIImage(named: ("seated patient in pre op.png"))
            }
            alertController.addAction(DestructiveAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
   /*     isPreOp=false
        
     if(sender.titleLabel?.text=="OR")
        {
            placeMonitorClicked(sender)
            if (ventMonitorView != nil)
            {
                self.ventMonitorView.removeFromSuperview()
            }
            self.ventMonitorView.frame = CGRect(x: self.view.frame.width-200 , y: 170, width: 200, height: 165)
            self.view .addSubview(ventMonitorView)
            sender.setTitle("Pre-Op", for: UIControlState())
            imgViewPatient.image = UIImage(named: ("Patient_in_OR.png"))
        }
        else
        {
            if(self.view.subviews.contains(gl_View))
            {
                self.graphHostView.isHidden=true
                gl_View.isHidden=true

                self.DynamicView.isHidden=true;
                self.blackView.isHidden=true;
                ventMonitorView .removeFromSuperview()
            }
           sender.setTitle("OR", for: UIControlState())
            imgViewPatient.image = UIImage(named: ("Patient_sitting.png"))
        }*/
        
    }
    
      // MARK: -  Vital Monitor  Methods
    @IBAction func placeMonitorClicked(_ sender: UIButton)
    {
       // let myObjClass:EAGLView = EAGLView()
        //        heartRateValues=myObjClass.valuesArray
        //        print(heartRateValues)

        if(self.view.subviews.contains(gl_View))
        {
            self.graphHostView.isHidden=false
            gl_View.isHidden=false
            self.DynamicView.isHidden=false;
            self.blackView.isHidden=false;
        }
        else
        {
            gl_View.animationInterval = 1.0/60.0;
            gl_View.startAnimation();
            gl_View.initView();
            self.view .addSubview(gl_View)
            self.displayMonitor()
        }
    }
    
    func displayMonitor()
        {
            // Create graph from theme
            let newGraph = CPTXYGraph(frame:CGRect.zero)
            
          // newGraph.applyTheme(CPTTheme(named: kCPTDarkGradientTheme))
            graphHostView = CPTGraphHostingView(frame:CGRect(x: screenSize.width - 200, y: 90, width: 150, height: 60) )
            graphHostView.backgroundColor=UIColor.black;
            graphHostView.hostedGraph = newGraph
            
            DynamicView=UIView(frame: CGRect(x: screenSize.width - 50, y: 48, width: 50, height: 130))
            DynamicView.backgroundColor=UIColor.black
            DynamicView.layer.borderWidth=0.2
            blackView=UIView(frame: CGRect(x: screenSize.width - 200, y: 148, width: 150, height: 30))
            blackView.backgroundColor=UIColor.black
            lblHeartRateGreen.textAlignment = NSTextAlignment.left
            lblHeartRateGreen.textColor=UIColor.green
            lblHeartRateGreen.font = lblHeartRateGreen.font.withSize(12)
            DynamicView.addSubview(lblHeartRateGreen)
            
            LblRed.textAlignment = NSTextAlignment.left
            LblRed.textColor=UIColor.red
            LblRed.font = LblRed.font.withSize(12)
            DynamicView.addSubview(LblRed)
            
            lblYellow.textAlignment = NSTextAlignment.left
            lblYellow.textColor=UIColor.yellow
            lblYellow.font = LblRed.font.withSize(12)
            DynamicView.addSubview(lblYellow)
            
            lblBlue.textAlignment = NSTextAlignment.left
            lblBlue.textColor=UIColor.cyan
            lblBlue.font = lblBlue.font.withSize(12)
            DynamicView.addSubview(lblBlue)
            
            lblTemperature.textAlignment = NSTextAlignment.left
            lblTemperature.textColor=UIColor.orange
            lblTemperature.font = lblTemperature.font.withSize(12)
            
            lblTOFTitle.textAlignment = NSTextAlignment.left
            lblTOFTitle.textColor=UIColor.white
            lblTOFTitle.font = lblTemperature.font.withSize(12)
            lblTOFTitle.text="TOF"

            
            lblTOF.textAlignment = NSTextAlignment.left
            lblTOF.textColor=UIColor.white
            lblTOF.font = lblTemperature.font.withSize(12)
            if(isPreOp)
            {
               
                let preOp = caseType["Pre-op"]! as! NSDictionary
                lblTemperature.text = preOp["Temperature"] as? String
                LblRed.text=preOp["BP"] as? String
                lblBlue.text=preOp["Spo2"] as? String
                lblYellow.text="35"
                lblHeartRateGreen.text=preOp["HR"] as? String
                lblTOF.text="1"

            }
            else
            {
                let OR = caseType["OR"]! as! NSDictionary
                lblTemperature.text = OR["Temperature"] as? String
                LblRed.text=OR["BP"] as? String
                lblBlue.text=OR["Spo2"] as? String
                lblYellow.text="35"
                lblHeartRateGreen.text=OR["HR"] as? String
                lblTOF.text = "1"

            }
           
            DynamicView.addSubview(lblTemperature)
            blackView.addSubview(lblTOFTitle)
            DynamicView.addSubview(lblTOF)
            self.view.addSubview(DynamicView)
            self.view.addSubview(blackView)
            
         
            
            self.view.addSubview(graphHostView)
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(ScatterPlotController.update), userInfo: nil, repeats: true)
            
            // Paddings
            newGraph.paddingLeft   = borderPadding
            newGraph.paddingRight  = borderPadding
            newGraph.paddingTop    = borderPadding
            newGraph.paddingBottom = borderPadding
            
            // Plot space
            plotSpace = newGraph.defaultPlotSpace as! CPTXYPlotSpace
            //plotSpace.allowsUserInteraction = true
            plotSpace.yRange = CPTPlotRange(location:-7.0, length:10.0)
            plotSpace.xRange = CPTPlotRange(location:-0.5, length:25.0)
            
            // Axes
            let textstyle = CPTMutableTextStyle();
            textstyle.fontSize=12.0;
            
            // Create a blue plot area
            //        let boundLinePlot = CPTScatterPlot(frame: CGRectZero)
            let red_Line = CPTMutableLineStyle()
            red_Line.miterLimit    = 1.0
            red_Line.lineWidth     = 1.0
            red_Line.lineColor     = CPTColor.red()
            secondVital.dataLineStyle = red_Line
            secondVital.identifier    = "Red Plot" as (NSCoding & NSCopying & NSObjectProtocol)?
            secondVital.dataSource    = self
            secondVital.opacity = 0
            
            
            let fillImage = CPTImage(named:"BlueTexture")
            fillImage.isTiled = true
            secondVital.areaFill      = CPTFill(image: fillImage)
            secondVital.areaBaseValue = 0.0
            
            let blue_Line               = CPTMutableLineStyle()
            blue_Line.lineWidth         = 1.0
            blue_Line.lineColor         = CPTColor.cyan()
            //greenLineStyle.dashPattern       = [5.0, 5.0]
            firstVital.dataLineStyle = blue_Line
            firstVital.identifier    = "Blue Plot" as (NSCoding & NSCopying & NSObjectProtocol)?
            firstVital.dataSource    = self
            
            let yellow_Line              = CPTMutableLineStyle()
            yellow_Line.lineWidth         = 1.0
            yellow_Line.lineColor         = CPTColor.yellow()
            //greenLineStyle.dashPattern       = [5.0, 5.0]
            thirdVital.dataLineStyle = yellow_Line
            thirdVital.identifier    = "Yellow Plot" as (NSCoding & NSCopying & NSObjectProtocol)?
            thirdVital.dataSource    = self
            
            firstVital.opacity = 0.0
            newGraph.add(firstVital)
            newGraph.add(secondVital)
            newGraph.add(thirdVital)
            
            let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
            fadeInAnimation.duration            = 1.0
            fadeInAnimation.isRemovedOnCompletion = false
            fadeInAnimation.fillMode            = kCAFillModeForwards
            fadeInAnimation.toValue             = 1.0
            
            firstVital.add(fadeInAnimation, forKey: "animateOpacity")
            secondVital.add(fadeInAnimation, forKey: "animateOpacity")
            thirdVital.add(fadeInAnimation, forKey: "animateOpacity")
            self.scatterGraph = newGraph
    }
    func update()
    {
        if(first)
        {
            let x = Double(counter)
            let y = sin(Double(counter)) + 1.5
            let redX = Double(counter)

            var redY = sin(Double(counter)) + 1
            

            if(redY>1)
            {
                if(1.4 ... 1.8 ~= redX || 7.4 ... 7.8 ~= redX || 14.0 ... 14.8 ~= redX)
                {
                    redY=0.2
                }
                
            }
            let yellowX = Double(counter)
            var yellowY = sin(Double(counter)) + 1
            if(yellowY<1)
            {
                yellowY = -1
            }
            else
            {
                yellowY = 1
            }
       
            let dataPointRed: plotDataType = [.X: redX, .Y: redY]
            let dataPoint: plotDataType = [.X: x, .Y: y]
            let dataPointYellow: plotDataType = [.X: yellowX, .Y: yellowY]
//            let c:String = String(format:"%.1f", y)
//            let c1:String = String(format:"%.1f", yellowY)
//            LblRed.text=c
//            lblBlue.text=c
//            lblYellow.text=c1
//            lblHeartRateGreen.text=c
//            print("x: ",x)
//            print("y:",y)
            self.dataForPlot.append(dataPoint)
            self.dataForRedPlot.append(dataPointRed)
            self.dataForPlotYellow.append(dataPointYellow)
            firstVital.insertData(at: ind , numberOfRecords: 1)
            secondVital.insertData(at: ind , numberOfRecords: 1)
            thirdVital.insertData(at: ind, numberOfRecords: 1)
        }
        else
        {
           
            let x = Double(counter)
            let y = sin(Double(counter)) * ( randomNum / 50 ) + 1
            
            let redX = Double(counter)
            var redY = sin(Double(counter)) * ( randomNum / 50 ) + 1.5
       
            
            if(redY>1.0)
            {
                if(1.4 ... 1.8 ~= redX || 7.4 ... 7.8 ~= redX || 14.0 ... 14.8 ~= redX)
                {
                    redY=0.2
                }
                
            }
            let dataPoint: plotDataType = [.X: x, .Y: y]
            let yellowX = Double(counter)
            var yellowY = sin(Double(counter)) * ( randomNum / 150 ) + 1
            if(yellowY<1)
            {
                yellowY = -1
            }
            else
            {
                yellowY=1
            }
            let dataPointYellow: plotDataType = [.X: yellowX, .Y: yellowY]
            let dataPointRed: plotDataType = [.X: redX, .Y: redY]
//            let c:String = String(format:"%.1f", y)
//            let c1:String = String(format:"%.1f", yellowY)
//            LblRed.text=c
//            lblBlue.text=c
//            lblYellow.text=c1
//            lblHeartRateGreen.text=c
//            print("x: ",x)
//            print("y:",y)
            //print(r)
          
            dataForPlot.remove(at: Int(ind))
            dataForPlot.insert(dataPoint, at: Int(ind))
            
            dataForPlotYellow.remove(at: Int(ind))
            dataForPlotYellow.insert(dataPointYellow, at: Int(ind))
            
            dataForRedPlot.remove(at: Int(ind))
            dataForRedPlot.insert(dataPointRed, at: Int(ind))
// 
          firstVital.reloadData()
           secondVital.reloadData()
          thirdVital.reloadData()
        }
        counter = counter + 0.1
       // print("count= \(self.dataForPlot.count) ind= \(ind) counter = \(counter)")
        
        if( Int(ind) >= self.dataMax)
        {
            ind = 0
            counter = 0
            first = false
            randomNum = Double( Int(arc4random_uniform(80)))
        }
        ind += 1
}
    
 
    // MARK: - Plot Data Source Methods
    func numberOfRecords(for plot: CPTPlot) -> UInt
    {
        if plot.identifier as! String == "Blue Plot"  || plot.identifier as! String  == "Red Plot" || plot.identifier as! String  == "Yellow Plot"
        {
            return UInt(self.dataForPlotYellow.count)
        }
     
        else
        {
            return 0
        }
    }
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any?
    {
        let plotID = plot.identifier as! String
        if plotID == "Blue Plot" || plotID == "Red Plot" || plotID == "Yellow Plot"
        {
            let plotField = CPTScatterPlotField(rawValue: Int(field))
            
            if let num = self.dataForPlot[Int(record)][plotField!] {
                //let plotID = plot.identifier as! String
                if (plotField! == .Y) && (plotID == "Yellow Plot")
                {
                    let num1=self.dataForPlotYellow[Int(record)][plotField!]
                    return (num1!-5.8) as NSNumber
                }
                if (plotField! == .Y) && (plotID == "Red Plot")
                {
                    let num2=self.dataForRedPlot[Int(record)][plotField!]
                    return (num2!-2.5) as NSNumber
                }
                if (plotField! == .Y) && (plotID == "Blue Plot")
                {
                    return num+0.2 as NSNumber
                }
                else
                {
                    return num as NSNumber
                }
            }
            else
            {
                return nil
            }
        }
            
        else
        {
            return nil
        }
    }

 
    // MARK: - TableView DataSource and Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let numberOfRows = orders.count
        return numberOfRows
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 20.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        // Fetch order
        let order = orders[(indexPath as NSIndexPath).row]
        // Configure Cell
        cell.textLabel?.text = order
        return cell
    }
}

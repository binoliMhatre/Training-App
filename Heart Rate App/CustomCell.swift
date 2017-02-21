

import UIKit



class CustomCell: UITableViewCell {

    // MARK: IBOutlet Properties
    
   
    
    @IBOutlet var txtViewDetails: UITextView!
    @IBOutlet var lblCategory: UILabel!
  
    
    // MARK: Constants
    
    let bigFont = UIFont(name: "Avenir-Book", size: 17.0)
    
    let smallFont = UIFont(name: "Avenir-Light", size: 15.0)
    
    let primaryColor = UIColor.blue
    
    let secondaryColor = UIColor.lightGray
    
    
    // MARK: Variables
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if textLabel != nil {
            textLabel?.font = bigFont
            textLabel?.textColor = primaryColor
        }
        
        if detailTextLabel != nil {
            detailTextLabel?.font = smallFont
            detailTextLabel?.textColor = secondaryColor
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
}

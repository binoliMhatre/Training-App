//
//  InfoCell.swift
//  Heart Rate App
//
//  Created by Binoli Mhatre on 6/14/16.
//  Copyright © 2016 Matt Leccadito. All rights reserved.
//

import UIKit

class CaseCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgCase: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MoviesCell.swift
//  flick
//
//  Created by phungducchinh on 6/13/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {

    
    @IBOutlet weak var posterImage: UIImageView!    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
      
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
            
            }

}

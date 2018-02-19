//
//  TableCell.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 19/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var lblRecipe: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

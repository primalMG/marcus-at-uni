//
//  RecipeTableViewCell.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 15/03/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
            
            detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
            
        }
        
        let recipeImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            
            addSubview(recipeImageView)
            recipeImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
            recipeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            recipeImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            recipeImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

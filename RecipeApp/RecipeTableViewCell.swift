//
//  RecipeTableViewCell.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 15/03/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import Firebase

class RecipeTableViewCell: UITableViewCell {
    
    func imageSetUp(){
        let ref = Database.database().reference().child("Recipe")
        ref.observeSingleEvent(of: .value, with:  { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let imgUrl = dictionary["img"] as? String {
                    self.recipeImageView.LoadingImageUsingCache(imgUrl)
                }
            }
        }, withCancel: nil)
    }
    
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            textLabel?.frame = CGRect(x: 84, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
            
            detailTextLabel?.frame = CGRect(x: 84, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        }
        
        let recipeImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 40
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
    
    
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            
            addSubview(recipeImageView)
            
            recipeImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            recipeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            recipeImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            recipeImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
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

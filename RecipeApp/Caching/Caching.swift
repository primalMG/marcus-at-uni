//
//  Caching.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 14/03/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    
    func LoadingImageUsingCache(_ urlString: String){
        
       //self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                DispatchQueue.main.async(execute: {
                        
                        if let downloadedImage = UIImage(data: data!) {
                            imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                            self.image = downloadedImage
                        }
                    })

            }).resume()
    }
    
    
    func LoadingVidsUsingCache() {
        
    }
    
}

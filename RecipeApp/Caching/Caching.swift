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
    
    func LoadingImageUsingCache(urlString: String){
        
       //self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let imageData = data {
                    DispatchQueue.main.async {
                        
                        if let downloadedImage = UIImage(data: imageData) {
                            imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                            self.image = downloadedImage
                        }
                
                    }
                } else {
                    print("image data is nil")
                }
            }).resume()
        } else {
            print("url is nil")
        }
    }
    
}

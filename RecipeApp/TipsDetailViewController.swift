//
//  TipsDetailViewController.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 08/03/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TipsDetailViewController: UIViewController {
    
    var tipsID = ""
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tipsID
        self.ref = Database.database().reference()
        TipsDirections()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func TipsDirections(){
        handle = self.ref.child("Tips").child(tipsID).child("Description").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                _ = TipsModel(dictionary: dictionary)
            }
            DispatchQueue.main.async {
                self.lblDescription.reloadInputViews()
            }
        })
    }

    
}

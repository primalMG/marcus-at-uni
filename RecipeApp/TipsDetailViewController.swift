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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tipsID
        
        TipsDirections()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func TipsDirections(){
        DatabaseHandle = self.ref.child("Tips").child(tipsID).child("Steps").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dic
        })
    }

    
}

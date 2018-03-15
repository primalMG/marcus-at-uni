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
    
    
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle!
    var tipsArray = [TipsModel]()
    var tipsID = ""
    
    @IBOutlet weak var lblDescription: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.ref = Database.database().reference()
        TipsDirections()
        
        self.title = tipsID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func TipsDirections(){
        databaseHandle = self.ref.child("Tips").child(tipsID).child("Description").observe(.value , with: { (snapshot) in
            print(snapshot)
            if let des = snapshot.value as? String {
                self.lblDescription.text = des
            }
            
        })
        
    }

    
}

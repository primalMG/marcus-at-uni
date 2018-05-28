//
//  TipsDetailViewController.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 08/03/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TipsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle!
    var tipsArray: [String] = []
    var tipsID = ""
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.ref = Database.database().reference().child("Tips").child(tipsID)
        TipsDirections()
      
        self.ref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let tip = TipsModel(dictionary: dictionary)
                self.navigationItem.title = tip.name
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func TipsDirections(){
        self.ref.child("steps").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children{
                let dictionary = child as! DataSnapshot
                self.tipsArray.append(dictionary.value as! String)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "steps", for: indexPath)
        cell.textLabel?.text = tipsArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

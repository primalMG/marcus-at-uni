//
//  Tips.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 14/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Tips: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getTips()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var tipsArray = [TipsModel]()
    
    func getTips(){
        databaseHandle = ref?.child("Tips").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let tips = TipsModel(dictionary: dictionary)
                self.tipsArray.append(tips)
            }
            print(snapshot)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tips", for: indexPath)
        let tips = tipsArray[indexPath.row]
        cell.textLabel?.text = tips.name
        
        return cell
    }
    
    
    
}

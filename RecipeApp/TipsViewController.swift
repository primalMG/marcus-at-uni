//
//  Tips.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 14/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TipsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    

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
    
    @IBOutlet weak var tableView: UITableView!
    var tipsArray = [TipsModel]()
    
    
    func getTips(){
        databaseHandle = ref.child("Tips").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let tips = TipsModel(dictionary: dictionary)
                self.tipsArray.append(tips)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "tips", for: indexPath)
        let tips = tipsArray[indexPath.row]
        cell.textLabel?.text = tips.name
        cell.detailTextLabel?.text = tips.brief
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tipsDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tipsDetailSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! TipsDetailViewController
                let selectedTip = tipsArray[indexPath.row].id
                controller.tipsID = selectedTip!
            }
        }
    }
}

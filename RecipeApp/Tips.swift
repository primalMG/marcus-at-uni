//
//  Tips.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 14/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Tips: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var tableIndex = 0
    var tipsClicked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTips()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var tipsArray = [TipsModel]()
    var tipSelected = [TipsModel]()
    
    func getTips(){
        let db = Firestore.firestore()
        db.collection("Tips").getDocuments { (snapshot, error) in
            if error != nil {
                print("error") //please update to table
            }else{
                for document in snapshot!.documents{
                    
                    let tip = TipsModel(dictionary: document.data() as [String : AnyObject])
                    self.tipsArray.append(tip)
                    print(document.data())
                    self.tableView.reloadData()
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = indexPath.row
        tipsClicked = true
        tipSelected.append(tipsArray[cell])
        performSegue(withIdentifier: "tipsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  (tipsClicked == true){
            if let destination = segue.destination as? TipsViewController {
                destination.currentTip = tipSelected
            }
        }
    }
}

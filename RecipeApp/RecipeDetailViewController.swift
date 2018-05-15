//
//  RecipeScreen.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 21/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import AVFoundation
import AVKit

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ingredientsArray: [String] = []
    var stepsArray: [String] = []
    var currentRecipe = [Recipe]()
    var ref : DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var recipeID: String!
    let currentUser = Auth.auth().currentUser?.uid
    
    var recipes: Recipe?
 
 
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgSelectRecipe: UIImageView!
    @IBOutlet weak var recipeImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        getIngredients()
        getSteps()
        //recipe()
        databaseHandle = self.ref.child("Recipe").child(recipeID).observe(.value, with: { (snapshot) in
            
            
            
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                self.navigationItem.title = recipe.name
                if let recipeImgUrl = recipe.img {
                    self.recipeImage.LoadingImageUsingCache(recipeImgUrl)
                } else {
                    print("error")
                }
                
            }
            
        })
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.ref.child("Recipe").child(recipeID).removeObserver(withHandle: databaseHandle)
    }
        

    

//    func recipe() {
//        databaseHandle = self.ref.child("Recipe").child(recipeID).observe(.value, with: { (snapshot) in
//
//
//
//
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                let recipe = Recipe(dictionary: dictionary)
//                self.navigationItem.title = recipe.name
//                if let recipeImgUrl = recipe.img {
//                    self.recipeImage.LoadingImageUsingCache(recipeImgUrl)
//                } else {
//                    print("error")
//                }
//
//            }
//
//        })
//    }
    
    
    func getIngredients() {
        databaseHandle = self.ref.child("Recipe").child(recipeID).child("Ingredients").observe(.value, with: { (snapshot) in
            //print(snapshot)
            
            for child in snapshot.children {
                let dictionary = child as! DataSnapshot
                self.ingredientsArray.append(dictionary.value as! String)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func getSteps(){
        databaseHandle = self.ref.child("Recipe").child(recipeID).child("steps").observe(.value, with: { (snapshot) in
          //print(snapshot)
            
            for child in snapshot.children {
                let dictionary = child as! DataSnapshot
                self.stepsArray.append(dictionary.value as! String)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ingredientsArray.count
        case 1:
            return stepsArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients", for: indexPath)
            cell.textLabel?.text = ingredientsArray[indexPath.row]
            return cell
        case 1:
            let stepsCell = tableView.dequeueReusableCell(withIdentifier: "steps", for: indexPath)
            stepsCell.textLabel?.text = stepsArray[indexPath.row]
            stepsCell.textLabel?.textColor = UIColor.black
            stepsCell.textLabel?.isEnabled = false 
            stepsCell.textLabel?.numberOfLines = 0
            //stepsCell.textLabel?.lineBreakMode = .
            return stepsCell
        default:
            return UITableViewCell()
        }
   
    }
    
    let headerTitles = ["Ingredients","Steps"]

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = ingredientsArray[indexPath.row]
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if self.currentUser != nil {
                let ingredient = self.ref.child("users").child(self.currentUser!).child("ShoppingList").childByAutoId()
                let ingredientKey = ingredient.key
                let name = ["nameID": ingredientKey,
                            "imgName": indexPath]
                ingredient.setValue(name)
                let alert = UIAlertController(title: "Ingredient Added to Shopping List", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let delay = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: delay){
                    alert.dismiss(animated: true, completion: nil)
                }
            } else {
                print("error")
            }
        }
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    
    @IBAction func btnPlay(_ sender: Any) {
        databaseHandle = self.ref.child("Recipe").child(recipeID).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                if let videoUrlString = recipe.video, let url = URL(string: videoUrlString) {
                    self.player = AVPlayer(url: url)
                    let videoPlayer = AVPlayerViewController()
                    videoPlayer.player = self.player
                    
                    self.present(videoPlayer, animated: true, completion: {
                        self.player?.play()
                        self.activityIndicatorView.startAnimating()
                    })
                } else {
                    let alert = UIAlertController(title: "No video Found", message: "Sorry, but there is no video for this recipe. Please try another", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action: UIAlertAction!) in
                        alert.dismiss(animated: true, completion: {
                            print("video string empty")
                        })
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func btnAddAll(_ sender: Any) {
    }
    
    @IBAction func btnShare(_ sender: Any) {
    }
    
    
    
}


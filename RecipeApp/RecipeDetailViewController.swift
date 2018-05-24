//
//  RecipeScreen.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 21/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import AVFoundation
import AVKit

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ingredientsArray: [String] = []
    var stepsArray: [String] = []
    var comments: [String] = []
    var currentRecipe = [Recipe]()
    var ref : DatabaseReference!
    var refer : DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var recipeID: String!
    let currentUser = Auth.auth().currentUser?.uid
    
    var recipes: Recipe?
 
 
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgSelectRecipe: UIImageView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var serving: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference().child("Recipe").child(recipeID)
        self.refer = Database.database().reference().child("users")
        tableView.delegate = self
        tableView.dataSource = self
        getIngredients()
        getSteps()
        getCommets()
        getRecipeRating()
        
        databaseHandle = self.ref.observe(.value, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                self.navigationItem.title =  recipe.name
                self.serving.text = "Serving: " + recipe.serving!
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
        self.ref.removeObserver(withHandle: self.databaseHandle)
    }
    
        
    func getRecipeRating(){
        self.ref.child("ratings").observe(.value) { (snapshot) in
            print(snapshot)
            let count = snapshot.childrenCount
            var total: Double = 0.0
            for child in snapshot.children {
                let dictionary = child as! DataSnapshot
                let val = dictionary.value as! Double
                total += val
            }
            let average = total/Double(count)
            print(average)
            self.rating.text = String(average)
        }
    }
    
    func getIngredients() {
        self.ref.child("Ingredients").observe(DataEventType.value, with: { (snapshot) in
            
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
        self.ref.child("steps").observe(.value, with: { (snapshot) in
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
    
    func getCommets(){
       self.ref.child("comments").observe(.value, with: { (snapshot) in
        
            for child in snapshot.children {
                let dictionary = child as! DataSnapshot
                self.comments.append(dictionary.value as! String)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ingredientsArray.count
        case 1:
            return stepsArray.count
        case 2:
            return comments.count
        default:
            return 0
        }
    }
    
    //populating the tableview cells with the data stored in the array.
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
        case 2:
            let commentsCell = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath)
            commentsCell.textLabel?.text = comments[indexPath.row]
            return commentsCell
        default:
            return UITableViewCell()
        }
    }
    //headers for the tableview
    let headerTitles = ["Ingredients","Steps","Comments"]

    //setting the headers within the tableview
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idexPath = ingredientsArray[indexPath.row]
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.orange
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil && (user?.isEmailVerified)!{
                let ingredient = self.refer.child(self.currentUser!).child("ShoppingList").childByAutoId()
                let ingredientKey = ingredient.key
                let name = ["nameID": ingredientKey, "imgName": idexPath]
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
        databaseHandle = self.ref.observe(.value, with: { (snapshot) in
            
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
    
    
    @IBAction func btnComment(_ sender: Any) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if self.currentUser != nil && (user?.isEmailVerified)!{
            let comment = self.ref.child("comments").childByAutoId()
            let alert = UIAlertController(title: "Comment", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Comment"
            })
            alert.addAction(UIAlertAction(title: "Comment", style: .default, handler: { (action) in
                comment.setValue(alert.textFields![0].text)
            }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("error")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
    }
    
    var choices = [1,2,3,4,5]
    var pickerView = UIPickerView()
    var typeValue = Int()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(choices[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       typeValue = choices[row]
    }
 
    @IBAction func btnRate(_ sender: Any) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil && (user?.isEmailVerified)!{
                let rating = self.ref.child("ratings").child(self.currentUser!)
                let alert = UIAlertController(title: "Comment", message: "Please rate out of 5 \n\n\n\n\n\n\n\n", preferredStyle: .alert)
                let pickerView = UIPickerView(frame: CGRect(x: 10, y: 20, width: 250, height: 140))
                pickerView.dataSource = self
                pickerView.delegate = self
                
                alert.view.addSubview(pickerView)
                alert.addAction(UIAlertAction(title: "Rate", style: .default, handler: { (action) in
                    rating.setValue(self.typeValue)
                    print(self.typeValue)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                self.present(alert, animated: true, completion: nil)
            } else {
                print("error")
            }
        }
    }
    
    
    
    
    

    @IBAction func btnShare(_ sender: Any) {
        let pageLink = "https://gsdf8.app.goo.gl/Marcus-at-uni"
        let msg = pageLink
        let activityViewController = UIActivityViewController(activityItems: [msg], applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }


    
}


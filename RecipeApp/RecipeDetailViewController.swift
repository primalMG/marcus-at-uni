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

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ingredientsArray: [String] = []
    var stepsArray: [String] = []
    var comments: [String] = []
    var currentRecipe = [Recipe]()
    var ref : DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var recipeID: String!
    let currentUser = Auth.auth().currentUser?.uid
    
    var recipes: Recipe?
 
      var sections = [Section]()
 
    
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
        getCommets()
        self.buildFDLLink()
        
        sections = [
            Section(name: .googleAnalytics, items: [.source, .medium, .campaign, .term, .content]),
            Section(name: .iOS, items: [.bundleID, .fallbackURL, .minimumAppVersion, .customScheme,
                                        .iPadBundleID, .iPadFallbackURL, .appStoreID]),
            Section(name: .iTunes, items: [.affiliateToken, .campaignToken, .providerToken]),
            Section(name: .android, items: [.packageName, .androidFallbackURL, .minimumVersion]),
            Section(name: .social, items: [.title, .descriptionText, .imageURL]),
            Section(name: .other, items: [.otherFallbackURL])
        ]
        
        databaseHandle = self.ref.child("Recipe").child(recipeID).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                self.navigationItem.title =  recipe.name
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
    
    func getCommets(){
        databaseHandle = self.ref.child("Recipe").child(recipeID).child("comments").observe(.value, with: { (snapshot) in
            print(snapshot)
            
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
        let indexPath = ingredientsArray[indexPath.row]
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if self.currentUser != nil && (user?.isEmailVerified)!{
                let ingredient = self.ref.child("users").child(self.currentUser!).child("ShoppingList").childByAutoId()
                let ingredientKey = ingredient.key
                let name = ["nameID": ingredientKey, "imgName": indexPath]
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
    
    
    @IBAction func btnComment(_ sender: Any) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if self.currentUser != nil && (user?.isEmailVerified)!{
            let comment = self.ref.child("Recipe").child(self.recipeID).child("comments").childByAutoId()
            let alert = UIAlertController(title: "Comment", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Comment"
            })
            alert.addAction(UIAlertAction(title: "Comment", style: .default, handler: { (action) in
                comment.setValue(alert.textFields![0].text)
            }))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("error")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
    }
    
    @IBAction func btnAddAll(_ sender: Any) {
        
    }
    
    

    @IBAction func btnShare(_ sender: Any) {
        let pageLink = "https://gsdf8.app.goo.gl/Marcus-at-uni"
        let msg = pageLink
        let activityViewController = UIActivityViewController(activityItems: [msg], applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }


    struct Section {
        var name: ParamTypes
        var items: [Params]
        var collapsed: Bool
        
        init(name: ParamTypes, items: [Params], collapsed: Bool = true) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }
    
    enum Params: String {
        case link = "gsdf8.app.goo.gl"
        case source = "Source"
        case medium = "Medium"
        case campaign = "Campaign"
        case term = "Term"
        case content = "Content"
        case bundleID = "App Bundle ID"
        case fallbackURL = "Fallback URL"
        case minimumAppVersion = "Minimum App Version"
        case customScheme = "Custom Scheme"
        case iPadBundleID = "iPad Bundle ID"
        case iPadFallbackURL = "iPad Fallback URL"
        case appStoreID = "AppStore ID"
        case affiliateToken = "Affiliate Token"
        case campaignToken = "Campaign Token"
        case providerToken = "Provider Token"
        case packageName = "Package Name"
        case androidFallbackURL = "Android Fallback URL"
        case minimumVersion = "Minimum Version"
        case title = "Title"
        case descriptionText = "Description Text"
        case imageURL = "Image URL"
        case otherFallbackURL = "Other Platform Fallback URL"
    }
    
    enum ParamTypes: String {
        case googleAnalytics = "Google Analytics"
        case iOS = "iOS"
        case iTunes = "iTunes Connect Analytics"
        case android = "Android"
        case social = "Social Meta Tag"
        case other = "Other Platform"
    }

    
    static let DYNAMIC_LINK_DOMAIN = "https://gsdf8.app.goo.gl"
    
    var dictionary = [Params: UITextField]()
    var longLink: URL?
    var shortLink: URL?
    
    @objc func buildFDLLink() {
        if RecipeDetailViewController.DYNAMIC_LINK_DOMAIN == "nill" {
            fatalError("Please update DYNAMIC_LINK_DOMAIN constant in your code from Firebase Console!")
        }
        // [START buildFDLLink]
        // general link params
        guard let linkString = dictionary[.link]?.text else {
            print("Link can not be empty!")
            return
        }
        
        guard let link = URL(string: linkString) else { return }
        let components = DynamicLinkComponents(link: link, domain: RecipeDetailViewController.DYNAMIC_LINK_DOMAIN)

        // analytics params
        let analyticsParams = DynamicLinkGoogleAnalyticsParameters(
            source: dictionary[.source]?.text ?? "", medium: dictionary[.medium]?.text ?? "",
            campaign: dictionary[.campaign]?.text ?? "")
        analyticsParams.term = dictionary[.term]?.text
        analyticsParams.content = dictionary[.content]?.text
        components.analyticsParameters = analyticsParams
        
        if let bundleID = dictionary[.bundleID]?.text {
            // iOS params
            let iOSParams = DynamicLinkIOSParameters(bundleID: bundleID)
            iOSParams.fallbackURL = dictionary[.fallbackURL]?.text.flatMap(URL.init)
            iOSParams.minimumAppVersion = dictionary[.minimumAppVersion]?.text
            iOSParams.customScheme = dictionary[.customScheme]?.text
            iOSParams.iPadBundleID = dictionary[.iPadBundleID]?.text
            iOSParams.iPadFallbackURL = dictionary[.iPadFallbackURL]?.text.flatMap(URL.init)
            iOSParams.appStoreID = dictionary[.appStoreID]?.text
            components.iOSParameters = iOSParams
            
            // iTunesConnect params
            let appStoreParams = DynamicLinkItunesConnectAnalyticsParameters()
            appStoreParams.affiliateToken = dictionary[.affiliateToken]?.text
            appStoreParams.campaignToken = dictionary[.campaignToken]?.text
            appStoreParams.providerToken = dictionary[.providerToken]?.text
            components.iTunesConnectParameters = appStoreParams
        }
        
        if let packageName = dictionary[.packageName]?.text {
            // Android params
            let androidParams = DynamicLinkAndroidParameters(packageName: packageName)
            androidParams.fallbackURL = dictionary[.androidFallbackURL]?.text.flatMap(URL.init)
            androidParams.minimumVersion = dictionary[.minimumVersion]?.text.flatMap {Int($0)} ?? 0
            components.androidParameters = androidParams
        }
        
        // social tag params
        let socialParams = DynamicLinkSocialMetaTagParameters()
        socialParams.title = dictionary[.title]?.text
        socialParams.descriptionText = dictionary[.descriptionText]?.text
        socialParams.imageURL = dictionary[.imageURL]?.text.flatMap(URL.init)
        components.socialMetaTagParameters = socialParams
        
        // OtherPlatform params
        let otherPlatformParams = DynamicLinkOtherPlatformParameters()
        otherPlatformParams.fallbackUrl = dictionary[.otherFallbackURL]?.text.flatMap(URL.init)
        components.otherPlatformParameters = otherPlatformParams
        
        longLink = components.url
        print(longLink?.absoluteString ?? "")
        
        components.shorten { (shortURL, warnings, error) in
            // Handle shortURL.
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print(shortURL?.absoluteString ?? "")
            // [START_EXCLUDE]
            self.shortLink = shortURL
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .none)
            // [END_EXCLUDE]
        }
        
        
    }

    
}


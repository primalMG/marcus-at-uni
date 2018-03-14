import UIKit
import Firebase
import FirebaseDatabaseUI

class ViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ref : DatabaseReference!
    var databaseHandle:DatabaseHandle!
    var tableIndex = 0
    var searchActive = false
    var recipeArray = [Recipe]()
    var filteredRecipe = [Recipe]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        ref = Database.database().reference()
        getRecipes()
        //searchbar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // getting the recipes from the database
    func getRecipes(){
        
        databaseHandle = ref.child("Recipe").observe(.childAdded, with: { (snapshot) in
         //   print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                self.recipeArray.append(recipe)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
   
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return filteredRecipe.count
        }
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipes", for: indexPath)
        let recipes = recipeArray[indexPath.row]
        cell.textLabel?.text = recipes.name
        if (searchActive) {
            cell.textLabel?.text = filteredRecipe[indexPath.row].name
            
        } else {
            cell.textLabel?.text = recipes.name
            cell.imageView?.image = UIImage(named: "placeholder")
            
            //implementation for images
            if let recipeImgUrl = recipes.img {
                if let url = URL(string: recipeImgUrl) {
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        if let imageData = data {
                            DispatchQueue.main.async {
                                cell.imageView?.image = UIImage(data: imageData)
                            }
                        } else {
                            print("image data is nil")
                        }
                    }).resume()
                } else {
                    print("url is nil")
                }
            }
        }
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "recipeSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeSegue"{
            if (searchActive){
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let controller = segue.destination as! RecipeScreen
                    let recipes = filteredRecipe[indexPath.row].name
                    controller.recipeID = recipes!
                }
            } else {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let controller = segue.destination as! RecipeScreen
                    let recipes = recipeArray[indexPath.row].name
                    controller.recipeID = recipes!
                }
            }
        }
    }
    
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRecipe = recipeArray.filter({ (text) -> Bool in
            let temp: NSString = text.name! as NSString
            let range = temp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filteredRecipe.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
   
    //Segue back to the home/Recipe screen
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }

    //Drawer Menu
    var menuState = false
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBAction func btnMenu(_ sender: Any) {
        if (menuState){
            //closes menu
            leadingConstraint.constant = 430
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            //opens menu
           leadingConstraint.constant = 175
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuState = !menuState
    }
    



    
}


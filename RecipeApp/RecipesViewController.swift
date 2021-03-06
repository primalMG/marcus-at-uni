import UIKit
import Firebase
import FirebaseDatabase


class RecipesViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ref : DatabaseReference!
    var databaseHandle:DatabaseHandle!
    var tableIndex = 0
    var searchActive = false
    var recipeArray = [Recipe]()
    var filteredRecipe = [Recipe]()
    var selectedRecipe: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        ref = Database.database().reference()
        getRecipes()
        //searchbar()
        
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "recipes")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // getting the recipes from the database
    func getRecipes(){
        
        databaseHandle = ref.child("Recipe").observe(.childAdded, with: { (snapshot) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipes", for: indexPath) as! RecipeTableViewCell
        
        let recipes = recipeArray[indexPath.row]
        cell.textLabel?.text = recipes.name
        if (searchActive) {
            cell.textLabel?.text = filteredRecipe[indexPath.row].name
<<<<<<< HEAD
            //cell.detailTextLabel?.text = filteredRecipe[indexPath.row].price
//            if let recipeImgUrl = filteredRecipe[indexPath.row].recipeImg {
//                cell.recipeImageView.LoadingImageUsingCache(recipeImgUrl)
//            }
=======
            cell.detailTextLabel?.text = filteredRecipe[indexPath.row].price
            if let recipeImgUrl = filteredRecipe[indexPath.row].img {
                cell.recipeImageView.LoadingImageUsingCache(recipeImgUrl)
            }
>>>>>>> parent of 71f738b... Code refactor Day 1

        } else {

            cell.textLabel?.text = recipes.name
            cell.detailTextLabel?.text = recipes.price
            //implementation for images
<<<<<<< HEAD
//            if let recipeImgUrl = recipeArray[indexPath.row].recipeImg {
//                cell.recipeImageView.LoadingImageUsingCache(recipeImgUrl)
//            }
=======
            if let recipeImgUrl = recipeArray[indexPath.row].img {
                cell.recipeImageView.LoadingImageUsingCache(recipeImgUrl)
            }
>>>>>>> parent of 71f738b... Code refactor Day 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searchActive) {
            if let recipe = filteredRecipe[indexPath.row].recipeID{
                selectedRecipe = recipe
                performSegue(withIdentifier: "recipeSegue", sender: self)
            }
        } else {
            if let recipe = recipeArray[indexPath.row].recipeID{
                selectedRecipe = recipe
                performSegue(withIdentifier: "recipeSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeSegue"{
            if (searchActive) {
                if let destination = segue.destination as? RecipeDetailViewController {
                    destination.recipeID = selectedRecipe
                }
            } else {
                if let destination = segue.destination as? RecipeDetailViewController {
                    destination.recipeID = selectedRecipe
                }
            }
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRecipe = recipeArray.filter({ (text) -> Bool in
            let temp: NSString = text.name! as NSString
            let range = temp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filteredRecipe.count == 0){
            searchActive = false;
            print("no recipes")
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
   
    //Segue back to the home/Recipe screen
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func accountSettingsUnwind(_ sender: UIStoryboardSegue){
        
    }

    //Drawer Menu
    var menuState = false
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    @IBAction func btnAccount(_ sender: Any) {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil && (currentUser?.isEmailVerified)! {
                self.performSegue(withIdentifier: "accountSettings", sender: nil)
            } else {
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
        
            //
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
}




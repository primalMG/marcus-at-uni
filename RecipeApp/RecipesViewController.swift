import UIKit
import Firebase

class RecipesViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var tableIndex = 0
    var searchActive = false
    var recipeArray = [Recipe]()
    var filteredRecipe = [Recipe]()
    var selectedRecipe: Recipe?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "recipes")
        
        FirestoreService.shared.readRecipes(from: .Recipe, returning: Recipe.self) { (recipe) in
            self.recipeArray = recipe
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            //cell.detailTextLabel?.text = filteredRecipe[indexPath.row].price
            if let recipeImgUrl = filteredRecipe[indexPath.row].recipeImg {
                cell.recipeImageView.LoadingImageUsingCache(recipeImgUrl)
            }

        } else {

            cell.textLabel?.text = recipes.name
            //cell.detailTextLabel?.text = recipes.price
            //implementation for images
            if let recipeImgUrl = recipeArray[indexPath.row].recipeImg {
                cell.recipeImageView.LoadingImageUsingCache(recipeImgUrl)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searchActive) {
            //let recipe = filteredRecipe[indexPath.row].id
            
            selectedRecipe = filteredRecipe[indexPath.row]
            
            performSegue(withIdentifier: "recipeSegue", sender: self)
            
        } else {
                selectedRecipe = recipeArray[indexPath.row]
                performSegue(withIdentifier: "recipeSegue", sender: self)
            
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
            let temp: NSString = text.name as NSString
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
        
    
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
}




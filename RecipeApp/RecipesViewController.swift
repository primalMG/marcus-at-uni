import UIKit
import Firebase
import FirebaseDatabaseUI

class RecipesViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipes", for: indexPath) as! RecipeTableViewCell
        
        let recipes = recipeArray[indexPath.row]
        cell.textLabel?.text = recipes.name
        if (searchActive) {
            cell.textLabel?.text = filteredRecipe[indexPath.row].name
            cell.detailTextLabel?.text = recipes.price
          

        } else {
            cell.imageView?.image = UIImage(named: "placeholder")
            cell.textLabel?.text = recipes.name
            cell.detailTextLabel?.text = recipes.price
            
            //implementation for images
            if let recipeImgUrl = recipes.img {
                cell.imageView?.LoadingImageUsingCache(urlString: recipeImgUrl)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "recipeSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeSegue"{
            if (searchActive){
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let controller = segue.destination as! RecipeDetailViewController
                    let recipes = filteredRecipe[indexPath.row].name
                    controller.recipeID = recipes!
                }
            } else {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let controller = segue.destination as! RecipeDetailViewController
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




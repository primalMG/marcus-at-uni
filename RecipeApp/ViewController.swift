import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var ref : DatabaseReference!
    var databaseHandle:DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRecipes()
        searchbar()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
     var recipeArray = [Recipe]()
    
    // getting the recipes from the database
    func getRecipes(){
        ref = Database.database().reference()
        databaseHandle = ref?.child("Recipe").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                self.recipeArray.append(recipe)
            }
            print(snapshot)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            

        })
    }
    
    
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipes", for: indexPath)
        
        let recipes = recipeArray[indexPath.row]
        cell.textLabel?.text = recipes.name
        
        return cell
    }
    
    
    
    private func searchbar() {
        searchBar.delegate = self
    }
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { selectedRecipe = recipeArray
            tableView.reloadData()
            return
        }
        selectedRecipe = recipeArray.filter({ Recipe -> Bool in
            Recipe.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
     guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipes") as? TableCell else {
     return UITableViewCell()
     }
     cell.lblRecipe.text = recipeArray[indexPath.row]
     return cell
     
     let cell = tableView.dequeueReusableCell(withIdentifier: "recipes", for: indexPath)
     
     let recipes = recipeArray[indexPath.row]
     cell.textLabel?.text = recipes.name
     
     return cell
     */
    


   
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


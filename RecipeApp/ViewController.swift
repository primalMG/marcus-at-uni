import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var ref : DatabaseReference!
    var databaseHandle:DatabaseHandle!
    var tableIndex = 0
    var recipeClicked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
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
        var recipeSelected = [Recipe]()
    
    // getting the recipes from the database
    func getRecipes(){
        let db = Firestore.firestore().collection("Recipe")
        
        db.addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("error") //please update to table
            }else{
                guard let snapshot = snapshot else { return }
                for document in snapshot.documents{
                    
                    let recipe = Recipe(dictionary: document.data() as [String : AnyObject])
                    self.recipeArray.append(recipe)
                    
                    print(document.data())
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            
        }
    }
    
    private func reference(to collectionReference: String) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference)
    }
    /*func getRecipes(){
        
        databaseHandle = ref?.child("Recipe").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                self.recipeArray.append(recipe)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }*/
    
    
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //getting the code from the array and counting them...
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipes", for: indexPath)
        let recipes = recipeArray[indexPath.row]
        cell.textLabel?.text = recipes.name 
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = indexPath.row
        recipeClicked = true
        recipeSelected.append(recipeArray[cell])
        performSegue(withIdentifier: "recipeSegue", sender: self)
        print(cell)
    }
    
    

    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     tableIndex = indexPath.row
     let recipe = self.recipeArray[indexPath.row]
     performSegue(withIdentifier: "recipeSegue", sender: self)
     }*/
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeSegue"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                let recipeSelected = recipeArray[selectedRow]

            }
        }
        
    }*/
    
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
    }*/
    
    
   
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


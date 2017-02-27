

import UIKit
import CoreData

class ViewController: UIViewController {
  
  // OUTLETS

  @IBOutlet weak var tableView: UITableView!
  
  // ARRAY TO STORE EACH ATTRIBUTE OF THE PERSON ENTITY
  
  var people: [Person] = []

  // MARK : VIEW LIFECYCLE
  
   override func viewDidLoad() {
    super.viewDidLoad()

    title = "The List"
    
    // ASSIGNING THE DATASOURCE AND DELEGATE TO SELF
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    self.tableView.allowsMultipleSelectionDuringEditing = false
   }
  
   //  WILL EXECUTE EVERYTIME WHEN THE VIEW IS ABOUT TO APPEAR
  
   override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    
    // CREATING A FETCH REQUEST TO FETCH THE DATA OF THE DATABASE EVEYTIME THE PAGE IS LOADED

    let fetchRequest : NSFetchRequest<Person> = Person.fetchRequest()
    
    // RELOADING THE TABLE
    
    tableView.reloadData()
    
    do {
      
      people = try managedContext.fetch(fetchRequest)
      
    } catch let error as NSError {
      
      print("Could not fetch. \(error), \(error.userInfo)")
    
     }
    
   }

   // FUNCTION TO HANDLE THE TAP ON THE PLUS BUTTON TO ADD MORE NAMES
  
   @IBAction func addName(_ sender: UIBarButtonItem) {
    
    let form = self.storyboard?.instantiateViewController(withIdentifier: "FormViewControllerID") as! FormViewController
    
     UIView.animate(withDuration: 0.01 , delay: 0.0, options: .curveLinear, animations:
      
      {  self.navigationController?.pushViewController(form, animated: true) }, completion:nil )
    
     // SETTING THE MODE AS NORMAL VIEW MODE
    
     form.selectedMode = .normalMode

      }

     }

 // MARK: - UITableViewDataSource AND UITABLEVIEW DATASOURCE

 extension ViewController: UITableViewDataSource  , UITableViewDelegate {
  
  // FUNCTION RETURNING THE NUMBER OF ROWS IN SECTION

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
     return people.count
   }
  
  // FUNCTION RETURNING THE CELL

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

     let person = people[indexPath.row]
    
     // SETTING THE TEXT OF THE CELL AS THE NAME OF THE ENTITY
    
     cell.textLabel?.text = person.name
    
     return cell
 
  }
  // FUNCTION TO GET THE SELECTED CELL
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
     // PUSHING TO THE VIEW PROFILE PAGE
    
     guard  let pushedPage = self.storyboard?.instantiateViewController(withIdentifier: "FormViewControllerID") as? FormViewController else { fatalError(" page not found")}
    
     // SETTING THE MODE TO PROFILE MODE
    
     pushedPage.selectedMode = .profileMode
    
     // SETTING THE SELECTED CELL TO THE CELL THAT IS BEEN SEEN AS A PROFILE
    
     pushedPage.selectedPerson = people[indexPath.row]
      
     self.navigationController?.pushViewController(pushedPage, animated: true)
     }
  
  // FUNCTION TO ADD EDIT AND DELETE BUTTON ON THE LEFT SWIPE OF THE CELL
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
  {
    
     // ADDING THE EDIT BUTTON
    
     let edit = UITableViewRowAction(style: .normal,title: "EDIT",handler: {(action: UITableViewRowAction,index: IndexPath) -> Void in

     guard let editPage = self.storyboard?.instantiateViewController(withIdentifier: "FormViewControllerID") as? FormViewController else { fatalError("  Not found")}
    
     // SETTING THE MODE TO PROFILE MODE
    
     editPage.selectedMode = .editmode
    
     // SETTING THE SELECTED CELL TO THE CELL THAT IS BEEN SEEN AS A PROFILE
    
     editPage.selectedPerson = self.people[indexPath.row]
    
      self.navigationController?.pushViewController(editPage, animated: true) })
    
     // SPECIFYING THE ACTION FOR THE DELETE SWIPE BUTTON
  
     let delete = UITableViewRowAction(style: .destructive, title: "DELETE", handler: {(action : UITableViewRowAction, index : IndexPath) -> Void  in
      
     // ADDING AN ALERT WHENEVER USER DELETES A VALUE OF THE TABLE
      
      let alert = UIAlertController(title: "DELETED!!!", message: "ITEM IS DELETED", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)

      
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      let managedContext = appDelegate.persistentContainer.viewContext
      
      let person = self.people[indexPath.row]
      
      self.people.remove(at: indexPath.row )
      
      managedContext.delete(person)
      
      do {
        
        try managedContext.save()
        
      } catch let error as NSError {
        
        print("Could not save. \(error), \(error.userInfo)")
      }
      
      // RELOADING THE TABLE WHEN THE ATTRIBUTE IS DELETED
      
      self.tableView.reloadData()
     })
    
     return [edit,delete]
    

       }
  
      }

// ENUM TAKEN TO SPECIFY WHETHER THE USER IS IN
// NORMAL -> ADDING THE NEW USER
// EDIT MODE -> EDITING THE VALUES OF THE CURRENT USER
// PROFILE MODE -> VIEWING THE INFORMATION OF THE USER

 enum mode
 {
  case editmode
  case normalMode
  case profileMode
 }


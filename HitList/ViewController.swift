

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

    let fetchRequest : NSFetchRequest<Person> = Person.fetchRequest()
    
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
    
     UIView.animate(withDuration: 0.1 , delay: 0.0, options: .curveEaseInOut, animations:
      {  self.navigationController?.pushViewController(form, animated: true)
    }, completion:nil )
    
    // SETTING THE MODE AS NORMAL VIEW MODE
    
    form.selectedMode = .normalMode

}

 }

// MARK: - UITableViewDataSource AND UITABLEVIEW DATASOURCE

extension ViewController: UITableViewDataSource  , UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let person = people[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    cell.textLabel?.text = person.name
    
    return cell
 
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // PUSHING TO THE VIEW PROFILE PAGE
    
    guard  let pushedPage = self.storyboard?.instantiateViewController(withIdentifier: "FormViewControllerID") as? FormViewController else { fatalError(" page not found")}
    
    // SETTING THE MODE TO PROFILE MODE
    
    pushedPage.selectedMode = .profileMode
    
    // SETTING THE SELECTED CELL TO THE CELL THAT IS BEEN SEEN AS A PROFILE
    
    pushedPage.selectedPerson = people[indexPath.row]
      
    self.navigationController?.pushViewController(pushedPage, animated: true)
    }
  
  // FUNCTION TO DELETE THE ATTRIBUTE OF THE ENTITY
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return }
      
      let managedContext = appDelegate.persistentContainer.viewContext
    
    // IF DELETE GESTURE IS MADE THEN THE ATTRIBUTE IS TO BE DELETED

      if editingStyle == .delete {
      
      let person = people[indexPath.row]
      
      people.remove(at: indexPath.row )
      
      managedContext.delete(person)
      
      do {
        
        try managedContext.save()

      } catch let error as NSError {
        
        print("Could not save. \(error), \(error.userInfo)")
        }

        // RELOADING THE TABLE WHEN THE ATTRIBUTE IS DELETED
        
      self.tableView.reloadData()
    }
  }
}

enum mode
{
  case editmode
  case normalMode
  case profileMode
}


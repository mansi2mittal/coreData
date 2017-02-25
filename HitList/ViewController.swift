

import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var people: [Person] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "The List"
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }

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

  @IBAction func addName(_ sender: UIBarButtonItem) {
    
    let form = self.storyboard?.instantiateViewController(withIdentifier: "FormViewControllerID") as! FormViewController
    
     UIView.animate(withDuration: 0.1 , delay: 0.0, options: .curveEaseInOut, animations:
      {  self.navigationController?.pushViewController(form, animated: true)
    }, completion:nil )

}

  func save(name: String) {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let entity = NSEntityDescription.entity(forEntityName: "Person",
                                            in: managedContext)!

    let person = Person(entity: entity,
                                 insertInto: managedContext)

    person.name = name

    do {
      try managedContext.save()
      
      people.append(person)
    
    } catch let error as NSError {
    
      print("Could not save. \(error), \(error.userInfo)")
    
    }
    
  }
}

// MARK: - UITableViewDataSource

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
  
}

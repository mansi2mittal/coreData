//
//  FormViewController.swift
//  HitList
//
//  Created by Appinventiv on 24/02/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import UIKit
import CoreData

class FormViewController: UIViewController {
  
  var people: [Person] = []
  
  let arrayOfLabels = ["NAME" , "EMAIL" ," MOBILE" , "GENDER" ,"AGE"]
  
  var index : [IndexPath?] = []
  
 
  @IBOutlet weak var formTableView: UITableView!
  
  
  @IBOutlet weak var doneButton: UIButton!
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
      formTableView.delegate = self
      formTableView.dataSource = self
      
      // REGISTERING THE NIB OF THE FORM TABLE VIEW CELL
      
      let cellNib = UINib( nibName : "FormCellTableViewCell" , bundle : nil)
      
      formTableView.register(cellNib , forCellReuseIdentifier : "FormCellTableViewCellID")
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped)
      )
    }
  
  func doneButtonTapped(_ sender: Any){
    
  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "Person",
                                            in: managedContext)!
    
    let person = Person(entity: entity,
                        insertInto: managedContext)
    
    for indices in index.indices {
    
      guard let cell = formTableView.cellForRow(at: index[indices]!) as? FormCellTableViewCell  else { fatalError(" Cell Not Found")
      }
    
    
    switch(indices){
      
    case 0 : person.name = cell.cellTextField.text
      
    case 1: person.email = cell.cellTextField.text
      
    case 2: person.mobile = cell.cellTextField.text
    
    case 3: person.gender = cell.cellTextField.text
      
    case 4: person.age = cell.cellTextField.text
      
    default: print(" Not Found ")
      
    }
    }
    
    do {
      try managedContext.save()
      
      people.append(person)
      
    } catch let error as NSError {
      
      print("Could not save. \(error), \(error.userInfo)")
    }
    
    guard  let homePage = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerID") as? ViewController else{ fatalError(" not found ")}
    
    self.navigationController?.pushViewController(homePage, animated: true)
    
   
    
   

  }
    
  }


extension FormViewController : UITableViewDelegate , UITableViewDataSource
{
  // FUNCTION RETURNING THE NUMBER OF ROWS IN TABLEVIEW
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrayOfLabels.count
  }
  // FUNCTION TO RETURN THE CELL AT A PARTICULAR INDEXPATH
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormCellTableViewCellID") as? FormCellTableViewCell else{
      fatalError("Error Not Found")
    }
    
   cell.cellLabel.text = arrayOfLabels[indexPath.row]
  
    self.index.append(indexPath)
    
    return cell
}
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

}

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
  
  // ARRAY TO STORE THE ATTRIBUTES OF THE ENTITY
  
  var people: [Person] = []
  
  // ARRAY TO STORE THE LABELS OF THE CELL
  
  let arrayOfLabels = ["NAME" , "EMAIL" ," MOBILE" , "GENDER" ,"AGE"]
  
  // ARRAY TO STORE THE INDEXPATH OF THE CELLS
  
  var index : [IndexPath?] = []
  
  // VARIABLE TO STORE THE ATTRIBUTE TYPE OF ENTITY PERSON
  
  var selectedPerson : Person!
  
  // VARIABLE TO STORE THE SELECT THE TYPE OF MODE SELECTED BY THE USER
  
  var selectedMode : mode = .profileMode
  
  // OUTLETS
 
  @IBOutlet weak var formTableView: UITableView!
  
  // MARK : VIEW LIFECYCLE
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
    formTableView.delegate = self
    formTableView.dataSource = self
      
  // REGISTERING THE NIB OF THE FORM TABLE VIEW CELL
      
      let cellNib = UINib( nibName : "FormCellTableViewCell" , bundle : nil)
      
      formTableView.register(cellNib , forCellReuseIdentifier : "FormCellTableViewCellID")
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
      
  // MAKING THE TABLEVIEW CELLS AS NON SELECTABLE
      
       formTableView.allowsSelection = false
      
  }
  
  
  // FUNCTION TO HANDLE THE EDITING AND SAVING OF THE ATTRIBUTES
  
  func doneButtonTapped(_ sender: Any){
    
  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // ADDING THE TEXT ENTERED TO THE CORE DATA ON THE CLICK OF THE DONE BUTTON
    
    if selectedMode == .normalMode
    {
    
    let entity = NSEntityDescription.entity(forEntityName: "Person",
                                            in: managedContext)!
    
    let person = Person(entity: entity,
                        insertInto: managedContext)
    
    // TRAVESRSING THE ARRAY OF THE STORED CELLS OF THE TEXTFIELDS THAT HAS BEEN GENERATED
    
    for indices in index.indices {
    
      guard let cell = formTableView.cellForRow(at: index[indices]!) as? FormCellTableViewCell  else { fatalError(" Cell Not Found")
      }
    
    // RETREIVING THE VALUES OF THE TEXT FIELDS ENTERED BY THE USER
      
    switch(indices){
      
    case 0 : person.name = cell.cellTextField.text
      
    case 1: person.email = cell.cellTextField.text
      
    case 2: person.mobile = cell.cellTextField.text
    
    case 3: person.gender = cell.cellTextField.text
      
    case 4: person.age = cell.cellTextField.text
      
    default: print(" Not Found ")
      
    }
      }
      
      do
      {
        
      // SAVING THE DATA TO THE CORE DATA
        
      try managedContext.save()
        
      // APPENDING THE NEW USER TO THE PEOPLE ARRAY
        
        people.append(person)
        
      } catch let error as NSError {
        
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    // WILL UPDATE THE EDITED TEXTFIELDS INTO THE DATABASE AND WILL RELOAD THE TABLE
    
    if selectedMode == .editmode
    {
      
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        fatalError(" cell not found")
      }
      
    // TRAVESRSING THE ARRAY OF THE STORED CELLS OF THE TEXTFIELDS THAT HAS BEEN GENERATED
      
      for indices in index.indices{
        
        guard let cell = formTableView.cellForRow(at: index[indices]!) as? FormCellTableViewCell  else { fatalError(" Cell Not Found") }
        
    // RETREIVING THE VALUES UPDATED IN THE TEXT FIELD AND UPDATING IT TO THE DATABASE
        
        switch(indices)
        {
          
        case 0 :   selectedPerson.name = cell.cellTextField.text
          
        case 1:   selectedPerson.email = cell.cellTextField.text
          
        case 2:   selectedPerson.mobile = cell.cellTextField.text
          
        case 3:   selectedPerson.gender = cell.cellTextField.text
          
        case 4:   selectedPerson.age = cell.cellTextField.text
          
        default: cell.cellTextField.text = ""
          
        }
      }
      
      // SAVING THE STATE OF THE APPDELEGATE
      
      appDelegate.saveContext()

    }
    
    // INSTANTIATING THE HOME PAGE
    
    guard  let homePage = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerID") as? ViewController else{ fatalError(" not found ")}
    
    // PUSHING THE HOME PAGE
    
    self.navigationController?.pushViewController(homePage, animated: true)
    }
    
  }

 // MARK : EXTENSION OF TABLE VIEW DELEGATE AND TABLEVIEW DATASOURCE

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
     // IF THE USER WANTS TO ADD A NEW USER
    
     if selectedMode == .normalMode
      {
        
      title = "Please Enter Values"
      
      cell.cellLabel.text = arrayOfLabels[indexPath.row]
      
    }
    
    // IF THE USER WANTS TO SEE THE ENTIRE PROFILE OF AN EXISTING USER
    
      if selectedMode == .profileMode
      {
        
        title = "USER PROFILE"
      
      cell.cellLabel.text = arrayOfLabels[indexPath.row]
      
      switch(indexPath.row)
      {
      case 0: cell.cellTextField.text = selectedPerson.name
        
      case 1: cell.cellTextField.text = selectedPerson.email
        
      case 2: cell.cellTextField.text = selectedPerson.mobile
        
      case 3: cell.cellTextField.text = selectedPerson.gender
      
      case 4: cell.cellTextField.text = selectedPerson.age
        
      default: cell.cellTextField.text = ""
        
        
        }
        
      cell.cellTextField.isUserInteractionEnabled = false
       
      
    }
    
    // IF THE USER WANTS TO EDIT THE DETAILS OF A PARTICULAR USER
    
    if selectedMode == .editmode
    {
      
      title = " EDIT THE VALUES"
      
      cell.cellLabel.text = arrayOfLabels[indexPath.row]
      
      switch(indexPath.row)
      {
      case 0: cell.cellTextField.text = selectedPerson.name
        
      case 1: cell.cellTextField.text = selectedPerson.email
        
      case 2: cell.cellTextField.text = selectedPerson.mobile
        
      case 3: cell.cellTextField.text = selectedPerson.gender
        
      case 4: cell.cellTextField.text = selectedPerson.age
        
      default: cell.cellTextField.text = ""
        
        
      }

      
    }
    
    // APPENDING THE INDEXPATH OF EACH CELL CREATED INSIDE THE INDEX ARRAY
    
    self.index.append(indexPath)
    
    return cell
}
  // FUNCTION RETURNING THE HEIGHT OF THE ROW
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
}


//
//  FormCellTableViewCell.swift
//  HitList
//
//  Created by Appinventiv on 24/02/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import UIKit

class FormCellTableViewCell: UITableViewCell {
  
  @IBOutlet weak var cellLabel: UILabel!
  
  @IBOutlet weak var cellTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  /*  func poplulateWithData()
    {
      func configureWithData(_ Profile : [String : String])
      {
        cellLabel.text =  Profile ["NameLabel"]
        cellTextField.text =  
        
      }  }
 */

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

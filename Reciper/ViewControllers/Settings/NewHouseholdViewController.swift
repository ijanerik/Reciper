//
//  NewHouseholdViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 15-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class NewHouseholdViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var householdModel: HouseholdModel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        householdModel = HouseholdModel.shared
        titleField.becomeFirstResponder()
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let textField = titleField.text, !textField.isEmpty {
            let household = HouseholdEntity(id: nil, title: textField, userIDs: [])
            let _ = self.householdModel.addHousehold(household)
            
            self.navigationController?.popViewController(animated: true)
        }
    }

}

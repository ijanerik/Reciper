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
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let textField = titleField.text, !textField.isEmpty {
            let household = HouseholdEntity(id: nil, title: textField, userIDs: [])
            self.householdModel.addHousehold(household)
            print("Better return")
            // @TODO
            //self.navigationController?.popViewController(animated: true)
        } else {
            // @TODO animation on error
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

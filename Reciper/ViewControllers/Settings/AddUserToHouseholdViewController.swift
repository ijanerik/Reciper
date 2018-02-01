//
//  AddUserToHouseholdViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 25-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class AddUserToHouseholdViewController: UIViewController {

    var emailCheckModel: EmailCheckModel!
    var householdModel: HouseholdModel!
    
    var household: HouseholdEntity!
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var submitButton: BigBlueButton!
    @IBOutlet weak var foundLabel: UILabel!
    
    var didFound: String? = nil
    var doSearch = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailCheckModel = EmailCheckModel.shared
        householdModel = HouseholdModel.shared

        resetCheckState()
        inputField.becomeFirstResponder()
    }
    
    // When input field value changed reset to check
    @IBAction func valueDidChange(_ sender: Any) {
        resetCheckState()
    }
    
    func resetCheckState() {
        didFound = nil
        foundLabel.isHidden = true
        doSearch = false
        submitButton.setTitle("Controleren", for: .normal)
    }
    
    @IBAction func pressedSubmit(_ sender: Any) {
        if let userID = didFound, !doSearch {
            self.householdModel.addUser(household, userID: userID)
            self.navigationController?.popViewController(animated: true)
        } else if let email = inputField.text, !email.isEmpty, !doSearch {
            emailCheckModel.checkEmail(email, with: { (userID) in
                if let userID = userID {
                    self.didFound = userID
                    self.foundLabel.text = "Dit emailadres is gevonden! :)"
                    self.submitButton.setTitle("Toevoegen", for: .normal)
                } else {
                    self.didFound = nil
                    self.foundLabel.text = "Dit emailadres konden we niet vinden"
                    self.submitButton.setTitle("Controleren", for: .normal)
                }
                
                self.foundLabel.isHidden = false
                self.doSearch = false
            })
            
            doSearch = true
        }
    }

}

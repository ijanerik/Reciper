//
//  AllHouseholdsTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 15-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

class AllHouseholdsTableViewController: UITableViewController {

    var userModel: UserModel! = nil
    var results: [HouseholdEntity] = []
    
    var householdObserver: FBObserver? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userModel = UserModel.shared
        
        userModel.addHouseholdChanger { (householdID) in
            self.householdObserver?.unobserve()
            
            self.results = []
            self.tableView.reloadData()
            
            self.householdObserver = self.userModel.allHouseholds(.observe) { (results) in
                self.results = results
                self.tableView.reloadData()
            }
        }
        
        initUI()
    }
    
    func initUI() {
        let addButton =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(pressedAddButton(sender:)))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func pressedAddButton(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ToNewHousehold", sender: self)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseholdCell", for: indexPath)

        cell.textLabel?.text = self.results[indexPath.row].title

        return cell
    }
    
    /*
    // MARK: - Deleting cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var household = self.results[indexPath.row]
        if household.userIDs.count == 1 && household.userIDs[0] == Auth.auth().currentUser?.uid {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var household = self.results[indexPath.row]
        }
    }
    */
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSharedWith" {
            let controller = segue.destination as! SharedWithHouseholdTableViewController
            controller.household = self.results[tableView.indexPathForSelectedRow!.row]
        }
    }
    

}

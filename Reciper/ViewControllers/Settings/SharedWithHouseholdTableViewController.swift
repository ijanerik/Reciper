//
//  SharedWithHouseholdTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 25-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

class SharedWithHouseholdTableViewController: UITableViewController {
    
    var household: HouseholdEntity! = nil
    
    var householdModel: HouseholdModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        householdModel = HouseholdModel.shared
        
        _ = householdModel.get(household.id!, .observe) { (household) in
            if let household = household {
                self.household = household
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
        self.performSegue(withIdentifier: "AddNewUser", sender: self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.household.userIDs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharedWith", for: indexPath)
        if self.household.userIDs[indexPath.row] == Auth.auth().currentUser?.uid {
            cell.textLabel?.text = "Jijzelf"
        } else {
            cell.textLabel?.text = self.household.userIDs[indexPath.row]
        }
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewUser" {
            let controller = segue.destination as! AddUserToHouseholdViewController
            controller.household = self.household
        }
    }

}

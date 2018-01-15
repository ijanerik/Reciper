//
//  CurrentHouseholdTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 12-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class CurrentHouseholdTableViewController: UITableViewController {

    var userModel: UserModel!
    var results: [HouseholdEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userModel = UserModel.shared
        
        userModel.allHouseholds { (results) in
            self.results = results
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func dismissPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) { }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseholdCell", for: indexPath)
        
        cell.textLabel?.text = String(self.results[indexPath.row].title)
        if userModel.currentHouseholdID() == self.results[indexPath.row].id {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.userModel.setCurrentHousehold(self.results[indexPath.row].id)
        self.dismiss(animated: true) { }
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

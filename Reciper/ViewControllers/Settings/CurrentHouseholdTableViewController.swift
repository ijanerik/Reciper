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
    var householdObserver: FBObserver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userModel = UserModel.shared
        initObserver()
    }
    
    func initObserver() {
        userModel.addHouseholdChanger { (householdID) in
            self.householdObserver?.unobserve()
            
            self.results = []
            self.tableView.reloadData()
            
            self.householdObserver = self.userModel.allHouseholds(.observe) { (results) in
                self.results = results
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func dismissPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) { }
    }
    
    
    // MARK: - Table view data source
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

}

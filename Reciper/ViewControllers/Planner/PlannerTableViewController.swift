//
//  PlannerTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 15-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class PlannerTableViewController: UITableViewController, PlannerRecipeCellDelegate {
    
    let dateFormatter = DateFormatter()
    let dateFormatterSmall = DateFormatter()
    
    var plannerModel: PlannerModel! = nil
    var userModel: UserModel! = nil
    
    // Variables for displaying data
    var results: [String: [PlannerEntity]] = [:]
    var days: [Date] = []
    var daysLoaded = 0
    
    // Do we need to load more days?
    var doLoadMore = false
    
    // For correctly remove old plannerHandler after changing household.
    var plannerObserverHandler: UInt = 0
    var oldHouseholdID: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "nl_NL")
        dateFormatterSmall.dateFormat = "dd-MM-yyyy"
        
        tableView.showsVerticalScrollIndicator = false
        
        loadMoreDays()
        
        plannerModel = PlannerModel.shared
        userModel = UserModel.shared
        
        userModel.addHouseholdChanger { (householdID) in
            if let id = self.oldHouseholdID {
                self.plannerModel.ref.child(id).removeObserver(withHandle: self.plannerObserverHandler)
            }
            
            self.oldHouseholdID = householdID
            self.plannerObserverHandler = self.plannerModel.allWithRecipe(.observe) { (results) in
                self.results = results
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return daysLoaded
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = self.results[self.dateFormatterSmall.string(from: self.days[section])] {
            return results.count + 1
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.string(from: days[section])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let results = self.results[self.dateFormatterSmall.string(from: self.days[indexPath.section])] {
            if indexPath.row < results.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
                let correctCell = cell as! PlannerRecipeTableViewCell
                correctCell.delegate = self
                if let recipe = results[indexPath.row].recipe {
                    correctCell.update(recipe)
                }
                return correctCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipeCell", for: indexPath)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipeCell", for: indexPath)
            return cell
        }
    }
    
    func loadMoreDays() {
        let loadDays = 20
        
        let day = 60*60*24
        let today = Calendar.current.startOfDay(for: Date())
        
        for _ in 0..<loadDays {
            self.days.append(today.addingTimeInterval(TimeInterval(day*self.daysLoaded)))
            self.daysLoaded += 1
        }
        
        tableView.reloadData()
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let results = self.results[self.dateFormatterSmall.string(from: self.days[indexPath.section])] {
            if indexPath.row < results.count {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let results = self.results[self.dateFormatterSmall.string(from: self.days[indexPath.section])] {
                if indexPath.row < results.count {
                    self.plannerModel.remove(results[indexPath.row])
                }
            }
        }
    }
    
    
    
    // Check if the view is low enough to load more recipes
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Distance from bottom
        let distance : CGFloat = 100
        
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - distance
            && scrollView.contentSize.height > 0 && self.doLoadMore == false) {
            self.loadMoreDays()
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ToSingleRecipe") {
            let recipeController = segue.destination as! RecipeViewController
            if let results = self.results[self.dateFormatterSmall.string(from: self.days[tableView.indexPathForSelectedRow!.section])] {
                if tableView.indexPathForSelectedRow!.row < results.count {
                    recipeController.smallRecipe = results[tableView.indexPathForSelectedRow!.row].recipe!
                }
            }
        } else if segue.identifier == "AddRecipeToGroceries" {
            let addGroceriesController = segue.destination as! AddGroceriesFromRecipeTableViewController
            let result = sender as! PlannerEntity
            addGroceriesController.planner = result
        }
    }
    
    func addToGroceriesTapped(sender: PlannerRecipeTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender),
            let results = self.results[self.dateFormatterSmall.string(from: self.days[indexPath.section])] {
            performSegue(withIdentifier: "AddRecipeToGroceries", sender: results[indexPath.row])
        }
    }
    
    
    @IBAction func unwindToPlanner(segue: UIStoryboardSegue) {
        
    }


}

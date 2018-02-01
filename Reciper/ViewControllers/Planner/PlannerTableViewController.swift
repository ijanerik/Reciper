//
//  PlannerTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 15-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class PlannerTableViewController: UITableViewController {
    
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
    var plannerObserverHandler: FBObserver?
    var indicator: SimpleLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "nl_NL")
        dateFormatterSmall.dateFormat = "dd-MM-yyyy"
        
        plannerModel = PlannerModel.shared
        userModel = UserModel.shared
        
        tableView.showsVerticalScrollIndicator = false
        loadMoreDays()
        
        initObserver()
    }
    
    // Initialize the observer who watches all the data from the planner in Firebase
    func initObserver() {
        // Reload observer if household changes.
        userModel.addHouseholdChanger { (householdID) in
            
            // Show loader indicator
            self.indicator = SimpleLoader(self)
            self.indicator.start()
            self.results = [:]
            
            self.plannerObserverHandler?.unobserve()
            self.tableView.reloadData()
            
            self.plannerObserverHandler = self.plannerModel.allWithRecipe(.observe) { (results) in
                self.results = results
                self.indicator.stop()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return daysLoaded
    }

    // Amount of recipes per day + 1 add button
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = self.results[self.dateFormatterSmall.string(from: self.days[section])] {
            return results.count + 1
        } else {
            return 1
        }
    }
    
    // Show date in header
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
                    
                    if let imageUrl = recipe.image {
                        RecipeAPIModel.shared.fetchImage(url: imageUrl, completion: { (image) in
                            DispatchQueue.main.async {
                                if let cellToUpdate = self.tableView.cellForRow(at: indexPath) {
                                    let newCell = cellToUpdate as! PlannerRecipeTableViewCell
                                    newCell.updateImage(image)
                                }
                            }
                        })
                    }
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

    
    // Remove possible cells except the add buttons
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ToSingleRecipe") {
            let recipeController = segue.destination as! RecipeViewController
            if let results = self.results[self.dateFormatterSmall.string(from: self.days[tableView.indexPathForSelectedRow!.section])], tableView.indexPathForSelectedRow!.row < results.count {
                    recipeController.smallRecipe = results[tableView.indexPathForSelectedRow!.row].recipe!
            }
        } else if segue.identifier == "AddRecipeToGroceries" {
            let addGroceriesController = segue.destination as! AddGroceriesFromRecipeTableViewController
            let result = sender as! PlannerEntity
            addGroceriesController.planner = result
        } else if segue.identifier == "AddRecipe" {
            let searchController = segue.destination as! FavoritesTableViewController
            searchController.planningDate = self.days[tableView.indexPathForSelectedRow!.section]
        }
    }
    
    
    @IBAction func unwindToPlanner(segue: UIStoryboardSegue) { }


}

extension PlannerTableViewController: PlannerRecipeCellDelegate {
    func addToGroceriesTapped(sender: PlannerRecipeTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender),
            let results = self.results[self.dateFormatterSmall.string(from: self.days[indexPath.section])] {
            performSegue(withIdentifier: "AddRecipeToGroceries", sender: results[indexPath.row])
        }
    }
}

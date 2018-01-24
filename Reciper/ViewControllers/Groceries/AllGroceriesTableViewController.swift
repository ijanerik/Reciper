//
//  AllGroceriesTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 15-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

import Firebase

class AllGroceriesTableViewController: UITableViewController {
    var groceriesModel: GroceriesModel! = nil
    var userModel: UserModel! = nil
    var recipeModel: RecipeModel! = nil
    
    // For correctly remove old plannerHandler after changing household.
    var groceriesObserverHandler: UInt = 0
    var oldHouseholdID: String? = nil
    
    // Boodschappen en hun recepten
    var groceries: [String: [GroceryEntity]] = ["":[]]
    var recipes: [String: SmallRecipeEntity] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if Auth.auth().currentUser == nil {
            return
        }
        
        groceriesModel = GroceriesModel.shared
        userModel = UserModel.shared
        recipeModel = RecipeModel.shared
        
        userModel.addHouseholdChanger { (householdID) in
            if let id = self.oldHouseholdID {
                self.groceriesModel.ref.child(id).removeObserver(withHandle: self.groceriesObserverHandler)
            }
            
            self.groceries = ["":[]]
            self.recipes = [:]
            
            self.oldHouseholdID = householdID
            self.groceriesObserverHandler = self.groceriesModel.all(.observe) { (results) in
                self.groceries = results
                let plannerIDs = Array(results.keys).filter { $0 != "" }
                let recipeIDs = plannerIDs.map({ results[$0]?[0].recipeID ?? "" }).filter { $0 != "" }
                self.recipeModel.getMany(recipeIDs, with: { (recipeResults) in
                    for recipe in recipeResults {
                        self.recipes[recipe.id] = recipe
                    }
                    
                    self.tableView.reloadData()
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groceries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.groceries[""]!.count + 1 // (Toevoegen button?)
        } else {
            let sectionName = getSectionNameByIndex(section)
            return self.groceries[sectionName]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Eigen boodschappen"
        } else {
            let sectionName = getSectionNameByIndex(section)
            return self.recipes[self.groceries[sectionName]?[0].recipeID ?? ""]?.title ?? "-"
        }
    }
    
    func getSectionNameByIndex(_ sectionIndex: Int) -> String {
        if sectionIndex == 0 {
            return ""
        } else {
            let sections = Array(self.groceries.keys).filter { $0 != "" }
            let sectionName = sections[sectionIndex - 1]
            return sectionName
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = self.getSectionNameByIndex(indexPath.section)
        if sectionName == "" && groceries[""]?.count ?? 0 <= indexPath.row {
            return tableView.dequeueReusableCell(withIdentifier: "AddGroceryCell", for: indexPath)
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCell", for: indexPath)
        guard let grocery = self.groceries[sectionName]?[indexPath.row] else {
            return cell
        }
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: grocery.title)
        if grocery.done == true {
            attributeString.addAttribute(.strikethroughStyle,
                                     value: 2,
                                     range: NSMakeRange(0, attributeString.length))
        }
        
        cell.textLabel?.attributedText = attributeString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionName = self.getSectionNameByIndex(indexPath.section)
        
        if sectionName == "" && groceries[""]?.count ?? 0 <= indexPath.row {
            return
        }
        
        guard let grocery = self.groceries[sectionName]?[indexPath.row] else {
            return
        }
        
        var newGrocery = grocery
        newGrocery.done = !newGrocery.done
        self.groceriesModel.update(newGrocery)
    }
    
    @IBAction func pressedCleaning(_ sender: UIBarButtonItem) {
        for (_, grocies) in groceries {
            for grocery in grocies {
                if grocery.done == true {
                    self.groceriesModel.remove(grocery)
                }
            }
        }
    }
    

    
    // Everything for deleting cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let sectionName = self.getSectionNameByIndex(indexPath.section)
        if sectionName == "" && groceries[""]?.count ?? 0 <= indexPath.row {
            return false
        } else {
            return true
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let sectionName = self.getSectionNameByIndex(indexPath.section)
        if editingStyle == .delete {
            guard let grocery = self.groceries[sectionName]?[indexPath.row] else {
                return
            }
            
            self.groceriesModel.remove(grocery)
        }
    }

}

//
//  AllGroceriesTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 15-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

import Firebase

class AllGroceriesTableViewController: UITableViewController, UITextFieldDelegate {
    var groceriesModel: GroceriesModel! = nil
    var userModel: UserModel! = nil
    var recipeModel: RecipeModel! = nil
    
    // For correctly remove old plannerHandler after changing household.
    var groceriesObserverHandler: FBObserver?
    
    // Boodschappen en hun recepten
    var groceries: [String: [GroceryEntity]] = ["":[]]
    var recipes: [String: SmallRecipeEntity] = [:]
    
    // Check if the system is loaded?
    var loaded = false
    var indicator: SimpleLoader!
    
    var tryAddingNewItem: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInitSystem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkInitSystem()
    }
    
    // Need to load once, but after the user logged in
    // Fix to prevent error in loading Groceries without being logged in.
    func checkInitSystem() {
        guard loaded == false, Auth.auth().currentUser != nil else {
            return
        }
        
        groceriesModel = GroceriesModel.shared
        userModel = UserModel.shared
        recipeModel = RecipeModel.shared
        
        initObserver()
        
        loaded = true
    }
    
    // Initialize the observer who watches all the data from the groceries in Firebase
    func initObserver() {
        userModel.addHouseholdChanger { (householdID) in
            self.groceriesObserverHandler?.unobserve()
            
            self.indicator = SimpleLoader(self)
            self.indicator.start()
            
            self.groceries = ["":[]]
            self.recipes = [:]
            self.tableView.reloadData()
            
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
                self.indicator.stop()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Add Grocery label
    @IBAction func startAddingGrocery(_ sender: UITextField) {
        sender.delegate = self
        sender.returnKeyType = .done
        tryAddingNewItem = sender
    }
    
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let text = textField.text, text.isEmpty {
            textField.resignFirstResponder()
            tryAddingNewItem = nil
            return true
        } else {
            let grocery = GroceryEntity(id: nil,
                                        title: textField.text!,
                                        plannerID: nil,
                                        recipeID: nil,
                                        done: false,
                                        planner: nil,
                                        recipe: nil
            )
        
            _ = self.groceriesModel.add(grocery)
            textField.text = ""
            return false
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groceries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Show on top your own groceries else the groceries from your planner
        if section == 0 {
            return self.groceries[""]!.count + 1 // Toevoeg textfield
        } else {
            let sectionName = getSectionNameByIndex(section)
            return self.groceries[sectionName]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Show on top your own groceries else the groceries from your planner
        if section == 0 {
            return "Eigen boodschappen"
        } else {
            let sectionName = getSectionNameByIndex(section)
            return self.recipes[self.groceries[sectionName]?[0].recipeID ?? ""]?.title ?? "-"
        }
    }
    
    func getSectionNameByIndex(_ sectionIndex: Int) -> String {
        // Show on top your own groceries else the groceries from your planner
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCell", for: indexPath)
            // Check if the grocery exists.
            guard let grocery = self.groceries[sectionName]?[indexPath.row] else {
                return cell
            }
            
            // Make the text. If the grocery is done add a crossed line through the text.
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: grocery.title)
            if grocery.done == true {
                attributeString.addAttribute(.strikethroughStyle,
                                         value: 2,
                                         range: NSMakeRange(0, attributeString.length))
            }
            
            cell.textLabel?.attributedText = attributeString
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionName = self.getSectionNameByIndex(indexPath.section)
        
        if sectionName == "" && groceries[""]?.count ?? 0 <= indexPath.row {
            return
        }
        
        guard let grocery = self.groceries[sectionName]?[indexPath.row] else {
            return
        }
        
        // When grocery selected toggle done/undone
        var newGrocery = grocery
        newGrocery.done = !newGrocery.done
        self.groceriesModel.update(newGrocery)
    }
    
    @IBAction func pressedCleaning(_ sender: UIBarButtonItem) {
        // Remove all the groceries when cleaning your screen.
        for (_, grocies) in groceries {
            for grocery in grocies {
                if grocery.done == true {
                    self.groceriesModel.remove(grocery)
                }
            }
        }
    }
    

    
    // MARK: - Deleting cells
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

//
//  AddToPlannerTableViewController.swift
//  
//
//  Created by Jan Erik van Woerden on 11-01-18.
//

import UIKit

class AddToPlannerTableViewController: UITableViewController {

    var plannerModel: PlannerModel! = nil
    var recipeModel: RecipeModel! = nil
    
    let dateFormatter = DateFormatter()
    
    var recipe: SmallRecipeEntity? = nil
    
    var currentDate = Calendar.current.startOfDay(for: Date()).addingTimeInterval(TimeInterval(0))
    var datePickerDate = Calendar.current.startOfDay(for: Date()).addingTimeInterval(TimeInterval(0))
    var customDate = false
    
    var dates: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plannerModel = PlannerModel.shared
        recipeModel = RecipeModel.shared
        
        dates = get7NextDays()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "nl_NL")
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if let recipe = self.recipe {
            let planner = PlannerEntity(id: nil, date: currentDate, recipeID: recipe.id, recipe: nil)
            let _ = self.plannerModel.add(planner)
            self.recipeModel.add(recipe)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        datePickerDate = sender.date
        
        if customDate == true {
            currentDate = Calendar.current.startOfDay(for: datePickerDate).addingTimeInterval(TimeInterval(0))
        }
        
        tableView.reloadData()
    }
    
    func get7NextDays() -> [Date] {
        var ret: [Date] = []
        let day = 60*60*24
        let today = Calendar.current.startOfDay(for: Date())
        for i in 0..<7 {
            ret.append(today.addingTimeInterval(TimeInterval(day*i)))
        }
        
        return ret
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDatePicker", for: indexPath)
            return cell
        } else if row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDate", for: indexPath)
            
            let dateString = dateFormatter.string(from: datePickerDate)
            cell.textLabel?.text = "Aangepast (\(dateString))"
            
            if customDate == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else {
            let thisDate = self.dates[row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateLabel", for: indexPath)
            
            let dateString = dateFormatter.string(from: thisDate)
            if row == 0 {
                cell.textLabel?.text = "Vandaag (\(dateString))"
            } else if row == 1 {
                cell.textLabel?.text = "Morgen (\(dateString))"
            } else if row == 2 {
                cell.textLabel?.text = "Overmorgen (\(dateString))"
            } else {
                cell.textLabel?.text = dateString
            }
            
            if thisDate == currentDate, customDate == false {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row < 7 {
            currentDate = self.dates[row]
            customDate = false
        } else if row == 7 {
            customDate = true
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        
        if row == 8 {
            if customDate == true {
                return 200
            } else {
                return 0
            }
        } else {
            return 44
        }
    }

}

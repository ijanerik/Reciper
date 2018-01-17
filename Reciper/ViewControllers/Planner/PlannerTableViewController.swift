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

    var daysLoaded = 0
    
    var plannerModel: PlannerModel! = nil
    
    var results: [[PlannerEntity]] = []
    var days: [Date] = []
    
    var doLoadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "nl_NL")
        
        tableView.showsVerticalScrollIndicator = false
        
        loadMoreDays()
        
        plannerModel = PlannerModel.shared
        
        plannerModel.all(.observe) { (results) in
            print(results)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return daysLoaded
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results[section].count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.string(from: days[section])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipeCell", for: indexPath)
        
        //RecipeCell

        return cell
    }
    
    func loadMoreDays() {
        let loadDays = 20
        
        let day = 60*60*24
        let today = Calendar.current.startOfDay(for: Date())
        
        for _ in 0..<loadDays {
            self.days.append(today.addingTimeInterval(TimeInterval(day*self.daysLoaded)))
            self.results.append([])
            self.daysLoaded += 1
        }
        
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    // Check if the view is low enough to load more recipes
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Distance from bottom
        let distance : CGFloat = 100
        
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - distance
            && scrollView.contentSize.height > 0 && self.doLoadMore == false) {
            self.loadMoreDays()
        }
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

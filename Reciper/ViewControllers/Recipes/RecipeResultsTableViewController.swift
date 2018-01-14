//
//  RecipeResultsTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class RecipeResultsTableViewController: UITableViewController {
    
    var searchTerm : String!
    var recipes : [SmallRecipeEntity] = []
    
    let RecipeAPI = RecipeAPIModel.shared
    
    var doLoadMore = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        findAndUpdateResults(searchTerm)
    }
    
    
    func findAndUpdateResults(_ searchTerm : String, moreLoading: Bool = false) {
        let startResults = (moreLoading == true) ? self.recipes.count : 0
        
        guard self.doLoadMore == false || moreLoading == false else {
            return
        }
        
        if moreLoading == true {
            self.doLoadMore = true
        }
        
        self.RecipeAPI.search(searchTerm: searchTerm, startResults: startResults) { (results) in
            DispatchQueue.main.async {
                if let results = results {
                    if moreLoading == false {
                        self.recipes = results.results
                    } else {
                        self.recipes += results.results
                    }
                    
                    self.tableView.reloadData()
                    
                    if self.doLoadMore == true {
                        self.doLoadMore = false
                    }
                }
            }
        }
    }

    // Give amount of recipes as amount of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }

    // Load in per recipe
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeResultCell", for: indexPath)
        cell.textLabel?.text = String(self.recipes[indexPath.row].title)
        return cell
    }
    
    
    // Check if the scroll view is low enough to load more recipes
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let distance : CGFloat = 200
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - distance
            && scrollView.contentSize.height > 0 && self.doLoadMore == false) {
            findAndUpdateResults(self.searchTerm, moreLoading: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ToSingleRecipe") {
            let recipeController = segue.destination as! RecipeViewController
            recipeController.smallRecipe = self.recipes[tableView.indexPathForSelectedRow!.row]
        }
    }

}

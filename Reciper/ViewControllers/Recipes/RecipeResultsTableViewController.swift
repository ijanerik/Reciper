//
//  RecipeResultsTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class RecipeResultsTableViewController: UITableViewController {
    
    var searchTerm : String = ""
    var recipes : [SmallRecipeEntity] = []
    
    var planningDate: Date?
    var indicator: SimpleLoader!
    
    let RecipeAPI = RecipeAPIModel.shared
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var doLoadMore = false
    var shouldLoadMore = false
    var latestSearch = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        indicator = SimpleLoader(self)
        indicator.start()
        
        initSearchBar()
        
        findAndUpdateResults(searchTerm)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func initSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Zoek recepten"
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    
    func findAndUpdateResults(_ searchTerm : String, moreLoading: Bool = false) {
        let startResults = (moreLoading == true) ? self.recipes.count : 0
        
        // Stop updating if you are already loading data and you want more data.
        // If you want new data you can still override the loading old data.
        guard self.doLoadMore == false || moreLoading == false else {
            return
        }
        self.doLoadMore = true
        
        // You know there is new data when loading a new search result
        if moreLoading == false {
            self.shouldLoadMore = true
        }
        
        // If no should load more then stop finding new results.
        if self.shouldLoadMore == false {
            return
        }
        
        self.RecipeAPI.search(searchTerm: searchTerm, startResults: startResults) { (results) in
            DispatchQueue.main.async {
                if let results = results, self.searchTerm == searchTerm || self.latestSearch != self.searchTerm {
                    if moreLoading == false {
                        self.recipes = results.results
                    } else {
                        self.recipes += results.results
                    }
                    
                    if results.results.count == 0 {
                        self.shouldLoadMore = false
                    }
                    
                    self.indicator.stop()
                    
                    self.tableView.reloadData()
                    
                    self.doLoadMore = false
                    self.latestSearch = searchTerm
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
        let newCell = cell as! RecipesResultsTableViewCell
        
        let recipe = self.recipes[indexPath.row]
        
        if let imageUrl = recipe.image {
            self.RecipeAPI.fetchImage(url: imageUrl, completion: { (image) in
                DispatchQueue.main.async {
                    if let cellToUpdate = self.tableView.cellForRow(at: indexPath) {
                        let newCell = cellToUpdate as! RecipesResultsTableViewCell
                        newCell.updateImage(image)
                    }
                }
            })
        }
        
        newCell.updateText(recipe)
        return newCell
    }
    
    
    // Check if the scroll view is low enough to load more recipes
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance : CGFloat = 100
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - distance
            && scrollView.contentSize.height > 0 && self.doLoadMore == false) {
            findAndUpdateResults(self.searchTerm, moreLoading: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ToSingleRecipe") {
            let recipeController = segue.destination as! RecipeViewController
            recipeController.smallRecipe = self.recipes[tableView.indexPathForSelectedRow!.row]
            recipeController.planningDate = planningDate
        }
    }

}

extension RecipeResultsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        self.searchTerm = searchController.searchBar.text ?? ""
        findAndUpdateResults(self.searchTerm, moreLoading: false)
    }
}

//
//  RecipeSearchViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class RecipeSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var planningDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.becomeFirstResponder()
    }
    
    @IBAction func pressedSearch(_ sender: UIButton) {
        if searchBar.text != nil, !searchBar.text!.isEmpty {
            self.performSegue(withIdentifier: "ToRecipeResults", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ToRecipeResults") {
            let resultsController = segue.destination as! RecipeResultsTableViewController
            resultsController.searchTerm = self.searchBar.text!
            resultsController.planningDate = planningDate
        }
    }
}

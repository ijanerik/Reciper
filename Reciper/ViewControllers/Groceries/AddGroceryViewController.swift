//
//  AddGroceryViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class AddGroceryViewController: UIViewController {

    var groceriesModel: GroceriesModel! = nil
    
    @IBOutlet weak var searchBar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groceriesModel = GroceriesModel.shared
        
        searchBar.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDone(_ sender: UIBarButtonItem) {
        let grocery = GroceryEntity(id: nil,
                                    title: searchBar.text!,
                                    plannerID: nil,
                                    planner: nil,
                                    recipeID: nil,
                                    recipe: nil,
                                    done: false
        )
        
        _ = self.groceriesModel.add(grocery)
        
        self.dismiss(animated: true, completion: nil)
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

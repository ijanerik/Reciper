//
//  RecipeViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    var smallRecipe : SmallRecipeEntity!
    var fullRecipe : FullRecipeEntity?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAndDisplayRecipe()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAndDisplayRecipe() {
        RecipeAPIModel.shared.getRecipe(recipeID: self.smallRecipe.id,
                                        completion: { (fullRecipe) in
            DispatchQueue.main.async {
                if let recipe = fullRecipe {
                    self.fullRecipe = recipe
                    self.updateUI()
                } else {
                    // Go back if something went wrong
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    func updateUI() {
        if fullRecipe != nil {
            displayFullRecipe()
        } else {
            displaySmallRecipe()
        }
    }
    
    func displayFullRecipe() {
        if let fullRecipe = self.fullRecipe {
            titleLabel.text = fullRecipe.title
        }
    }
    
    func displaySmallRecipe() {
        titleLabel.text = smallRecipe.title
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

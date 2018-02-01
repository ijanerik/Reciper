//
//  PlannerRecipeTableViewCell.swift
//  Reciper
//
// A single recipe cell in the planner with a "Add to groceries" button
//
//  Created by Jan Erik van Woerden on 22-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

@objc protocol PlannerRecipeCellDelegate: class {
    func addToGroceriesTapped(sender: PlannerRecipeTableViewCell)
}

class PlannerRecipeTableViewCell: UITableViewCell {

    var delegate: PlannerRecipeCellDelegate?
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var plannerImage: UIImageView!
    
    // Update all the text from the cell based on the recipe
    func update(_ recipe: SmallRecipeEntity) {
        self.labelText.text = recipe.title
    }
    
    // Update the image of the Cell
    func updateImage(_ image: UIImage?) {
        if let image = image {
            self.plannerImage.image = image
            self.plannerImage.isHidden = false
            self.plannerImage.layer.cornerRadius = 8
        } else {
            self.plannerImage.isHidden = true
        }
        self.setNeedsLayout()
    }
    
    // Call delegate when the add to groceries button is clicked
    @IBAction func clickAddToGroceries(_ sender: UIButton) {
        delegate?.addToGroceriesTapped(sender: self)
    }

}

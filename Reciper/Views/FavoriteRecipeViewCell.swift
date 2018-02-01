//
//  PlannerRecipeTableViewCell.swift
//  Reciper
//
//  A custom recipe cell for all the favorites and button to add to planner.
//
//  Created by Jan Erik van Woerden on 22-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

@objc protocol FavoriteRecipeCellDelegate: class {
    func addToPlannerTapped(sender: FavoriteRecipeTableViewCell)
}

class FavoriteRecipeTableViewCell: UITableViewCell {
    
    var delegate: FavoriteRecipeCellDelegate?
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    // Update all the text from the cell based on the recipe
    func update(_ recipe: SmallRecipeEntity) {
        self.labelText.text = recipe.title
    }
    
    // Update the image
    func updateImage(_ image: UIImage?) {
        if let image = image {
            self.favoriteImage.image = image
            self.favoriteImage.isHidden = false
            self.favoriteImage.layer.cornerRadius = 8
        } else {
            self.favoriteImage.isHidden = true
        }
        self.setNeedsLayout()
    }
    
    // Call delegate when the add to planner button is clicked
    @IBAction func clickAddToPlanner(_ sender: UIButton) {
        delegate?.addToPlannerTapped(sender: self)
    }
}


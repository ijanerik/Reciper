//
//  RecipesResultsTableViewCell.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 24-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class RecipesResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipePersons: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateImage(_ image: UIImage?) {
        if let image = image {
            self.recipeImage.image = image
            self.recipeImage.isHidden = false
        } else {
            self.recipeImage.isHidden = true
        }
        self.setNeedsLayout()
    }
    
    func updateText(_ recipe: SmallRecipeEntity) {
        recipeTitle.text = recipe.title
        recipeTime.text =  "\(recipe.time) minuten"
        recipePersons.text = recipe.servings
    }

}

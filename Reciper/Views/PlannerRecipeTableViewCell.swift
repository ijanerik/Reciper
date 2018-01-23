//
//  PlannerRecipeTableViewCell.swift
//  Reciper
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickAddToGroceries(_ sender: UIButton) {
        delegate?.addToGroceriesTapped(sender: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(_ recipe: SmallRecipeEntity) {
        self.labelText.text = recipe.title
    }

}

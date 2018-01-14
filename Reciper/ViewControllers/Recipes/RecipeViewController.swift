//
//  RecipeViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    let RecipeAPI = RecipeAPIModel.shared
    let favoritesModel = FavoriteModel.shared
    let recipeModel = RecipeModel.shared
    
    var smallRecipe : SmallRecipeEntity!
    var fullRecipe : FullRecipeEntity?
    
    var isFavorite = false
    
    // All UI elements
    var favoriteButton : UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var portionsLabel: UILabel!
    @IBOutlet weak var preperationsText: UITextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAndDisplayRecipe()
        updateUI()
        
        self.favoritesModel.get(self.smallRecipe, .observe) { (isFavorite) in
            self.isFavorite = isFavorite
            self.updateUI()
        }
    }
    
    func initUI() {
        // No big title
        navigationItem.largeTitleDisplayMode = .never
        
        // Add favorite button
        self.favoriteButton =  UIBarButtonItem(image: UIImage(named:"heart"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(pressedFavoriteButton(sender:)))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func loadAndDisplayRecipe() {
        self.RecipeAPI.getRecipe(recipeID: self.smallRecipe.id,
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
        
        // @todo nicer coding and maybe an nice "no recipe image" image
        if let recipeImage = self.smallRecipe.image {
            self.RecipeAPI.fetchImage(url: recipeImage, completion: { (image) in
                DispatchQueue.main.async {
                    guard let image = image else {
                        self.recipeImage.isHidden = true
                        return
                    }
                    self.recipeImage.isHidden = false
                    self.recipeImage.image = image
                }
            })
        } else {
            self.recipeImage.isHidden = false
        }
    }
    
    func updateUI() {
        if let fullRecipe = self.fullRecipe {
            titleLabel.text = fullRecipe.title
            timeLabel.text =  "\(fullRecipe.time) minuten"
            portionsLabel.text = fullRecipe.servings
            preperationsText.text = fullRecipe.preperation.joined(separator: "\n\n")
            
        } else {
            titleLabel.text = smallRecipe.title
            timeLabel.text =  "\(smallRecipe.time) minuten"
            portionsLabel.text = smallRecipe.servings
        }
        
        if isFavorite == true {
            favoriteButton.tintColor = UIColor.red
        } else {
            favoriteButton.tintColor = UIColor.blue
        }
    }
    
    @objc func pressedFavoriteButton(sender: UIBarButtonItem) {
        if isFavorite == false {
            isFavorite = true
            self.recipeModel.add(self.smallRecipe)
            self.favoritesModel.add(self.smallRecipe)
        } else{
            isFavorite = false
            self.favoritesModel.remove(self.smallRecipe)
        }
        
        updateUI()
    }
    
    @IBAction func pressedPlanning(_ sender: UIButton) {
        // Inplannen van het recept
        self.performSegue(withIdentifier: "ToAddToPlanner", sender: self)
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

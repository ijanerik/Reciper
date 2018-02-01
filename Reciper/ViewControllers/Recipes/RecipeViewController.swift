//
//  RecipeViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var planningDate: Date?
    
    let RecipeAPI = RecipeAPIModel.shared
    let favoritesModel = FavoriteModel.shared
    let recipeModel = RecipeModel.shared
    let plannerModel = PlannerModel.shared
    
    var smallRecipe: SmallRecipeEntity!
    var fullRecipe: FullRecipeEntity?
    
    var isFavorite = false
    
    // All UI elements
    var favoriteButton : UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var portionsLabel: UILabel!
    @IBOutlet weak var preperationsText: UITextView!
    @IBOutlet weak var ingredientTable: UITableView!
    
    
    
    
    
    @IBOutlet weak var preperationHeight: NSLayoutConstraint!
    @IBOutlet weak var ingredientsHeight: NSLayoutConstraint!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFullrecipe()
        loadImage()
        updateUI()
        
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
        
        _ = self.favoritesModel.get(self.smallRecipe, .observe) { (isFavorite) in
            self.isFavorite = isFavorite
            self.updateUI()
        }
    }
    
    func initUI() {
        self.favoriteButton =  UIBarButtonItem(image: UIImage(named:"heart"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(pressedFavoriteButton(sender:)))
        navigationItem.rightBarButtonItem = favoriteButton
    }

    func loadFullrecipe() {
        self.RecipeAPI.getRecipe(recipeID: self.smallRecipe.id, completion: { (fullRecipe) in
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
    
    func loadImage() {
        if let recipeImage = self.smallRecipe.image {
            self.RecipeAPI.fetchImage(url: recipeImage, completion: { (image) in
                DispatchQueue.main.async {
                    guard let image = image else {
                        return
                    }
                    self.recipeImage.image = image
                }
            })
        }
    }
    
    func updateUI() {
        updateText()
        
        favoriteButton.tintColor = UIColor.red
        if isFavorite {
             favoriteButton.image = UIImage(named: "icons8-heart-filled-50")
        } else {
            favoriteButton.image = UIImage(named: "icons8-heart-50")
        }
        
        // Update heights of preperations and ingredients
        self.preperationHeight.constant = 0
        self.preperationHeight.constant = preperationsText.contentSize.height
        ingredientTable.reloadData()
        self.ingredientsHeight.constant = 0
        self.ingredientsHeight.constant = ingredientTable.contentSize.height
    }
    
    func updateText() {
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
        // Als planningdate is gegeven meteen terug naar planner
        if let planningDate = self.planningDate {
            let planner = PlannerEntity(id: nil, date: planningDate, recipeID: smallRecipe.id, recipe: nil)
            let _ = self.plannerModel.add(planner)
            self.recipeModel.add(smallRecipe)
            self.performSegue(withIdentifier: "unwindToPlanner", sender: self)
        } else {
            self.performSegue(withIdentifier: "ToAddToPlanner", sender: self)
        }
    }
    
    // MARK: - Table View
    // Give amount of recipes as amount of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fullRecipe?.ingredients.count ?? 0
    }
    
    // Load in per recipe
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient", for: indexPath)
        cell.textLabel?.text = self.fullRecipe?.ingredients[indexPath.row].label ?? ""
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddToPlanner" {
            let controller = segue.destination as! AddToPlannerTableViewController
            controller.recipe = smallRecipe
        }
    }
}

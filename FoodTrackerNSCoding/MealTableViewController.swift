//
//  MealTableViewController.swift
//  FoodTrackerNSCoding
//
//  Created by Nick Reichard on 3/21/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    // MARK: - Properties 
    
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data 
        if let savedMeals = loadMeals() {
            meals += saveMeals()
        }
        else {
        // Load the sample data.
        loadSampleMeals()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as? MealTableViewCell else { return UITableViewCell () }
       
        // This code fetches the appropriate meal from the meals array.
        
        let meal = meals[indexPath.row]

        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControll.rating = meal.rating

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    // This method lets you configure a view controller before it's presented.


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "AddItem":
            os_log("Adding a new mail", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? FoodEntryViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Seque Identifier; \(segue.identifier)")
        
        }
    }
    
    // MARK: - Actions 
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? FoodEntryViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            saveMeals()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "jack")
        let photo2 = UIImage(named: "Saturn")
        let photo3 = UIImage(named: "like")
        
        guard let meal1 = Meal(name: "Caprse Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal 1")
        }
        guard let meal2 = Meal(name: "Saturn", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        meals.append(contentsOf: [meal1, meal2, meal3])
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
}

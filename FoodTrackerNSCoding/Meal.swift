//
//  Meal.swift
//  FoodTrackerNSCoding
//
//  Created by Nick Reichard on 3/20/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import Foundation
import UIKit

class Meal {
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    
    
    init?(name: String, photo: UIImage?, rating: Int) {
       
        guard !name.isEmpty else { return nil }
        guard ( rating >= 0) && (rating <= 5) else { return nil }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        
    }
    
    
    
    
}

//
//  Meal.swift
//  FoodTrackerNSCoding
//
//  Created by Nick Reichard on 3/20/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Meal: NSObject, NScoding {
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")

    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    
    
    init?(name: String, photo: UIImage?, rating: Int) {
        guard !name.isEmpty else { return nil }
        guard ( rating >= 0) && (rating <= 5) else { return nil }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    // MARK: - NSCoding 
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDeCoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail
        guard let name = aDeCoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal just use conditional cast 
        let photo = aDeCoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDeCoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer 
        self.init(name: name, photo: photo, rating: rating)
        
    }
}

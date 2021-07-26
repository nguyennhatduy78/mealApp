//
//  Meals.swift
//  firstApp
//
//  Created by ChinhPV on 3/4/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//
import os.log
import MapKit
import UIKit

class Meal: NSObject, NSCoding, Codable{
    struct PropertyKey{
        static let id = "id"
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let address = "address"
        static let user_id = "user_id"
    }
    
    //var
    var id: Int
    var name : String
    var photo : String
    var rating : Int
    var address: String
    var user_id : Int
    init?(id: Int, name : String, photo: String, rating : Int, address: String, user_id: Int){
        guard  !name.isEmpty else {
            return nil
        }
        guard (rating > 0) && (rating < 10) else {
            return nil
        }
        if name.isEmpty || rating < 0 {
            return nil
        }
        self.id = id
        self.name = name
        self.photo = photo
        self.rating = rating
        self.address = address
        self.user_id = user_id
    }
    //Mark : Nscoding
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: PropertyKey.id)
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
        coder.encode(address, forKey: PropertyKey.address)
        coder.encode(user_id, forKey: PropertyKey.user_id)
    }
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            return nil
        }
        guard let photo = coder.decodeObject(forKey: PropertyKey.photo) as? String else{
            return nil
        }
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        guard let address = coder.decodeObject(forKey: PropertyKey.address) as? String else {
            return nil
        }
        let id = coder.decodeInteger(forKey: PropertyKey.id)
        let user_id = coder.decodeInteger(forKey: PropertyKey.user_id)
        self.init(id: id,name: name, photo: photo, rating: rating, address: address, user_id: user_id)
    }
    
}

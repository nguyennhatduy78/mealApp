//
//  User.swift
//  firstApp
//
//  Created by Nguyen Nhat Duy on 25/03/2021.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding, Codable {
    struct PropertyKey{
        static let id = "id"
        static let username = "username"
        static let password = "password"
        static let name = "name"
        static let phone = "phone"
        static let address = "address"
        static let photo = "photo"
        static let meals = "meals"
    }
    var id: Int
    var username: String
    var password: String
    var name: String
    var phone: String
    var address: String
    var photo: String
    var meals: [Meal]
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = DocumentsDirectory.appendingPathComponent("user")
    
    init?(id: Int,username: String, password: String, name: String, phone: String, address: String, photo: String, meals: [Meal]){
        guard !name.isEmpty else{
            return nil
        }
        guard !username.isEmpty else {
            return nil
        }
        guard !password.isEmpty else {
            return nil
        }

        self.id = id
        self.username = username
        self.password = password
        self.name = name
        self.phone = phone
        self.address = address
        self.photo = photo
        self.meals = meals
    }
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: PropertyKey.id)
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(phone, forKey: PropertyKey.phone)
        coder.encode(address, forKey: PropertyKey.address)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(meals, forKey: PropertyKey.meals)
    }
    
    required convenience init?(coder: NSCoder) {
        let id = coder.decodeInteger(forKey: PropertyKey.id)
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            return nil
        }
        guard let photo = coder.decodeObject(forKey: PropertyKey.photo) as? String else {
            return nil
        }
        guard let phone = coder.decodeObject(forKey: PropertyKey.phone) as? String else {
            return nil }
        guard let address = coder.decodeObject(forKey: PropertyKey.address) as? String else {
            return nil
        }
        guard let username = coder.decodeObject(forKey: PropertyKey.username) as? String else {
            return nil
        }
        guard let password = coder.decodeObject(forKey: PropertyKey.password) as? String else {
            return nil
        }
        guard let meals = coder.decodeObject(forKey: PropertyKey.meals) as? [Meal] else { return nil }
        self.init(id: id, username: username, password:password, name: name, phone: phone, address: address, photo: photo, meals: meals)
    }
  
}

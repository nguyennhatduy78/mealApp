//
//  PersistData.swift
//  firstApp
//
//  Created by Nguyen Nhat Duy on 12/04/2021.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import Foundation
import CoreData
class LoginPersist {
    enum Key : String, CaseIterable {
        case username, password
        func make(for userID: String) -> String {
            return self.rawValue+"_"+userID
        }
    }
    let userDefaults: UserDefaults
    init(userDefaults: UserDefaults = .standard){
        self.userDefaults = userDefaults
    }
    
    func saveLoginInfo(forUserID userID: String, username: String, password: String){
        saveValue(forKey: .username, value: username, userID: userID)
        saveValue(forKey: .password, value: password, userID: userID)
        
    }
    
    func getLoginInfo(forUserID userID:String) -> (username: String?, password: String?){
        let username:String? = readValue(forKey: .username, userID: userID)
        let password:String? = readValue(forKey: .password, userID: userID)
        return (username, password)
    }
    
    func removeLoginInfo(forUserID userID: String){
        Key
            .allCases
            .map { $0.make(for: userID) }
            .forEach { (key) in
                userDefaults.removeObject(forKey: key)
            }
    }
    
    private func saveValue(forKey key: Key, value: Any, userID: String){
        userDefaults.set(value, forKey: key.make(for: userID))
    }
    private func readValue<T>(forKey key: Key, userID: String) -> T?{
        return userDefaults.value(forKey: key.make(for: userID)) as? T
    }
}

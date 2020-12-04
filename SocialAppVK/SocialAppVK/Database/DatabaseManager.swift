//
//  DatabaseManager.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 27.11.2020.
//

import RealmSwift

class DatabaseManager {
    static var shared = DatabaseManager()
    
    private var realm = try! Realm()
    
    private init() {  }
    
    // MARK: - Saving data
    
    func saveGroupData(groups: [Group]) {
        try? realm.write {
            realm.add(groups)
        }
    }
    
    func saveUserData(groups: [User]) {
        try? realm.write {
            realm.add(groups)
        }
    }
    
    // MARK: - Loading data
    
    func loadGroupData() -> [Group] {
        return Array(realm.objects(Group.self))
    }
    
    func loadUserData() -> [User] {
        return Array(realm.objects(User.self))
    }
    
    // MARK: - Remove all data
    
    func deleteGroupData() {
        let result = realm.objects(Group.self)
        try? realm.write {
            realm.delete(result)
        }
    }
    
    func deleteUserData() {
        let result = realm.objects(User.self)
        try? realm.write {
            realm.delete(result)
        }
    }
}

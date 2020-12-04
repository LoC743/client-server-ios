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
    
    func saveImageData(images: [Image]) {
        try? realm.write {
            realm.add(images, update: .modified)
        }
    }
    
    // MARK: - Loading data
    
    func loadGroupData() -> [Group] {
        return Array(realm.objects(Group.self))
    }
    
    func loadUserData() -> [User] {
        return Array(realm.objects(User.self))
    }
    
    func loadImageDataBy(ownerID: Int) -> [Image] {
        return Array(realm.objects(Image.self).filter("ownerID == %@", ownerID).sorted(byKeyPath: "date", ascending: false))
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
    
    func deleteImageData() {
        let result = realm.objects(Image.self)
        try? realm.write {
            realm.delete(result)
        }
    }
}

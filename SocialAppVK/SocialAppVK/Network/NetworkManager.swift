//
//  NetworkManager.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 20.11.2020.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {  }
    
    private let baseURL = "https://api.vk.com/method/"
    private let versionVKAPI = "5.126"
    
    enum Paths: String {
        case friends = "friends.get"
        case userData = "users.get"
        case groups = "groups.get"
    }
    
    @discardableResult
    func loadFriendList(completion: @escaping (Any?) -> Void) -> Request? {
        guard let token = UserSession.instance.token,
              let userID = UserSession.instance.userID else { return nil }
        
        let path = Paths.friends.rawValue
        
        let parameters: Parameters = [
            "user_id": userID,
            "access_token": token,
            "v": versionVKAPI,
            "fields": "city, sex"
        ]
        
        let url = baseURL + path
        
        return Session.custom.request(url, parameters: parameters).responseJSON { response in
            completion(response.value)
        }
    }
    
    @discardableResult
    func getUserDataBy(id: String, completion: @escaping (Any?) -> Void) -> Request? {
        guard let token = UserSession.instance.token else { return nil }
        
        let path = Paths.userData.rawValue
        
        let parameters: Parameters = [
            "user_ids": id,
            "access_token": token,
            "v": versionVKAPI,
            "fields": "sex, bdate, city, country, home_town, has_photo, photo_50, photo_100, photo_200_orig, photo_200, photo_400_orig, photo_max, photo_max_orig"
        ]
        
        let url = baseURL + path
        
        return Session.custom.request(url, parameters: parameters).responseJSON { response in
            completion(response.value)
        }
    }
    
    @discardableResult
    func loadGroupsList(completion: @escaping (Any?) -> Void) -> Request? {
        guard let token = UserSession.instance.token,
              let userID = UserSession.instance.userID else { return nil }
        
        let path = Paths.groups.rawValue
        
        let parameters: Parameters = [
            "user_id": userID,
            "access_token": token,
            "v": versionVKAPI,
            "extended": 1
        ]
        
        let url = baseURL + path
        
        return Session.custom.request(url, parameters: parameters).responseJSON { response in
            completion(response.value)
        }
    }
}

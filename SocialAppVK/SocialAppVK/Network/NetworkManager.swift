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
        case searchGroups = "groups.search"
    }
    
    @discardableResult
    func loadFriendList(count: Int, offset: Int, completion: @escaping (FriendList) -> Void) -> Request? {
        guard let token = UserSession.instance.token,
              let userID = UserSession.instance.userID else { return nil }
        
        let path = Paths.friends.rawValue
        
        let parameters: Parameters = [
            "user_id": userID,
            "access_token": token,
            "v": versionVKAPI,
            "fields": "bdate, city, sex, has_photo, photo_50, photo_100, photo_200",
            "count": count,
            "offset": offset,
            "order": "hints"
        ]
        
        let url = baseURL + path
        
        return Session.custom.request(url, parameters: parameters).responseData { response in
            guard let data = response.value,
                  let friendList = try? JSONDecoder().decode(FriendList.self, from: data)
            else {
                print("Failed to pase friend JSON!")
                return
            }
            
            completion(friendList)
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
            "order": "hints",
            "fields": "sex, bdate, city, country, home_town, has_photo, photo_50, photo_100, photo_200"
        ]
        
        let url = baseURL + path
        
        return Session.custom.request(url, parameters: parameters).responseJSON { response in
            completion(response.value)
        }
    }
    
    @discardableResult
    func loadGroupsList(count: Int, offset: Int, completion: @escaping (GroupList) -> Void) -> Request? {
        guard let token = UserSession.instance.token,
              let userID = UserSession.instance.userID else { return nil }
        
        let path = Paths.groups.rawValue
        
        let parameters: Parameters = [
            "user_id": userID,
            "access_token": token,
            "v": versionVKAPI,
            "extended": 1,
            "count": count,
            "offset": offset
        ]
        
        let url = baseURL + path
        
        return Session.custom.request(url, parameters: parameters).responseData { response in
            guard let data = response.value,
                  let groupList = try? JSONDecoder().decode(GroupList.self, from: data)
            else {
                print("Failed to pase group JSON!")
                return
            }
            
            completion(groupList)
        }
    }
    
    @discardableResult
    func getGroupsBy(searchRequest: String, count: Int, offset: Int, completion: @escaping (Any?) -> Void) -> Request? {
        guard let token = UserSession.instance.token else { return nil }
        
        let path = Paths.searchGroups.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "q": searchRequest,
            "count": count,
            "offset": offset
        ]
        
        let url = baseURL + path
        
        return Session.custom.request(url, parameters: parameters).responseJSON { response in
            completion(response.value)
        }
    }
}

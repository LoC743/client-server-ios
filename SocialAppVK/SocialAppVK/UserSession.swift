//
//  UserSession.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 20.11.2020.
//



// MARK: - Singleton Session
class Session {
    static let instance = Session()
    
    private init() {  }
    
    var token: String = ""  // Токен VK
    var userID: Int = -1    // Идентификатор пользователя VK
}

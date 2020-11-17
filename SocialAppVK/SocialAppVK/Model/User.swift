//
//  User.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 05.10.2020.
//

import UIKit

protocol CellModel {
    var image: UIImage { get set }
    var name: String { get set }
    var isAdded: Bool  { get set }
}

struct User: CellModel {
    let id: Int
    
    var image: UIImage
    var name: String
    var isAdded: Bool
    
    var posts: [Post]
    
    static func changeUserAdded(by id: Int) {
        for i in 0..<database.count {
            if database[i].id == id {
                database[i].isAdded = !database[i].isAdded
            }
        }
    }
    
    static func getUser(by id: Int) -> User? {
        var result: User? = nil
        for user in database {
            if user.id == id {
                result = user
                break
            }
        }
        
        return result
    }
    
    static var database: [User] = [User(id: 0, image: UIImage(named: "profile1")!, name: "Иван Иванов", isAdded: true, posts: [Post(id: 0, ownerId: 0, image: UIImage(named: "profile1")!, likeState: .dislike, date: Date(), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ut tristique felis. Curabitur vehicula id est in efficitur. Morbi sed nunc vitae arcu varius lobortis nec consequat risus. Donec vitae vulputate turpis. Nulla velit nulla, sagittis eget suscipit nec, laoreet non leo. Etiam urna lacus, aliquet eget nibh non, dapibus efficitur lorem. Ut nulla orci, tempor sed interdum nec, venenatis ut est. Suspendisse potenti. Cras dolor ligula, blandit non dui lacinia, convallis porta orci. Morbi massa mi, mollis quis vestibulum et, posuere vitae turpis. Praesent finibus rutrum ornare.", likesCount: 2, commentsCount: 2, viewsCount: 10, repostsCount: 1), Post(id: 1, ownerId: 0, image: UIImage(named: "profile2")!, likeState: .like, date: Date(), text: "vel pretium lectus quam id leo in vitae turpis massa sed elementum tempus egestas sed sed risus pretium quam vulputate", likesCount: 2, commentsCount: 2, viewsCount: 10, repostsCount: 2), Post(id: 6, ownerId: 0, image: UIImage(named: "profile3")!, likeState: .like, date: Date(), text: "vel pretium lectus quam id leo in vitae turpis massa sed elementum tempus egestas sed sed risus pretium quam vulputate", likesCount: 2, commentsCount: 2, viewsCount: 10, repostsCount: 2)]),
                                   User(id: 1, image: UIImage(named: "profile2")!, name: "Мария Иванова", isAdded: true, posts: [Post(id: 2, ownerId: 1, image: UIImage(named: "profile2")!, likeState: .dislike, date: Date(), text: "dignissim cras tincidunt lobortis feugiat", likesCount: 399, commentsCount: 56, viewsCount: 672, repostsCount: 52)]),
                                   User(id: 2, image: UIImage(named: "profile3")!, name: "Николай Сидоров", isAdded: true, posts: [Post(id: 3, ownerId: 2, image: UIImage(named: "profile3")!, likeState: .dislike, date: Date(), text: "lacus laoreet non curabitur gravida arcu ac tortor dignissim convallis", likesCount: 0, commentsCount: 0, viewsCount: 1, repostsCount: 0)]),
                                   User(id: 3, image: UIImage(named: "profile4")!, name: "Леонид Харламов", isAdded: true, posts: [Post(id: 4, ownerId: 3, image: UIImage(named: "profile4")!, likeState: .dislike, date: Date(), text: "euismod lacinia at quis risus sed vulputate odio ut enim blandit volutpat", likesCount: 4, commentsCount: 3, viewsCount: 12, repostsCount: 0)]),
                                   User(id: 4, image: UIImage(named: "profile5")!, name: "Ксения Новикова", isAdded: true, posts: [Post(id: 5, ownerId: 4, image: UIImage(named: "profile5")!, likeState: .dislike, date: Date(), text: "est lorem ipsum dolor sit amet", likesCount: 6, commentsCount: 4, viewsCount: 20, repostsCount: 1)]),
                                   User(id: 5, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 6, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 7, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 8, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 9, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 10, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 11, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 12, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 13, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 14, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
                                   User(id: 15, image: UIImage(named: "default-profile")!, name: "Test Test", isAdded: true, posts: []),
    ]
}

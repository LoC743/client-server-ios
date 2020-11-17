//
//  Group.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 05.10.2020.
//

import UIKit

struct Group: CellModel {
    let id: Int
    
    var image: UIImage
    var name: String
    var isAdded: Bool
    
    static func changeGroupAdded(by id: Int) {
        for i in 0..<database.count {
            if database[i].id == id {
                database[i].isAdded = !database[i].isAdded
            }
        }
    }
    
    static var database: [Group] = [Group(id: 0, image: UIImage(named: "group1")!, name: "/dev/null", isAdded: true),
                                    Group(id: 1, image: UIImage(named: "group2")!, name: "Типичный программист", isAdded: false),
                                    Group(id: 2, image: UIImage(named: "group3")!, name: "Habr", isAdded: false),
                                    Group(id: 3, image: UIImage(named: "group4")!, name: "Nintendo Россия", isAdded: false)]
}

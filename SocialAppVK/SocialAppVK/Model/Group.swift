//
//  Group.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 05.10.2020.
//

import UIKit

class GroupList: Decodable {
    var amount: Int = 0
    var groups: [Group] = []
    
    enum ResponseCodingKeys: String, CodingKey {
        case response
    }
    
    enum ItemsCodingKeys: String, CodingKey {
        case count
        case items
    }
    
    enum GroupKeys: String, CodingKey {
        case id
        case isMember = "is_member"
        case name
        case photo_50
        case photo_100
        case photo_200
    }
    
    required init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: ResponseCodingKeys.self)
        let values = try response.nestedContainer(keyedBy: ItemsCodingKeys.self, forKey: .response)
        // Получение {..{ count: Int, items [..] }..}
        let count = try values.decode(Int.self, forKey: .count)
        self.amount = count
        
        var items = try values.nestedUnkeyedContainer(forKey: .items)
        
        let itemsCount: Int = items.count ?? 0
        for _ in 0..<itemsCount {
            let groupContainer = try items.nestedContainer(keyedBy: GroupKeys.self)
            let id = try groupContainer.decode(Int.self, forKey: .id)
            let name = try groupContainer.decode(String.self, forKey: .name)
            let isMemberInt = try groupContainer.decode(Int.self, forKey: .isMember)
            let isMemberBool = isMemberInt == 0 ? false : true
            let photo50 = try groupContainer.decode(String.self, forKey: .photo_50)
            let photo100 = try groupContainer.decode(String.self, forKey: .photo_100)
            let photo200 = try groupContainer.decode(String.self, forKey: .photo_200)
            
            let photo = Photo(photo_50: photo50, photo_100: photo100, photo_200: photo200)
            let group = Group(id: id, isMember: isMemberBool, name: name, photo: photo)
            
            self.groups.append(group)
        }
    }
}

struct Group {
    var id: Int
    var isMember: Bool
    var name: String
    var photo: Photo
}





//struct Group: CellModel {
//    let id: Int
//
//    var image: UIImage
//    var name: String
//    var isAdded: Bool
//
//    static func changeGroupAdded(by id: Int) {
//        for i in 0..<database.count {
//            if database[i].id == id {
//                database[i].isAdded = !database[i].isAdded
//            }
//        }
//    }
//
//    static var database: [Group] = [Group(id: 0, image: UIImage(named: "group1")!, name: "/dev/null", isAdded: true),
//                                    Group(id: 1, image: UIImage(named: "group2")!, name: "Типичный программист", isAdded: false),
//                                    Group(id: 2, image: UIImage(named: "group3")!, name: "Habr", isAdded: false),
//                                    Group(id: 3, image: UIImage(named: "group4")!, name: "Nintendo Россия", isAdded: false)]
//}

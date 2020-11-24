//
//  ProfileImages.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 24.11.2020.
//

import UIKit

// Описание типов: https://vk.com/dev/photo_sizes
enum VKImageSize: String {
    case m
    case o
    case p
    case q
    case r
    case s
    case x
    case y
    case z
}

struct Likes {
    var userLikes: Bool
    var count: Int
}

struct VKImage {
    var height: Int
    var width: Int
    var type: VKImageSize
    var url: String
}

protocol Images {
    var ownerID: Int { get set }
    var albumID: Int { get set }
    var id: Int { get set }
    
    var date: Int { get set }
    var image: [VKImage] { get set }
    var text: String { get set }
    var likes: Likes { get set }
    var reposts: Int { get set }
}

struct ProfileImage: Images {
    var ownerID: Int
    var albumID: Int
    var id: Int
    var postID: Int
    
    var date: Int
    var image: [VKImage]
    var text: String
    var likes: Likes
    var reposts: Int
}

struct GroupImage: Images {
    var ownerID: Int
    var albumID: Int
    var id: Int
    var userID: Int
    
    var date: Int
    var image: [VKImage]
    var text: String
    var likes: Likes
    var reposts: Int

}

class ImageList: Decodable {
    var amount: Int = 0
    var images: [Images] = []
    
    enum ResponseCodingKeys: String, CodingKey {
        case response
    }
    
    enum ItemsCodingKeys: String, CodingKey {
        case count
        case items
    }
    
    enum VKImageCodingKeys: String, CodingKey {
        case ownerID = "owner_id"
        case albumID = "album_id"
        case id
        case userID = "user_id"
        case postID = "post_id"
        case date
        case sizes
        case text
        case likes
        case reposts
    }
    
    enum ImageSizeCodingKey: String, CodingKey  {
        case height
        case width
        case url
        case type
    }
    
    enum LikesCodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
    
    enum RepostsCodingKeys: String, CodingKey {
        case count
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
            let imageContainer = try items.nestedContainer(keyedBy: VKImageCodingKeys.self)
            
            let ownerID = try imageContainer.decode(Int.self, forKey: .ownerID)
            let albumID = try imageContainer.decode(Int.self, forKey: .albumID)
            let id = try imageContainer.decode(Int.self, forKey: .id)
            
            let date = try imageContainer.decode(Int.self, forKey: .date)
            let text = try imageContainer.decode(String.self, forKey: .text)
            
            let likesContainer = try imageContainer.nestedContainer(keyedBy: LikesCodingKeys.self, forKey: .likes)
            let repostsContainer = try imageContainer.nestedContainer(keyedBy: RepostsCodingKeys.self, forKey: .reposts)
            
            let userLikesInt = try likesContainer.decode(Int.self, forKey: .userLikes)
            let userLikesBool = userLikesInt == 0 ? false : true
            let likesCount = try likesContainer.decode(Int.self, forKey: .count)
            
            let likes = Likes(userLikes: userLikesBool, count: likesCount)
            
            let repostsCount = try repostsContainer.decode(Int.self, forKey: .count)
            
            var imageSizeContainer = try imageContainer.nestedUnkeyedContainer(forKey: .sizes)
            var vkImagesArray = [VKImage]()
            let sizesCount: Int = imageSizeContainer.count ?? 0
            for _ in 0..<sizesCount {
                let sizeContainer = try imageSizeContainer.nestedContainer(keyedBy: ImageSizeCodingKey.self)
                let height = try sizeContainer.decode(Int.self, forKey: .height)
                let width = try sizeContainer.decode(Int.self, forKey: .width)
                let url = try sizeContainer.decode(String.self, forKey: .url)
                let typeString = try sizeContainer.decode(String.self, forKey: .type)
                
                let vkImage = VKImage(height: height, width: width, type: VKImageSize(rawValue: typeString) ?? .p, url: url)
                vkImagesArray.append(vkImage)
            }
            
            // Если > 0 то это пользователь, иначе группа
            if ownerID > 0 {
                let postID = try imageContainer.decode(Int.self, forKey: .postID)
                
                let userImage = ProfileImage(ownerID: ownerID, albumID: albumID, id: id, postID: postID, date: date, image: vkImagesArray, text: text, likes: likes, reposts: repostsCount)
                images.append(userImage)
            } else {
                let userID = try imageContainer.decode(Int.self, forKey: .userID)
                
                let groupImages = GroupImage(ownerID: ownerID, albumID: albumID, id: id, userID: userID, date: date, image: vkImagesArray, text: text, likes: likes, reposts: repostsCount)
                images.append(groupImages)
            }
        }
    }
}

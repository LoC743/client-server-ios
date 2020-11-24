//
//  ProfileImages.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 24.11.2020.
//

import UIKit

struct Likes {
    var userLikes: Bool
    var count: Int
}

struct VKImage {
    var height: Int
    var width: Int
    var url: String
}

struct Image {
    var ownerID: Int
    var albumID: Int
    var id: Int
    
    var date: Int
    var text: String
    var likes: Likes
    var reposts: Int
    
    var photo50: VKImage
    var photo100: VKImage
    var photo200: VKImage
}


class ImageList: Decodable {
    var amount: Int = 0
    var images: [Image] = []
    
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
            let sizesCount: Int = imageSizeContainer.count ?? 0
            
            var photo50: VKImage = VKImage(height: 0, width: 0, url: "")
            var photo100: VKImage = VKImage(height: 0, width: 0, url: "")
            var photo200: VKImage = VKImage(height: 0, width: 0, url: "")
            for _ in 0..<sizesCount {
                let sizeContainer = try imageSizeContainer.nestedContainer(keyedBy: ImageSizeCodingKey.self)
                let height = try sizeContainer.decode(Int.self, forKey: .height)
                let width = try sizeContainer.decode(Int.self, forKey: .width)
                let url = try sizeContainer.decode(String.self, forKey: .url)
                let typeString = try sizeContainer.decode(String.self, forKey: .type)
                
                switch typeString {
                case "s":
                    photo50 = VKImage(height: height, width: width, url: url)
                case "m":
                    photo100 = VKImage(height: height, width: width, url: url)
                case "x":
                    photo200 = VKImage(height: height, width: width, url: url)
                default:
                    break
                }
            }
            
            let userImage = Image(ownerID: ownerID, albumID: albumID, id: id, date: date, text: text, likes: likes, reposts: repostsCount, photo50: photo50, photo100: photo100, photo200: photo200)
            images.append(userImage)
        }
    }
}

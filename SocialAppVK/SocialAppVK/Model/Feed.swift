//
//  Feed.swift
//  SocialAppVK
//
//  Created by Alexey on 16.12.2020.
//

import RealmSwift

class News: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var text: String = ""
    @objc dynamic var date: Int = -1
    @objc dynamic var photoURL: String = ""
    @objc dynamic var commentCount: Int = -1
    @objc dynamic var likesCount: Int = -1
    @objc dynamic var isUserLikes: Bool = false
    @objc dynamic var repostsCount: Int = -1
    @objc dynamic var viewsCount: Int = -1
    @objc dynamic var owner: Int = -1
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, text: String, date: Int, photoURL: String, commentCount: Int, likesCount: Int, isUserLikes: Bool, repostsCount: Int, viewsCount: Int, owner: Int) {
        self.init()
        
        self.id = id
        self.text = text
        self.date = date
        self.photoURL = photoURL
        self.commentCount = commentCount
        self.likesCount = likesCount
        self.isUserLikes = isUserLikes
        self.repostsCount = repostsCount
        self.viewsCount = viewsCount
        self.owner = owner
    }
}

class Feed: Decodable {
    var newsArray: [News] = []
    
    enum ResponseCodingKeys: String, CodingKey {
        case response
    }
    
    enum ItemsCodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
    }
    
    enum NewsCodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case text
        case comments
        case likes
        case views
        case reposts
        case attachments
    }
    
    enum CommentsCodingKeys: String, CodingKey {
        case count
    }
    
    enum LikesCodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
    
    enum RepostsCodingKeys: String, CodingKey {
        case count
    }
    
    enum ViewsCodingKeys: String, CodingKey {
        case count
    }
    
    enum AttachmentsCodingKeys: String, CodingKey {
        case type
        case photo
    }
    
    enum PhotoCodingKeys: String, CodingKey {
        case sizes
        case ownerID = "owner_id"
    }
    
    enum SizesCodingKeys: String, CodingKey {
        case url
    }
    
    enum GroupCodingKeys: String, CodingKey {
        case id
        case isMember = "is_member"
        case name
        case photo_50
        case photo_100
        case photo_200
    }
    
    required init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: ResponseCodingKeys.self)
        let items = try response.nestedContainer(keyedBy: ItemsCodingKeys.self, forKey: .response)
        
        var news = try items.nestedUnkeyedContainer(forKey: .items)
//        let groups = try items.
        
        let newsCount = news.count ?? 0
        for _ in 0..<newsCount {
            let newsContainer = try news.nestedContainer(keyedBy: NewsCodingKeys.self)
            
            let sourceID = try newsContainer.decode(Int.self, forKey: .sourceID)
            let text = try newsContainer.decode(String.self, forKey: .text)
            let date = try newsContainer.decode(Int.self, forKey: .date)
            
            let commentsContainer = try newsContainer.nestedContainer(keyedBy: CommentsCodingKeys.self, forKey: .comments)
            let commentsCount = try commentsContainer.decode(Int.self, forKey: .count)
            
            let likesContainer = try newsContainer.nestedContainer(keyedBy: LikesCodingKeys.self, forKey: .likes)
            let likesCount = try likesContainer.decode(Int.self, forKey: .count)
            let isUserLikesInt = try likesContainer.decode(Int.self, forKey: .userLikes)
            let isUserLikesBool = isUserLikesInt == 0 ? false : true
            
            let repostsContainer = try newsContainer.nestedContainer(keyedBy: RepostsCodingKeys.self, forKey: .reposts)
            let repostsCount = try repostsContainer.decode(Int.self, forKey: .count)
            
            let viewsContainer = try newsContainer.nestedContainer(keyedBy: ViewsCodingKeys.self, forKey: .views)
            let viewsCount = try viewsContainer.decode(Int.self, forKey: .count)
            
            var attachments = try newsContainer.nestedUnkeyedContainer(forKey: .attachments)
            
            let attachmentsCount = attachments.count ?? 0
            for _ in 0..<attachmentsCount {
                let attachmentsContainer = try attachments.nestedContainer(keyedBy: AttachmentsCodingKeys.self)
                
                let type = try attachmentsContainer.decode(String.self, forKey: .type)
                
                if type != "photo" {
                    let news = News(id: sourceID, text: text, date: date, photoURL: "", commentCount: commentsCount, likesCount: likesCount, isUserLikes: isUserLikesBool, repostsCount: repostsCount, viewsCount: viewsCount, owner: 0)
                    
                    newsArray.append(news)
                    break
                }
                
                
                let photoContainer = try attachmentsContainer.nestedContainer(keyedBy: PhotoCodingKeys.self, forKey: .photo)
                
                let ownerID = try photoContainer.decode(Int.self, forKey: .ownerID)
                
                var sizes = try photoContainer.nestedUnkeyedContainer(forKey: .sizes)
                let sizesCount = sizes.count ?? 0
                for z in 0..<sizesCount {
                    let sizeContainer = try sizes.nestedContainer(keyedBy: SizesCodingKeys.self)
                    let url = try sizeContainer.decode(String.self, forKey: .url)
                    
                    if z == sizesCount-1 {                        
                        let news = News(id: sourceID, text: text, date: date, photoURL: url, commentCount: commentsCount, likesCount: likesCount, isUserLikes: isUserLikesBool, repostsCount: repostsCount, viewsCount: viewsCount, owner: ownerID)
                        
                        newsArray.append(news)

                    }
                }
            }
            
           

        }
    }
}


//
//  CommentItem.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 06. 24..
//

import Foundation

struct Comment: Codable, Hashable {
    
    let commentId: String
    let text: String
    let creatorId: Int
    let creationDate: String
    var creatorName: String?
    
    enum CodingKeys: String, CodingKey {
        case commentId = "commentId"
        case text = "text"
        case creatorId = "creatorId"
        case creationDate = "creatorDate"
        case creatorName = "creatorName"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commentId = try container.decode(String.self, forKey: .commentId)
        self.text = try container.decode(String.self, forKey: .text)
        self.creatorId = try container.decode(Int.self, forKey: .creatorId)
        self.creationDate = try container.decode(String.self, forKey: .creationDate)
        self.creatorName = try container.decodeIfPresent(String.self, forKey: .creatorName)
    }
   
    //for the dummy API call
    init(commentId: String, text: String, creatorId: Int, creationDate: String) {
        self.commentId = commentId
        self.text = text
        self.creatorId = creatorId
        self.creationDate = creationDate
        self.creatorName = nil
    }
    
    
    init(commentId: String, text: String, creatorId: Int, creationDate: String, creatorName: String) {
        self.commentId = commentId
        self.text = text
        self.creatorId = creatorId
        self.creationDate = creationDate
        self.creatorName = creatorName
    }
}

struct CommentItem: Codable {
    
    let taskId: String
    let comments: [Comment]
    
}


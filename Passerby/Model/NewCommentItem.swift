//
//  NewCommentItem.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 07. 09..
//

import Foundation

struct NewCommentItem: Codable {
    
    let taskId: String
    let creatorId: Int
    let text: String
}


//
//  NewTask.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 05. 07..
//

import Foundation

struct NewTask: Codable {
    
    let taskName: String
    let taskPrio: Int
    let taskWeight: Int
    let creationDate: String
    let modifiedDate: String
    let creatorId: String
    let assignedId: String
    let description: String
    
}

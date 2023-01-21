//
//  User.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 21..
//

import Foundation

struct User: Codable {
    
    let userId: String
    let loginName: String
    let fullName: String
    let userTaskID: [String]
}

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
    let teamName: String
    let teamId: String
    let userTaskID: [String]
    let permissions: [String]
    
    init(userId: String, loginName: String, fullName: String, teamname: String, teamId: String, userTaskID: [String], permissions: [String]) {
        self.userId = userId
        self.loginName = loginName
        self.fullName = fullName
        self.teamName = teamname
        self.teamId = teamId
        self.userTaskID = userTaskID
        self.permissions = permissions
    }
}

//
//  Team.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 04. 15..
//

import Foundation

struct Team: Codable {
    let id: String
    let teamUser: [TeamUser]
    
    init(id: String, teamUser:  [TeamUser]) {
        self.id = id
        self.teamUser = teamUser
    }
}


struct TeamUser: Codable {
    let userId: String
    let userName: String
    
    init(userId: String, userName: String ) {
        self.userId = userId
        self.userName = userName
    }
}

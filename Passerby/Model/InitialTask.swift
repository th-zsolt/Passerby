//
//  CreationTask.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 04. 10..
//

import Foundation

struct InitialTask: Decodable {
    let creationDate: String
    let modifiedDate: String
    let creatorId: String
    let creatorName: String
}

extension InitialTask {
    init(user: User) {
        self.creationDate = Date().convertToDayMonthYearFormat()
        self.modifiedDate = Date().convertToDayMonthYearFormat()
        self.creatorId = user.userId
        self.creatorName = user.fullName
    }
}

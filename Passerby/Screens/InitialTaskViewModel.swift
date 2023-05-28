//
//  InitialTaskViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 05. 28..
//

import Foundation

struct InitialTaskViewModel {
    let creationDate: String
    let modifiedDate: String
    let creator: String
}

extension InitialTaskViewModel {
    init(user: User) {
        self.creationDate = Date().convertToDayMonthYearFormat()
        self.modifiedDate = Date().convertToDayMonthYearFormat()
        self.creator = user.fullName
    }
}

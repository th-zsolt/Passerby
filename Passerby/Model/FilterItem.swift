//
//  FilterItem.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 06. 14..
//

import Foundation

struct FilterItem: Codable {
    
    let taskId: String
    let taskName: String
    let description: String
    let taskPrio: Int
    let taskWeight: Int
    let creator: String
    let state: Int

    init() {
        taskId = ""
        taskName = ""
        description = ""
        taskPrio = -1
        taskWeight = -1
        creator = ""
        state = -1
    }
    
    init(taskId: String, taskName: String, description: String, taskPrio: Int, taskWeight: Int, creator: String, state: Int) {
        self.taskId = taskId
        self.taskName = taskName
        self.description = description
        self.taskPrio = taskPrio
        self.taskWeight = taskWeight
        self.creator = creator
        self.state = state
    }

}

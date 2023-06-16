//
//  TaskItem.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 08..
//

import Foundation

struct TaskItem: Codable {
    

    let taskId: String
    let taskName: String
    let taskPrio: Int
    let taskWeight: Int
    let creationDate: String
    let modifiedDate: String
    let creator: String
    let creatorId: String
    let assigned: String
    let assignedId: String
    let description: String
    let state: Int
    

//    init() {
//        self.taskId = ""
//        self.taskName = ""
//        self.taskPrio = 0
//    }
    
}

struct TaskItemResult: Codable {
    let taskItems: [TaskItem]
    
    init() {
        taskItems = []
    }
}

//struct TaskPrio {
//        var taskPrio = [1: "Low",
//                        2: "Medium",
//                        3: "High"]
//}
//
//struct TaskWeight {
//        var taskWeight = [1: "Low",
//                        2: "Medium",
//                        3: "High"]
//}

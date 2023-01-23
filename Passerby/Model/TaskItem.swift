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


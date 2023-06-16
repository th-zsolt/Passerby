//
//  TaskState.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 04. 23..
//

import Foundation

struct TaskState: Codable {
    var state: [Int: String] = [
        1: "Closed",
        2: "Pending",
        3: "Open",
        4: "In Progress"
    ]
}

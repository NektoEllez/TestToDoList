//
//  Task.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//

import Foundation

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool
}

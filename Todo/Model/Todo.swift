//
//  Todo.swift
//  Todo
//
//  Created by Reza Mohseni on 6/12/19.
//  Copyright © 2019 rezamohseni. All rights reserved.
//

import Foundation

class Todo: Codable {
    var title: String
    var isDone: Bool
    
    init(title: String) {
        self.title = title
        self.isDone = false
    }
}

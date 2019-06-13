//
//  Todo.swift
//  Todo
//
//  Created by Reza Mohseni on 6/13/19.
//  Copyright © 2019 rezamohseni. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    let category = LinkingObjects(fromType: Category.self, property: "todos")
}

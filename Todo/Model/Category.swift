//
//  Category.swift
//  Todo
//
//  Created by Reza Mohseni on 6/13/19.
//  Copyright © 2019 rezamohseni. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    let todos = List<Todo>()
}

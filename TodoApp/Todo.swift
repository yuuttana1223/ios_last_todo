//
//  Todo.swift
//  TodoApp
//
//  Created by Yuu Tanaka on 2021/07/21.
//

import RealmSwift

class Todo: Object {
    @objc dynamic var id = 0
    
    @objc dynamic var task = ""
    
    @objc dynamic var isDone = false
    
    @objc dynamic var deadline = Date()

    override static func primaryKey() -> String? {
        return "id"
    }

}

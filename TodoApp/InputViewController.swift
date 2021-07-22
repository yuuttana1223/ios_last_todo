//
//  InputViewController.swift
//  TodoApp
//
//  Created by Yuu Tanaka on 2021/07/21.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    
    let realm = try! Realm()
    var todo = Todo()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setDate(Date(), animated: true)
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func addTask(_ sender: Any) {
        let input = textField.text!.trimmingCharacters(in: .whitespaces)
        if (!input.isEmpty) {
            try! realm.write {
                todo.task = input
                todo.deadline = datePicker.date
                let todos = realm.objects(Todo.self)
                // インクリメント
                if todos.count != 0 {
                    todo.id = todos.max(ofProperty: "id")! + 1
                }
                realm.add(todo)
            }
            dismiss(animated: true, completion: nil)
        }
    }
}

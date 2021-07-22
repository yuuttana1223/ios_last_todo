//
//  IncompleteViewController.swift
//  TodoApp
//
//  Created by Yuu Tanaka on 2021/07/21.
//

import UIKit
import RealmSwift

class IncompleteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var todos = try! Realm().objects(Todo.self).filter("isDone == false").sorted(byKeyPath: "deadline", ascending: true)
    var nowTodos = try! Realm().objects(Todo.self).filter("isDone == false").sorted(byKeyPath: "deadline", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func editTask(_ sender: Any) {
        tableView.isEditing.toggle()
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
}

// 共通化できてない。
extension IncompleteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.task
        
        cell.accessoryType = todo.isDone ? .checkmark : .none
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let dateStr: String = dateFormatter.string(from: todo.deadline)
        
        cell.detailTextLabel?.text = "期限: \(dateStr)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        try! realm.write {
            todo.isDone.toggle()
            realm.add(todo)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(todos[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

}

extension IncompleteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            todos = nowTodos
        } else {
            todos = todos.filter("task CONTAINS %@", searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

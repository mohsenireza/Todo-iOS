//
//  TodoListViewController.swift
//  Todo
//
//  Created by Reza Mohseni on 6/12/19.
//  Copyright © 2019 rezamohseni. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var defaults = UserDefaults.standard
    var todos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todosFromUserDefaults = defaults.array(forKey: "todos") as? [String] {
            self.todos = todosFromUserDefaults
        }
    }

    // TableView delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "todoCell")
        cell.textLabel?.text = todos[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Add todo
    @IBAction func addTodo(_ sender: Any) {
        var todoTextField = UITextField()
        let alert = UIAlertController(title: "Add todo", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your todo"
            todoTextField = textField
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.todos.append(todoTextField.text!)
            self.defaults.set(self.todos, forKey: "todos")
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}


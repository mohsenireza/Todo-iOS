//
//  TodoListViewController.swift
//  Todo
//
//  Created by Reza Mohseni on 6/12/19.
//  Copyright © 2019 rezamohseni. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todos: Results<Todo>?
    var selectedCategory: Category? {
        didSet {
            navigationItem.title = self.selectedCategory?.title
            getTodos()
        }
    }
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = todos?[indexPath.row].title
        cell.accessoryType = todos?[indexPath.row].isDone ?? false ? .checkmark : .none
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = todos?[indexPath.row]
        if let selectedTodo = selectedTodo {
            do {
                try realm.write {
                    selectedTodo.isDone = !selectedTodo.isDone
                }
            }
            catch {
                print("error while updating todo data: \(error)")
            }
        }
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data manipulation methods
    
    func saveTodo(_ todo: Todo) {
        do {
            try realm.write {
                realm.add(todo)
            }
        }
        catch {
            print("Saving data error: \(error)")
        }
    }
    
    func getTodos(){
        todos = realm.objects(Todo.self)
        tableView.reloadData()
    }
    
    // MARK: - Add new todo
    
    @IBAction func addTodo(_ sender: Any) {
        var todoTextField = UITextField()
        let alert = UIAlertController(title: "Add todo", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your todo"
            todoTextField = textField
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let selectedCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let todo = Todo()
                        todo.title = todoTextField.text!
                        selectedCategory.todos.append(todo)
                    }
                }
                catch {
                    print("error while adding todo: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            getTodos()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else {
            todos = realm.objects(Todo.self).filter(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
            tableView.reloadData()
        }
    }
    
}

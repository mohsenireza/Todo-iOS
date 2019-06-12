//
//  TodoListViewController.swift
//  Todo
//
//  Created by Reza Mohseni on 6/12/19.
//  Copyright © 2019 rezamohseni. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var todos = [Todo]()
    let todosDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Todos.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readTodosFromJsonFile()
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
    }

    // TableView delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row].title
        cell.accessoryType = todos[indexPath.row].isDone ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = todos[indexPath.row]
        selectedTodo.isDone = !selectedTodo.isDone
        self.writeTodosToJsonFile()
        self.tableView.reloadData()
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
            self.todos.append(Todo(title: todoTextField.text!))
            self.writeTodosToJsonFile()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Read/write methods
    func writeTodosToJsonFile(){
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(self.todos)
            try? jsonData.write(to: self.todosDataFilePath!)
        }
        catch{
            print(error)
        }
    }
    
    func readTodosFromJsonFile(){
        let jsonDecoder = JSONDecoder()
        if let todosData = try? Data(contentsOf: todosDataFilePath!) {
            do {
                todos = try jsonDecoder.decode([Todo].self, from: todosData)
            }
            catch{
                print(error)
            }
        }
    }
    
}


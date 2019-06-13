//
//  TodoListViewController.swift
//  Todo
//
//  Created by Reza Mohseni on 6/12/19.
//  Copyright © 2019 rezamohseni. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todos = [Todo]()
    var selectedCategory: Category? {
        didSet {
            navigationItem.title = self.selectedCategory?.title
            getTodos()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row].title
        cell.accessoryType = todos[indexPath.row].isDone ? .checkmark : .none
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = todos[indexPath.row]
        selectedTodo.isDone = !selectedTodo.isDone
        self.saveContext()
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data manipulation methods
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                print("Saving context error: \(error)")
            }
        }
    }
    
    func getTodos(with request: NSFetchRequest<Todo> = Todo.fetchRequest(), filterPredicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "category.title MATCHES %@", selectedCategory!.title!)
        if filterPredicate == nil {
            request.predicate = categoryPredicate
        }
        else {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, filterPredicate!])
        }
        do {
            todos = try context.fetch(request)
        }
        catch {
            print("Fetching data error: \(error)")
        }
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
            let todo = Todo(context: self.context)
            todo.title = todoTextField.text
            todo.category = self.selectedCategory
            self.saveContext()
            self.todos.append(todo)
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
            let request: NSFetchRequest<Todo> = Todo.fetchRequest()
            let filterPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            //request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            getTodos(with: request, filterPredicate: filterPredicate)
        }
    }
    
}

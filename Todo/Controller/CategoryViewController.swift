//
//  CategoryViewController.swift
//  Todo
//
//  Created by Reza Mohseni on 6/13/19.
//  Copyright © 2019 rezamohseni. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        getCategories()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTodoPage" {
            let destinationViewController = segue.destination as! TodoListViewController
            if let selectedRow = tableView.indexPathForSelectedRow {
                destinationViewController.selectedCategory = categories[selectedRow.row]
            }
        }
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
    
    func getCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        }
        catch {
            print("Fetching data from context error: \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Add new category
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Category name"
            categoryTextField = textField
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let category = Category(context: self.context)
            category.title = categoryTextField.text
            self.saveContext()
            self.categories.append(category)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            getCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            let filterPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            request.predicate = filterPredicate
            getCategories(with: request)
        }
    }
    
}

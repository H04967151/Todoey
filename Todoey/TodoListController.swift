//
//  ViewController.swift
//  Todoey
//
//  Created by Neil on 27/01/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit

class TodoListController: UITableViewController {
    
    var itemArray = ["Feed dog", "Buy dog food", "Make dinner"]
    let cellID = "TodoItemCell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let newTodo = textField.text{
            self.itemArray.append(newTodo)
            self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    

}

extension TodoListController{
    
    //MARK - Tableview Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - Tableview Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

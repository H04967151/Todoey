//
//  ViewController.swift
//  Todoey
//
//  Created by Neil on 27/01/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import CoreData

class TodoListController: UITableViewController {
    
    let cellID = "TodoItemCell"
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //*********** CRUD METHODS for CORE DATA***********//
    
    //MARK - CREATE
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("err")        }
    }
    
    //MARK - READ
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do{
            itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    //MARK - UPDATE - This is called in the DidSelectRowAtIndexPah method -- saveData() is called when cell yapped and check mark added
    
    
    //MARK- DELETE
    func deleteItem(indexPath: Int){
        context.delete(itemArray[indexPath])
        itemArray.remove(at: indexPath)
    }
    
    //*********** CRUD METHODS for CORE DATA***********//
    
    //MARK - IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK - Tableview Datasource & Tableview Delegates
extension TodoListController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteItem(indexPath: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveItems()
        }
    }
    
    
}

//MARK - Searchbar Delegate
extension TodoListController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        if let searchTerm = searchBar.text{
            request.predicate = NSPredicate(format: "title CONTAINS %@", searchTerm)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request)
        }
        
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

//
//  ComputerInTheCartTVC.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 24.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import UIKit
import CoreData

class ComputerInTheCartTVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchResultsController: NSFetchedResultsController<ComputersCoreData>!
    var arrayComputersInCart: [ComputersCoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // create fetch request with descriptor
        let fetchRequest: NSFetchRequest<ComputersCoreData> = ComputersCoreData.fetchRequest()
        // sorted by "name"
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // getting context
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            // creating fetch result controller
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            // trying to retrieve data
            do {
                try fetchResultsController.performFetch()
                // save retrieved data into restaurants array
                arrayComputersInCart = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }

    // MARK: - Fetch results controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        arrayComputersInCart = controller.fetchedObjects as! [ComputersCoreData]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayComputersInCart.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ComputerInTheCartTVCell
        cell.computerId.text = String(arrayComputersInCart[indexPath.row].id)
        cell.computerName.text = arrayComputersInCart[indexPath.row].name

        

        return cell
    }


    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let addToCart = UITableViewRowAction(style: .default, title: "Удалить из корзины") { (action, indexPath) in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                do {
                    try context.save()
                    print("Удаление удалось!")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        addToCart.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return [addToCart]
    }

}

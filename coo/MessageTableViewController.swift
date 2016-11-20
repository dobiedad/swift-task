import UIKit
import CoreData

class MessageTableViewController: UITableViewController {
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let nameSort = NSSortDescriptor(key: "message", ascending: true)
        request.sortDescriptors = [nameSort]
        let moc = CoredataController.getContext()
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
  
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let selectedObject = fetchedResultsController.object(at: indexPath as IndexPath) as? Message else { fatalError("Unexpected Object in FetchedResultsController") }
          cell.textLabel?.text = selectedObject.message
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          guard let selectedObject = fetchedResultsController.object(at: indexPath as IndexPath) as? Message else { fatalError("Unexpected Object in FetchedResultsController") }
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        vc.setUserName(string: selectedObject.senderName!)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath! as IndexPath], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath! as IndexPath], with: .fade)
        case .update:
            print("")
            self.configureCell(cell: self.tableView.cellForRow(at: indexPath! as IndexPath)!, indexPath: indexPath!)
        case .move:
            self.tableView.deleteRows(at: [indexPath! as IndexPath], with: .fade)
            self.tableView.insertRows(at: [indexPath! as IndexPath], with: .fade)
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                return cell
    }

}

extension UITableViewController: NSFetchedResultsControllerDelegate {
    
}


//
//  ViewController.swift
//  Swift3_NSFetchedResultsController
//
//  Created by Franks, Kent Eric on 4/3/17.
//  Copyright © 2017 KefBytes. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    private let addAccountSegue = "AddAccountSegue"
    
    private let persistentContainer = NSPersistentContainer(name: "Accounts")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Account> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "accountName", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self.setupView()
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
            }
        }
        
    }
    
    // MARK: - Setup UI
    
    fileprivate func updateView() {
        var hasAccounts = false
        
        if let accounts = fetchedResultsController.fetchedObjects {
            hasAccounts = accounts.count > 0
        }
        
        tableView.isHidden = !hasAccounts
        messageLabel.isHidden = hasAccounts
        
        activityIndicatorView.stopAnimating()
    }
    
    private func setupView() {
        setupMessageLabel()
        updateView()
    }
    
    private func setupMessageLabel() {
        messageLabel.text = "You don't have any quotes yet."
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addAccountSegue {
            if let destinationViewController = segue.destination as? AddAccountVC {
                destinationViewController.managedObjectContext = persistentContainer.viewContext
                destinationViewController.persistentContainer = persistentContainer
            }
        }
    }


}

// MARK: - ViewController Extension

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let accounts = fetchedResultsController.fetchedObjects else { return 0 }
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.reuseIdentifier, for: indexPath) as? AccountTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Quote
        let account = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.accountNameLabel.text = account.accountName
        cell.accountUsernameLabel.text = account.accountUsername
        cell.accountPasswordLabel.text = account.accountPassword
        cell.accountDescriptionLabel.text = account.accountDescription

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Account
            let account = fetchedResultsController.object(at: indexPath)
            
            // Delete Quote
            account.managedObjectContext?.delete(account)
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }

}
















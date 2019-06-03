//
//  AddAccountVC.swift
//  Swift3_NSFetchedResultsController
//
//  Created by Franks, Kent Eric on 4/3/17.
//  Copyright © 2017 KefBytes. All rights reserved.
//

import UIKit
import CoreData

class AddAccountVC: UIViewController {
    
    @IBOutlet var accountNameTextField: UITextField!
    @IBOutlet var accountUsernameTextField: UITextField!
    @IBOutlet var accountUPasswordTextField: UITextField!
    @IBOutlet var accountDescriptionTextField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext?
    var persistentContainer: NSPersistentContainer?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Account"
    }
    
    @IBAction func saveAccount(_ sender: Any) {
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        // Create Quote
        let account = Account(context: managedObjectContext)
        
        // Configure Quote
        account.accountName = accountNameTextField.text
        account.accountUsername = accountUsernameTextField.text
        account.accountPassword = accountUPasswordTextField.text
        account.accountDescription = accountDescriptionTextField.text
        
        do {
            try persistentContainer?.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }

        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }


}

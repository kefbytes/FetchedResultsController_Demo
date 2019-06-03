//
//  AccountTableViewCell.swift
//  Swift3_NSFetchedResultsController
//
//  Created by Franks, Kent Eric on 4/3/17.
//  Copyright © 2017 KefBytes. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "AccountCell"
    
    // MARK: -
    @IBOutlet var accountNameLabel: UILabel!
    @IBOutlet var accountUsernameLabel: UILabel!
    @IBOutlet var accountPasswordLabel: UILabel!
    @IBOutlet var accountDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

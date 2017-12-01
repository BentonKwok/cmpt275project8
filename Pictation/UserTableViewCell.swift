//
//  UserTableViewCell.swift
//  Pictation
//
//  Created by Jameson Roy on 2017-11-17.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "UserCell"

class UserTableViewCell: UITableViewCell {
    
    func setLabel(name: String){
        textLabel?.text = name
    }
}

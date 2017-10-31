//
//  myCell.swift
//  Pictation
//
//  Created by Benton on 2017-10-30.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class myCell: UICollectionViewCell {
    
    var buttonHandler: ((UIButton) -> Void)?

    @IBAction func cellButtonHandler(_ sender: UIButton) {
        buttonHandler?(sender)
    }
    @IBOutlet weak var buttonCell: UIButton!
}

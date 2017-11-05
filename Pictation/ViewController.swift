//
//  ViewController.swift
//  Pictation
//
//  Created by Benton on 2017-10-25.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func GuestButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "toLevelViewSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//  SettingsViewController.swift
//  Pictation
//
//  Created by Jameson Roy on 11/13/17.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController  {
    //MARK: Properties
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var levelSelect: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.backgroundColor = UIColor.red
        
        //Add Done button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        // Do any additional setup after loading the view.
    }

    //Settings button handler
    @objc func doneTapped(){
        if( levelSelect.selectedSegmentIndex == 0){
            performSegue(withIdentifier: "beginnerFromSettings", sender: self)
        }
        else if(levelSelect.selectedSegmentIndex == 1){
            performSegue(withIdentifier: "intermediateFromSettings", sender: self)
        }
        else{
            performSegue(withIdentifier: "intermediateFromSettings", sender: self)
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        performSegue(withIdentifier: "toUsers", sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

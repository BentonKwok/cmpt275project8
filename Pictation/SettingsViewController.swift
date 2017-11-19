//
//  SettingsViewController.swift
//  Pictation
//
//  Created by Jameson Roy on 11/13/17.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit
import CoreData

// Allows for backgroundColor to be a global variable
class Settings {
    static let sharedValues = Settings()
    var BGColor = UIColor(colorWithHexValue: 0xD6EAF8)
}

class SettingsViewController: UITableViewController, UITextFieldDelegate  {
    //MARK: Properties
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelSelect: UISegmentedControl!
    
    //MARK: User Settings Properties
    let BEGINNER_LEVEL: Int = 0
    let INTERMEDIATE_LEVEL: Int = 1
    let ADVANCED_LEVEL: Int = 2
    var UserInfo : NSManagedObject?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        logoutButton.backgroundColor = UIColor.red
        
        if(CURRENT_USER != "none"){
            nameTextField.text = CURRENT_USER
            if(CURRENT_USER == "Guest"){
                nameTextField.isUserInteractionEnabled = false
            }
        }
        //Add Done button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
        //Retrieve the user settings
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if((data.value(forKey: "name") as! String) == CURRENT_USER){
                    UserInfo = data
                    break
                }
            }
            if( UserInfo == nil){
                let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                UserInfo = NSManagedObject(entity: entity!, insertInto: context)
                UserInfo?.setValue(CURRENT_USER, forKey: "name")
                UserInfo?.setValue(BEGINNER_LEVEL, forKey: "commlevel")
            }
            
        } catch {
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
            UserInfo = NSManagedObject(entity: entity!, insertInto: context)
            UserInfo?.setValue(CURRENT_USER, forKey: "name")
            UserInfo?.setValue(BEGINNER_LEVEL, forKey: "commlevel")
        }
        
        //set up the containers in the table
        nameTextField.text = (UserInfo?.value(forKey: "name") as! String)
        levelSelect.selectedSegmentIndex = UserInfo?.value(forKey: "commlevel") as! Int
    }

    //dismiss keyboard when enter is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Done button handler
    @objc func doneTapped(){
       //save changed settings
        saveData()
        
        if( levelSelect.selectedSegmentIndex == BEGINNER_LEVEL){
            performSegue(withIdentifier: "beginnerFromSettings", sender: self)
        }
        else if(levelSelect.selectedSegmentIndex == INTERMEDIATE_LEVEL){
            performSegue(withIdentifier: "intermediateFromSettings", sender: self)
        }
        else{
            performSegue(withIdentifier: "intermediateFromSettings", sender: self)
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        saveData()
        performSegue(withIdentifier: "toUserFromSettings", sender: self)
    }
    
    func saveData(){
        //save changed settings
        UserInfo?.setValue(levelSelect.selectedSegmentIndex, forKey: "commlevel")
        CURRENT_USER = nameTextField.text!
        UserInfo?.setValue(nameTextField.text, forKey: "name")
        do {
            let context = appDelegate.persistentContainer.viewContext
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SettingsViewController.swift
//  Pictation
//
//  Created by Jameson Roy on 11/13/17.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit
import CoreData

// Setting global variables for Custom User values
class Settings {
    static let sharedValues = Settings()
    var viewBackgroundColor = UIColor(colorWithHexValue: 0xD6EAF8)
    var sentencePanelFont = UIFont(name: "Helvetica-Bold", size: 30)
}

class SettingsViewController: UITableViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate  {
    //MARK: Properties
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelSelect: UISegmentedControl!
    @IBOutlet weak var BGColourButton: UIButton!
    //    @IBOutlet weak var fontStyle: UIButton!
    
    //MARK: User Settings Properties
    let BEGINNER_LEVEL: Int = 0
    let INTERMEDIATE_LEVEL: Int = 1
    let ADVANCED_LEVEL: Int = 2
    var UserInfo : NSManagedObject?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // color counter
    var colorClick = 0
    let color = [UIColor.white, UIColor.black, UIColor(colorWithHexValue: 0xD6EAF8), UIColor.blue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets background color of SettingsViewController
        self.view.backgroundColor = Settings.sharedValues.viewBackgroundColor
        BGColourButton.backgroundColor = Settings.sharedValues.viewBackgroundColor
        for i in 0...color.endIndex{
            colorClick = i
            if(color[i].toHexString() == Settings.sharedValues.viewBackgroundColor.toHexString()){
                break
            }
        }
        //**Add button borders here
        
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
        Settings.sharedValues.viewBackgroundColor = UIColor(hexString : UserInfo?.value(forKey: "bg_colour") as! String)
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
        UserInfo?.setValue(Settings.sharedValues.viewBackgroundColor.toHexString(), forKey: "bg_colour")
        UserInfo?.setValue(nameTextField.text, forKey: "name")
        do {
            let context = appDelegate.persistentContainer.viewContext
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    @IBAction func backgroundColorChange(_ sender: UIButton) {
       /* let color = [UIColor.white, UIColor.black, UIColor(colorWithHexValue: 0xD6EAF8), UIColor.blue]
        for i in 0...color.endIndex-1{
            colorClick = i
            if(color[i].toHexString() == Settings.sharedValues.viewBackgroundColor.toHexString()){
                break
            }
        }*/
        
        Settings.sharedValues.viewBackgroundColor = color[colorClick]
        colorClick += 1
        if (colorClick >= 4){
            return colorClick = 0
        }
        //Settings.sharedValues.viewBackgroundColor = color[colorClick]
        UserInfo?.setValue(color[colorClick].toHexString(), forKey: "bg_colour")
        // Setting all background color values to the new viewBackgroundColor value
        self.view.backgroundColor = Settings.sharedValues.viewBackgroundColor
        BGColourButton.backgroundColor = Settings.sharedValues.viewBackgroundColor
    }
    // Trying to make the font style show up as a popover. No success
//    @IBAction func FontStyleButton(_ sender: UIButton) {
//        let tableViewController = UITableViewController()
//        tableViewController.modalPresentationStyle = UIModalTransitionStyle.popover
//        tableViewController.preferredContentSize = CGSize(width: 400, height: 400)
//
//        present(tableViewController, animated: true, completion: nil)
//
//        let popoverPresentationController =
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

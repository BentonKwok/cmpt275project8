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
    //var systemFont = UIFont(name: "Helvetica-Bold", size: 30)
}

class SettingsViewController: UITableViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, ColorPickerDelegate  {
    //MARK: Properties
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelSelect: UISegmentedControl!
    @IBOutlet weak var fontSizeSelect: UISegmentedControl!
    @IBOutlet weak var passwordSwitch: UISwitch!
    @IBOutlet var changeColorButton: UIButton!
    @IBAction func changeColorButtonClicked(_ sender: UIButton) {
        self.showColorPicker(viewFromSource: sender)
    }
    @IBOutlet weak var fontStyleSelect: UIButton!
    @IBAction func fontStyleChanged(_ sender: UIButton) {
        fontStyleClick += 1
        if(fontStyleClick >= 7){
            fontStyleClick = 0
        }
        fontStyleSelect.titleLabel?.font = UIFont(name: fontStyleList[fontStyleClick], size: 20)
        //Settings.sharedValues.systemFont = UIFont(name: fontStyleList[fontStyleClick], size: 20)
        //        //Setting all background color values to the new viewBackgroundColor value
        //        self.view.backgroundColor = Settings.sharedValues.viewBackgroundColor
        //        //BGColourButton.backgroundColor = Settings.sharedValues.viewBackgroundColor
    }

    
    
    //MARK: User Settings Properties
    let BEGINNER_LEVEL: Int = 0
    let INTERMEDIATE_LEVEL: Int = 1
    let ADVANCED_LEVEL: Int = 2
    var UserInfo : NSManagedObject?
    var newUser : Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // class varible maintain selected color value
    var selectedColor: UIColor = UIColor.blue
    var selectedColorHex: String = "0000FF"
    
    //MARK: Font Styles
    var fontStyleList = ["StarJedi", "Helvetica", "Zapfino", "Menlo", "Didot", "Avenir", "Snell"]
    var fontStyleClick = 0
    
    //MARK: Popover delegate functions
    //Overrides iPhone behaviour where it would present popovers as full screen options instead
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // show popover box for iPhone and iPad both
        return UIModalPresentationStyle.none
    }
    
    //MARK: Color picker delegate functions
    //Called by color picker after color selected
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String) {
        
        // update color value within class variable
        self.selectedColor = selectedUIColor
        self.selectedColorHex = selectedHexColor
        
        // set preview background to selected color
        Settings.sharedValues.viewBackgroundColor = selectedUIColor
        UserInfo?.setValue(Settings.sharedValues.viewBackgroundColor.toHexString(), forKey: "bg_colour")
        changeColorButton.backgroundColor = selectedUIColor
        self.view.backgroundColor = Settings.sharedValues.viewBackgroundColor
    }
    
    //MARK: Utility Functions
    //Setting up color picker from UIButton and presenting it as a popover
    private func showColorPicker(viewFromSource: UIButton){
        // initialise color picker view controller
        let colorPickerVc = storyboard?.instantiateViewController(withIdentifier: "sbColorPicker") as! ColorPickerViewController
        
        // set modal presentation style
        colorPickerVc.modalPresentationStyle = .popover
        
        // set max. size
        colorPickerVc.preferredContentSize = CGSize(width: 265, height: 400)
        
        // set color picker deleagate to current view controller
        // must write delegate method to handle selected color
        colorPickerVc.colorPickerDelegate = self
        
        // show popover
        if let popoverController = colorPickerVc.popoverPresentationController {
            // set source view
            popoverController.sourceView = viewFromSource
            
            // show popover from button
            popoverController.sourceRect = viewFromSource.bounds
            
            // show popover arrow at feasible direction
            popoverController.permittedArrowDirections = .up
            
            // set popover delegate self
            popoverController.delegate = self
        }
        //show color popover
        present(colorPickerVc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up background colour and BGColourButton
        self.view.backgroundColor = Settings.sharedValues.viewBackgroundColor
        changeColorButton.layer.cornerRadius = 1
        
        self.nameTextField.delegate = self
        logoutButton.backgroundColor = UIColor.red
        if(CURRENT_USER != "none"){
            nameTextField.text = CURRENT_USER
            if(CURRENT_USER == "Guest"){
                nameTextField.isUserInteractionEnabled = false
                passwordSwitch.isUserInteractionEnabled = false
                passwordTextField.isUserInteractionEnabled = false
                passwordTextField.placeholder = "No Password for Guest"
            }
        }
        //Add Done button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(doneTapped))
        
        //Displaying current system font
        //fontStyleSelect.setTitle("Font Style", for: .normal)
        //fontStyleSelect.titleLabel?.font = UIFont(name: "StarJedi", size: 20)
        
        //Retrieve the user settings
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if(data.value(forKey: "name") != nil)
                {
                    if((data.value(forKey: "name") as! String) == CURRENT_USER){
                        UserInfo = data
                        break
                    }
                }
            }
            if( UserInfo == nil){
                UserInfo = initUserInfo()
                newUser = true
            }
            
        } catch {
            UserInfo = initUserInfo()
            newUser = true
        }
        
        //set up the containers in the table to match stored user settings
        fontSizeSelect.selectedSegmentIndex = UserInfo?.value(forKey: "fontsize") as! Int
        nameTextField.text = (UserInfo?.value(forKey: "name") as! String)
        passwordTextField.text = (UserInfo?.value(forKey: "password") as! String)
        passwordTextField.isSecureTextEntry = true
        passwordSwitch.setOn((UserInfo?.value(forKey: "passwordEnable") as! Bool), animated: false)
        levelSelect.selectedSegmentIndex = UserInfo?.value(forKey: "commlevel") as! Int
        Settings.sharedValues.viewBackgroundColor = UIColor(hexString : UserInfo?.value(forKey: "bg_colour") as! String)
        changeColorButton.backgroundColor = Settings.sharedValues.viewBackgroundColor
        fontStyleSelect.titleLabel?.font = UIFont(name: UserInfo?.value(forKey: "fontstyle") as! String, size: 20)
     //   fontStyleClick = fontStyleList.index(of: (UserInfo?.value(forKey: "fontstyle") as! String))!
        
        for _ in fontStyleList{
            if((UserInfo?.value(forKey: "fontstyle") as! String) == fontStyleList[fontStyleClick]){
                break
            }
            fontStyleClick += 1
        }
        
        //diable user interaction on textfield if password is disabled
        passwordTextField.isUserInteractionEnabled = passwordSwitch.isOn
    }
    
    //handles the switch tap
    @IBAction func passwordSwtichTapped(_ sender: UISwitch) {
        UserInfo?.setValue(passwordSwitch.isOn, forKey: "passwordEnable")
        passwordTextField.isUserInteractionEnabled = passwordSwitch.isOn
        
        if(((UserInfo?.value(forKey: "securityQuestion") as! String) == "") || ((UserInfo?.value(forKey: "securityQuestion") as! String) == "")){
            //create a popup to prompt the user to enter a security question and answer
            LoginAlert.userSecurityQuestionAlert(viewController: self, user: UserInfo!, passwordSwitch: passwordSwitch, passwordTextField: passwordTextField)
        }
    }
    
    @IBAction func securityQuestionButtonTapped(_ sender: UIButton) {
        LoginAlert.userSecurityQuestionAlert(viewController: self, user: UserInfo!, passwordSwitch: nil, passwordTextField: passwordTextField)
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
            performSegue(withIdentifier: "advancedFromSettings", sender: self)
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
        UserInfo?.setValue(fontSizeSelect.selectedSegmentIndex, forKey: "fontsize")
        UserInfo?.setValue(passwordTextField.text, forKey: "password")
        UserInfo?.setValue(passwordSwitch.isOn, forKey: "passwordEnable")
        UserInfo?.setValue(fontStyleList[fontStyleClick], forKey: "fontstyle")
        Settings.sharedValues.sentencePanelFont = UIFont(name: (UserInfo?.value(forKey: "fontstyle") as! String), size: (CGFloat((10*fontSizeSelect.selectedSegmentIndex)+20)))
        
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
    func initUserInfo( ) -> NSManagedObject{
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        UserInfo = NSManagedObject(entity: entity!, insertInto: context)
        UserInfo?.setValue(CURRENT_USER, forKey: "name")
        UserInfo?.setValue(BEGINNER_LEVEL, forKey: "commlevel")
        UserInfo?.setValue(false, forKey: "passwordEnable")
        UserInfo?.setValue("", forKey: "securityQuestion")
        UserInfo?.setValue("", forKey: "securityAnswer")
        UserInfo?.setValue("", forKey: "password")
        UserInfo?.setValue(Settings.sharedValues.viewBackgroundColor.toHexString(), forKey: "bg_colour")
        UserInfo?.setValue(1, forKey: "fontsize")
        UserInfo?.setValue("", forKey: "userPictures")
        UserInfo?.setValue("Helvetica-Bold", forKey: "fontstyle")
        
        return UserInfo!
    }

}

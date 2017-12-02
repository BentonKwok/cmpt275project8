//
//  UsersViewController.swift
//  Pictation
//
//  Created by Jameson Roy on 11/13/17.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit
import CoreData

class UsersViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: User Settings Properties
    let BEGINNER_LEVEL: Int = 0
    let INTERMEDIATE_LEVEL: Int = 1
    let ADVANCED_LEVEL: Int = 2
    var GuestInfo : NSManagedObject!
    var UsersInfo : [NSManagedObject]! = [NSManagedObject]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CURRENT_USER = "none"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Add Done button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        //disable the back button for this view
        navigationItem.hidesBackButton = true
        
        //Retrieve the user names to be used in
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        //Puts the core data for guest into guest info and everything else into UserInfo array
        do {
            let result = try context.fetch(request)
            if(result.count != 0){
                for data in result as! [NSManagedObject] {
                    if (data.value(forKey: "name") as? String) != nil{
                        if((data.value(forKey: "name") as! String) == "Guest"){
                            /**************************
                            * if Guest is broken whe  you got setting:
                            * 1. Comment out GuestInfo = data
                            * 2. Uncomment context.delete(data)
                            * 3. Run the app and click all the way to settings then stop the app
                            * 4. undo the comment changes you made and now the app should work
                            ***************************/
                            GuestInfo = fillFields(UserData: data)
                            //context.delete(data)
                        }
                        else{
                            UsersInfo.append(fillFields(UserData: data))
                        }
                    }
                }
            }
            //Creates a Guest Account if none exists
            if(GuestInfo == nil){
                GuestInfo = initGuestInfo()
                do {
                    let context = appDelegate.persistentContainer.viewContext
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch {
            print("Error Loading User Data")
        }
    }

    // MARK: - Navigation
    //Handles the tap of the add or + button
    @objc func addTapped(){
        CURRENT_USER = "New User"
        performSegue(withIdentifier: "toSettingsFromUsers", sender: self)
    }

    //Handles the pressing of the guest button
    @IBAction func guestButtonPress(_ sender: UIButton) {
        CURRENT_USER = "Guest"
        Settings.sharedValues.viewBackgroundColor = UIColor(hexString : GuestInfo.value(forKey: "bg_colour") as! String)
        Settings.sharedValues.sentencePanelFont = UIFont(name: (GuestInfo.value(forKey: "fontstyle") as! String), size: (CGFloat((10*(GuestInfo.value(forKey : "fontsize") as! Int))+20)))
        
        if((GuestInfo.value(forKey: "commlevel") as! Int) == BEGINNER_LEVEL){
            performSegue(withIdentifier: "usersToBeginner", sender: self)
        }
        else if((GuestInfo.value(forKey: "commlevel") as! Int) == INTERMEDIATE_LEVEL){
            performSegue(withIdentifier: "userToIntermediate", sender: self)
        }
        else{
            performSegue(withIdentifier: "userToAdvanced", sender: self)
        }
    }
    
    //Used to initialize NSManagedObjects for Guest to store the User Data
    func initGuestInfo( ) -> NSManagedObject{
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let UserData = NSManagedObject(entity: entity!, insertInto: context)
        UserData.setValue("Guest", forKey: "name")
        UserData.setValue(BEGINNER_LEVEL, forKey: "commlevel")
        UserData.setValue(false, forKey: "passwordEnable")
        UserData.setValue("", forKey: "securityQuestion")
        UserData.setValue("", forKey: "securityAnswer")
        UserData.setValue("", forKey: "password")
        UserData.setValue(Settings.sharedValues.viewBackgroundColor.toHexString(), forKey: "bg_colour")
        UserData.setValue(1, forKey: "fontsize")
        UserData.setValue("", forKey: "userPictures")
        UserData.setValue("Helvetica", forKey: "fontstyle")
        
        return UserData
    }

}

//MARK: Table View for Users
extension UsersViewController : UITableViewDelegate, UITableViewDataSource{

    /* Sets the cells in the table view to the names of all the users stored in core data. */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath as IndexPath) as! UserTableViewCell
        cell.setLabel(name: (UsersInfo[indexPath.row].value(forKey: "name") as! String))
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    //handles what happens when an account name is pressed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CURRENT_USER = (UsersInfo[indexPath.row].value(forKey: "name") as! String)
        Settings.sharedValues.viewBackgroundColor = UIColor(hexString : UsersInfo[indexPath.row].value(forKey: "bg_colour") as! String)
        Settings.sharedValues.sentencePanelFont = UIFont(name: (UsersInfo[indexPath.row].value(forKey: "fontstyle") as! String), size: (CGFloat((10*(UsersInfo[indexPath.row].value(forKey : "fontsize") as! Int))+20)))
        if((UsersInfo[indexPath.row].value(forKey: "commlevel") as! Int) == self.BEGINNER_LEVEL){
            if(!(UsersInfo[indexPath.row].value(forKey: "passwordEnable") as! Bool)){
                performSegue(withIdentifier: "usersToBeginner", sender: self)
            }
            else{
                LoginAlert.userPasswordAlert(viewController: self, user: UsersInfo[indexPath.row], segue: "usersToBeginner")
            }
        }
        else if((UsersInfo[indexPath.row].value(forKey: "commlevel") as! Int) == self.INTERMEDIATE_LEVEL){
            if(!(UsersInfo[indexPath.row].value(forKey: "passwordEnable") as! Bool)){
                performSegue(withIdentifier: "userToIntermediate", sender: self)
            }
            else{
                LoginAlert.userPasswordAlert(viewController: self, user: UsersInfo[indexPath.row], segue: "userToIntermediate")
            }
        }
        else{
            if(!(UsersInfo[indexPath.row].value(forKey: "passwordEnable") as! Bool)){
                performSegue(withIdentifier: "userToAdvanced", sender: self)
            }
            else{
                LoginAlert.userPasswordAlert(viewController: self, user: UsersInfo[indexPath.row], segue: "userToAdvanced")
            }
        }
    }
    
    //Allows you to swipe left on a user in order to delete them
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            //delete from core data
            let context = appDelegate.persistentContainer.viewContext
            context.delete(UsersInfo[indexPath.row])
            UsersInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
            do {
                let context = appDelegate.persistentContainer.viewContext
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersInfo.count
    }
    
  
}

//
//  UserPictures.swift
//  Pictation
//
//  Created by Jameson Roy on 2017-11-30.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit
import CoreData
/* Class that allows pictures added by user to be stored for them and not the other users */
class UserPictures{
    var pictures : String?
    var User : NSManagedObject?
    
    init(){
        //Retrieve the user names to be used in
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        //Puts the core data for CURRENT_USER into User
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "name") as? String) != nil{
                    if((data.value(forKey: "name") as! String) == CURRENT_USER){
                        User = fillFields(UserData: data)
                        break
                    }
                }
            }
            
            pictures = (User?.value(forKey: "userPictures") as? String)
        }
        catch{
            pictures = ""
            print("Error loading picture names")
        }
    }
    
    func thisUserPictures( pictureNames : [String]) -> [String]{
        var filteredPictures = [String]()
        for pictureName in pictureNames{
            if(pictures?.range(of: pictureName) != nil){
                filteredPictures.append(pictureName)
            }
        }
        
        return filteredPictures
    }
    
    func addPictureToUser( newPicture: String) -> String {
        //let pictureToBeAdded = "--USER--" + newPicture
        if(pictures == nil){
            pictures = ""
        }
        pictures = pictures! + (newPicture + ".jpg")
        User?.setValue(pictures, forKey: "userPictures")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            let context = appDelegate.persistentContainer.viewContext
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        return newPicture
    }
}

//returns an NSManaged object where none of the fields are nil
func fillFields(UserData: NSManagedObject) -> NSManagedObject {
    let filledUserData = UserData
    
    if (filledUserData.value(forKey: "name") as? String) == nil{
        filledUserData.setValue(CURRENT_USER, forKey: "name")
    }
    if (filledUserData.value(forKey: "commlevel") as? Int) == nil{
        filledUserData.setValue(0, forKey: "commlevel")
    }
    if (filledUserData.value(forKey: "passwordEnable") as? Bool) == nil{
        filledUserData.setValue(false, forKey: "passwordEnable")
    }
    if (filledUserData.value(forKey: "securityQuestion") as? String) == nil{
        filledUserData.setValue("", forKey: "securityQuestion")
    }
    if (filledUserData.value(forKey: "securityAnswer") as? String) == nil{
        filledUserData.setValue("", forKey: "securityAnswer")
    }
    if (filledUserData.value(forKey: "password") as? String) == nil{
        filledUserData.setValue("", forKey: "password")
    }
    if (filledUserData.value(forKey: "bg_colour") as? String) == nil{
        filledUserData.setValue(Settings.sharedValues.viewBackgroundColor.toHexString(), forKey: "bg_colour")
    }
    if (filledUserData.value(forKey: "fontsize") as? Int) == nil{
        filledUserData.setValue(1, forKey: "fontsize")
    }
    if (filledUserData.value(forKey: "userPictures") as? String) == nil{
        filledUserData.setValue("", forKey: "userPictures")
    }
    if (filledUserData.value(forKey: "fontstyle") as? String) == nil{
        filledUserData.setValue("Helvetica", forKey: "fontstyle")
    }
    return filledUserData
}

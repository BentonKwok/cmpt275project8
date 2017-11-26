//
//  suggestedSentences.swift
//  Pictation
//
//  Created by Zoe Yan on 2017-11-23.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit
import CoreData
struct suggestedSentencesCoreDataSingleton{
    
    static let sharedSuggestedSentenceCoreData = suggestedSentencesCoreDataSingleton();
    
    class suggestedSentences: NSObject {
        //MARK: - Video Part 1
        
        private class func getContext() -> NSManagedObjectContext {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            return appDelegate.persistentContainer.viewContext
        }
        //save generated sentences after user tapped "hammer" button
        class func saveGeneratedSentences(suggestedSentences:String) -> Bool {
            let context = getContext()
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
            let manageObject = NSManagedObject(entity: entity!, insertInto: context)
            
            manageObject.setValue(suggestedSentences, forKey: "suggestedSentences")
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        //fetch suggested sentences saved in core data
        class func fetchSuggestedSentences() -> [Users]? {
            let context = getContext()
            var user:[Users]? = nil
            do {
                user = try context.fetch(Users.fetchRequest())
                return user
            }catch {
                return user
            }
        }
        
    }
    
}



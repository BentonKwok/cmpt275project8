import Foundation
import UIKit

class UtilHelper {
    //Remove strings after seeing the key word.
    //Example: passing in helloworld, world
    //will return: hello
    class func removeLastComponentOfString(_ originalString: String, _ stringToBeRemoved: String) -> String {
        if (stringToBeRemoved != "") {
            var trimmedString = ""
            if let index = originalString.range(of: stringToBeRemoved)?.lowerBound {
                let substring = originalString[..<(index)]
                trimmedString = String(substring)
            }
            return trimmedString
        } else {
            return originalString
        }
    }
    
    //Return all the file names as an Arary [String] under folder at folderPath
    class func getTitleArrays(_ folderPath: String) -> [String] {
        var titleArray = [String]()
        do {
            titleArray = try FileManager.default.contentsOfDirectory(atPath: folderPath)
        } catch {
            print("Error at getting contents of directory = \(folderPath)")
        }
        return titleArray
    }
    
    //Return all the images as an Array [UIImages] under folder at folderPath
    class func getImageArrays(_ folderPath: String, _ titleArray : [String], _ imageUrlArray : [URL]) -> [UIImage] {
        var imageArray = [UIImage]()
        var imageIndex = 0
        for _ in titleArray {
            let data = NSData(contentsOf: imageUrlArray[imageIndex])
            let image = UIImage(data: data! as Data)
            imageArray.append(image!)
            imageIndex = imageIndex + 1
        }
        return imageArray
    }
    
    //Return all the images as an Array [UIImages] under folder at folderPath
    class func getDocumentImageArrays(_ folderPath: String, _ titleArray : [String]) -> [UIImage] {
        var imageArray = [UIImage]()
        var imageIndex = 0
        for _ in titleArray {
            let folderPath = folderPath.appending("/" + titleArray[imageIndex])
            let image = UIImage(contentsOfFile: folderPath)
            imageArray.append(image!)
            imageIndex = imageIndex + 1
        }
        return imageArray
    }
    
    //Return the folder path by getting the file path of first image, and then remove its last componenet to get its folder path
    //Example: Passing in User/subjects/eat.jpg will return
    //User/subjects
    class func getFolderPathWithoutLastComponent(imageUrlArray : [URL]) -> String {
        if (imageUrlArray[0].absoluteString != "" ) {
            let firstImagePath = imageUrlArray[0].path
            let firstImageNSPath = firstImagePath as NSString
            let stringToBeRemoved = firstImageNSPath.lastPathComponent as String
            return removeLastComponentOfString(firstImagePath, stringToBeRemoved)
        } else {
            return ""
        }
    }
    
    class func getDocumentDirectory(atFolder : String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0].appending("/"+atFolder)
        return documentsDirectory
    }
    
    class func createSubjectsDocumentDirectory() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/" + Constants.SUBJECT_FOLDER_NAME)
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("subjects directory already created.")
        }
    }
    
    class func createObjectsDocumentDirectory() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/" + Constants.OBJECT_FOLDER_NAME)
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("objects directory already created.")
        }
    }
    
    class func createVerbsDocumentDirectory() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/" + Constants.VERB_FOLDER_NAME)
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("verbs directory already created.")
        }
    }
    
    class func createConnectivesDocumentDirectory() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/" + Constants.CONNECTIVES_FOLDER_NAME)
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("connectives directory already created.")
        }
    }
    
    class func createAllDocumentDirectories() {
        createSubjectsDocumentDirectory()
        createObjectsDocumentDirectory()
        createVerbsDocumentDirectory()
        createConnectivesDocumentDirectory()
    }
}


/* Code below taken from: https://gist.github.com/yannickl/16f0ed38f0698d9a8ae7
 * This code is used to convert UIcolor for storage and the other way around
 */
extension UIColor {
    convenience init(hexString:String) {
        
        let scanner  = Scanner(string: hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}

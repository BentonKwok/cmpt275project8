import UIKit

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var allImages:[UIImage]!
    var allTitles:[String]!
    
    var subjectImagesUrlArray:[URL]!
    var objectImagesUrlArray:[URL]!
    var verbImagesUrlArray:[URL]!
    var allImagesUrlArray:[URL]!
    
    let SUBJECT_FOLDER_NAME = "subjects"
    let OBJECT_FOLDER_NAME = "objects"
    let VERB_FOLDER_NAME = "verbs"
    var imagesDirectoryPath:String!
    var images:[UIImage]!
    var titles:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let documentDirectorPath:String = paths[0]
        // Create a new path for the new images folder
        imagesDirectoryPath = documentDirectorPath.appending("/ImagePicker")
        var objcBool:ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath:imagesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if isExist == false{
            do{
                try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                //createDirectoryAtPath(imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
    }

    @IBOutlet weak var myImageView: UIImageView!

    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = myImageView.image!
        //get the PNG data for this image
        let data = UIImagePNGRepresentation(image)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    @IBAction func storePictureButton(_ sender: UIButton) {

        let imageData = UIImagePNGRepresentation(myImageView.image!)
        let compressedImage=UIImage(data:imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!,nil,nil,nil)
        let alert=UIAlertController(title: "saved", message: "Your image has been saved", preferredStyle:.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
       /* let fileName = "Test"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("jpg")
        print("FilePath: \(fileURL.path)")
        imageData.write(to:fileURL,atomatically:true)*/
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appending("lalala.png")
        print(paths)
        fileManager.createFile(atPath:paths,contents:imageData,attributes:nil)
        
        
        
        /*// Create path.
        //NSSearchPathForDirectoriesInDomains(<#T##directory: FileManager.SearchPathDirectory##FileManager.SearchPathDirectory#>, <#T##domainMask: FileManager.SearchPathDomainMask##FileManager.SearchPathDomainMask#>, <#T##expandTilde: Bool##Bool#>)
        NSSearchPathForDirectoriesInDomains(directory:DocumentDirectory, domainMask:UserDomainMask, expandTilde:YES)
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        let filePath = subjectFolderPath = getFolderPathWithoutLastComponent(imageUrlArray: subjectImagesUrlArray)
        
        // Save image.
        UIImagePNGRepresentation(imageData).writeToFile(atPaht:filePath, atomically:true)
        
        //saveImage(imageName:"lalala.png");*/
        
        
    /*   do{
            try imageData!.write(to:completeUrl)
               print("hahahaha");
        }
        catch {
            let alert=UIAlertController(title: "saved", message: "Fail to save the image", preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
               print("houhouhou");
            
        }*/
        
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
  
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image=info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImageView.image=image
        }
        else
        {
            //Error message
        }
        self.dismiss(animated:true,completion:nil)
    }
    
    
    
    @IBAction func photoDirectoryButton(_ sender: UIButton) {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
        
    }
    @IBAction func cameraButton(_ sender: UIButton) {
 
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
}

import UIKit

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorWithHexValue : 0xD6EAF8)
    }
    
    // The save button on the camera. This will save the user selected photo at the location they specified during the alert notification prompts
    @IBOutlet weak var myImageView: UIImageView!
    
    func saveImage(imageName: String) {
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //print(imagePath)
        //get the image we took with camera
        let image = myImageView.image!
        //get the JPG data for this image
        let data = UIImageJPEGRepresentation(image, 1.0)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    //Stores the photo in the user specified location from the notification alert
    @IBAction func storePictureButton(_ sender: UIButton) {
        chooseDirectory()
        let alert=UIAlertController(title: "saved", message: "Your image has been saved", preferredStyle:.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Function to prompt the user to enter their designated location for where their photo is to go to
    func chooseDirectory() {
        let alertController = UIAlertController(title: "Name", message: "Please enter a name for your image", preferredStyle: .alert)
        let titleAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                UserDefaults.standard.set(field.text, forKey: "userTitle")    // We can use this forKey to store the name of the picture ***** possibly append username here *****
                UserDefaults.standard.synchronize()
                
                let alert=UIAlertController(title: "Diretcory", message: "Choose a Directory", preferredStyle:.alert)
                
                let subjectsAlert = UIAlertAction(title: "Subjects",style: .default, handler: {ACTION in self.saveImage(imageName: "subjects/"+field.text!+".jpg")})
                
                let verbsAlert = UIAlertAction(title: "Verbs",style: .default, handler: {ACTION in self.saveImage(imageName: "verbs/"+field.text!+".jpg")})
                
                let objectsAlert = UIAlertAction(title: "Objects",style: .default, handler: {ACTION in self.saveImage(imageName: "objects/"+field.text!+".jpg")})
                
                let cancelAction1 = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                
                alert.addAction(subjectsAlert)
                alert.addAction(verbsAlert)
                alert.addAction(objectsAlert)
                alert.addAction(cancelAction1)
                
                self.present(alert, animated: true, completion: nil)
                //self.saveImage(imageName:  field.text! + ".jpg")
                
                
            }
            // user did not fill field
            //let alertCon = UIAlertAction(title: "Error", style: .cancel, handler: nil)
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "ImageName"
        }
        
        alertController.addAction(titleAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        //saveImage(imageName : "title/userTitle")
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
    
    // The "My Picture" button for the camera. This button will pull up photos on the device that the user can add to the app
    @IBAction func photoDirectoryButton(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
        
    }
    
    // The "Photo Time!" button for the camera. This button will open up the default camera application on the device.
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
    
    // Notifies the user that there isn't a camera available on the current device
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

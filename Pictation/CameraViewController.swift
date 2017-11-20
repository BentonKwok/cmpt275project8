import UIKit

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorWithHexValue : 0xD6EAF8)
    }
    
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
    
    @IBAction func storePictureButton(_ sender: UIButton) {
        chooseDirectory()
        let alert=UIAlertController(title: "saved", message: "Your image has been saved", preferredStyle:.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func chooseDirectory() {
        let alertController = UIAlertController(title: "Directory and Name", message: "Please type a directory and name for the Image : subjects, verbs or objects followed by /'name of image'", preferredStyle: .alert)
        let titleAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                UserDefaults.standard.set(field.text, forKey: "userTitle")    // We can use this forKey to store the name of the picture
                UserDefaults.standard.synchronize()
                let alert=UIAlertController(title: "saved", message: "Your image has been saved", preferredStyle:.alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                self.saveImage(imageName:  field.text! + ".jpg")
                
                
            } else {
                // user did not fill field
                //let alertController = UIAlertController(title: "Error", message: "field cannot be left empty", preferredStyle: .alert)
                
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Directory/ImageName"
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

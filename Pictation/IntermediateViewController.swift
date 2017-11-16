import UIKit
import AVFoundation

class IntermediateViewController: UIViewController, AVAudioPlayerDelegate {
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var outputSentenceText: UITextField!
    @IBOutlet weak var sentenceImages: ImageDisplay!
    @IBOutlet weak var subjectPanelState: UILabel!
    @IBOutlet weak var verbPanelState: UILabel!
    @IBOutlet weak var objectPanelState: UILabel!
    
    
    
    var allImages:[[UIImage]]! = [[UIImage](), [UIImage](), [UIImage](), [UIImage]()]
    var allTitles:[[String]]! = [[String](), [String](), [String](), [String]()]
    
    var currentImages:[UIImage]!
    var currentTitles:[String]!
    
    var subjectImagesUrlArray:[URL]!
    var objectImagesUrlArray:[URL]!
    var verbImagesUrlArray:[URL]!
    var allImagesUrlArray:[URL]!
    
    var selectedImage: UIImage!
    var currenctSelectedWord = ""
    
    let SUBJECT_FOLDER_NAME = "subjects"
    let OBJECT_FOLDER_NAME = "objects"
    let VERB_FOLDER_NAME = "verbs"
    var collectionViewClick = 0
    let picturePanelFontSizeBolded = 20 
    let picturePanelFontSize = 14

    
   // @IBAction func makeButtonHandler(_ sender: UIButton) {
    @IBAction func makeButtonHandler(_ sender: UIButton) {
        //A check to make sure selectedText is not accessed when it doesn't have elements yet
        if (currenctSelectedWord != "") {
            var sentence : String = ""
            for i in 0...(self.sentenceImages.selectedText.count-1){    
                sentence += self.sentenceImages.selectedText[i]
                sentence += " "
            }
                outputSentenceText.text = sentence
        }
    }

    @IBAction func restartButtonHandler(_ sender: UIButton
        ) {
        currenctSelectedWord = ""
        selectedImage = nil
        outputSentenceText.text = currenctSelectedWord
        self.sentenceImages.reset()
        self.collectionViewClick = 0
        
        currentTitles = allTitles[collectionViewClick]
        currentImages = allImages[collectionViewClick]
        collectionView.reloadData()
        
        //Resets the panel to display basics
        subjectPanelState.text = SUBJECT_FOLDER_NAME
        subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSizeBolded), weight: .bold)
        subjectPanelState.textColor = UIColor.black
        verbPanelState.text = VERB_FOLDER_NAME
        verbPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSize), weight: .thin)
        verbPanelState.textColor = UIColor.lightGray
        objectPanelState.text = OBJECT_FOLDER_NAME
        objectPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSize), weight: .thin)
        objectPanelState.textColor = UIColor.lightGray
    }
    //Remove strings after seeing the key word.
    //Example: passing in helloworld, world
    //will return: hello
    func removeLastComponentOfString(_ originalString: String, _ stringToBeRemoved: String) -> String {
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
    fileprivate func getTitleArrays(_ folderPath: String) -> [String] {
        var titleArray = [String]()
        do {
            titleArray = try FileManager.default.contentsOfDirectory(atPath: folderPath)
        } catch {
            print("Error at getting contents of directory = \(folderPath)")
        }
        return titleArray
    }
    
    //Return all the images as an Array [UIImages] under folder at folderPath
    fileprivate func getImageArrays(_ folderPath: String, _ titleArray : [String], _ imageUrlArray : [URL]) -> [UIImage] {
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
    
    //Return the folder path by getting the file path of first image, and then remove its last componenet to get its folder path
    //Example: Passing in User/subjects/eat.jpg will return
    //User/subjects
    func getFolderPathWithoutLastComponent(imageUrlArray : [URL]) -> String {
        if (imageUrlArray[0].absoluteString != "" ) {
            let firstImagePath = imageUrlArray[0].path
            let firstImageNSPath = firstImagePath as NSString
            let stringToBeRemoved = firstImageNSPath.lastPathComponent as String
            return removeLastComponentOfString(firstImagePath, stringToBeRemoved)
        } else {
            return ""
        }
    }
    
    //Settings button handler
    @objc func settingsTapped(){
        performSegue(withIdentifier: "settingsFromIntermediate", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Settings button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
        //Getting all the image folder paths as URL arrays [URL]
        //There are THREE folders, subjects, objects, verbs
        subjectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: SUBJECT_FOLDER_NAME)!
        objectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: OBJECT_FOLDER_NAME)!
        verbImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: VERB_FOLDER_NAME)!
        
        allImagesUrlArray = subjectImagesUrlArray + objectImagesUrlArray
        allImagesUrlArray = allImagesUrlArray + verbImagesUrlArray
        
        let subjectFolderPath = getFolderPathWithoutLastComponent(imageUrlArray: subjectImagesUrlArray)
        let objectFolderPath = getFolderPathWithoutLastComponent(imageUrlArray: objectImagesUrlArray)
        let verbFolderPath = getFolderPathWithoutLastComponent(imageUrlArray: verbImagesUrlArray)
        
        //Getting all the file names of each folder and put them in String arrays [String]
        let subjectTitles = getTitleArrays(subjectFolderPath)
        let objectTitles = getTitleArrays(objectFolderPath)
        let verbTitles = getTitleArrays(verbFolderPath)
        
        //Getting all the images of each foler and put them in UIImages arrays [UIImage]
        let subjectImages = getImageArrays(subjectFolderPath, subjectTitles, subjectImagesUrlArray)
        let objectImages = getImageArrays(objectFolderPath, objectTitles, objectImagesUrlArray)
        let verbImages = getImageArrays(verbFolderPath, verbTitles, verbImagesUrlArray)
        
        allTitles[0] = subjectTitles
        allTitles[1] = verbTitles
        allTitles[2] = objectTitles
        //allTitles = allTitles + verbTitles
        
        allImages[0] = subjectImages
        allImages[1] = verbImages
        allImages[2] = objectImages
        
        currentImages = allImages[collectionViewClick]  
        currentTitles = allTitles[collectionViewClick]
     
        //setting display of PicturePanel
        subjectPanelState.text = SUBJECT_FOLDER_NAME
        subjectPanelState.layer.borderWidth = 2.0
        subjectPanelState.layer.cornerRadius = 8
        subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSizeBolded), weight: .bold)
        subjectPanelState.textColor = UIColor.black
        verbPanelState.text = VERB_FOLDER_NAME
        verbPanelState.layer.borderWidth = 2.0
        verbPanelState.layer.cornerRadius = 8
        verbPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSize), weight: .thin)
        verbPanelState.textColor = UIColor.lightGray
        objectPanelState.text = OBJECT_FOLDER_NAME
        objectPanelState.layer.borderWidth = 2.0
        objectPanelState.layer.cornerRadius = 8
        objectPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSize), weight: .thin)
        objectPanelState.textColor = UIColor.lightGray
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //text-to-speech
    let mySynthesizer = AVSpeechSynthesizer()
    var myUtterence = AVSpeechUtterance(string: "This assignment is so much fun and I really enjoy doing it!")
    var wasPaused = false;
    
    @IBAction func stopAudioButton(_ sender: UIButton) {
        self.mySynthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func playAudioButton(_ sender: UIButton) {
        if(wasPaused==true)
        {
            self.mySynthesizer.continueSpeaking()
            wasPaused=false;
        }
        else
        {
            myUtterence = AVSpeechUtterance(string: outputSentenceText.text!);
            // myUtterence.rate = AVSpeechUtteranceMinimumSpeechRate
            myUtterence.rate = 0.52
            myUtterence.voice = AVSpeechSynthesisVoice(language: "en-us")
            myUtterence.pitchMultiplier = 1.5 //between 0.5 and 2.0. Default is 1.0.
            mySynthesizer.speak(myUtterence)
            // Do any additional setup after loading the view, typically from a nib.
        }
    }
    
    //@IBAction func pauseAudioButton(_ sender: UIButton) {
    @IBAction func pauseAudioButton(_ sender: UIButton) {
        self.mySynthesizer.pauseSpeaking(at: .word)
        wasPaused = true;
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

/// Collection View Impl
//extension BeginnerLevelViewController : UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        print("styuen: should select item at location \(indexPath.item)")
//        return true
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("styuen: item: \(indexPath.item) was selected")
//    }
//}

/// Collection View data
extension IntermediateViewController : UICollectionViewDataSource {
    /// Number of section and items in each section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return allImages.count
        return currentImages.count
    }
    
    /// Create cell for each item
    // In buttonHandler, update currentSelectedWord and the selectedImage when "Make" button is clicked
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.borderWidth = 3
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        cell.buttonCell.setBackgroundImage(allImages[collectionViewClick][indexPath.row], for: .normal)
        cell.layer.borderWidth = 4
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 8
        cell.buttonHandler = { [weak self] button in
            self?.currenctSelectedWord = (self?.removeLastComponentOfString((self?.allTitles[(self?.collectionViewClick)!][indexPath.row])!, ".jpg"))!
            self?.selectedImage = self?.allImages[(self?.collectionViewClick)!][indexPath.row]
            
            //adds images and text to subview at the top
            self?.sentenceImages.addImage(newImage: (self?.selectedImage), newText : (self?.currenctSelectedWord), maxSubViews: 3)
            if((self?.collectionViewClick)! < 2){
                self?.collectionViewClick = ((self?.collectionViewClick)! + 1)
            }

            self?.currentTitles = self?.allTitles[(self?.collectionViewClick)!]
            self?.currentImages = self?.allImages[(self?.collectionViewClick)!]
            collectionView.reloadData()
            
            switch (self?.collectionViewClick)!{
            case 0: //subject
                //bolding words to emphasize selection
                self?.subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSizeBolded)!), weight:.bold)
                self?.subjectPanelState.textColor = UIColor.black
                
                //changing font and colour to give it the faded look
                self?.verbPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSize)!), weight:.thin)
                self?.verbPanelState.textColor = UIColor.lightGray
                self?.objectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSize)!), weight:.thin)
                self?.objectPanelState.textColor = UIColor.lightGray
            case 1: //verb
                //bolding words to emphasize selection
                self?.verbPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSizeBolded)!), weight:.bold)
                self?.verbPanelState.textColor = UIColor.black
                
                //changing font and colour to give it the faded look
                self?.subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSize)!), weight:.thin)
                self?.subjectPanelState.textColor = UIColor.lightGray
                self?.objectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSize)!), weight:.thin)
                self?.objectPanelState.textColor = UIColor.lightGray
            case 2://object
                //bolding words to emphasize selection
                self?.objectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSizeBolded)!), weight:.bold)
                self?.objectPanelState.textColor = UIColor.black
                
                // changing font and colour to give it the faded look
                self?.subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSize)!), weight:.thin)
                self?.subjectPanelState.textColor = UIColor.lightGray
                self?.verbPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSize)!), weight:.thin)
                self?.verbPanelState.textColor = UIColor.lightGray
            default:
                //default will have a faded look
                self?.subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSize)!), weight:.thin)
                self?.subjectPanelState.textColor = UIColor.lightGray
                self?.verbPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSize)!), weight:.thin)
                self?.verbPanelState.textColor = UIColor.lightGray
                self?.objectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self?.picturePanelFontSize)!), weight:.thin)
                self?.objectPanelState.textColor = UIColor.lightGray
            }
            //print("bentonk: buttonHandler on item: \(indexPath.item) selected")
        }
        //cell.buttonCell.setAttributedTitle(NSAttributedString.init(string: "test"), for: .normal)
        
        return cell
    }
}


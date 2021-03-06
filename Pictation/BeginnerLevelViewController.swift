import UIKit
import AVFoundation
class BeginnerLevelViewController: UIViewController,AVAudioPlayerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var outputSentenceText: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var picturePanelState: UILabel!
    
    var allImages:[UIImage]!
    var allTitles:[String]!
    
//    var subjectImagesUrlArray:[URL]!
//    var objectImagesUrlArray:[URL]!
//    var verbImagesUrlArray:[URL]!
//    var allImagesUrlArray:[URL]!
    
    var currenctSelectedWord = ""
    
    let picturePanelFontSizeBolded = 20
    
    @IBAction func makeButtonHandler(_ sender: UIButton) {
        if (currenctSelectedWord != "") {
            outputSentenceText.font = Settings.sharedValues.sentencePanelFont
            outputSentenceText.text = currenctSelectedWord
        }
    }
    
    @IBAction func restartButtonHandler(_ sender: UIButton) {
        currenctSelectedWord = ""
        selectedImage.image = nil
        outputSentenceText.text = currenctSelectedWord
    }
    
    //Settings button handler
    @objc func settingsTapped(){
        performSegue(withIdentifier: "settingsFromBeginner", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UtilHelper.createAllDocumentDirectories()
        
        //used to keep track of which user added which pictures
        let userPictures : UserPictures = UserPictures()
        
        //Sets background color of ViewController
        self.view.backgroundColor = Settings.sharedValues.viewBackgroundColor
        
        //Add Settings button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
        //Getting all the image folder paths as URL arrays [URL]
        //There are THREE folders, subjects, objects, verbs
        let subjectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.SUBJECT_FOLDER_NAME)!
        let objectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.OBJECT_FOLDER_NAME)!
        let verbImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.VERB_FOLDER_NAME)!
        let connectiveImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.CONNECTIVES_FOLDER_NAME)!
        
        //Getting all the folder paths where the predefined images are stored
        let subjectFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: subjectImagesUrlArray)
        let objectFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: objectImagesUrlArray)
        let verbFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: verbImagesUrlArray)
        let connectiveFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: connectiveImagesUrlArray)

        //Getting all the directories where the user-defined images are stored
        let subjectFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.SUBJECT_FOLDER_NAME)
        let objectFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.OBJECT_FOLDER_NAME)
        let verbFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.VERB_FOLDER_NAME)
        let connectiveFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.CONNECTIVES_FOLDER_NAME)

        //Getting all the predefined images' file names of each folder and put them in String arrays [String]
        var subjectTitles = UtilHelper.getTitleArrays(subjectFolderPath)
        var objectTitles = UtilHelper.getTitleArrays(objectFolderPath)
        var verbTitles = UtilHelper.getTitleArrays(verbFolderPath)
        var connectiveTitles = UtilHelper.getTitleArrays(connectiveFolderPath)

        //Getting all the user-defined images' file names of each folder and put them in String arrays [String]
        let subjectDocumentTitles = userPictures.thisUserPictures( pictureNames: UtilHelper.getTitleArrays(subjectFolderDocumentDirectory))
        let objectDocumentTitles = userPictures.thisUserPictures( pictureNames: UtilHelper.getTitleArrays(objectFolderDocumentDirectory))
        let verbDocumentTitles = userPictures.thisUserPictures( pictureNames: UtilHelper.getTitleArrays(verbFolderDocumentDirectory))
        let connectivesDocumentTitles = UtilHelper.getTitleArrays(connectiveFolderDocumentDirectory)
        
        //Getting all the predefined images of each foler and put them in UIImages arrays [UIImage]
        var subjectImages = UtilHelper.getDocumentImageArrays(subjectFolderPath, subjectTitles)
        var objectImages = UtilHelper.getDocumentImageArrays(objectFolderPath, objectTitles)
        var verbImages = UtilHelper.getDocumentImageArrays(verbFolderPath, verbTitles)
        var connectivesImages = UtilHelper.getDocumentImageArrays(connectiveFolderPath, connectiveTitles)
        
        //Getting all the user-defined images of each foler and put them in UIImages arrays [UIImage]
        let subjectDocumentImages = UtilHelper.getDocumentImageArrays(subjectFolderDocumentDirectory, subjectDocumentTitles)
        let objectDocumentImages = UtilHelper.getDocumentImageArrays(objectFolderDocumentDirectory, objectDocumentTitles)
        let verbDocumentImages = UtilHelper.getDocumentImageArrays(verbFolderDocumentDirectory, verbDocumentTitles)
        let connectivesDocumentImages = UtilHelper.getDocumentImageArrays(connectiveFolderDocumentDirectory, connectivesDocumentTitles)
        
        //Putting all the images titles into allTitles : [String]
        subjectTitles = subjectTitles + subjectDocumentTitles
        objectTitles = objectTitles + objectDocumentTitles
        verbTitles = verbTitles + verbDocumentTitles
        connectiveTitles = connectiveTitles + connectivesDocumentTitles
        allTitles = subjectTitles + objectTitles
        allTitles = allTitles + verbTitles
        allTitles = allTitles + connectiveTitles
        
        subjectImages = subjectImages + subjectDocumentImages
        objectImages = objectImages + objectDocumentImages
        verbImages = verbImages + verbDocumentImages
        connectivesImages = connectivesImages + connectivesDocumentImages
        allImages = subjectImages + objectImages
        allImages = allImages + verbImages
        allImages = allImages + connectivesImages
        
        picturePanelState.text = Constants.ALL_PICTURES_NAME
        picturePanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSizeBolded), weight: .bold)
        picturePanelState.textColor = UIColor.black
        picturePanelState.layer.borderWidth = 2.0
        picturePanelState.layer.cornerRadius = 8
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //text-to-speech
    let mySynthesizer = AVSpeechSynthesizer()
    var myUtterence = AVSpeechUtterance(string: "This assignment is so much fun and I really enjoy doing it!")
    var wasPaused = false;
    var voiceRate = 0.0
    @IBOutlet weak var rateLabel: UILabel!
    @IBAction func adjustSpeakRateButton(_ sender: UISlider) {
        rateLabel.text = String(Int(sender.value))
        voiceRate = Double(sender.value / 100.0)
    }
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
            myUtterence.rate = Float(voiceRate)
            myUtterence.voice = AVSpeechSynthesisVoice(language: "en-us")
            myUtterence.pitchMultiplier = 1.5 //between 0.5 and 2.0. Default is 1.0.
            mySynthesizer.speak(myUtterence)
            // Do any additional setup after loading the view, typically from a nib.
        }
    }
    
    @IBAction func pauseAudioButton(_ sender: UIButton) {
        self.mySynthesizer.pauseSpeaking(at: .word)
        wasPaused = true;
    }
}

/// Collection View data
extension BeginnerLevelViewController : UICollectionViewDataSource {
    /// Number of section and items in each section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    /// Create cell for each item
    // In buttonHandler, update currentSelectedWord and the selectedImage when "Make" button is clicked
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Sets color and borders of Collection View
        collectionView.backgroundColor = Settings.sharedValues.viewBackgroundColor// hex number color #D6EAF8
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.borderWidth = 3
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        cell.buttonCell.setBackgroundImage(allImages[indexPath.row], for: .normal)
        cell.cellName.text = UtilHelper.removeLastComponentOfString(allTitles[indexPath.row], ".jpg")
        cell.cellName.textAlignment = .center
        cell.layer.borderWidth = 4
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 8
        cell.buttonHandler = { [weak self] button in
            self?.currenctSelectedWord = (UtilHelper.removeLastComponentOfString((self?.allTitles[indexPath.row])!, ".jpg"))
            self?.selectedImage.image = self?.allImages[indexPath.row]
            
            print("bentonk: buttonHandler on item: \(indexPath.item) selected")
        }
        return cell
    }
}

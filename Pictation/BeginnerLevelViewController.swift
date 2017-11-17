import UIKit
import AVFoundation
class BeginnerLevelViewController: UIViewController,AVAudioPlayerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var outputSentenceText: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    
    var allImages:[UIImage]!
    var allTitles:[String]!
    
    var subjectImagesUrlArray:[URL]!
    var objectImagesUrlArray:[URL]!
    var verbImagesUrlArray:[URL]!
    var allImagesUrlArray:[URL]!
    
    var currenctSelectedWord = ""
    
    @IBAction func makeButtonHandler(_ sender: UIButton) {
        if (currenctSelectedWord != "") {
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
        
        //Add Settings button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
        //Getting all the image folder paths as URL arrays [URL]
        //There are THREE folders, subjects, objects, verbs
        subjectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.SUBJECT_FOLDER_NAME)!
        objectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.OBJECT_FOLDER_NAME)!
        verbImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.VERB_FOLDER_NAME)!
        
        allImagesUrlArray = subjectImagesUrlArray + objectImagesUrlArray
        allImagesUrlArray = allImagesUrlArray + verbImagesUrlArray
        
        //Getting all the folder paths where the predefined images are stored
        let subjectFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: subjectImagesUrlArray)
        let objectFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: objectImagesUrlArray)
        let verbFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: verbImagesUrlArray)
        
        //Getting all the directories where the user-defined images are stored
        let subjectFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.SUBJECT_FOLDER_NAME)
        let objectFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.OBJECT_FOLDER_NAME)
        let verbFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.VERB_FOLDER_NAME)
        
        //Getting all the predefined images' file names of each folder and put them in String arrays [String]
        var subjectTitles = UtilHelper.getTitleArrays(subjectFolderPath)
        var objectTitles = UtilHelper.getTitleArrays(objectFolderPath)
        var verbTitles = UtilHelper.getTitleArrays(verbFolderPath)
        
        //Getting all the user-defined images' file names of each folder and put them in String arrays [String]
        let subjectDocumentTitles = UtilHelper.getTitleArrays(subjectFolderDocumentDirectory)
        let objectDocumentTitles = UtilHelper.getTitleArrays(objectFolderDocumentDirectory)
        let verbDocumentTitles = UtilHelper.getTitleArrays(verbFolderDocumentDirectory)
        
        //Getting all the predefined images of each foler and put them in UIImages arrays [UIImage]
        var subjectImages = UtilHelper.getImageArrays(subjectFolderPath, subjectTitles, subjectImagesUrlArray)
        var objectImages = UtilHelper.getImageArrays(objectFolderPath, objectTitles, objectImagesUrlArray)
        var verbImages = UtilHelper.getImageArrays(verbFolderPath, verbTitles, verbImagesUrlArray)
        
        //Getting all the user-defined images of each foler and put them in UIImages arrays [UIImage]
        let subjectDocumentImages = UtilHelper.getDocumentImageArrays(subjectFolderDocumentDirectory, subjectDocumentTitles)
        let objectDocumentImages = UtilHelper.getDocumentImageArrays(objectFolderDocumentDirectory, objectDocumentTitles)
        let verbDocumentImages = UtilHelper.getDocumentImageArrays(verbFolderDocumentDirectory, verbDocumentTitles)
        
        //Putting all the images titles into allTitles : [String]
        subjectTitles = subjectTitles + subjectDocumentTitles
        objectTitles = objectTitles + objectDocumentTitles
        verbTitles = verbTitles + verbDocumentTitles
        allTitles = subjectTitles + objectTitles
        allTitles = allTitles + verbTitles
        
        subjectImages = subjectImages + subjectDocumentImages
        objectImages = objectImages + objectDocumentImages
        verbImages = verbImages + verbDocumentImages
        allImages = subjectImages + objectImages
        allImages = allImages + verbImages
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        cell.buttonCell.setBackgroundImage(allImages[indexPath.row], for: .normal)
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

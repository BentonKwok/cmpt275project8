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
    
    var collectionViewClick = 0
    let picturePanelFontSizeBolded = 20 
    let picturePanelFontSize = 14
    var colorClick = 0
    
   // @IBAction func makeButtonHandler(_ sender: UIButton) {
    @IBAction func makeButtonHandler(_ sender: UIButton) {
        var verbWithS = ""
        let addWantTo = "want to"
        //A check to make sure selectedText is not accessed when it doesn't have elements yet
        if (currenctSelectedWord != "") {
            var sentence : String = ""
            for i in 0...(self.sentenceImages.selectedText.count-1){
                if i >= 1
                {
                    // Grammer correction for the sentence combinations be are able to currently able to offer
                    if (sentenceImages.selectedText[i-1] == "I" ||  sentenceImages.selectedText[i-1] == "me" || sentenceImages.selectedText[i-1] == "we" ||  sentenceImages.selectedText[i-1] == "they")
                    {
                        sentence += addWantTo
                        sentence += " "
                        sentence += self.sentenceImages.selectedText[i]
                        sentence += " "
                    }
                    else if sentenceImages.selectedText[i-1] == "he" || sentenceImages.selectedText[i-1] == "she"
                    {
                        verbWithS = sentenceImages.selectedText[i]
                        verbWithS += "s"
                        sentence += verbWithS
                        sentence += " "
                    }
                    else
                    {
                        sentence += self.sentenceImages.selectedText[i]
                        sentence += " "
                    }
                    
                }
                else{
                    sentence += self.sentenceImages.selectedText[i]
                    sentence += " "
                }
            }
            outputSentenceText.font = Settings.sharedValues.sentencePanelFont
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
        subjectPanelState.text = Constants.SUBJECT_FOLDER_NAME
        subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSizeBolded), weight: .bold)
        subjectPanelState.textColor = UIColor.black
        verbPanelState.text = Constants.VERB_FOLDER_NAME
        verbPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSize), weight: .thin)
        verbPanelState.textColor = UIColor.lightGray
        objectPanelState.text = Constants.OBJECT_FOLDER_NAME
        objectPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSize), weight: .thin)
        objectPanelState.textColor = UIColor.lightGray
    }
    
    //Settings button handler
    @objc func settingsTapped(){
        performSegue(withIdentifier: "settingsFromIntermediate", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets background color of Picture Panel ViewController
        self.view.backgroundColor = Settings.sharedValues.viewBackgroundColor
        
        //Add Settings button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
        //Getting all the image folder paths as URL arrays [URL]
        //There are THREE folders, subjects, objects, verbs
        subjectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.SUBJECT_FOLDER_NAME)!
        objectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.OBJECT_FOLDER_NAME)!
        verbImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.VERB_FOLDER_NAME)!
        
        allImagesUrlArray = subjectImagesUrlArray + objectImagesUrlArray
        allImagesUrlArray = allImagesUrlArray + verbImagesUrlArray
        
        let subjectFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: subjectImagesUrlArray)
        let objectFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: objectImagesUrlArray)
        let verbFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: verbImagesUrlArray)
        
        //Getting all the directories where the user-defined images are stored
        let subjectFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.SUBJECT_FOLDER_NAME)
        let objectFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.OBJECT_FOLDER_NAME)
        let verbFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.VERB_FOLDER_NAME)
        
        //Getting all the file names of each folder and put them in String arrays [String]
        let subjectTitles = UtilHelper.getTitleArrays(subjectFolderPath)
        let objectTitles = UtilHelper.getTitleArrays(objectFolderPath)
        let verbTitles = UtilHelper.getTitleArrays(verbFolderPath)
        
        //Getting all the user-defined images' file names of each folder and put them in String arrays [String]
        let subjectDocumentTitles = UtilHelper.getTitleArrays(subjectFolderDocumentDirectory)
        let objectDocumentTitles = UtilHelper.getTitleArrays(objectFolderDocumentDirectory)
        let verbDocumentTitles = UtilHelper.getTitleArrays(verbFolderDocumentDirectory)
        
        //Getting all the images of each foler and put them in UIImages arrays [UIImage]
        let subjectImages = UtilHelper.getImageArrays(subjectFolderPath, subjectTitles, subjectImagesUrlArray)
        let objectImages = UtilHelper.getImageArrays(objectFolderPath, objectTitles, objectImagesUrlArray)
        let verbImages = UtilHelper.getImageArrays(verbFolderPath, verbTitles, verbImagesUrlArray)
        
        //Getting all the user-defined images of each foler and put them in UIImages arrays [UIImage]
        let subjectDocumentImages = UtilHelper.getDocumentImageArrays(subjectFolderDocumentDirectory, subjectDocumentTitles)
        let objectDocumentImages = UtilHelper.getDocumentImageArrays(objectFolderDocumentDirectory, objectDocumentTitles)
        let verbDocumentImages = UtilHelper.getDocumentImageArrays(verbFolderDocumentDirectory, verbDocumentTitles)
        
        allTitles[0] = subjectTitles + subjectDocumentTitles
        allTitles[1] = verbTitles + verbDocumentTitles
        allTitles[2] = objectTitles + objectDocumentTitles
        
        allImages[0] = subjectImages + subjectDocumentImages
        allImages[1] = verbImages + verbDocumentImages
        allImages[2] = objectImages + objectDocumentImages
        
        currentImages = allImages[collectionViewClick]  
        currentTitles = allTitles[collectionViewClick]
     
        //setting display of PicturePanel
        subjectPanelState.text = Constants.SUBJECT_FOLDER_NAME
        subjectPanelState.layer.borderWidth = 2.0
        subjectPanelState.layer.cornerRadius = 8
        subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSizeBolded), weight: .bold)
        subjectPanelState.textColor = UIColor.black
        verbPanelState.text = Constants.VERB_FOLDER_NAME
        verbPanelState.layer.borderWidth = 2.0
        verbPanelState.layer.cornerRadius = 8
        verbPanelState.font = UIFont.systemFont(ofSize: CGFloat(picturePanelFontSize), weight: .thin)
        verbPanelState.textColor = UIColor.lightGray
        objectPanelState.text = Constants.OBJECT_FOLDER_NAME
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

// HEX Value to UIColor conversion
extension UIColor{
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

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
        
        // Sets color and borders of Collection View
        collectionView.backgroundColor = Settings.sharedValues.viewBackgroundColor
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.borderWidth = 3
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        cell.buttonCell.setBackgroundImage(allImages[collectionViewClick][indexPath.row], for: .normal)
        cell.layer.borderWidth = 4
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 8
        cell.buttonHandler = { [weak self] button in
            self?.currenctSelectedWord = (UtilHelper.removeLastComponentOfString((self?.allTitles[(self?.collectionViewClick)!][indexPath.row])!, ".jpg"))
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


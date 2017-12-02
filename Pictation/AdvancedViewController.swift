import UIKit
import AVFoundation


class AdvancedViewController: UIViewController, AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate{
    
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var outputSentenceText: UITextField!
    @IBOutlet weak var sentenceImages: ImageDisplay!
    @IBOutlet weak var subjectPanelState: UILabel!
    @IBOutlet weak var verbPanelState: UILabel!
    @IBOutlet weak var objectPanelState: UILabel!
    @IBOutlet weak var connectivesPanelState: UILabel!
    
    let MAX_NUMBER_OF_CLICKS_ALLOWED = 6
    
    var allImages:[[UIImage]]! = [[UIImage](), [UIImage](), [UIImage](), [UIImage]()]
    var allTitles:[[String]]! = [[String](), [String](), [String](), [String]()]
    
    var currentImages:[UIImage]!
    var currentTitles:[String]!
    
    var selectedImage: UIImage!
    var currenctSelectedWord = ""
    
    var collectionViewClick = 0
    var collectionViewOutOfBoundClicked = false
    
    // Needed for the extension of collection view
    let picturePanelFontSizeBolded = 20
    let picturePanelFontSize = 14
    
    //Undo Button action
    @IBAction func undoButtonHandler(_ sender: UIButton) {
        if (collectionViewClick != 0 && sentenceImages.getSize() != 0) {
            if (!collectionViewOutOfBoundClicked) {
            sentenceImages.removeLastImage()
            collectionViewClick -= 1
            currentTitles = allTitles[collectionViewClick % 4]
            currentImages = allImages[collectionViewClick % 4]
            collectionView.reloadData()
            self.setSelectedStateStyle(viewClicked: (self.collectionViewClick) % 4)
            }
            //if Maximum number of pictures reached
            else {
                sentenceImages.removeLastImage()
                collectionViewOutOfBoundClicked = false
            }
        }
        else if (sentenceImages.getSize() == 0){
            collectionViewClick = 0
        }
    }
    
    //Suggested Sentence Select Button action
    @IBAction func selectSentenceButton(_ sender: UIButton)
    {
       outputSentenceText.text = selectedSentenceSavedInTextBox.text
    }
    
    //Table View display of suggested sentences
    @IBOutlet weak var suggestedSentenceDisplay: UITableView!
    var suggestedSentenceList: [String] = []
    
    //Table View delegate functions for Suggested Sentence display
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (suggestedSentenceList.isEmpty){
            suggestedSentenceDisplay.isHidden = true
        }
        else {
            suggestedSentenceDisplay.isHidden = false
        }
        return suggestedSentenceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestedSentenceCell", for: indexPath)
        cell.textLabel?.text = suggestedSentenceList[indexPath.row] as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectedSentenceSavedInTextBox.text = cell?.textLabel?.text
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(suggestedSentenceList[indexPath.row] as String == " "){
            return 0
        }
        else{
            return UITableViewAutomaticDimension
        }
    }

    // Displays chosen Sentence Suggestion
    @IBOutlet weak var selectedSentenceSavedInTextBox: UITextField!
    
    //MARK: Variables to set up suggested sentence data display
    var sentenceListFromMatchingTappedImageWithCoreData = [""]
    var indexOfSelectedImageText = 0
    var sentenceGeneratedFromCollectedWords : String = ""
    var sentenceRange = 30
    var wordsInCollectionView = [""]
    
    func updateWordsInCollectionView(word:String,appendWord:Bool)
    {
        if(appendWord == true){
            wordsInCollectionView.append(word)
        }
        else{
            if(wordsInCollectionView.count >= 1){
              wordsInCollectionView.removeLast(wordsInCollectionView.count-1)
            }
        }
    }
    
    // MARK:
    func sentenceRangeBasedOnFirstImage(collectedWordsSoFar: String)
    {
        let sentences = suggestedSentencesCoreDataSingleton.suggestedSentences.fetchSuggestedSentences()
        var j = 0
        for i in sentences!{
            if(i.suggestedSentences != nil && j <= sentenceRange){
                if (((i.suggestedSentences as String!) .range(of: collectedWordsSoFar)) != nil){
                    sentenceListFromMatchingTappedImageWithCoreData.append(i.suggestedSentences as String!)
                    j = j + 1
                }
            }
        }
        
        if(sentenceListFromMatchingTappedImageWithCoreData.count > 0){
            if(sentenceListFromMatchingTappedImageWithCoreData[0] == ""){
                sentenceListFromMatchingTappedImageWithCoreData.remove(at: 0)
                sentenceRange = j
            }
            else{
                sentenceRange = j + 1
            }
        }
        refreshSuggestedSentenceTableView(&sentenceListFromMatchingTappedImageWithCoreData)
    }
    
    // MARK: Refereshing TableView of sentence suggestion
    func refreshSuggestedSentenceTableView(_ stringArray: inout [String]){
        //Fills the suggested sentence array with white space strings if empty.
        if(suggestedSentenceList.isEmpty){
            suggestedSentenceList = [" ", " ", " ", " ", " "]
        }
        var randomIndex = 0;
        for i in 0...4{
            //if the number of sentences within the array<= 5, we will just display all of them
            if (stringArray.count<=5 && i<stringArray.count){
                suggestedSentenceList[i] = stringArray[i] // table view
            }
            //if the number of sentences within array >= 6
            //will generate random index number if # of suggested sentence > 6. This allows for the user to see different suggested sentences when there are matches.
            else if(stringArray.count>=6 && i<stringArray.count){
                randomIndex = Int(arc4random_uniform(UInt32(stringArray.count)))
                suggestedSentenceList[i] = stringArray[randomIndex] // table view
            }
            else{
                suggestedSentenceList[i] = " " // table view
            }
        }
        if(suggestedSentenceList == [" ", " ", " ", " ", " "]){
            suggestedSentenceList.removeAll()
        }
        suggestedSentenceDisplay.reloadData() //reloads data of table view
    }
    
    func narrowTheRangeOfSuggestedSentences(_ stringArray: inout [String], _ matchWithWord: String)
    {
        var i = 0
        var newRangeOfSuggestedSentence = [""]
        //  var indexNeededToBeRemoved = [0]
        while (i < stringArray.count){
            if (stringArray[i].range(of: matchWithWord) != nil){
                newRangeOfSuggestedSentence.append(stringArray[i])
            }
            i = i + 1
        }
        sentenceRange = i
        if(newRangeOfSuggestedSentence[0]==""){
            newRangeOfSuggestedSentence.remove(at: 0)
            sentenceRange -= 1
        }
        refreshSuggestedSentenceTableView(&stringArray)
    }
    
    
    @IBAction func makeButtonHandler(_ sender: UIButton) {
        var verbWithS = ""
        let addWantTo = "want to"
        let addWantsTo = "wants to"
        let addOn = "on"
        let addFor = "for"
        //A check to make sure selectedText is not accessed when it doesn't have elements yet
        if (currenctSelectedWord != "" && sentenceImages.getSize() != 0) {
            var sentence : String = ""
            for i in 0...(self.sentenceImages.selectedText.count-1) {
                if i >= 1 {
                    // Grammer correction for the sentence combinations be are able to currently able to offer
                    if (sentenceImages.selectedText[i-1] == "I" ||  sentenceImages.selectedText[i-1] == "me" || sentenceImages.selectedText[i-1] == "we" ||  sentenceImages.selectedText[i-1] == "they") {
                        sentence += addWantTo
                        sentence += " "
                        sentence += self.sentenceImages.selectedText[i]
                        sentence += " "
                    }
                    else if (sentenceImages.selectedText[i-1] == "he" || sentenceImages.selectedText[i-1] == "she" ) {
                        verbWithS = sentenceImages.selectedText[i]
                        verbWithS += "s"
                        sentence += verbWithS
                        sentence += " "
                    }
                    else if (sentenceImages.selectedText[i-1] == "paint" || sentenceImages.selectedText[i-1] == "read"){
                        sentence += addOn
                        sentence += " "
                        sentence += self.sentenceImages.selectedText[i]
                        sentence += " "
                    }
                    else if (sentenceImages.selectedText[i-1] == "wait"){
                        sentence += addFor
                        sentence += " "
                        sentence += self.sentenceImages.selectedText[i]
                        sentence += " "
                    }
                    else {
                        sentence += self.sentenceImages.selectedText[i]
                        sentence += " "
                    }
                }
                else {
                    sentence += self.sentenceImages.selectedText[i]
                    sentence += " "
                }
            }
            outputSentenceText.font = Settings.sharedValues.sentencePanelFont
            outputSentenceText.text = sentence
        }
        //save the new generated sentences into the core data
        let sentences = suggestedSentencesCoreDataSingleton.suggestedSentences.fetchSuggestedSentences();
        
        var storedBefore = false
        for i in sentences!{
            if outputSentenceText.text as String! == (i.suggestedSentences as String!){
                print("it is saved before")
                print(outputSentenceText.text as String!)
                storedBefore = true
                break
            }
        }
        if(storedBefore == false){
            _ = suggestedSentencesCoreDataSingleton.suggestedSentences.saveGeneratedSentences(suggestedSentences: outputSentenceText.text as String!)
            print(outputSentenceText.text as String!)
            
        }
        
        indexOfSelectedImageText = 0
        sentenceGeneratedFromCollectedWords = ""
        suggestedSentenceList.removeAll()
        sentenceListFromMatchingTappedImageWithCoreData=[""]
        sentenceRange = 30
        suggestedSentenceDisplay.reloadData()
       // refresh(_ object: suggestedSentencesCoreDataSingleton.suggestedSentences, true)
        
    }
    
    @IBAction func restartButtonHandler(_ sender: UIButton) {
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
        subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat(Constants.picturePanelFontSizeBolded), weight: .bold)
        subjectPanelState.textColor = UIColor.black
        verbPanelState.text = Constants.VERB_FOLDER_NAME
        verbPanelState.font = UIFont.systemFont(ofSize: CGFloat(Constants.picturePanelFontSize), weight: .thin)
        verbPanelState.textColor = UIColor.lightGray
        objectPanelState.text = Constants.OBJECT_FOLDER_NAME
        objectPanelState.font = UIFont.systemFont(ofSize: CGFloat(Constants.picturePanelFontSize), weight: .thin)
        objectPanelState.textColor = UIColor.lightGray
        connectivesPanelState.text = Constants.CONNECTIVES_FOLDER_NAME
        connectivesPanelState.font = UIFont.systemFont(ofSize: CGFloat(Constants.picturePanelFontSize), weight: .thin)
        connectivesPanelState.textColor = UIColor.lightGray
        
        //Reloading Picker & Table View of Suggested sentences
        indexOfSelectedImageText = 0
        sentenceGeneratedFromCollectedWords = ""
        suggestedSentenceList.removeAll()
        sentenceListFromMatchingTappedImageWithCoreData=[""]
        sentenceRange = 30
        suggestedSentenceDisplay.reloadData()
        
    }
    
    //Settings button handler
    @objc func settingsTapped() {
        performSegue(withIdentifier: "settingsFromAdvanced", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View
        suggestedSentenceDisplay.delegate = self
        suggestedSentenceDisplay.dataSource = self
        suggestedSentenceDisplay.backgroundColor = Settings.sharedValues.viewBackgroundColor
        
        //Sets background color of Picture Panel ViewController
        self.view.backgroundColor = Settings.sharedValues.viewBackgroundColor
        
        //used to keep track of which user added which pictures
        let userPictures : UserPictures = UserPictures()
        
        //Add Settings button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
        //Getting all the image folder paths as URL arrays [URL]
        //There are THREE folders, subjects, objects, verbs
        let subjectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.SUBJECT_FOLDER_NAME)!
        let objectImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.OBJECT_FOLDER_NAME)!
        let verbImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.VERB_FOLDER_NAME)!
        let connectiveImagesUrlArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: Constants.CONNECTIVES_FOLDER_NAME)!

        let subjectFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: subjectImagesUrlArray)
        let objectFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: objectImagesUrlArray)
        let verbFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: verbImagesUrlArray)
        let connectiveFolderPath = UtilHelper.getFolderPathWithoutLastComponent(imageUrlArray: connectiveImagesUrlArray)

        //Getting all the directories where the user-defined images are stored
        let subjectFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.SUBJECT_FOLDER_NAME)
        let objectFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.OBJECT_FOLDER_NAME)
        let verbFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.VERB_FOLDER_NAME)
        let connectiveFolderDocumentDirectory = UtilHelper.getDocumentDirectory(atFolder: Constants.CONNECTIVES_FOLDER_NAME)
        
        //Getting all the file names of each folder and put them in String arrays [String]
        let subjectTitles = UtilHelper.getTitleArrays(subjectFolderPath)
        let objectTitles = UtilHelper.getTitleArrays(objectFolderPath)
        let verbTitles = UtilHelper.getTitleArrays(verbFolderPath)
        let connectiveTitles = UtilHelper.getTitleArrays(connectiveFolderPath)
        
        //Getting all the user-defined images' file names of each folder and put them in String arrays [String]
        let subjectDocumentTitles = userPictures.thisUserPictures( pictureNames: UtilHelper.getTitleArrays(subjectFolderDocumentDirectory))
        let objectDocumentTitles = userPictures.thisUserPictures( pictureNames: UtilHelper.getTitleArrays(objectFolderDocumentDirectory))
        let verbDocumentTitles = userPictures.thisUserPictures( pictureNames: UtilHelper.getTitleArrays(verbFolderDocumentDirectory))
        let connectivesDocumentTitles = UtilHelper.getTitleArrays(connectiveFolderDocumentDirectory)
        
        //Getting all the images of each foler and put them in UIImages arrays [UIImage]
        let subjectImages = UtilHelper.getImageArrays(subjectFolderPath, subjectTitles, subjectImagesUrlArray)
        let objectImages = UtilHelper.getImageArrays(objectFolderPath, objectTitles, objectImagesUrlArray)
        let verbImages = UtilHelper.getImageArrays(verbFolderPath, verbTitles, verbImagesUrlArray)
        let connectivesImages = UtilHelper.getDocumentImageArrays(connectiveFolderPath, connectiveTitles)
        
        //Getting all the user-defined images of each foler and put them in UIImages arrays [UIImage]
        let subjectDocumentImages = UtilHelper.getDocumentImageArrays(subjectFolderDocumentDirectory, subjectDocumentTitles)
        let objectDocumentImages = UtilHelper.getDocumentImageArrays(objectFolderDocumentDirectory, objectDocumentTitles)
        let verbDocumentImages = UtilHelper.getDocumentImageArrays(verbFolderDocumentDirectory, verbDocumentTitles)
        let connectivesDocumentImages = UtilHelper.getDocumentImageArrays(connectiveFolderDocumentDirectory, connectivesDocumentTitles)
        
        allTitles[0] = subjectTitles + subjectDocumentTitles
        allTitles[1] = verbTitles + verbDocumentTitles
        allTitles[2] = objectTitles + objectDocumentTitles
        allTitles[3] = connectiveTitles + connectivesDocumentTitles
        
        allImages[0] = subjectImages + subjectDocumentImages
        allImages[1] = verbImages + verbDocumentImages
        allImages[2] = objectImages + objectDocumentImages
        allImages[3] = connectivesImages + connectivesDocumentImages
        
        currentImages = allImages[collectionViewClick]
        currentTitles = allTitles[collectionViewClick]
        
        //Sets display of PicturePanel
        subjectPanelState.text = Constants.SUBJECT_FOLDER_NAME
        subjectPanelState.layer.borderWidth = 2.0
        subjectPanelState.layer.cornerRadius = 8
        subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat(Constants.picturePanelFontSizeBolded), weight: .bold)
        subjectPanelState.textColor = UIColor.black
        verbPanelState.text = Constants.VERB_FOLDER_NAME
        verbPanelState.layer.borderWidth = 2.0
        verbPanelState.layer.cornerRadius = 8
        verbPanelState.font = UIFont.systemFont(ofSize: CGFloat(Constants.picturePanelFontSize), weight: .thin)
        verbPanelState.textColor = UIColor.lightGray
        objectPanelState.text = Constants.OBJECT_FOLDER_NAME
        objectPanelState.layer.borderWidth = 2.0
        objectPanelState.layer.cornerRadius = 8
        objectPanelState.font = UIFont.systemFont(ofSize: CGFloat(Constants.picturePanelFontSize), weight: .thin)
        objectPanelState.textColor = UIColor.lightGray
        connectivesPanelState.text = Constants.CONNECTIVES_FOLDER_NAME
        connectivesPanelState.layer.borderWidth = 2.0
        connectivesPanelState.layer.cornerRadius = 8
        connectivesPanelState.font = UIFont.systemFont(ofSize: CGFloat(Constants.picturePanelFontSize), weight: .thin)
        connectivesPanelState.textColor = UIColor.lightGray
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
        if(wasPaused==true){
            self.mySynthesizer.continueSpeaking()
            wasPaused=false;
        }
        else{
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

// HEX Value to UIColor converter
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
extension AdvancedViewController : UICollectionViewDataSource {
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
        cell.buttonCell.setBackgroundImage(allImages[collectionViewClick % 4][indexPath.row], for: .normal)
        cell.cellNameAdvanced.text = UtilHelper.removeLastComponentOfString(allTitles[collectionViewClick % 4][indexPath.row], ".jpg")
        cell.cellNameAdvanced.textAlignment = .center

        cell.layer.borderWidth = 4
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 8
        cell.buttonHandler = { [weak self] button in
            self?.currenctSelectedWord = (UtilHelper.removeLastComponentOfString((self?.allTitles[((self?.collectionViewClick)! % 4)][indexPath.row])!, ".jpg"))
            self?.selectedImage = self?.allImages[((self?.collectionViewClick)! % 4)][indexPath.row]
            
            //adds images and text to subview at the top
            self?.sentenceImages.addImage(newImage: (self?.selectedImage), newText : (self?.currenctSelectedWord), maxSubViews: 7)
            if((self?.collectionViewClick)! < (self?.MAX_NUMBER_OF_CLICKS_ALLOWED)!) {
                self?.collectionViewClick = ((self?.collectionViewClick)! + 1)
            } else {
                //check if max number of images reached
                self?.collectionViewOutOfBoundClicked = true
            }
            
            self?.currentTitles = self?.allTitles[((self?.collectionViewClick)! % 4)]
            self?.currentImages = self?.allImages[((self?.collectionViewClick)! % 4)]
            collectionView.reloadData()
            self?.setSelectedStateStyle(viewClicked: (self?.collectionViewClick)! % 4)
            }

        return cell
    }
    
    func setSelectedStateStyle(viewClicked: Int) {
        switch ((self.collectionViewClick) % 4){
        case 0: //subject
            //bolding words to emphasize selection
            self.subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSizeBolded)), weight:.bold)
            self.subjectPanelState.textColor = UIColor.black
            
            //changing font and colour to give it the faded look
            self.verbPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.verbPanelState.textColor = UIColor.lightGray
            self.objectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.objectPanelState.textColor = UIColor.lightGray
            self.connectivesPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.connectivesPanelState.textColor = UIColor.lightGray
        case 1: //verb
            //bolding words to emphasize selection
            self.verbPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSizeBolded)), weight:.bold)
            self.verbPanelState.textColor = UIColor.black
            
            //changing font and colour to give it the faded look
            self.subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.subjectPanelState.textColor = UIColor.lightGray
            self.objectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.objectPanelState.textColor = UIColor.lightGray
            self.connectivesPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.connectivesPanelState.textColor = UIColor.lightGray

             sentenceRangeBasedOnFirstImage(collectedWordsSoFar: self.sentenceImages.selectedText[self.indexOfSelectedImageText as Int!] as String!)
            
        case 2://object
            //bolding words to emphasize selection
            self.objectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSizeBolded)), weight:.bold)
            self.objectPanelState.textColor = UIColor.black
            
            // changing font and colour to give it the faded look
            self.subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.subjectPanelState.textColor = UIColor.lightGray
            self.verbPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.verbPanelState.textColor = UIColor.lightGray
            self.connectivesPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.connectivesPanelState.textColor = UIColor.lightGray
        narrowTheRangeOfSuggestedSentences(&self.sentenceListFromMatchingTappedImageWithCoreData,self.sentenceImages.selectedText[self.indexOfSelectedImageText as Int!] as String!)

            
        case 3:
            //bolding words to emphasize selection
            self.connectivesPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSizeBolded)), weight:.bold)
            self.connectivesPanelState.textColor = UIColor.black
            
            // changing font and colour to give it the faded look
            self.subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.subjectPanelState.textColor = UIColor.lightGray
            self.verbPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.verbPanelState.textColor = UIColor.lightGray
            self.objectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.objectPanelState.textColor = UIColor.lightGray
            
        narrowTheRangeOfSuggestedSentences(&self.sentenceListFromMatchingTappedImageWithCoreData,self.sentenceImages.selectedText[self.indexOfSelectedImageText as Int!] as String!)

        default:
            //default will have a faded look
            self.subjectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.subjectPanelState.textColor = UIColor.lightGray
            self.verbPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.verbPanelState.textColor = UIColor.lightGray
            self.objectPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.objectPanelState.textColor = UIColor.lightGray
            self.connectivesPanelState.font = UIFont.systemFont(ofSize: CGFloat((self.picturePanelFontSize)), weight:.thin)
            self.connectivesPanelState.textColor = UIColor.lightGray
        }
    }
}



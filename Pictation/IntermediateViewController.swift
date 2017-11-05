import UIKit

class IntermediateViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    var currenctSelectedWord = ""
    @IBOutlet weak var outputSentenceText: UITextField!
    var selectedImage: UIImage!
    @IBOutlet weak var sentenceImages: ImageDisplay!
    
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return Asset.allImages.count
    }
    
    /// Create cell for each item
    // In buttonHandler, update currentSelectedWord and the selectedImage when "Make" button is clicked
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        cell.buttonCell.setBackgroundImage(Asset.allImages[indexPath.row].image, for: .normal)
        cell.buttonHandler = { [weak self] button in
            self?.currenctSelectedWord = Asset.allImages[indexPath.row].name
            self?.selectedImage = Asset.allImages[indexPath.row].image
            
            //adds images and text to subview at the top
            self?.sentenceImages.addImage(newImage: (self?.selectedImage), newText : (self?.currenctSelectedWord), maxSubViews: 3)

            
            //print("bentonk: buttonHandler on item: \(indexPath.item) selected")
        }
        //cell.buttonCell.setAttributedTitle(NSAttributedString.init(string: "test"), for: .normal)
        
        return cell
    }
}


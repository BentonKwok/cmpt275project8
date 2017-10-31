//
//  BeginnerLevelViewController.swift
//  Pictation
//
//  Created by Benton on 2017-10-26.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit

class BeginnerLevelViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var currenctSelectedWord = ""
    @IBOutlet weak var outputSentenceText: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!

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
extension BeginnerLevelViewController : UICollectionViewDataSource {
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
            self?.selectedImage.image = Asset.allImages[indexPath.row].image
            
            print("bentonk: buttonHandler on item: \(indexPath.item) selected")
        }
        //cell.buttonCell.setAttributedTitle(NSAttributedString.init(string: "test"), for: .normal)
        
        return cell
    }
}

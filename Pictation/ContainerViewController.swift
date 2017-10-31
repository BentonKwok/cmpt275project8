////
////  ContainerViewController.swift
////  Pictation
////
////  Created by Benton on 2017-10-29.
////  Copyright © 2017 Benton. All rights reserved.
////
//
//import UIKit
//
//class ContainerViewController: UIViewController {
//
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    var subjectsArray : NSArray!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
///// Collection View Impl
//extension ContainerViewController : UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        print("styuen: should select item at location \(indexPath.item)")
//        return true
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("styuen: item: \(indexPath.item) was selected")
//    }
//}
//
///// Collection View data
//extension ContainerViewController : UICollectionViewDataSource {
//    /// Number of section and items in each section
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return Asset.allImages.count
//    }
//
//    /// Create cell for each item
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
//        cell.buttonCell.setBackgroundImage(Asset.allImages[indexPath.row].image, for: .normal)
//        cell.buttonHandler = { [weak self] button in
//            print("styuen: buttonHandler on item: \(indexPath.item) selected")
//        }
//        //cell.buttonCell.setAttributedTitle(NSAttributedString.init(string: "test"), for: .normal)
//
//        return cell
//    }
//}
//
////extension ContainerViewController : UICollectionViewDataSource, UICollectionViewDelegate {
////    func collectionV
////}
//

//
//  BeginnerLevelViewController.swift
//  Pictation
//
//  Created by Benton on 2017-10-26.
//  Copyright © 2017 Benton. All rights reserved.
//

import UIKit

class BeginnerLevelViewController: UIViewController {

    var currenctSelectedWord = ""
    @IBOutlet weak var OutputSentence: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
//    @IBAction func make(_ sender: Any) {
//        if (OutputSentence.text != nil) {
//            OutputSentence.text = currenctSelectedWord
//        }
//    }
//    @IBAction func apple(_ sender: Any) {
//        currenctSelectedWord = "Apple"
//        imageView.image = UIImage(named: "apple")
//    }
//    @IBAction func cucumber(_ sender: Any) {
//        currenctSelectedWord = "Cucumber"
//        imageView.image = UIImage(named: "cucumber")
//    }

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

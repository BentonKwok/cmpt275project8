import UIKit

private let reuseIdentifier = "Cell"

class myCell: UICollectionViewCell {
    
    var buttonHandler: ((UIButton) -> Void)?

    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellNameIntermediate: UILabel!
    @IBOutlet weak var cellNameAdvanced: UILabel!
    //closure from BeginnerViewController. Handling button click
    @IBAction func cellButtonHandler(_ sender: UIButton) {
        buttonHandler?(sender)
    }
    @IBOutlet weak var buttonCell: UIButton!
}

import UIKit

class LevelViewController: UIViewController {

    @IBOutlet weak var beginnerButton: UIButton!
    
    @IBOutlet weak var intermediateButton: UIButton!
    
    @IBOutlet weak var advancedButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func buttonHandler(button: UIButton) {
        switch button {
       case beginnerButton:
            beginnerButtonHandler(sender: button)
        case intermediateButton:
            intermediateButtonHandler(sender: button)
        case advancedButton:
            beginnerButtonHandler(sender: button)
        case backButton:
            backButtonHandler(sender: button)
        default:
            break
        }
    }
    @IBAction func beginnerButtonHandler(sender: UIButton) {
        performSegue(withIdentifier: "toBeginnerSegue", sender: self)
    }
    func intermediateButtonHandler(sender: UIButton){
        performSegue(withIdentifier: "toIntermediateSegue", sender: self)
    }
    @IBAction func backButtonHandler(sender: UIButton) {
        performSegue(withIdentifier: "segueBackToViewController", sender: self)
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

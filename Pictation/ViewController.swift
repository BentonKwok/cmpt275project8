import UIKit

class ViewController: UIViewController {
    
    @IBAction func GuestButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "toLevelViewSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


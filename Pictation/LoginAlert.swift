//
//  LoginAlert.swift
//  Pictation
//
//  Created by Jameson Roy on 2017-11-28.
//  Copyright © 2017 Benton. All rights reserved.
//

/* Much of code here is take from: https://blog.apoorvmote.com/how-to-create-login-screen-with-alert-view/ */
import UIKit

var userPass : String?

class LoginAlert{

    class func userPasswordAlert(viewController : UIViewController, password: String, segue: String) {
        userPass = password
        
        let loginController = UIAlertController(title: "Login", message: "Enter Password", preferredStyle: UIAlertControllerStyle.alert)
        
        //Action for when login button is pressed
        let loginAction = UIAlertAction(title: "Log In", style: UIAlertActionStyle.default) { (action:UIAlertAction) -> Void in
            viewController.performSegue(withIdentifier: segue, sender: viewController)
        }
        
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: UIAlertActionStyle.destructive, handler: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        loginController.addTextField { (textField:UITextField!) -> Void in
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            
        }
        // add the button actions
        loginController.addAction(loginAction)
        loginController.addAction(forgotPasswordAction)
        loginController.addAction(cancelAction)
        
        loginController.actions[0].isEnabled = false
        //***find a way to  make the button look enabled when it isn't
        // create the alert view popup
        viewController.present(loginController, animated: true, completion: nil)
    }

    @objc class func textChanged(_ sender: Any) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let loginController = resp as! UIAlertController
        loginController.actions[0].isEnabled = (tf.text == userPass)
    }
}

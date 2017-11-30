//
//  LoginAlert.swift
//  Pictation
//
//  Created by Jameson Roy on 2017-11-28.
//  Copyright © 2017 Benton. All rights reserved.
//

/* Code here is taken from and based off: https://blog.apoorvmote.com/how-to-create-login-screen-with-alert-view/ */
import UIKit
import CoreData

var userPass : String?
var userAnswer : String?

class LoginAlert{
    
    //Creates a popup for the login when a user is selected from the user screen
    class func userPasswordAlert(viewController : UIViewController, user: NSManagedObject, segue: String) {
        userPass = (user.value(forKey: "password") as! String)
        
        let loginController = UIAlertController(title: "Login", message: "Enter Password", preferredStyle: UIAlertControllerStyle.alert)
        
        //Action for when login button is pressed
        let loginAction = UIAlertAction(title: "Log In", style: UIAlertActionStyle.default) { (action:UIAlertAction) -> Void in
            viewController.performSegue(withIdentifier: segue, sender: viewController)
        }
        
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: UIAlertActionStyle.destructive) { (action:UIAlertAction) -> Void in
                //call func for forgot password popup
                self.passwordResetAlert(viewController: viewController, user: user, segue: segue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        loginController.addTextField { (textField:UITextField!) -> Void in
            textField.addTarget(self, action: #selector(self.passwordCorrect), for: .editingChanged)
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
    
    //create a popup prompting for security question and answer in settings
    class func userSecurityQuestionAlert(viewController : UIViewController, user: NSManagedObject, passwordSwitch: UISwitch?, passwordTextField: UITextField) {
    
        let securityController = UIAlertController(title: "Security Question", message: "Enter Security Question and Answer", preferredStyle: UIAlertControllerStyle.alert)
        
        //Action for when save button is pressed
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { (action:UIAlertAction) -> Void in
           
            let questionTextField = securityController.textFields![0]
            
            let answerTextField = securityController.textFields![1]
            
            user.setValue(questionTextField.text, forKey: "securityQuestion")
            user.setValue(answerTextField.text, forKey: "securityAnswer")
            if (passwordSwitch) != nil{
                passwordTextField.isEnabled = true
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action:UIAlertAction) -> Void in
            if (passwordSwitch) != nil{
                passwordSwitch?.setOn(false, animated: true)
                passwordTextField.isUserInteractionEnabled = false
            }
        }
        //add the question and answer text fields
        securityController.addTextField { (questionTextField:UITextField!) -> Void in
            questionTextField.placeholder = "Enter Security Question"
        }
        securityController.addTextField { (answerTextField:UITextField!) -> Void in
            answerTextField.addTarget(self, action: #selector(self.bothTextChanged), for: .editingChanged)
            answerTextField.placeholder = "Enter Answer"
        }
        
        // add the button actions
        securityController.addAction(saveAction)
        securityController.addAction(cancelAction)
        
        securityController.actions[0].isEnabled = false
        // create the alert view popup
        viewController.present(securityController, animated: true, completion: nil)
    }
    
    
    //Creates a popup for the password recovery when user forget password
    class func passwordResetAlert(viewController : UIViewController, user: NSManagedObject, segue: String) {
        userAnswer = (user.value(forKey: "securityAnswer") as! String)
        
        let resetController = UIAlertController(title: "Reset Password", message: "Security Question: " + (user.value(forKey: "securityQuestion") as! String), preferredStyle: UIAlertControllerStyle.alert)
        
        //Action for when reset button is pressed
        let resetAction = UIAlertAction(title: "Reset", style: UIAlertActionStyle.destructive) { (action:UIAlertAction) -> Void in
            self.newPasswordAlert(viewController: viewController, user: user, segue: segue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        resetController.addTextField { (textField:UITextField!) -> Void in
            textField.addTarget(self, action: #selector(self.answerEntered), for: .editingChanged)
            textField.placeholder = "Answer"
            
        }
        // add the button actions
        resetController.addAction(resetAction)
        resetController.addAction(cancelAction)
        
        resetController.actions[0].isEnabled = false
        // create the alert view popup
        viewController.present(resetController, animated: true, completion: nil)
    }
    
    //create a popup prompting for saving new password after reset
    class func newPasswordAlert(viewController : UIViewController, user: NSManagedObject, segue: String) {
        
        let newPasswordController = UIAlertController(title: "New Password", message: "Enter New Password", preferredStyle: UIAlertControllerStyle.alert)
        
        //Action for when save button is pressed
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { (action:UIAlertAction) -> Void in
            
            let passwordTextField = newPasswordController.textFields![1]
            
            user.setValue(passwordTextField.text, forKey: "password")
            
            viewController.performSegue(withIdentifier: segue, sender: viewController)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        //add the password and confirm password textfields
        newPasswordController.addTextField { (passwordTextField:UITextField!) -> Void in
            passwordTextField.placeholder = "Enter Password"
            passwordTextField.isSecureTextEntry = true
        }
        newPasswordController.addTextField { (confirmTextField:UITextField!) -> Void in
            confirmTextField.addTarget(self, action: #selector(self.passwordsEqual), for: .editingChanged)
            confirmTextField.placeholder = "Confirm Password"
            confirmTextField.isSecureTextEntry = true
        }
        
        // add the button actions
        newPasswordController.addAction(saveAction)
        newPasswordController.addAction(cancelAction)
        
        newPasswordController.actions[0].isEnabled = false
        // create the alert view popup
        viewController.present(newPasswordController, animated: true, completion: nil)
    }
    
    //Keeps login button disabled until correct password is entered
    @objc class func passwordCorrect(_ sender: Any) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let loginController = resp as! UIAlertController
        loginController.actions[0].isEnabled = (tf.text == userPass)
    }
    
    //keeps save button disabled until both a question and answer have been entered
    @objc class func bothTextChanged(_ sender: Any) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let securityController = resp as! UIAlertController
        securityController.actions[0].isEnabled = (tf.text != "" && securityController.textFields?.first?.text != "")
    }
    
    //keeps reset button disabled until correct answer to security question has been entered
    @objc class func answerEntered(_ sender: Any) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let securityController = resp as! UIAlertController
        securityController.actions[0].isEnabled = (tf.text == userAnswer)
    }
    
    //keeps save button disabled until the two passwords are equal
    @objc class func passwordsEqual(_ sender: Any) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let securityController = resp as! UIAlertController
        securityController.actions[0].isEnabled = (tf.text == securityController.textFields?.first?.text)
    }
    
}

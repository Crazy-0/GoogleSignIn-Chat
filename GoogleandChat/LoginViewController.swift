//
//  LoginViewController.swift
//  GoogleandChat
//
//  Created by 廖堉筌 on 2016/8/21.
//  Copyright © 2016年 CrazyQuan. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    
    @IBOutlet weak var anonymouslyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anonymouslyButton.layer.borderWidth = 1.5
        anonymouslyButton.layer.borderColor = UIColor.whiteColor().CGColor
        // Do any additional setup after loading the view.
        
        // Google Login ID
        GIDSignIn.sharedInstance().clientID = "592585255566-3gotdufljs4lt7pdvhcerbqvjhbjr31g.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginAnonymouslyDidTapped(sender: AnyObject) {
        Helper.helper.loginAnonymouslyDidTapped()
    }
    
    @IBAction func googleLoginDidTapped(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        // The authentication object for the user.
        print(user.authentication)
        Helper.helper.loginWithGoogle(user.authentication)
        
        if error != nil{
            print(error!.localizedDescription)
            return
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboard){
        
    }
    
}

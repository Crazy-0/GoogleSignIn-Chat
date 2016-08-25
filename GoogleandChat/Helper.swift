//
//  Helper.swift
//  GoogleandChat
//
//  Created by 廖堉筌 on 2016/8/23.
//  Copyright © 2016年 CrazyQuan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
class Helper {
    static let helper = Helper()
    
    @IBAction func loginAnonymouslyDidTapped() {
        print("Sccess!!LoginAnonymous------------------------------")
        //switch view by setting Navigation Controller as rootView Controller
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (anonymouslyUsers: FIRUser?, error: NSError?) in
            
            if error == nil {
                print("UsersID: .\(anonymouslyUsers?.uid)")
                self.swithToNavigationVewController()
                
            } else {
                print(error!.localizedDescription)
                return
            }
            
        })

    }
    
    func loginWithGoogle(authentication:GIDAuthentication){
        print("Sccess!!GoogleLogin--------------------------------")
        
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        FIRAuth.auth()?.signInWithCredential(credential, completion:
            { (user:FIRUser?, error:NSError?) in
                if error != nil{
                    print(error!.localizedDescription)
                } else {
                    self.swithToNavigationVewController()
                    
                    print(user?.displayName)
                    print(user?.email)
                }
        })
    }
    
    func swithToNavigationVewController(){
        //轉頁面
        // Create a main storyboard instance
        // From main storyboard instantiate a Navigation Controller
        // Get the app delegate
        // See Navigation Controller as root View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = navVC
    }
    
    
    
}//End







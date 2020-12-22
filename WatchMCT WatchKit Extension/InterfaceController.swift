//
//  InterfaceController.swift
//  WatchMCT WatchKit Extension
//
//  Created by Apple on 21/12/20.
//

import WatchKit
import Foundation
import AuthenticationServices
import UIKit;
import Alamofire

class InterfaceController: WKInterfaceController, ASAuthorizationControllerDelegate {

    
    @IBOutlet weak var btnGoogleA: WKInterfaceButton!
    
    @IBOutlet weak var btnFBA: WKInterfaceButton!
    
    @IBOutlet weak var appleLogin: WKInterfaceAuthorizationAppleIDButton!
    let defaults = UserDefaults.standard

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        let parameters: [String: Any] = [
            "user_emial" : "pavanWatch@gmail.com",
        ]
        AF.request("http://54.242.174.119:3000/user/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
            }
        
    }

    @IBAction func btnAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        appleIDProvider.getCredentialState(forUserID: "com.mct.WatchMCT.watchkitapp.watchkitextension") { (credential, error) in

            switch credential {
            case .authorized:
                print("authorized for sign in")
                break
            case .notFound, .revoked, .transferred:
                print("ready to logout")
                break
            default:
                print("Apple sign in credential state unidentified")
            }
            
        }

        performExistingAccountSetupFlows()
    }
 

    override func willActivate() {
        
        
        // This method is called when watch view controller is about to be visible to user
    }
    

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error){
  print("\(error)")
    }
    func performExistingAccountSetupFlows() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
           let request = appleIDProvider.createRequest()
           request.requestedScopes = [.fullName, .email]
           
           let authorizationController = ASAuthorizationController(authorizationRequests: [request])
           authorizationController.delegate = self
         //  authorizationController.presentationContextProvider = self
           authorizationController.performRequests()
        
      }
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

        let userIdentifier = credential.user
        let token = credential.identityToken
        let authCode = credential.authorizationCode
        let realUserStatus = credential.realUserStatus
        let mail = credential.email // nil
        let name = credential.fullName // nil
        
        
        
        
        print(userIdentifier)
        print(token)
        print(authCode)
        print(realUserStatus)
        print(mail)
        print(name)
        
//        defaults.set(userIdentifier, forKey: userIdentifier)
//        defaults.set(token, forKey: "token")
//        defaults.set(authCode, forKey: "authCode")
//        defaults.set(realUserStatus, forKey: "realUserStatus")
//        defaults.set(mail, forKey: "mail")
//        defaults.set(mail, forKey: "mail")
       
        print(credential)
        
        let h0 = { print("ok")}

        let action1 = WKAlertAction(title: "Approve", style: .default, handler:h0)
        let action2 = WKAlertAction(title: "Decline", style: .destructive) {}
        let action3 = WKAlertAction(title: "Cancel", style: .cancel) {}

        presentAlert(withTitle: "Voila", message: "\(token)", preferredStyle: .actionSheet, actions: [action1,action2,action3])

        

    }
    func showPopup(){

        let h0 = { print("ok")}

        let action1 = WKAlertAction(title: "Approve", style: .default, handler:h0)
        let action2 = WKAlertAction(title: "Decline", style: .destructive) {}
        let action3 = WKAlertAction(title: "Cancel", style: .cancel) {}

        presentAlert(withTitle: "Voila", message: "", preferredStyle: .actionSheet, actions: [action1,action2,action3])

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }


}


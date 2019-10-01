//
//  ViewController.swift
//  arcs
//
//  Created by Aakarsh S on 04/01/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import Toast_Swift

class ViewController: UIViewController {

    @IBOutlet weak var email: DesignableUITextField!
    @IBOutlet weak var password: DesignableUITextField!
    @IBOutlet weak var loginButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        
        super.viewDidLoad()
        email.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
         email.layer.borderWidth = 2.0
        
        password.layer.borderWidth = 2.0
        password.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        signUp.layer.cornerRadius=signUp.frame.size.height/2
        loginButton.layer.cornerRadius=loginButton.frame.size.height/2
        email.layer.cornerRadius=email.frame.size.height/2
        password.layer.cornerRadius=password.frame.size.height/2
       
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var signUp: UIButton!
    
    @IBAction func loginUser(_ sender: Any) {
     
        acceptLogin { (success) in
            if success {
                let url2 = "https://register.ieeecsvit.com/api/user/app-profile"
                //        print(UserDefaults.standard.string(forKey: "token"),"hello")
                if let token=UserDefaults.standard.string(forKey: "token"){
                    let header = ["token" : token]
                    
                    
                    
                    Alamofire.request(url2, method: .get, headers: header)
                        .validate()
                        .responseJSON { (response) in
                            
                            
                            print(response)
                            
                            
                            switch response.result {
                                
                            case .success(let value):
                                let swiftyjson = JSON(value).object
                                print("123")
                                
                                let array = swiftyjson as? [String: AnyObject]
                                
                                
                                if let name=array?["name"]
                                {
                                    
                                    UserDefaults.standard.set(name, forKey: "name")
                                }
                                if let email=array?["email"]{
                                    UserDefaults.standard.set(email, forKey: "email")
                                }
                                if let reg=array?["registration"]{
                                    UserDefaults.standard.set(reg, forKey: "regno")
                                }
                                if let reg=array?["contact"]{
                                    UserDefaults.standard.set(reg, forKey: "phoneno")
                                }
                                
                                
                                
                                
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
                                
                                
                            }
                    }
                    
                }
                
            } else {
                print("error")
                //toast
                
            }
        }
      
    }
    typealias CompletionHandler = (_ success: Bool) -> Void
    func acceptLogin(completionHandler: @escaping CompletionHandler){
        
        if self.email.text?.isEmpty==false && self.password.text?.isEmpty==false{
            
            let url = "https://register.ieeecsvit.com/api/login"
            print(url)
            
           
            self.view.makeToast("Please wait..")
            let parameters: [String: Any] = [
                "email": self.email.text!,
                "password": self.password.text!
            ]
            
            print(parameters)
            
            Alamofire.request(URL(string: url)!, method: .post, parameters: parameters, headers: nil)
                
                .responseJSON { (response) in
                    
                    switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        let stringValue = json["success"].rawString()
                        if stringValue == "true"{
                            
                            let headerJson=JSON(response.response?.allHeaderFields as Any)
                            if let token=headerJson["token"].rawString()
                            {
                                UserDefaults.standard.set(token,forKey:"token")
                                
                            }
                            
                            
                            
                            
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            self.performSegue(withIdentifier: "loginSuccess", sender: self)
                            
                            
                            
                                
                            
                            
                            print(headerJson)
                        }
                        else if json["message"].rawString()=="User already registered"{
                            let message = json["message"].rawString()
                            let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: nil)
                            print("hellothere")
                        }
                        else{
                            let message = json["message"].rawString()
                            let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
//                        let stringValue = json["status"].rawString()
//                        if stringValue == "1" {
//                            self.performSegue(withIdentifier: "updateProfileSegue", sender: self)
//                        }else{
//                           // print("error in sign up")
//                        }
                        completionHandler(true)
                        break
                    case .failure(let error):
                        print(error)
                        completionHandler(false)
                        
                    }
                    
            }
            
        }else{
            let alertController = UIAlertController(title: "Oops", message: "Please enter all the fields", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSuccess"{
            //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            //            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "webViewController") as! webViewController
            //
            //            nextViewController.mainURL = "https://register.ieeecsvit.com/login"
            
            
            
            
            //
            
        }
        
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


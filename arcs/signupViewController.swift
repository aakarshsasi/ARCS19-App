//
//  signupViewController.swift
//  arcs
//
//  Created by Aakarsh S on 30/01/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import SwiftyJSON
import Toast_Swift
class signupViewController: UIViewController,UIGestureRecognizerDelegate {

  
    @IBOutlet weak var gender: DropDown!
    @IBOutlet weak var nPhone: DesignableUITextField!
    @IBOutlet weak var tshirtSize: DropDown!
    @IBOutlet weak var nEmail: DesignableUITextField!
    @IBOutlet weak var nPassword: DesignableUITextField!
    @IBOutlet weak var nName: DesignableUITextField!
    @IBOutlet weak var nConfirmPassword: DesignableUITextField!
    @IBOutlet weak var regNumber: DesignableUITextField!
    @IBOutlet weak var university: DesignableUITextField!
    @IBOutlet weak var roomNumber: DesignableUITextField!
    @IBOutlet weak var ieeeNumber: DesignableUITextField!
    @IBOutlet weak var ieeeSection: DesignableUITextField!
    @IBOutlet weak var vitian: UISwitch!
    @IBOutlet weak var SignUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tshirtSize.optionArray=["XS","S","M","L","XL","XXL"]
        gender.optionArray=["Male","Female","Other"]
        nPhone.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        nPhone.layer.borderWidth = 2.0
        nEmail.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        nEmail.layer.borderWidth = 2.0
        nPassword.layer.borderWidth = 2.0
        nPassword.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        nPhone.layer.borderWidth = 2.0
    
        nName.layer.borderWidth = 2.0
        nName.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        nConfirmPassword.layer.borderWidth = 2.0
        nConfirmPassword.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        university.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        university.layer.borderWidth = 2.0
        regNumber.layer.borderWidth = 2.0
        regNumber.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        roomNumber.layer.borderWidth = 2.0
        roomNumber.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        ieeeNumber.layer.borderWidth = 2.0
        ieeeNumber.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        ieeeSection.layer.borderWidth = 2.0
        ieeeSection.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
    tshirtSize.selectedRowColor=UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0)
        tshirtSize.layer.borderWidth=2.0
        tshirtSize.layer.borderColor=UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        gender.layer.borderWidth=2.0
        gender.layer.borderColor=UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        gender.selectedRowColor=UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0)
        regNumber.isHidden=true
        roomNumber.isHidden=true
        self.regNumber.autocapitalizationType = .allCharacters
        SignUpButton.layer.cornerRadius=SignUpButton.frame.size.height/2
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func isVitian(_ sender: Any) {
        if vitian.isOn==true{
        regNumber.isHidden=false
            roomNumber.isHidden=false
            university.text="VIT Vellore"
            university.isEnabled=false
    }
        if vitian.isOn==false{
            regNumber.isHidden=true
            regNumber.text=""
            roomNumber.isHidden=true
            roomNumber.text=""
            university.text=""
            university.isEnabled=true
            
        }
    }
    func acceptSignUp(){
        
        func isValidEmail(testStr:String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: testStr)
        }
        if (self.nEmail.text?.isEmpty==false && self.nPassword.text?.isEmpty==false && self.nConfirmPassword.text?.isEmpty==false && self.nPhone.text?.isEmpty==false && self.nName.text?.isEmpty==false && self.tshirtSize.text?.isEmpty==false && self.university.text?.isEmpty==false && vitian.isOn==false)||(self.nEmail.text?.isEmpty==false && self.nPassword.text?.isEmpty==false && self.nConfirmPassword.text?.isEmpty==false && self.nPhone.text?.isEmpty==false && self.nName.text?.isEmpty==false && self.tshirtSize.text?.isEmpty==false && self.university.text?.isEmpty==false && vitian.isOn==true&&regNumber.text?.isEmpty==false && roomNumber.text?.isEmpty==false){
            if self.nPassword.text==self.nConfirmPassword.text{
                
            if (ieeeNumber.text?.isEmpty==true && ieeeSection.text?.isEmpty==true) || (ieeeNumber.text?.isEmpty==false && ieeeSection.text?.isEmpty==false)
            { if(isValidEmail(testStr: self.nEmail.text!)){
                
                if(self.nPhone.text?.count==10)
                {
                    self.view.makeToast("Please wait..")
                
            let url = "https://register.ieeecsvit.com/api/register-ios"
            print(url)
            
            
            
            let parameters: [String: Any] = [
                "email": self.nEmail.text!,
                "password": self.nPassword.text!,
                "gender": self.gender.text!,
                "room": self.roomNumber.text!,
                "memberno": self.ieeeNumber.text!,
                "contact": self.nPhone.text!,
                "tShirtSize": self.tshirtSize.text!,
                "section": self.ieeeSection.text!,
                "university": self.university.text!,
                "registration": self.regNumber.text!,
                "name": self.nName.text!
                
                
                
                
            ]
            
            print(parameters)
            
            Alamofire.request(URL(string: url)!, method: .post, parameters: parameters, headers: nil)
                .responseJSON { (response) in
                print(response)
                    
                    switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        let stringValue = json["success"].rawString()
                        
                        if stringValue == "true"{
                            self.performSegue(withIdentifier: "registerSuccess", sender: self)
                            self.view.makeToast("Registration Successful. Login to Continue")
                
                        }else{
//                            let message = json["message"].rawString()
                            
                            let message = json["error"].rawString()
                            let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        
                    }
                    
            }
                }else{
                  self.view.makeToast("Mobile Number Should be 10 digits")
                }
            }else{
                self.view.makeToast("Enter Valid Email address.")
                
                }
                
            }else{
               
                self.view.makeToast("Enter both IEEE member number and section, else leave both empty")
                }
            
            }else{
               
                self.view.makeToast("Password and Confirm Password doesn't match")
            }
        }else{
            let alertController = UIAlertController(title: "Oops", message: "Please fill all the fields to proceed", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerSuccess"{
            //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            //            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "webViewController") as! webViewController
            //
            //            nextViewController.mainURL = "https://register.ieeecsvit.com/login"
            
            
            
            
            //
            
        }
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func SignUp(_ sender: Any) {
        
        acceptSignUp()
    }
    //for dropddown
//    dropDown.didSelect{(selectedText , index ,id) in
//    self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


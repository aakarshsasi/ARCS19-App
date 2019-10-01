//
//  profileViewController.swift
//  arcs
//
//  Created by Aakarsh S on 22/02/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class profileViewController: UIViewController,iCarouselDelegate,iCarouselDataSource {
   let defaults = UserDefaults.standard
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return registered.count
    }
    
    var imageWorkshopSet=[UIImage(named:"blockchain"),UIImage(named:"machinelearning"),UIImage(named:"uiux"),UIImage(named:"cybersecurity"),UIImage(named:"cloud"),UIImage(named:"combos")]
    var eventNames=["Machine Learning Workshop","Cloud Computing Workshop","UI/UX Workshop","Blockchain and Cryptocurrency Workshop","Cyber-Security Workshop","ARCS Combo 1","ARCS Combo 2","Workshop Combo 2","Workshop Combo 1","Convoke'19"]
    var registered:[String]=[]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewRegisteredEvents { (success) in
            if success {
                if (self.registered.count>0)
                {
                    self.registeredEvents.text="Your registered Events"
                    self.eventName.text=self.registered[0]
                    self.regEvents.reloadData()
                    
                }
                else{
                    self.registeredEvents.text="No Events Registered"
                }
                
            } else {
                print("error")
                //toast
                
            }
            
        }
       
        setupNavForDefaultMenu()
        
        
        
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = leftBarItem
      
        
        title = "Profile"
        
    }
    
    
    private func setupNavForDefaultMenu() {
        // Revert navigation bar translucent style to default
        navigationBarNonTranslecentStyle()
        
        // Update side menu after reverted navigation bar style
        sideMenuManager?.instance()?.menu?.isNavbarHiddenOrTransparent = false
        navigationItem.hidesBackButton = true
    }
    
   
    @objc func toggleSideMenu() {
        sideMenuManager?.toggleSideMenuView()
    }
    
 
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var regView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var regEvents: iCarousel!
    @IBOutlet weak var regNo: UILabel!
    @IBOutlet weak var registeredEvents: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNo: UILabel!
    
    @IBOutlet weak var eventName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regView.layer.shadowColor = UIColor.gray.cgColor
        regView.layer.shadowOpacity = 0.8
        regView.layer.shadowOffset = CGSize.zero
        regView.layer.shadowRadius = 5
        regView.layer.cornerRadius = regView.frame.size.height/2
        emailView.layer.shadowColor = UIColor.gray.cgColor
        emailView.layer.shadowOpacity = 0.8
        emailView.layer.shadowOffset = CGSize.zero
        emailView.layer.shadowRadius = 5
        emailView.layer.cornerRadius = emailView.frame.size.height/2
        mobileView.layer.shadowColor = UIColor.gray.cgColor
        mobileView.layer.shadowOpacity = 0.8
        mobileView.layer.shadowOffset = CGSize.zero
        mobileView.layer.shadowRadius = 5
        mobileView.layer.cornerRadius = mobileView.frame.size.height/2
        profilePicture.layer.shadowColor = UIColor.gray.cgColor
        profilePicture.layer.shadowOpacity = 0.8
        profilePicture.layer.shadowOffset = CGSize.zero
        profilePicture.layer.shadowRadius = 5
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
        
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "qr-code"), style: .plain, target: self, action: #selector(qrbutton))
        rightBarItem.tintColor=UIColor.black
        self.navigationItem.rightBarButtonItem = rightBarItem
      
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(profileViewController.selectImage))
        profilePicture.addGestureRecognizer(tapGesture)
      profilePicture.isUserInteractionEnabled=true
        
        
        if UserDefaults.standard.string(forKey: "email") != nil{
        regNo.text=UserDefaults.standard.string(forKey: "regno")
            phoneNo.text=UserDefaults.standard.string(forKey: "phoneno")
            email.text=UserDefaults.standard.string(forKey: "email")
            nameLbl.text=UserDefaults.standard.string(forKey: "name")
            
        }
        else{
            self.view.makeToast("Failed to Load.")
        }
        
        regEvents.isPagingEnabled=true
        if let data=UserDefaults.standard.object(forKey: "savedImage")
        {
            profilePicture.image=UIImage(data: data as! Data)
        }
       
    }
    @objc func selectImage()
    {
        let picker=UIImagePickerController()
        picker.delegate=self
        present(picker, animated: true)
        
        
    }
    typealias CompletionHandler = (_ success: Bool) -> Void
    func viewRegisteredEvents(completionHandler: @escaping CompletionHandler){
        
        
        
            
            let url = "https://register.ieeecsvit.com/api/user/app-receipt"
            if let token=UserDefaults.standard.string(forKey: "token"){
                let header = ["token" : token]
                
                
                
                Alamofire.request(url, method: .get, headers: header)
                    .validate()
                    .responseJSON { (response) in
                        
                        
                        
                        
                        
                        switch response.result {
                            
                        case .success(let value):
                            if let swiftyjson = JSON(value).array{
                            
                                for element in swiftyjson{
                            let dict = element.dictionary
                                    if let eve=dict?["eventName"]?.string{
                                       let evesplit = eve.components(separatedBy: "+")
                                        for el in evesplit{
                                        self.registered.append(el)
                                        }
                                        
                            }
                                    self.registered = self.registered.filter(){$0 != ""}
                                    
                        }
                                print(self.registered)
                    }
                            completionHandler(true)
                            
                            break
                        case .failure(let error):
                            print(error.localizedDescription)
                            completionHandler(false)
                        }
                }
                
                
            }
        }
    
    
//    @IBAction func qrCodeButton(_ sender: Any) {
//        let vc=self.storyboard!.instantiateViewController(withIdentifier: "qrCodeViewController")
//        present(vc, animated: true, completion: nil)
//        print("yes")
//
//    }
    
    @objc func qrbutton() {
        print("qr button")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "qrCodeViewController") as! qrCodeViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
       print("executed")
        
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView=UIView(frame: CGRect(x: 0, y: 0, width: 200 , height: 200))
        tempView.backgroundColor=UIColor.white
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: tempView.frame.size.width-20 , height: tempView.frame.size.height-20))
       imageView.center = CGPoint(x: tempView.frame.size.width  / 2,
                                     y: tempView.frame.size.height / 2)
        
        if registered[index]==eventNames[0]{
            imageView.image = UIImage(named:"machinelearning")
        }
       else if registered[index]==eventNames[1]{
            imageView.image = UIImage(named:"cloud")
        }
        else if registered[index]==eventNames[2]{
            imageView.image = UIImage(named:"uiux")
        }
        else if registered[index]==eventNames[3]{
            imageView.image = UIImage(named:"blockchain")
        }
       else if registered[index]==eventNames[4]{
            imageView.image = UIImage(named:"cybersecurity")
        }
        else if registered[index]==eventNames[5]{
            imageView.image = UIImage(named:"combos-black")
        }
        else if registered[index]==eventNames[6]{
            imageView.image = UIImage(named:"combos-black")
        }
        else if registered[index]==eventNames[7]{
            imageView.image = UIImage(named:"combos-black")
        }
        else if registered[index]==eventNames[8]{
            imageView.image = UIImage(named:"combos-black")
        }
        else if registered[index]==eventNames[9]{
            imageView.image = UIImage(named:"convoke-black")
        }
        
        
        
        
        imageView.layer.cornerRadius=20
        tempView.layer.cornerRadius=20
        
        tempView.addSubview(imageView)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
        imageView.clipsToBounds = true
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option==iCarouselOption.spacing{
            return value*1.1
        }
        return value
    }
    
 
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        if self.registered.isEmpty{
            return
            
    }
        else
        {
            eventName.text=registered[regEvents.currentItemIndex]
        }
    }
    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension profileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    // Code to store image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image=info[UIImagePickerController.InfoKey.originalImage]{
            profilePicture.image=(image as! UIImage)
            let imageData:NSData=profilePicture.image!.pngData()! as NSData
            UserDefaults.standard.set(imageData,forKey: "savedImage")
          
            
//            let saveImage = (image as! UIImage).pngData() as NSData?
//            defaults.set(saveImage, forKey: "test")
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    

}

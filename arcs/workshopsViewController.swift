//
//  workshopsViewController.swift
//  arcs
//
//  Created by Aakarsh S on 04/02/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import WebKit
import FirebaseDatabase
import Toast_Swift

class workshopsViewController: UIViewController,iCarouselDelegate,iCarouselDataSource {
    @IBOutlet weak var workshopCarousel: iCarousel!
    @IBOutlet weak var buttonView: UIView!

    var imageWorkshopSet=[UIImage(named: "blockchain"),UIImage(named:"cloud-computing"),UIImage(named:"cyber-security"),UIImage(named:"machine"),UIImage(named:"ui-ux")]
    var imageWorkshop: [String] = []
    var workPrice: [String] = []
//    let workName=["Machine Learning", "Cyber Security","UI UX","Blockchain","Cloud Computing"]
    var workName: [String] = []
    var workLocation:[String]=[]
    var workDescription:[String]=[]
    var workDate:[String]=[]
    var workSpeakerDesc:[String]=[]
    var workSpeaker:[String]=[]
    var eventNames=["Machine Learning Workshop","Cloud Computing Workshop","UI/UX Workshop","Blockchain and Cryptocurrency Workshop","Cyber-Security Workshop"].sorted()
    

    
    let custOrange : UIColor = UIColor(red:0.97, green:0.62, blue:0.29, alpha:1.0)
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // FIXME: Remove code below if u're using your own menu
        setupNavForDefaultMenu()
        
        // Add left bar button item
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = leftBarItem
        
       
        
        
        title = "Workshops"
        
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

    func numberOfItems(in carousel: iCarousel) -> Int {
        return  imageWorkshop.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView=UIView(frame: CGRect(x: 0, y: 0, width: 200 , height: 200))
        tempView.backgroundColor=UIColor.white
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: tempView.frame.size.width-20, height: tempView.frame.size.height-20))
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.center = CGPoint(x: tempView.frame.size.width  / 2,
                                   y: tempView.frame.size.height / 2)
        
        imageView.image = UIImage(named: imageWorkshop[index])
        imageView.layer.cornerRadius=20
        tempView.layer.cornerRadius=20
        tempView.addSubview(imageView)
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option==iCarouselOption.spacing{
            return value*3
        }
        return value
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        workshopCarousel.type = .rotary
        workshopCarousel.decelerationRate=0.3
        speakerView.isHidden=true
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("Events").observeSingleEvent(of: .value) { (snapshot) in
            //getting workshop name
            let value = snapshot.value as? NSDictionary
            self.workName = value?.allKeys as! [String]
            self.workName = self.workName.sorted()
            //getting workshop details
            for name in self.workName
            {
                ref.child("Events").child(name).observeSingleEvent(of: .value) { (snapshot1) in
                    
                    let value1 = snapshot1.value as? NSDictionary
                    self.workDate.append(value1?["date"] as! String)
                    self.workLocation.append(value1?["location"] as! String)
                    self.workDescription.append(value1?["description"] as! String)
                    self.workSpeaker.append(value1?["speaker"] as! String)
                    self.workSpeakerDesc.append(value1?["speakerDetails"] as! String)
                    self.workPrice.append(value1?["price"] as! String)
                    self.imageWorkshop.append(value1?["image"] as! String)
                    if self.workDate.isEmpty{
                        return
                    }else{
                        self.workshopDate.text=self.workDate[0]
                        self.workshopName.text=self.workName[0]
                        self.workshopCost.text=self.workPrice[0]
                        self.workshopLocation.text=self.workLocation[0]
                        self.speakerDescription.text=self.workSpeakerDesc[0]
                        self.speakerName.text=self.workSpeaker[0]
                        self.speakerImage.image=UIImage(named: self.imageWorkshop[0])
                        self.descriptionWorkshop.text=self.workDescription[0]
                        if self.speakerName.text=="ARCS"
                      {
                        self.speakerView.isHidden=true
                    }
                        else{
                           self.speakerView.isHidden=false
                        }
                        
                    }
                    self.workshopCarousel.reloadData()
                    
                    
                    
                    
                   
                }
                
                
            }
         
            
                    }
   
     
        
        // Do any additional setup after loading the view.
        workshopCarousel.isPagingEnabled=false
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = custOrange.cgColor
       
        self.navigationItem.rightBarButtonItem?.accessibilityElementsHidden=true
        
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        print(workshopCarousel.currentItemIndex)
       
        if self.workDate.isEmpty{
            return
        }else{ workshopCost.text=workPrice[workshopCarousel.currentItemIndex]
        bookNowButton.tag=workshopCarousel.currentItemIndex
            bookNowButton.addTarget(self, action: #selector(bookNow), for: .touchUpInside)
        workshopName.text=workName[workshopCarousel.currentItemIndex]
        workshopLocation.text=workLocation[workshopCarousel.currentItemIndex]
        descriptionWorkshop.text=workDescription[workshopCarousel.currentItemIndex]
        speakerImage.image=imageWorkshopSet[workshopCarousel.currentItemIndex]
        speakerName.text=workSpeaker[workshopCarousel.currentItemIndex]
        speakerDescription.text=workSpeakerDesc[workshopCarousel.currentItemIndex]
        workshopDate.text=workDate[workshopCarousel.currentItemIndex]
            if self.speakerName.text=="ARCS"
            {
                self.speakerView.isHidden=true
            }
            else{
                self.speakerView.isHidden=false
            }
            
        
        }
    }
    @IBOutlet weak var workshopCost: UILabel!
    @IBOutlet weak var workshopName: UILabel!
    @IBOutlet weak var workshopLocation: UILabel!
    @IBOutlet weak var workshopDate: UILabel!
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var descriptionWorkshop: UITextView!
    @IBOutlet weak var speakerDescription: UILabel!
    @IBOutlet weak var bookNowButton: UIButton!
    
    
    @IBAction func nextButton(_ sender: Any) {
       
       workshopCarousel.currentItemIndex=(workshopCarousel.currentItemIndex+1)%5
    
        
    }
    @IBOutlet weak var speakerView: UIView!
    
    @IBAction func backButton(_ sender: Any) {
         workshopCarousel.currentItemIndex=(workshopCarousel.currentItemIndex-1)%5
        
    }
   
    
    
  
    @IBAction func bookNow(_ sender: Any) {
        // Create the controller
        
        
        //start loading the URL
        
//        let request=URLRequest(url: url!)
//        nextViewController.webView.load(request)
//        self.navigationController?.pushViewController(nextViewController, animated: true)
      
        
        // present it
//        present(nextViewController, animated: true, completion: nil)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
            self.performSegue(withIdentifier: "webView", sender: self)
        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "") as! webViewController
        
       
      
//        nextViewController.webView.load(URLRequest(url: URL(string: "")!))
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//        print("executed")
       
       
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webView"{
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "webViewController") as! webViewController
//
//            nextViewController.mainURL = "https://register.ieeecsvit.com/login"
            
            print(eventNames[bookNowButton.tag])
            let nowPlayingView = segue.destination as! webViewController
            
            
            nowPlayingView.url="https://register.ieeecsvit.com/api/login-webview?ename=\(eventNames[bookNowButton.tag])"
            nowPlayingView.title="Payment"
                
            
            
        }
     
    }
 

}

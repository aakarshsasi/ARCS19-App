//
//  hackathonViewController.swift
//  arcs
//
//  Created by Aakarsh S on 12/02/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Toast_Swift
import FirebaseDatabase
import SDWebImage


class hackathonViewController: UIViewController,iCarouselDelegate,iCarouselDataSource{
    
   
   
    @IBOutlet weak var teamNameLabel: UILabel!
    var ref:DatabaseReference!
    let storage = Storage.storage()
    var tracks:[String]=[]
    var questions:[String]=[]
    var questDesc:[String]=[]
    var teamName:String = ""
    var documentLink:String=""
    var projectLink:String=""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // FIXME: Remove code below if u're using your own menu
        setupNavForDefaultMenu()
        
        // Add left bar button item
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = leftBarItem
        
        title = "HackBattle"
        
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
   
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let padding: CGFloat =  10
//        let collectionViewSize = collectionView.frame.size.width - padding
//
//        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
//    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID2", for: indexPath) as! hackathonCollectionViewCell
        cell.themeHackathon.text?=tracks[indexPath.row]
        
      
        //This creates the shadows and modifies the cards a little bit
        
        
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
       
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionPop"
        {
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       collectionView.allowsMultipleSelection = false
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "hackathonPopupViewController") as! hackathonPopupViewController
        vc.titleString = questions[indexPath.row]
        vc.descString = questDesc[indexPath.row]
        
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        
     
       
    }
    @IBAction func documentUpload(_ sender: Any) {
        if teamField.text?.isEmpty==false{
            let alertController = UIAlertController(title: "Document Link (Google Drive/Dropbox)", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let textFold = alertController.textFields![0] as UITextField
                if let documentLink1=textFold.text{
                    
                
                if(documentLink1.isEmpty==false){
                    self.ref.child("FileUpload").child(self.teamName).child("pptLink").setValue(documentLink1){ (error, ref) -> Void in
                        if error==nil{
                            self.view.makeToast("Link Uploaded Successfully")
                        }
                        else{
                            self.view.makeToast("Link Upload failed. Check network connectivity.")
                        }
                    }
                }
                else{
                    self.view.makeToast("Link can't be empty.")
                    }
                    
                }
                else{
                    print("error")
                }
             
                
                // do something with textField
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                
            })
            present(alertController, animated: true, completion: nil)
            
        }
        else{
            self.view.makeToast("Enter Team Name first.")
        }
    }
    
    
    @IBAction func projectLink(_ sender: Any) {
        if teamField.text?.isEmpty==false{
            let alertController = UIAlertController(title: "Github Link", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let textField = alertController.textFields![0] as UITextField
                textField.layer.borderWidth = 1.0
                textField.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
                let textFold = alertController.textFields![0] as UITextField
                if let documentLink1=textFold.text{
                    
                    
                    if(documentLink1.isEmpty==false){
                        self.ref.child("FileUpload").child(self.teamName).child("GitHub").setValue(documentLink1){ (error, ref) -> Void in
                            if error==nil{
                                self.view.makeToast("Link Uploaded Successfully")
                            }
                            else{
                                self.view.makeToast("Link Upload failed. Check network connectivity.")
                            }
                        }
                        
                    }
                    else{
                        self.view.makeToast("Link can't be empty.")
                    }
                    
                }
                else{
                    print("error")
                }
                
                
                // do something with textField
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                
            })
            present(alertController, animated: true, completion: nil)
            
        }
        else{
            self.view.makeToast("Enter Project Link")
        }

    
    }

    @IBOutlet weak var projectButton: UIButton!
    @IBOutlet weak var teamButton: UIButton!
 
    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.teamField.isHidden=true
        self.teamButton.isHidden=true
        self.uploadButton.isHidden=true
        self.projectButton.isHidden=true
        self.teamNameLabel.isHidden=true
        teamField.layer.borderWidth = 2.0
        teamField.layer.borderColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0).cgColor
        
        

        // Do any additional setup after loading the view.
        trackCarousel.type = .coverFlow2
        
        self.view.makeToast("Tap on the themes to view detailed description.")
        ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("Hackathon").observe(.value) { (snapshot) in
            let value=snapshot.value as?NSDictionary
            
            self.tracks=(value?.allKeys as! [String]).sorted()
            self.tracks.remove(at: self.tracks.index(of:"coupons")!)
            for name in self.tracks
            {
                self.ref.child("Hackathon").child(name).observe(.value, with: { (snapshot1) in
                    let value1 = snapshot1.value as? NSDictionary
                    self.questions.append(value1?["question"] as! String)
                    self.questDesc.append(value1?["desc"]as! String)
                    
                    
                    self.ref.keepSynced(true)
                    
                    self.trackCarousel.reloadData()
                })
            }
            
        }
        
        
        ref.child("FileUpload").child("enable").observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let val=value?["final"] as? String{
                if val=="1"{
                    self.teamField.isHidden=false
                    self.teamButton.isHidden=false
                    self.uploadButton.isHidden=false
                    self.projectButton.isHidden=false
                    if let teamNameStored=UserDefaults.standard.object(forKey: "teamname") as? String{
                        self.teamNameLabel.text="Team: \(teamNameStored)"
                        self.teamNameLabel.isHidden=false
                        self.teamField.isHidden=true
                        self.teamButton.isHidden=true
                    }
                }
            }
        }
        
       
       
    }
  
 
    
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func hackbattleClick(_ sender: Any) {
        let url=URL(string: "https://hackbattle19.hackerearth.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func teamSubmitButton(_ sender: Any) {
        if(teamField.text?.isEmpty==false){
        teamNameLabel.isHidden=false
        teamNameLabel.text="Team: \(teamField.text!)"
            UserDefaults.standard.setValue(teamField.text!, forKey: "teamname")
        teamField.isHidden=true
        teamButton.isHidden=true
            teamName=teamField.text!
        }
        else{
            self.view.makeToast("Enter team name.")
        }
    }
    
    @IBOutlet weak var teamField: DesignableUITextField!
    @IBAction func teamName(_ sender: Any) {
    }
    
    @IBOutlet weak var trackCarousel: iCarousel!
    
    @IBOutlet weak var themeView: UIView!
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if questions.count>0{
            trackCarousel.scrollToItem(at: questions.count/2, animated: true)
        }
        return questions.count
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let tempView=UIView(frame: CGRect(x: 0, y: 0, width: 200 , height: 200))
        tempView.backgroundColor=UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0)
       
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: tempView.frame.size.width-20, height: tempView.frame.size.height-20))
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.center = CGPoint(x: tempView.frame.size.width  / 2,
                                   y: tempView.frame.size.height / 2)
        
        let storageRef = storage.reference()
        
        
        let imageRef = storageRef.child("Hackathon")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.child("\(tracks[index]).png").downloadURL { (url, error) in
            if error != nil {
                // Uh-oh, an error occurred!
                print(error!)
            } else {
                // Data for "images/island.jpg" is returned
                
                if let urlf=url{
                    imageView.sd_setImage(with: urlf, completed: nil)
                }
            }
        }
       
            imageView.layer.cornerRadius=20
            tempView.layer.cornerRadius=20
            tempView.addSubview(imageView)
        
        return tempView
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.4
        }
        return value
    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "hackathonPopupViewController") as! hackathonPopupViewController
        vc.titleString = questions[index]
        vc.descString = questDesc[index]
        
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    
}




    


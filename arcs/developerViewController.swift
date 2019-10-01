//
//  developerViewController.swift
//  arcs
//
//  Created by Aakarsh S on 01/02/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import FirebaseStorage

import FirebaseDatabase
import SDWebImage
import Toast_Swift
class developerViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{
  
    
    var linkedinLinks:[String]=[]
    var speakerNames:[String]=[]
    var speakerTopic:[String]=[]
    var speakerDay:[String]=[]
    var speakerPhoto:[String]=[]
    var speakerDetails:[String]=[]
    
    
    var ref:DatabaseReference!
    let storage=Storage.storage()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return speakerTopic.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // FIXME: Remove code below if u're using your own menu
        setupNavForDefaultMenu()
        
        // Add left bar button item
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = leftBarItem
        
        title = "Convoke'19"
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.makeToast("Tap each speaker to view in detail.")
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("Convoke").observe(.value) { (snapshot) in
            let value=snapshot.value as?NSDictionary
            
            self.speakerNames=value?.allKeys as! [String]
            for name in self.speakerNames
            {
                self.ref.child("Convoke").child(name).observe(.value, with: { (snapshot1) in
                    let value1 = snapshot1.value as? NSDictionary
                    self.linkedinLinks.append(value1?["facebook_link"] as! String)
                    
                    self.speakerDetails.append(value1?["details"] as! String)
                    self.speakerTopic.append(value1?["topic"] as! String)
                    
                    
                    self.ref.keepSynced(true)
                    self.convokeCollectionView.reloadData()
                })
            }
            
        }
    } 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! developerCollectionViewCell
        let storageRef=storage.reference()
        cell.devName.text?=speakerNames[indexPath.row]
        let imageRef = storageRef.child("Convoke")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        
        DispatchQueue.main.async {
            
            imageRef.child("\(self.speakerNames[indexPath.row]).png").downloadURL { (url, error) in
                if error != nil {
                    // Uh-oh, an error occurred!
                    print(error!)
                } else {
                    // Data for "images/island.jpg" is returned
                    
                    if let urlf=url{
                    cell.devImage.sd_setImage(with: urlf, completed: nil)
                    }
                }
            }
        }
        
        cell.devCountry.text?=speakerTopic[indexPath.row]
        cell.devImage.layer.cornerRadius=40
        cell.devImage.layer.masksToBounds=true
        cell.devImage.clipsToBounds=true
        cell.devImage.layer.borderWidth = 2
        cell.devImage.layer.borderColor = UIColor.black.cgColor
       cell.devLinkedin.tag=indexPath.row
        cell.devLinkedin.addTarget(self, action: #selector(linkedinTapped), for: .touchUpInside)
        //This creates the shadows and modifies the cards a little bit
        
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.devImage.layer.cornerRadius = 62.5
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "hackathonPopupViewController") as! hackathonPopupViewController
        vc.titleString = speakerNames[indexPath.row]
        vc.descString = speakerDetails[indexPath.row]
        
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    @objc func linkedinTapped(_ sender: UIButton){
      
         if let url=URL(string: linkedinLinks[sender.tag])
         {UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
   
    
    @IBOutlet weak var convokeCollectionView: UICollectionView!
    

    /*
     @IBOutlet weak var devCountry: UILabel!
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

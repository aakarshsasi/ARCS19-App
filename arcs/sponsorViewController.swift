//
//  sponsorViewController.swift
//  arcs
//
//  Created by Aakarsh S on 30/01/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import WebKit
import Firebase
import FirebaseStorage
import SDWebImage

class sponsorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var sponsorLinks:[String]=[]
    var sponsorNames:[String]=[]
    var sponsorPhotoLinks:[URL]=[]
    
    var workImage: UIImage!
    var ref:DatabaseReference!
    let storage = Storage.storage()
   
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // FIXME: Remove code below if u're using your own menu
        setupNavForDefaultMenu()
        
        // Add left bar button item
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = leftBarItem
        
        title = "Sponsors"
        
        //firebase
     
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
        return sponsorLinks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let storageRef = storage.reference()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walkThroughIdentifier", for: indexPath) as! WalkThroughCollectionViewCell
        
        let imageRef = storageRef.child("Sponsors")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
      
        DispatchQueue.main.async {
            
            imageRef.child("\(self.sponsorNames[indexPath.row]).png").downloadURL { (url, error) in
            if error != nil {
                // Uh-oh, an error occurred!
                print(error!)
            } else {
                // Data for "images/island.jpg" is returned
                
               
               if let urlf=url
               {
                cell.sponsorLogo.sd_setImage(with: urlf, completed: nil)
                }
            }
        }
        }
        
        
        
        cell.viewButton.tag=indexPath.row
        cell.viewButton.addTarget(self, action: #selector(sponsorTapped(_:)), for: .touchUpInside)
       
        return cell
    }
    
  
    @objc func sponsorTapped(_ sender: UIButton){
        // use the tag of button as index
        
        if let url=URL(string: sponsorLinks[sender.tag])
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "webViewController") as! webViewController
//        let link=sponsorLinks[sender.tag]
//        nextViewController.mainURL = link
        
// nextViewController.title="Sponsors"
//        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
        
    }
    @IBOutlet weak var walkThroughCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        walkThroughCollectionView.register(UINib.init(nibName: "WalkThroughCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "walkThroughIdentifier")
        let flowlayout=UPCarouselFlowLayout()
        flowlayout.itemSize=CGSize(width: UIScreen.main.bounds.size.width-60.0, height: walkThroughCollectionView.frame.size.height)
        flowlayout.scrollDirection = .horizontal
        flowlayout.sideItemScale=0.8
        flowlayout.sideItemAlpha=1.0
        flowlayout.spacingMode = .fixed(spacing: 5.0)
        walkThroughCollectionView.collectionViewLayout=flowlayout
        walkThroughCollectionView.delegate=self
        walkThroughCollectionView.dataSource=self
        
        //firebase
        ref = Database.database().reference()
        ref.keepSynced(true)
       
        ref.child("Sponsors").observe(.value) { (snapshot) in
            let value=snapshot.value as?NSDictionary
            
            self.sponsorNames=value?.allKeys as! [String]
            for name in self.sponsorNames
            {
                self.ref.child("Sponsors").child(name).observe(.value, with: { (snapshot1) in
                    let value1 = snapshot1.value as? NSDictionary
                    self.sponsorLinks.append(value1?["url"] as! String)
                   
                    
                    self.ref.keepSynced(true)
                    self.walkThroughCollectionView.reloadData()
                })
            }
            print(self.sponsorLinks)
        }
        
        
        // Create a child reference
        // imagesRef now points to "images"
        
        // This is equivalent to creating the full reference
     
        
        
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


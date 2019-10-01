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
class comboViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var comboName: [String] = []
    var comboPrice:[String]=[]
    var comboDescription:[String]=[]
    
    var eventNames=["ARCS Combo 1","ARCS Combo 2","Workshop Combo 2","Workshop Combo 1"].sorted()
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-200)
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // FIXME: Remove code below if u're using your own menu
        setupNavForDefaultMenu()
        
        // Add left bar button item
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = leftBarItem
        
        title = "Combos"
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walkThroughIdentifier", for: indexPath) as! comboCollectionViewCell
        cell.comboTitle.text=self.comboName[indexPath.row]
        if self.comboDescription.isEmpty==false{
            cell.comboDescription.text=self.comboDescription[indexPath.row]
            
            cell.comboPrice.text=self.comboPrice[indexPath.row]
            
            cell.viewButton.tag=indexPath.row
            cell.viewButton.addTarget(self, action: #selector(payment), for: .touchUpInside)
        }
        
        return cell
    }
    @IBOutlet weak var walkThroughCollectionView: UICollectionView!
    
    @objc func payment(_ sender: UIButton){
        
        let url=URL(string: eventNames[sender.tag])
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "webViewController") as! webViewController
        nextViewController.url = "https://register.ieeecsvit.com/api/login-webview?ename=\(eventNames[sender.tag])"
       nextViewController.title="Payment"
      self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        var ref:DatabaseReference
        ref = Database.database().reference()
        walkThroughCollectionView.register(UINib.init(nibName: "comboCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "walkThroughIdentifier")
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
        
        ref.child("Combos").observe(.value) { (snapshot) in
            let value=snapshot.value as?NSDictionary
            
            self.comboName=value?.allKeys as! [String]
            self.comboName=self.comboName.sorted()
            for name in self.comboName
            {
                ref.child("Combos").child(name).observe(.value, with: { (snapshot1) in
                    let value1 = snapshot1.value as? NSDictionary
                    self.comboPrice.append(value1?["price"] as! String)
                    self.comboDescription.append(value1?["longDescription"] as! String)
                 
                    ref.keepSynced(true)
            self.walkThroughCollectionView.reloadData()
                })
            }
         
        }
        
        
        
        
        
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  comboPrice.count
    }
    
    
    
    
    @IBAction func webViewHere(_ sender: Any) {
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "webViewController") as! webViewController
//
////                    nextViewController.url = "https://register.ieeecsvit.com/login"
//
//nextViewController.title="Payment"
//      self.navigationController?.pushViewController(nextViewController, animated: true)
        //
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "web"{
//            //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            //            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "webViewController") as! webViewController
//            //
//            //            nextViewController.mainURL = "https://register.ieeecsvit.com/login"
//            let nowPlayingView = segue.destination as! webViewController
//            nowPlayingView.mainURL = "https://register.ieeecsvit.com/login"
//            //
//
//        }
      
       
        
       
//
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


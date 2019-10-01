//
//  SMNavigationController.swift
//  LNSideMenuEffect
//
//  Created by Luan Nguyen on 6/30/16.
//  Copyright © 2016 Luan Nguyen. All rights reserved.
//

import LNSideMenu

class SMNavigationController: LNSideMenuNavigationController {
    
    fileprivate var items:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Using default side menu
        items =  ["Schedule","Workshops","Convoke","Combos","HackBattle","Sponsors","Developers","View Profile","Logout"]
        //    initialSideMenu(.left)
        // Custom side menu
        initialCustomMenu(pos: .left)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initialSideMenu(_ position: Position) {
        menu = LNSideMenu(sourceView: view, menuPosition: position, items: items!)
        menu?.menuViewController?.menuBgColor = UIColor.black.withAlphaComponent(0.85)
        menu?.delegate = self
        menu?.underNavigationBar = true
        menu?.allowPanGesture=true
        
        menu?.allowRightSwipe=false
        view.bringSubviewToFront(navigationBar)
        
    }
    
    fileprivate func initialCustomMenu(pos position: Position) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuTableViewController") as! LeftMenuTableViewController
        vc.delegate = self
        menu = LNSideMenu(navigation: self, menuPosition: position, customSideMenu: vc, size: .custom(UIScreen.main.bounds.width - 60))
        menu?.delegate = self
        menu?.allowPanGesture=true
        
        menu?.allowRightSwipe=false
        menu?.enableDynamic = true
        // Moving down the menu view under navigation bar
        //    menu?.underNavigationBar = true
    }
    
    fileprivate func setContentVC(_ index: Int) {
        print("Did select item at index: \(index)")
        var nViewController: UIViewController? = nil
        /*
         if let viewController = viewControllers.first , viewController is sponsorViewController {
         nViewController = storyboard?.instantiateViewController(withIdentifier: "parentViewController")
         } else {
         nViewController = storyboard?.instantiateViewController(withIdentifier: "sponsorViewController")
         }
         */
        if index==0{
            nViewController=storyboard?.instantiateViewController(withIdentifier: "parentViewController")
            
        }
        if index==1{
            nViewController=storyboard?.instantiateViewController(withIdentifier: "workshopsViewController")
        }
        if index==2{
            nViewController=storyboard?.instantiateViewController(withIdentifier: "developerViewController")
        }
        if index==3{
            nViewController=storyboard?.instantiateViewController(withIdentifier: "comboViewController")
        }
        if index==4{
            nViewController=storyboard?.instantiateViewController(withIdentifier: "hackathonViewController")
        }
       
        if index==5{
            nViewController=storyboard?.instantiateViewController(withIdentifier: "sponsorViewController")
        }
        
    
        if index==6{
            nViewController=storyboard?.instantiateViewController(withIdentifier: "developerFinalViewController")
        }
        if index==7{
            nViewController=storyboard?.instantiateViewController(withIdentifier: "profileViewController")
        }
        if index==8{
            let alertController = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
               print("yes")
                nViewController=self.storyboard?.instantiateViewController(withIdentifier: "signInViewController")
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                self.present(nViewController!,animated:true,completion:nil)
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        
        
        if let viewController = nViewController {
            self.setContentViewController(viewController)
        }
        menu?.allowPanGesture=false
        // Test moving up/down the menu view
        if let sm = menu, sm.isCustomMenu {
            menu?.underNavigationBar = false
        }
    }
    
    
}

extension SMNavigationController: LNSideMenuDelegate {
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    func didSelectItemAtIndex(_ index: Int) {
        setContentVC(index)
    }
}

extension SMNavigationController: LeftMenuDelegate {
    func didSelectItemAtIndex(index idx: Int) {
        menu?.toggleMenu() { [unowned self] in
            self.setContentVC(idx)
        }
    }
    
    
}


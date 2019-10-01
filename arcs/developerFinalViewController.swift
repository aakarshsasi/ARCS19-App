//
//  developerFinalViewController.swift
//  arcs
//
//  Created by Aakarsh S on 10/02/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit

class developerFinalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var devnames=["INDRESH ARORA","AAKARSH.S","SIDDHARTH GORADIA"]
    var roles=["Mentor","Developer","Designer"]
    var devphotos=[UIImage(named: "indresh"),UIImage(named:"aakarsh"),UIImage(named:"siddharth")]
    
    var devlinks=["https://github.com/arora-72","https://github.com/dnawarrior/", "https://github.com/Siddharth-14"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // FIXME: Remove code below if u're using your own menu
        setupNavForDefaultMenu()
        
        // Add left bar button item
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = leftBarItem
        
        title = "Developers"
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devnames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!devCellTableViewCell
        cell.devName.text = devnames[indexPath.row]
        cell.devRole.text=roles[indexPath.row]
        cell.devImage.layer.cornerRadius=cell.devImage.frame.height/2
        cell.devImage.image=devphotos[indexPath.row]
        cell.devImage.layer.borderWidth = 1.0
        cell.devImage.layer.borderColor = UIColor.black.cgColor
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "webViewController") as! webViewController
//
//        nextViewController.mainURL = ""
//
//        nextViewController.title="Github"
//        self.navigationController?.pushViewController(nextViewController, animated: true)
       if let url=URL(string: devlinks[indexPath.row])
       {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        let tempImageView = UIImageView(image: UIImage(named: "bg_pattern"))
        tempImageView.frame = self.devTableView.frame
        self.devTableView.backgroundView = tempImageView;
      
        
    }
    
    @IBOutlet weak var devTableView: UITableView!
    
    
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  LeftMenuTableViewController.swift
//  LNSideMenu
//
//  Created by Aakarsh.S



import UIKit
import Alamofire
import SwiftyJSON

protocol LeftMenuDelegate: class {
  func didSelectItemAtIndex(index idx: Int)
}


class LeftMenuTableViewController: UIViewController {
  

    @IBOutlet weak var profileImage: UIImageView!
    
    
    typealias CompletionHandler = (_ success: Bool) -> Void
    
    func getData(completionHandler: @escaping CompletionHandler) {
        
        
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
                        self.userNameLabel.text=name as? String
                        
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
                    

                    completionHandler(true)

                    break
                case .failure(let error):
                    print(error.localizedDescription)

                    completionHandler(false)
                }
        }
        
        }
    }
    
    
    // MARK: IBOutlets


    @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var menuTableView: UITableView!
  
  // MARK: Properties
  let kCellIdentifier = "menuCell"
  let items = ["Schedule","Workshops","Convoke","Combos","HackBattle","Sponsors","Developers","View Profile","Logout"]
    let imageSet=[UIImage(named: "schedule"),UIImage(named:"workshops"),UIImage(named:"convoke"),UIImage(named:"combos"),UIImage(named:"hackathon"),UIImage(named:"sponsors"),UIImage(named:"developer"),UIImage(named:"profile"),UIImage(named:"logout")]
  weak var delegate: LeftMenuDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    DispatchQueue.main.async {
    if let name=UserDefaults.standard.string(forKey: "name"){
        
    
        self.userNameLabel.text=name 
    }
    }
   let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
    menuTableView.register(nib, forCellReuseIdentifier: kCellIdentifier)
    
    
   
   
  }
  
    override func viewWillAppear(_ animated: Bool) {
//        getData { (success) in
//            if success {
//
//
//            } else {
//                print("error")
//                //toast
//
//            }
//        }
        
        
        if let data=UserDefaults.standard.object(forKey: "savedImage")
        {
            profileImage.image=UIImage(data: data as! Data)
        }
    }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
//    menuTableView.reloadSections(IndexSet(integer: 0), with: .none)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // Circle avatar imageview
    if let name = UserDefaults.standard.value(forKey: "name") as? String{
        self.userNameLabel.text=name
    }
    profileImage.layer.cornerRadius =  ((profileImage.frame.size.height))/2
   
 
    profileImage.layer.masksToBounds = true
   profileImage.clipsToBounds = true
    
    // Border
    profileImage.layer.borderWidth = 1
    profileImage.layer.borderColor = UIColor.black.cgColor
    
    // Shadow img
    profileImage.layer.shadowColor = UIColor.white.cgColor
    profileImage.layer.shadowOpacity = 1
    profileImage.layer.shadowOffset = .zero
    profileImage.layer.shadowRadius = 10
    profileImage.layer.shadowPath = UIBezierPath(rect: (profileImage.bounds)).cgPath
    profileImage.layer.shouldRasterize = true
  
    
    }
}

extension LeftMenuTableViewController: UITableViewDataSource {
  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0)
        cell?.backgroundColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0)
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
        cell?.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
        
    }
    
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! MenuTableViewCell
    cell.titleLabel.text = items[indexPath.row]
    cell.titleImage.image=imageSet[indexPath.row]
    cell.contentView.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
    cell.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
    if(cell.isSelected){
        cell.contentView.backgroundColor = UIColor.red
    }else{
        cell.contentView.backgroundColor = UIColor.clear
    }

    return cell
  }
  
  
}

extension LeftMenuTableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
 
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      delegate.didSelectItemAtIndex(index: indexPath.row)
    }
  }
 
}

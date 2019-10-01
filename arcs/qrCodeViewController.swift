//
//  qrCodeViewController.swift
//  arcs
//
//  Created by Aakarsh S on 02/02/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit
import Toast_Swift
class qrCodeViewController: UIViewController {

    @IBOutlet weak var barcodeImage: UIImageView!
    var filter:CIFilter!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // FIXME: Remove code below if u're using your own menu
        setupNavForDefaultMenu()
        
        // Add left bar button item
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = leftBarItem
        
        title = "Barcode"
        
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(goBack))
        
        
        navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    
    
    @objc func goBack(){
      self.navigationController?.popViewController(animated: true)
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
//        self.navigationController?.pushViewController(secondViewController, animated: true)
        
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
    func generateBarcode(regNo: String){
        
        if let data = regNo.data(using: .ascii, allowLossyConversion: false){
        filter=CIFilter(name: "CICode128BarcodeGenerator")
        filter.setValue(data, forKey: "inputMessage")
            let image=UIImage(ciImage: filter.outputImage!)
        barcodeImage.image=image
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let reg=UserDefaults.standard.string(forKey:"regno"){
            if reg.isEmpty==false{
                generateBarcode(regNo: reg)
            }
        
        
        else if let phone=UserDefaults.standard.string(forKey:"phoneno"){
                if phone.isEmpty==false{
                generateBarcode(regNo:phone )
                }
        }
        }
        else{
            self.view.makeToast("Failed to load. Please try again.")
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

}

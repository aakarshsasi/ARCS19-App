//
//  parentViewController.swift
//  testest
//
//  Created by Aakarsh S on 07/01/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import LNSideMenu
import Alamofire
import SwiftyJSON


class parentViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    
    let purpleInspireColor = UIColor(red:0.98, green:0.64, blue:0.10, alpha:1.0)
    let bgcol=UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
    let notselectedtab=UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.7)
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = bgcol
        settings.style.buttonBarItemBackgroundColor = bgcol
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = notselectedtab
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = self?.notselectedtab
            newCell?.label.textColor = .white
          
        }
        func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // FIXME: Remove code below if u're using your own menu
            setupNavforDefaultMenu()
        }
        super.viewDidLoad()
    }
    
    
    private func setupNavforDefaultMenu() {
        barButton.image = UIImage(named: "burger")?.withRenderingMode(.alwaysOriginal)
        // Set navigation bar translucent style
        self.navigationBarTranslucentStyle()
        // Update side menu
        sideMenuManager?.instance()?.menu?.isNavbarHiddenOrTransparent = true
        // Re-enable sidemenu
        sideMenuManager?.instance()?.menu?.disabled = false
        sideMenuManager?.instance()?.menu?.allowPanGesture=true
    }
    
    @IBAction func toogleSideMenu(_ sender: AnyObject) {
        sideMenuManager?.toggleSideMenuView()
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child2")
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child3")
        let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child4")
        return [child_1, child_2,child_3,child_4]
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

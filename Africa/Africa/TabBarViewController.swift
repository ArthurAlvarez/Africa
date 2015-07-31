//
//  TabBarViewController.swift
//  
//
//  Created by Felipe Eulalio on 31/07/15.
//
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hue: 0.577777, saturation: 0.45, brightness: 0.16, alpha: 1.0)], forState: .Normal)
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
		
		let tabBarItem1 = tabBar.items![0] as! UITabBarItem
		let tabBarItem2 = tabBar.items![1] as! UITabBarItem
		
		let icon1 = UIImage(named: "settingsIconWhite")
		let icon2 = UIImage(named: "gameplayWhiteIcon")
		
		tabBarItem1.selectedImage = icon1
		tabBarItem2.selectedImage = icon2
		
		tabBarItem1.title = NSLocalizedString("item1", comment: "")
		tabBarItem2.title = NSLocalizedString("item2", comment: "")
    }
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

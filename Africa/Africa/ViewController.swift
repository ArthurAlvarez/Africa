//
//  ViewController.swift
//  Africa
//
//  Created by Arthur Alvarez on 7/7/15.
//  Copyright (c) 2015 Arthur Alvarez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var playBtn: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		playBtn.layer.cornerRadius = playBtn.frame.height/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}


//
//  RoundViewController.swift
//  Africa
//
//  Created by Arthur Alvarez on 7/14/15.
//  Copyright (c) 2015 Arthur Alvarez. All rights reserved.
//

import UIKit

class RoundViewController: UIViewController {

	// MARK: - Outlets
    // Displays current round
    @IBOutlet weak var roundLabel: UILabel!
    // Describes current round
    @IBOutlet weak var descriptionLabel: UILabel!
	// Displays the round image
	@IBOutlet weak var imageView: UIImageView!
	
	// Var to know the round
    var round : Round!
	
	// MARK: - Life Cicle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        self.round = Game.sharedInstance.round
    
        //Displays description of the current round
        
        if(self.round == Round.FirstRound){
            self.roundLabel.text = NSLocalizedString("round",comment: "") + " 1"
            self.descriptionLabel.text = NSLocalizedString("hints",comment: "")
			self.imageView.image = UIImage(named: "hints")
        }
        else if(self.round == Round.SecondRound){
            self.roundLabel.text = NSLocalizedString("round",comment: "") + " 2"
            self.descriptionLabel.text = NSLocalizedString("mimics",comment: "")
			self.imageView.image = UIImage(named: "mimics")
        }
        else if(self.round == Round.ThirdRound){
            self.roundLabel.text = NSLocalizedString("round",comment: "") + " 3"
            self.descriptionLabel.text = NSLocalizedString("onlyOne",comment: "")
			self.imageView.image = UIImage(named: "onlyOne")
        }
		
		var layer = CALayer()
		layer.backgroundColor = UIColor.whiteColor().CGColor
		
		imageView.layer.addSublayer(layer)
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

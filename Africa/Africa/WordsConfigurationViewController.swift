//
//  WordsConfigurationViewController.swift
//  Africa
//
//  Created by Arthur Alvarez on 7/7/15.
//  Copyright (c) 2015 Arthur Alvarez. All rights reserved.
//

import UIKit

class WordsConfigurationViewController: UIViewController {

	// MARK: - Outlets
    // Slider for selecting number of words
    @IBOutlet weak var words_Slider: UISlider!
    // Label showing curent number of words
    @IBOutlet weak var wordsNumber_Label: UILabel!
    // Button to go to the next ViewController
    @IBOutlet weak var playBtn: UIButton!
	
	@IBOutlet weak var writeBtn: UIButton!
	
	@IBOutlet weak var rulesButton: UIButton!

	// MARK: - Other Properties
	// Keep a reference to the Game
	let game = Game.sharedInstance
    
	// MARK: - LifeCicle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		writeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
		
		playBtn.layer.cornerRadius = playBtn.frame.height/2
		writeBtn.layer.cornerRadius = writeBtn.frame.height/2
		rulesButton.layer.cornerRadius = rulesButton.frame.height/2
		
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// MARK: - Action Methods
    /**
        Action called when slider value changes
    */
    @IBAction func sliderValueChanged(sender: AnyObject) {
        
        // Changes label text
        self.wordsNumber_Label.text = "\(Int(words_Slider.value)) " + NSLocalizedString("wordSlider",comment: "")
        
		
        // Allows to go next
        self.playBtn.enabled = true
    }

	@IBAction func goBack(sender: UIButton)
	{
		self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	/**
	Go to the next ViewController, according to what is selected at the segmented control
	*/
	@IBAction func next(sender: UIButton!) {
		
		var identifier : String!
		
		if sender.tag == 0 {
			identifier = "startGameNow"
			game.source = .Game
		}
		else if sender.tag == 1 {
			identifier = "insertWords"
			game.source = .Players
		}
		/* Salva configuração e palavras */
		game.numberOfWords = Int(words_Slider.value)
		
		game.startGame()
		
		self.performSegueWithIdentifier(identifier, sender: self)
	}
}

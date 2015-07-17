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
    // Segmented control for selecting configuration
    @IBOutlet weak var config_SegmentedCtrl: UISegmentedControl!
    // Slider for selecting number of words
    @IBOutlet weak var words_Slider: UISlider!
    // Label showing curent number of words
    @IBOutlet weak var wordsNumber_Label: UILabel!
    // Button to go to the next ViewController
    @IBOutlet weak var next_Btn: UIButton!
	
	// MARK: - Other Properties
	// Keep a reference to the Game
	let game = Game.sharedInstance
    
	// MARK: - LifeCicle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.next_Btn.enabled = true
    }

	/**
	Go to the next ViewController, according to what is selected at the segmented control
	*/
	@IBAction func next(sender: AnyObject) {
		
		var identifier : String
		
		if config_SegmentedCtrl.selectedSegmentIndex == 0 { identifier = "startGameNow" }
		else { identifier = "insertWords" }
		
		self.performSegueWithIdentifier(identifier, sender: self)
	}
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        /* Salvar configuração e palavras */
		game.numberOfWords = Int(words_Slider.value)
		
		if config_SegmentedCtrl.selectedSegmentIndex == 0 { game.source = .Game }
		else { game.source = .Players }
		
		game.startGame()
    }
    

}

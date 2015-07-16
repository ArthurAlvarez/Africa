//
//  WordsConfigurationViewController.swift
//  Africa
//
//  Created by Arthur Alvarez on 7/7/15.
//  Copyright (c) 2015 Arthur Alvarez. All rights reserved.
//

import UIKit

class WordsConfigurationViewController: UIViewController {

    // Segmented control for selecting configuration
    @IBOutlet weak var config_SegmentedCtrl: UISegmentedControl!
    // Slider for selecting number of words
    @IBOutlet weak var words_Slider: UISlider!
    // Label showing curent number of words
    @IBOutlet weak var wordsNumber_Label: UILabel!
    // Button to go next
    @IBOutlet weak var next_Btn: UIButton!
	
	let game = Game.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial state setup
        //self.next_Btn.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
        Action called when slider value changes
    */
    @IBAction func sliderValueChanged(sender: AnyObject) {
        
        // Changes label text
        self.wordsNumber_Label.text = "\(Int(words_Slider.value)) Palavras"
		
        // Allows to go next
        self.next_Btn.enabled = true
    }

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

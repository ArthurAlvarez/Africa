//
//  GroupConfigurationsViewController.swift
//  Africa
//
//  Created by Arthur Alvarez on 7/7/15.
//  Copyright (c) 2015 Arthur Alvarez. All rights reserved.
//

import UIKit

class GroupConfigurationsViewController: UIViewController {

    //Segmented Control for number of groups selection
    @IBOutlet weak var groups_SegmentedCtrl: UISegmentedControl!
    //Slider for numer of players selection
    @IBOutlet weak var players_Slider: UISlider!
    //Label showing current number of players
    @IBOutlet weak var playersLabel: UILabel!
    //Button to go to the next step
    @IBOutlet weak var next_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initial state setup
        self.next_btn.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** 
        Action called when the slider value changes
    */
    @IBAction func sliderValueChanged(sender: AnyObject) {
        
        //Updates playerLabel
        let numPlayers : Int = Int(self.players_Slider.value)
        
        self.playersLabel.text = "\(numPlayers) Pessoas"
        
        // Allows to go next
        self.next_btn.enabled = true
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        /* Salvar Grupos e Players */
		Game.sharedInstance.numberOfPlayers = Int(self.players_Slider.value)
    }

}

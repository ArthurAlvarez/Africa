//
//  RoundViewController.swift
//  Africa
//
//  Created by Arthur Alvarez on 7/14/15.
//  Copyright (c) 2015 Arthur Alvarez. All rights reserved.
//

import UIKit

class RoundViewController: UIViewController {

    // Displays current round
    @IBOutlet weak var roundLabel: UILabel!
    // Describes current round
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var round : Round!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.round = Game.sharedInstance.round
        
        if(self.round == Round.FirstRound){
            self.roundLabel.text = "Round 1"
            self.descriptionLabel.text = "Dicas!"
        }
        else if(self.round == Round.FirstRound){
            self.roundLabel.text = "Round 2"
            self.descriptionLabel.text = "Mimica!"
        }
        else if(self.round == Round.FirstRound){
            self.roundLabel.text = "Round 3"
            self.descriptionLabel.text = "Uma Palavra!"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ResultsViewController.swift
//  
//
//  Created by Felipe Eulalio on 15/07/15.
//
//

import UIKit

class ResultsViewController: UIViewController {
	
	@IBOutlet weak var team1: NSLayoutConstraint!
	
	@IBOutlet weak var team2: NSLayoutConstraint!
	
	@IBOutlet weak var scoreView1: UIView!
	@IBOutlet weak var scoreView2: UIView!
	
	@IBOutlet weak var score1: UILabel!
	@IBOutlet weak var score2: UILabel!
	@IBOutlet weak var roundLabel: UILabel!
	
	@IBOutlet weak var button: UIButton!
	
	var height: CGFloat!
	
	let game = Game.sharedInstance
	
	var points1 : Float = Game.sharedInstance.roundScores[0]
	var points2 : Float = Game.sharedInstance.roundScores[1]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		button.layer.cornerRadius = button.frame.height/2
		button.alpha = 0
		
        // Displays current round in title
		switch game.round {
		case .FirstRound:
			roundLabel.text = NSLocalizedString("round", comment: "") + " 1"
			break
		case .SecondRound:
			roundLabel.text = NSLocalizedString("round", comment: "") + " 2"
			break
		case .ThirdRound:
			roundLabel.text = NSLocalizedString("round", comment: "") + " 3"
            
			button.setTitle(NSLocalizedString("finalResults", comment: ""), forState: .Normal)
			button.setImage(UIImage(named: "trophy"), forState: .Normal)
			break
		default:
			break
		}
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.view.layoutIfNeeded()
		
        // Sets bars to height = 0
        
		height = scoreView1.frame.height
		
		team1.constant += height
		team2.constant += height
		
		self.score1.text = "0"
		self.score2.text = "0"
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
        //Shows results
		self.animateResults()
		
		game.endRound()
	}

    /**
        Updates score1 label during animation
    */
	func updateScore1(sender : NSTimer)
	{
		score1.text = "\((score1.text as NSString!).intValue + 1)"
		if (score1.text as NSString!).integerValue == Int(points1) { sender.invalidate() }
	}
	/**
        Updates score2 label during animation
    */
	func updateScore2(sender : NSTimer)
	{
		score2.text = "\((score2.text as NSString!).intValue + 1)"
		if (score2.text as NSString!).integerValue == Int(points2) { sender.invalidate() }
	}
    
    /**
        Handles tap on button!
    */
    @IBAction func buttonPressed(sender: UIButton) {
		sender.alpha = 0.0
		
        // if endgame, shows final results
		if game.round == .EndGame && sender.titleLabel?.text == NSLocalizedString("finalResults", comment: "") {
			
			self.score1.text = "0"
			self.score2.text = "0"
			
			UIView.animateWithDuration(2.0, animations: { () -> Void in
				self.team1.constant += self.scoreView1.frame.height
				self.team2.constant += self.scoreView2.frame.height
				
				self.view.layoutIfNeeded()
			}, completion: { (result) -> Void in
				self.points1 = self.game.totalScores[0]
				self.points2 = self.game.totalScores[1]
				
				self.roundLabel.text = NSLocalizedString("finalResults", comment: "")
				self.button.setTitle(NSLocalizedString("finish", comment: ""), forState: .Normal)
				self.button.setImage(UIImage(named: "back-small"), forState: .Normal)
				
				self.animateResults()
			})
			
			return
		}
			
        // If finished game, go back to settings screen
        else if sender.titleLabel?.text == NSLocalizedString("finish", comment: "") {
			game.endGame()
			self.navigationController?.popToRootViewControllerAnimated(true)
			return
		}
		
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    }
	
    /**
        Animates graphic bars
    */
	func animateResults()
	{
		var multiplier = 1
		
		if game.round == .EndGame { multiplier = 3 }
		
        // Gets final height
		let height1 = Float(height) * points1/Float(game.numberOfWords * multiplier)
		let height2 = Float(height) * points2/Float(game.numberOfWords * multiplier)
		
        // Animates labels
		if points1 != 0 { let timer1 = NSTimer.scheduledTimerWithTimeInterval(2/Double(points1), target: self, selector: "updateScore1:", userInfo: nil, repeats: true) }
		if points2 != 0 { let timer2 = NSTimer.scheduledTimerWithTimeInterval(2/Double(points2), target: self, selector: "updateScore2:", userInfo: nil, repeats: true) }
		
        // Animates bars
		UIView.animateWithDuration(2.0, animations: { () -> Void in
			self.team1.constant -= CGFloat(height1)
			self.team2.constant -= CGFloat(height2)
			
			self.view.layoutIfNeeded()
			}, completion: { (result) -> Void in
				UIView.animateKeyframesWithDuration(0.5, delay: 0, options: nil, animations: { () -> Void in
					UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
						self.button.alpha = 1.0
						self.button.transform = CGAffineTransformMakeScale(1.1, 1.1)
					})
					UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
						self.button.transform = CGAffineTransformMakeScale(1.0, 1.0)
					})
				}, completion: nil)
			})
	}
    
}

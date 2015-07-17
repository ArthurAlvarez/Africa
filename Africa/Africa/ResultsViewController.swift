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
			break
		default:
			break
		}
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.view.layoutIfNeeded()
		
		height = scoreView1.frame.height
		
		team1.constant += height
		team2.constant += height
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.animateResults()
		
		game.endRound()
	}

	func updateScore1(sender : NSTimer)
	{
		score1.text = "\((score1.text as NSString!).intValue + 1)"
		if (score1.text as NSString!).integerValue == Int(points1) { sender.invalidate() }
	}
	
	func updateScore2(sender : NSTimer)
	{
		score2.text = "\((score2.text as NSString!).intValue + 1)"
		if (score2.text as NSString!).integerValue == Int(points2) { sender.invalidate() }
	}
    
    @IBAction func buttonPressed(sender: UIButton) {
		
		if game.round == .EndGame && sender.titleLabel?.text == NSLocalizedString("finalResults", comment: "") {
			
			self.roundLabel.text = NSLocalizedString("finalResults", comment: "")
			self.button.setTitle(NSLocalizedString("finish", comment: ""), forState: .Normal)
			
			UIView.animateWithDuration(2.0, animations: { () -> Void in
				self.team1.constant += self.scoreView1.frame.height
				self.team2.constant += self.scoreView2.frame.height
				
				self.view.layoutIfNeeded()
			}, completion: { (result) -> Void in
				self.points1 = self.game.totalScores[0]
				self.points2 = self.game.totalScores[1]
				
				self.animateResults()
			})
			
			return
		} else if sender.titleLabel?.text == NSLocalizedString("finish", comment: "") {
			game.endGame()
			self.navigationController?.popToRootViewControllerAnimated(true)
			return
		}
		
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    }
	
	func animateResults()
	{
		var multiplier = 1
		
		if game.round == .EndGame { multiplier = 3 }
		
		let height1 = Float(height) * points1/Float(game.numberOfWords * multiplier)
		let height2 = Float(height) * points2/Float(game.numberOfWords * multiplier)
		
		self.score1.text = "0"
		self.score2.text = "0"
		
		if points1 != 0 { let timer1 = NSTimer.scheduledTimerWithTimeInterval(2/Double(points1), target: self, selector: "updateScore1:", userInfo: nil, repeats: true) }
		if points2 != 0 { let timer2 = NSTimer.scheduledTimerWithTimeInterval(2/Double(points2), target: self, selector: "updateScore2:", userInfo: nil, repeats: true) }
		
		UIView.animateWithDuration(2.0, animations: { () -> Void in
			self.team1.constant -= CGFloat(height1)
			self.team2.constant -= CGFloat(height2)
			
			self.view.layoutIfNeeded()
		})
	}
    
}

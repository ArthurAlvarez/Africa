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
	
	var height: CGFloat!
	
	let game = Game.sharedInstance
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
		
		let height1 = Float(height) * Game.sharedInstance.roundScores[0]/Float(game.numberOfWords)
		let height2 = Float(height) * Game.sharedInstance.roundScores[1]/Float(game.numberOfWords)

		self.score1.text = "0"
		self.score2.text = "0"
		
		let timer1 = NSTimer.scheduledTimerWithTimeInterval(2/Double(Game.sharedInstance.roundScores[0]), target: self, selector: "updateScore1:", userInfo: nil, repeats: true)
		let timer2 = NSTimer.scheduledTimerWithTimeInterval(2/Double(Game.sharedInstance.roundScores[1]), target: self, selector: "updateScore2:", userInfo: nil, repeats: true)
				
		UIView.animateWithDuration(2.0, animations: { () -> Void in
			self.team1.constant -= CGFloat(height1)
			self.team2.constant -= CGFloat(height2)
			
			self.view.layoutIfNeeded()
		})
	}

	func updateScore1(sender : NSTimer)
	{
		score1.text = "\((score1.text as NSString!).intValue + 1)"
		if (score1.text as NSString!).integerValue == Int(Game.sharedInstance.roundScores[0]) { sender.invalidate() }
	}
	
	func updateScore2(sender : NSTimer)
	{
		score2.text = "\((score2.text as NSString!).intValue + 1)"
		if (score2.text as NSString!).integerValue == Int(Game.sharedInstance.roundScores[1]) { sender.invalidate() }
	}
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);

    }
    
}

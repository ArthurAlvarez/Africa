//
//  GameViewController.swift
//  
//
//  Created by Felipe Eulalio on 07/07/15.
//
//

import UIKit

class GameViewController: UICollectionViewController
{
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
	var cellcount = 20
	
	var cell : Cell!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		Game.sharedInstance.startGame()
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        tapRecognizer.numberOfTapsRequired = 1
		self.collectionView?.addGestureRecognizer(tapRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTimer:", name: "updateTimer", object: nil)
        
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cellcount
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MY_CELL", forIndexPath: indexPath) as! Cell
		
		cell.label!.text = "oi"
        cell.label.hidden = true
		(cell.card as! CardComponent).animate()
        
		return cell
	}
	
	func handleTapGesture(sender : UITapGestureRecognizer)
	{
		if sender.state == .Ended {
			let initialPinchPoint = sender.locationInView(self.collectionView)
			let tappedCellPath = self.collectionView?.indexPathForItemAtPoint(initialPinchPoint)
			
            
			if tappedCellPath != nil {
				
				let size = self.collectionView?.frame.size
				let cell = self.collectionView?.cellForItemAtIndexPath(tappedCellPath!)! as! Cell
                
                (cell.card as! CardComponent).animate()
                                
				UIView.animateWithDuration(1.0, animations: { () -> Void in
                    cell.center = CGPointMake(size!.width / 2.0, size!.height / 2.0)
                    cell.transform = CGAffineTransformMakeScale(4, 4)
                }, completion: { (result) -> Void in
                    cell.label.hidden = false
                })
                
			}
		}
	}
    
    @IBAction func startTurn(sender: AnyObject)
    {
        let team = Game.sharedInstance.startTurn()
        self.teamLabel.text = "Equipe \(team + 1)"
        self.startButton.hidden = true
    }
    
    func updateTimer(notification : NSNotification)
    {
        let userInfo: [String: Int] = notification.userInfo as! [String: Int]
        let time = userInfo["time"]!
        
        self.timerLabel.text = "\(time)"
    }
	
}

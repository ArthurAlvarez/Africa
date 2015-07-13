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
    
	var cellCount = Game.sharedInstance.numberOfWords
	
	var cell : Cell!
    
    var activeCell : Cell!
	
	var gameStarted = false
	var oldPosition : CGPoint!
	
    let game = Game.sharedInstance
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		game.startGame()
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        tapRecognizer.numberOfTapsRequired = 1
		self.collectionView?.addGestureRecognizer(tapRecognizer)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "rightAnswer:")
        doubleTap.numberOfTapsRequired = 2
        self.collectionView?.addGestureRecognizer(doubleTap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTimer:", name: "updateTimer", object: nil)
        
        self.timerLabel.text = "45"
        
        self.activeCell = nil
		
		cellCount = Game.sharedInstance.numberOfWords

	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cellCount
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MY_CELL", forIndexPath: indexPath) as! Cell
		
        cell.label.alpha = 0.0
		(cell.card as! CardComponent).animate()
        
        cell.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOpacity = 1.0
        
		return cell
	}
	
	func handleTapGesture(sender : UITapGestureRecognizer)
	{
		if sender.state == .Ended {
			let initialPinchPoint = sender.locationInView(self.collectionView)
			let tappedCellPath = self.collectionView?.indexPathForItemAtPoint(initialPinchPoint)
			
            
			if tappedCellPath != nil && self.activeCell == nil && gameStarted {
				
				let size = self.collectionView?.frame.size
				let cell = self.collectionView?.cellForItemAtIndexPath(tappedCellPath!)! as! Cell
                self.activeCell = cell
                (cell.card as! CardComponent).animate()
				oldPosition = cell.center
                
                cell.label.text = game.nextWord()
                
				UIView.animateWithDuration(1.0, animations: { () -> Void in
                    cell.center = CGPointMake(size!.width / 2.0, size!.height / 2.0)
                    cell.transform = CGAffineTransformMakeScale(4, 4)
                }, completion: { (result) -> Void in
					cell.label.alpha = 1.0
                    
                    cell.label.transform = CGAffineTransformMakeScale(1/4, 1/4)
                })
                
			}
            else if self.activeCell != nil{ self.animateActiveCell() }
		}
	}
    
    @IBAction func startTurn(sender: AnyObject)
    {
        if Game.sharedInstance.round == .FirstRound { self.timerLabel.text = "45" }
        else { self.timerLabel.text = "60" }
        
        let team = Game.sharedInstance.startTurn()
        self.teamLabel.text = "Equipe \(team + 1)"
        self.startButton.hidden = true
		
		gameStarted = true
    }
    
    func updateTimer(notification : NSNotification)
    {
        let userInfo: [String: Int] = notification.userInfo as! [String: Int]
        let time = userInfo["time"]!
        
        self.timerLabel.text = "\(time)"
        
        if time == 0 {
			self.startButton.hidden = false
			gameStarted = false
			if self.activeCell != nil {
				// Verifies if the cell is closed, only making the animation if it's opened
				if (activeCell.card as! CardComponent).isOpened { self.animateActiveCell() }
				
				UIView.animateWithDuration(1.0, animations: { () -> Void in
					self.activeCell.center = self.oldPosition
					self.activeCell.transform = CGAffineTransformMakeScale(1, 1)
				})
				
				activeCell = nil
			}
        }
    }
	
	private func animateActiveCell(){
		(self.activeCell.card as! CardComponent).animate()
		if(self.activeCell.label.alpha == 0.0){
			UIView.animateWithDuration(0.1, delay: 1.0, options: nil, animations: { () -> Void in
				self.activeCell.label.alpha = 1.0
				}, completion: nil)
		}
		else{
			self.activeCell.label.alpha = 0.0
		}
	}
	
    func rightAnswer(sender: UITapGestureRecognizer)
    {
		if activeCell != nil {
			let indexPath = self.collectionView?.indexPathForCell(self.activeCell)
			self.cellCount--
			
			self.collectionView?.performBatchUpdates({ () -> Void in
				self.collectionView?.deleteItemsAtIndexPaths(NSArray(object: indexPath!) as! [NSIndexPath])
				}, completion: nil)
			
			game.increaseScore()
			self.activeCell = nil
		}
    }
	
}

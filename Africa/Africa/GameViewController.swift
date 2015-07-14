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
	private let cellName = "CircleCell"
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
	var cellCount = Game.sharedInstance.numberOfWords
	    
    var activeCell : CircleLayoutCell!
	
    var animator : UIDynamicAnimator!
    
    var snap : UISnapBehavior!
    
    var attachmentBehavior : UIAttachmentBehavior!
    
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
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        self.collectionView?.addGestureRecognizer(panRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTimer:", name: "updateTimer", object: nil)
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.timerLabel.text = "45"
        
        self.activeCell = nil
		
		cellCount = Game.sharedInstance.numberOfWords

	}
	
    func handlePanGesture(sender : UIPanGestureRecognizer)
    {
        if(self.activeCell != nil){
            self.view.backgroundColor = UIColor.blackColor()
            let panLocationInView = sender.locationInView(self.view)
            let panLocationInCell = sender.locationInView(self.activeCell)
            
            if(sender.state == UIGestureRecognizerState.Began){
                self.animator.removeAllBehaviors()
                
                let offset = UIOffsetMake(panLocationInCell.x - CGRectGetMidX(self.activeCell.bounds),
                    panLocationInCell.y - CGRectGetMidY(self.activeCell.bounds))
                
                self.attachmentBehavior = UIAttachmentBehavior(item: self.activeCell, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                
                self.attachmentBehavior.action = {() -> Void in
                    self.activeCell.transform = CGAffineTransformMakeScale(4, 4)
                    self.animator.updateItemUsingCurrentState(self.activeCell)
                }
                
                    self.animator.addBehavior(attachmentBehavior)

            }
            else if(sender.state == UIGestureRecognizerState.Changed){
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if(sender.state == UIGestureRecognizerState.Ended){
                self.animator.removeAllBehaviors()
                
                self.snap = UISnapBehavior(item: self.activeCell, snapToPoint: self.view.center)
                
                self.snap.action = {() -> Void in
                    self.activeCell.transform = CGAffineTransformMakeScale(4, 4)
                    self.animator.updateItemUsingCurrentState(self.activeCell)
                }
                
                self.animator.addBehavior(self.snap)
                
                // If drag is higher than 100px dismiss the activeCell
                if(abs(sender.translationInView(self.view).y) > 100
                    || abs(sender.translationInView(self.view).x) > 100){
                    self.rightAnswer()
                }
            }
        }
    }
    
	func handleTapGesture(sender : UITapGestureRecognizer)
	{
		if sender.state == .Ended {
			let initialPinchPoint = sender.locationInView(self.collectionView)
			let tappedCellPath = self.collectionView?.indexPathForItemAtPoint(initialPinchPoint)
			
            
			if tappedCellPath != nil && self.activeCell == nil && gameStarted {
				
				let size = self.collectionView?.frame.size
				let cell = self.collectionView?.cellForItemAtIndexPath(tappedCellPath!)! as! CircleLayoutCell
                self.activeCell = cell
                self.activeCell.layer.shouldRasterize = false
                cell.card.animate()
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
				if activeCell.card.isOpened { self.animateActiveCell() }
				
				UIView.animateWithDuration(1.0, animations: { () -> Void in
					self.activeCell.center = self.oldPosition
					self.activeCell.transform = CGAffineTransformMakeScale(1, 1)
				})
				
				activeCell = nil
			}
        }
    }
	
	private func animateActiveCell()
	{
		self.activeCell.card.animate()
		
		if(self.activeCell.label.alpha == 0.0){
			UIView.animateWithDuration(0.1, delay: 1.0, options: nil, animations: { () -> Void in
				self.activeCell.label.alpha = 1.0
				}, completion: nil)
		} else {
			self.activeCell.label.alpha = 0.0
		}
	}
	
    func rightAnswer()
    {
		if activeCell != nil {
			
			let word = activeCell.label.text
			let indexPath = self.collectionView?.indexPathForCell(self.activeCell)
			self.cellCount--
			
            self.animator.removeAllBehaviors()
			
			self.collectionView?.performBatchUpdates(
				{ () -> Void in
					self.collectionView?.deleteItemsAtIndexPaths(NSArray(object: indexPath!) as! [NSIndexPath])
				}, completion: nil)
			
			game.increaseScore(word!)
			
            activeCell = nil
		}
    }
	
}

extension GameViewController
{
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cellCount
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellName, forIndexPath: indexPath) as! CircleLayoutCell
		
		cell.layer.shouldRasterize = true
		cell.label!.text = "Oi"
		cell.label.alpha = 0.0
		cell.card.animate()
		
		cell.layer.shadowOffset = CGSizeMake(1.0, 1.0)
		cell.layer.shadowColor = UIColor.blackColor().CGColor
		cell.layer.shadowOpacity = 1.0
		
		return cell
	}
}

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
	// MARK: - Constants
	// Constant with the name of the cell on the StoryBoard
	private let cellName = "CircleCell"
	
	// MARK: - Outlets
    //  Label for timer
    @IBOutlet weak var timerLabel: UILabel!
    // Label displaying current team
    @IBOutlet weak var teamLabel: UILabel!
    // Button to start turn
    @IBOutlet weak var startButton: UIButton!
	
	// MARK: - Other Properties
    // Number of collection view cells
	var cellCount = Game.sharedInstance.numberOfWords
    // Selected cell
    var activeCell : CircleLayoutCell!
	// Animator for dynamic behaviors
    var animator : UIDynamicAnimator!
    // Snap behavior
    var snap : UISnapBehavior!
    // Attachment Behavior
    var attachmentBehavior : UIAttachmentBehavior!
    //  Flag to notify that game has started
	var gameStarted = false
	// Original cell position
    var oldPosition : CGPoint!
	// Reference to the game
    let game = Game.sharedInstance
	
	// MARK: - LifeCicle Methods
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
        // Sets up gesture recognizers
        
		let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        tapRecognizer.numberOfTapsRequired = 1
		self.collectionView?.addGestureRecognizer(tapRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        self.collectionView?.addGestureRecognizer(panRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTimer:", name: "updateTimer", object: nil)
        
        // Sets class variables
        self.animator = UIDynamicAnimator(referenceView: self.view)
		
		if game.round == .FirstRound { self.timerLabel.text = "45" }
		else { self.timerLabel.text = "60" }
		
		self.teamLabel.text = NSLocalizedString("team",comment: "") + " 1"
        
        self.activeCell = nil
		
		cellCount = Game.sharedInstance.numberOfWords
		
        // Starts game
		game.startRound()

	}
	
	
	// MARK: - Handlers
    /**
        Function called when a pan gesture is detected
    */
    func handlePanGesture(sender : UIPanGestureRecognizer)
    {
        if(self.activeCell != nil){
            self.view.backgroundColor = UIColor.blackColor()
            let panLocationInView = sender.locationInView(self.view)
            let panLocationInCell = sender.locationInView(self.activeCell)
			
            // Starts attachment behavior to drag activeCell
            if(sender.state == UIGestureRecognizerState.Began){
                self.animator.removeAllBehaviors()

				let offset = UIOffsetMake(panLocationInCell.x - CGRectGetMidX(self.activeCell!.bounds),
                    panLocationInCell.y - CGRectGetMidY(self.activeCell!.bounds))
                
                self.attachmentBehavior = UIAttachmentBehavior(item: self.activeCell!, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                
                self.attachmentBehavior.action = {() -> Void in
                    self.activeCell!.transform = CGAffineTransformMakeScale(4, 4)
                    self.animator.updateItemUsingCurrentState(self.activeCell!)
                }
                
                    self.animator.addBehavior(attachmentBehavior)

            }
            // Updates attachment anchor point
            else if(sender.state == UIGestureRecognizerState.Changed){
                attachmentBehavior.anchorPoint = panLocationInView
            }
            // Ends drag
            else if(sender.state == UIGestureRecognizerState.Ended){
                self.animator.removeAllBehaviors()
				
				let size = self.collectionView?.frame.size
				let point = CGPointMake(size!.width/2.0, size!.height/2.0)
				
                self.snap = UISnapBehavior(item: self.activeCell!, snapToPoint: point)
				
                self.snap.action = {() -> Void in
                    self.activeCell!.transform = CGAffineTransformMakeScale(4, 4)
                    self.animator.updateItemUsingCurrentState(self.activeCell!)
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
    
    /**
        Function called when a tap gesture is detected
    */
	func handleTapGesture(sender : UITapGestureRecognizer)
	{
		if sender.state == .Ended {
			
			let initialPinchPoint = sender.locationInView(self.collectionView)
			let tappedCellPath = self.collectionView?.indexPathForItemAtPoint(initialPinchPoint)
			
            //Animates selected cell
			if tappedCellPath != nil && self.activeCell == nil && gameStarted {
				
				// Get the size from the CollectionView
				let size = self.collectionView?.frame.size
				
                self.activeCell = self.collectionView?.cellForItemAtIndexPath(tappedCellPath!)! as? CircleLayoutCell
                self.activeCell!.layer.shouldRasterize = false
                self.activeCell!.card.animate()
				
				oldPosition = activeCell.center
                
                activeCell.label.text = game.nextWord()
				
				// Set the selected cell to the center and increase its size
				UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.activeCell.transform = CGAffineTransformMakeScale(4, 4)
					self.activeCell.center = CGPointMake(size!.width/2.0, size!.height/2.0 - 20)
                }, completion: { (result) -> Void in
					self.activeCell.label.alpha = 1.0
                    
                    self.activeCell.label.transform = CGAffineTransformMakeScale(1/4, 1/4)
                })
				
			}
            else if self.activeCell != nil{ self.animateActiveCell() }
		}
	}
	
	// MARK: - Action Methods
    /**
        Starts a game turn
    */
    @IBAction func startTurn(sender: AnyObject)
    {
        if Game.sharedInstance.round == .FirstRound { self.timerLabel.text = "45" }
        else { self.timerLabel.text = "60" }
        
        let team = Game.sharedInstance.startTurn()
        self.teamLabel.text = NSLocalizedString("team", comment: "") + " \(team + 1)"
        self.startButton.hidden = true
		
		gameStarted = true
    }
	
	// MARK: - Other Methods
    /**
        Updates timer and dismisses activeCell when time ends
    */
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
				self.animator.removeAllBehaviors()
				
				if abs(activeCell!.center.x - collectionView!.center.x) > 100 || abs(activeCell!.center.y - collectionView!.center.y) > 100 {
					self.rightAnswer()
				} else {
					if activeCell!.card.isOpened { self.animateActiveCell() }
					
					activeCell!.label.alpha = 0
					
					UIView.animateWithDuration(1.0, animations: { () -> Void in
						self.activeCell!.center = self.oldPosition
						self.activeCell!.transform = CGAffineTransformMakeScale(1, 1)
					})
					activeCell = nil
				}
			}
        }
    }
	
    /**
        Animates activeCell
    */
	private func animateActiveCell()
	{
		self.activeCell!.card.animate()
		
		if(self.activeCell!.card.isOpened) {
			UIView.animateWithDuration(0.1, delay: 1.0, options: nil, animations: { () -> Void in
				self.activeCell!.label.alpha = 1.0
				}, completion: nil)
		} else {
			self.activeCell!.label.alpha = 0.0
		}
	}
	
    /** 
	Computes right answer and removes activeCell from the collectionView
	*/
    func rightAnswer()
    {
		if activeCell != nil {
			
			let word = activeCell!.label.text
			let indexPath = self.collectionView?.indexPathForCell(self.activeCell!)
			self.cellCount--
			
            self.animator.removeAllBehaviors()
			
			self.collectionView?.performBatchUpdates(
				{ () -> Void in
					self.collectionView?.deleteItemsAtIndexPaths(NSArray(object: indexPath!) as! [NSIndexPath])
				}, completion: nil)
			
			game.increaseScore(word!)
			
			activeCell = nil
		}
		
		if cellCount == 0 {
			self.performSegueWithIdentifier("showScore", sender: self)
		}
    }
	
}

// MARK: - Collection View DataSource
extension GameViewController
{
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cellCount
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellName, forIndexPath: indexPath) as! CircleLayoutCell
		
		// Set the basics from the cell
		cell.layer.shouldRasterize = true
		cell.label.alpha = 0.0
		cell.card.animate()
		cell.layer.shadowOffset = CGSizeMake(1.0, 1.0)
		cell.layer.shadowColor = UIColor.blackColor().CGColor
		cell.layer.shadowOpacity = 1.0
		
		return cell
	}
}

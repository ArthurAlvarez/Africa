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
    
	var cellcount = 50
	
	var cell : Cell!
    
    var activeCell : Cell!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		Game.sharedInstance.startGame()
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        tapRecognizer.numberOfTapsRequired = 1
		self.collectionView?.addGestureRecognizer(tapRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTimer:", name: "updateTimer", object: nil)
        
        self.activeCell = nil
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cellcount
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MY_CELL", forIndexPath: indexPath) as! Cell
		
		cell.label!.text = "Oi"
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
			
            
			if tappedCellPath != nil && self.activeCell == nil {
				
				let size = self.collectionView?.frame.size
				let cell = self.collectionView?.cellForItemAtIndexPath(tappedCellPath!)! as! Cell
                self.activeCell = cell
                (cell.card as! CardComponent).animate()
                
				UIView.animateWithDuration(1.0, animations: { () -> Void in
                    cell.center = CGPointMake(size!.width / 2.0, size!.height / 2.0)
                    cell.transform = CGAffineTransformMakeScale(4, 4)
                }, completion: { (result) -> Void in
                     cell.label.alpha = 1.0
                    
                    cell.label.transform = CGAffineTransformMakeScale(1/4, 1/4)
                })
                
			}
            else if self.activeCell != nil{
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

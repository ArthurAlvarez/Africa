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
	
	var cellcount = 20
	
	var cell : Cell!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		Game.sharedInstance.startGame()
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
		self.collectionView?.addGestureRecognizer(tapRecognizer)
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cellcount
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MY_CELL", forIndexPath: indexPath) as! Cell
		
		cell.label.text = "oi"
		
		return cell
	}
	
	func handleTapGesture(sender : UITapGestureRecognizer)
	{
		if sender.state == .Ended {
			let initialPinchPoint = sender.locationInView(self.collectionView)
			let tappedCellPath = self.collectionView?.indexPathForItemAtPoint(initialPinchPoint)
			
			if tappedCellPath != nil {
				
				let size = self.collectionView?.frame.size
				
				UIView.animateWithDuration(1.0, animations: { () -> Void in
					self.collectionView?.cellForItemAtIndexPath(tappedCellPath!)!.center = CGPointMake(size!.width / 2.0, size!.height / 2.0)
					self.collectionView?.cellForItemAtIndexPath(tappedCellPath!)!.transform = CGAffineTransformMakeScale(4, 4)
				})
			} else {
				self.cellcount++
				self.collectionView?.performBatchUpdates({ () -> Void in
					self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
				}, completion: nil)
			}
		}
	}
	
}

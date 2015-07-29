//
//  InsertLayout.swift
//  
//
//  Created by Felipe Eulalio on 14/07/15.
//
//

import UIKit

class InsertLayout: UICollectionViewLayout
{
	// MARK: - Constants
	// The size of the cell
	let ITEM_SIZE : CGFloat = 200.0
	/// The keyboard Size
	let KEYBOARD_SIZE : CGFloat = 273.0
	
	// MARK: - Other Properties
	/// The center of the view
	var center : CGPoint!
	/// The number of cells
	var cellCount : Int = 0
	/// IndexPaths to be deleted
	var deleteIndexPaths: NSMutableArray!
	/// IndexPaths do be inserted
	var insertIndexPaths: NSMutableArray!
	
	override func prepareLayout()
	{
		super.prepareLayout()
		
		let size = self.collectionView?.frame.size
		// Get the cell count
		cellCount = collectionView!.numberOfItemsInSection(0)
		// Get the center
		var y : CGFloat
		
		if size!.height/2 < KEYBOARD_SIZE { y = size!.height - KEYBOARD_SIZE }
		else { y = size!.height/2 }
		
		center = CGPointMake(size!.width/2, y)
	}
	
	override func collectionViewContentSize() -> CGSize
	{
		return self.collectionView!.frame.size
	}
	
	override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!
	{
		let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
		
		let index = CGFloat(indexPath.item)
		
		/// Seth the size, positon and alpha of each new cell
		attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE)
		attributes.center = CGPointMake(center.x + index * (center.x + ITEM_SIZE/2), center.y)
		attributes.alpha = 1.0
		
		return attributes
	}
	
	override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?
	{
		var attributes = NSMutableArray()
		
		// Loop by the cells, setting their attributes
		for i in 0...cellCount {
			if i < cellCount {
				let indexPath = NSIndexPath(forItem: i, inSection: 0)
				
				attributes.addObject(self.layoutAttributesForItemAtIndexPath(indexPath))
			}
		}
		
		return attributes as [AnyObject]
	}
	
	override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!)
	{
		super.prepareForCollectionViewUpdates(updateItems)
		
		self.deleteIndexPaths = NSMutableArray()
		self.insertIndexPaths = NSMutableArray()
		
		for update in updateItems {
			if update.updateAction == UICollectionUpdateAction.Delete {
				self.deleteIndexPaths.addObject(update)
			} else if update.updateAction == UICollectionUpdateAction.Insert{
				self.insertIndexPaths.addObject(update)
			}
		}
		
	}
	
	override func finalizeCollectionViewUpdates() {
		super.finalizeCollectionViewUpdates()
		
		self.deleteIndexPaths = nil
		self.insertIndexPaths = nil
	}
	
	override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
	{
		let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath) as UICollectionViewLayoutAttributes!

		attributes.alpha = 0.0
		attributes.center = CGPointMake(center.x + 2 * ITEM_SIZE, center.y)
		
		return attributes
	}
	
	override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
	{
		let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath) as UICollectionViewLayoutAttributes!
	
		attributes.alpha = 0.0
		attributes.center = CGPointMake(center.x, center.y + 2 * ITEM_SIZE)
		attributes.transform3D = CATransform3DMakeScale(0.5, 0.5, 1.0)
		
		return attributes
	}
}

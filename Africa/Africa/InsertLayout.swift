//
//  InsertLayout.swift
//  
//
//  Created by Felipe Eulalio on 14/07/15.
//
//

import UIKit

class InsertLayout: UICollectionViewLayout {
	
	var center : CGPoint!
	var cellCount : Int = 0
	let ITEM_SIZE : CGFloat = 200.0
	
	var deleteIndexPaths: NSMutableArray!
	var insertIndexPaths: NSMutableArray!
	
	override func prepareLayout()
	{
		super.prepareLayout()
		
		let size = self.collectionView?.frame.size
		
		cellCount = collectionView!.numberOfItemsInSection(0)
		
		center = CGPointMake(size!.width/2, size!.height/2)
	}
	
	override func collectionViewContentSize() -> CGSize
	{
		return self.collectionView!.frame.size
	}
	
	override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!
	{
		let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
		
		let index = CGFloat(indexPath.item)
		
		attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE)
		attributes.center = CGPointMake(center.x + index * (center.x + ITEM_SIZE/2), center.y)
		attributes.alpha = 1.0
		
		return attributes
	}
	
	override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?
	{
		var attributes = NSMutableArray()
		
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

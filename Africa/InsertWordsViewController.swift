//
//  InsertWordsViewController.swift
//  
//
//  Created by Felipe Eulalio on 13/07/15.
//
//

import UIKit

class InsertWordsViewController: UIViewController
{
	private let cellName = "InsertCell"
	
	@IBOutlet weak var nOfWordsLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	
	let ITEM_SIZE : CGFloat = 200.0
	
	let game = Game.sharedInstance
	
	var cellCount : Int = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		cellCount = game.numberOfWords
		
		nOfWordsLabel.text = "\(cellCount) missing words"
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.collectionView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func startGame(sender: UIButton!)
	{
		if cellCount != 0 {
			game.getWords(cellCount)
		}
		
		self.performSegueWithIdentifier("startGame", sender: self)
	}
}

extension InsertWordsViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		
		let indexPath = NSIndexPath(forItem: 0, inSection: 0)
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! InsertCell
		
		--cellCount
		game.insertWord(cell.textField.text)
		
		
		self.collectionView!.performBatchUpdates(
			{ () -> Void in
				self.collectionView!.deleteItemsAtIndexPaths(NSArray(object: indexPath!) as! [NSIndexPath])
			}, completion: nil)
		
		
		nOfWordsLabel.text = "\(cellCount) missing words"
		
		
		return true
	}
}

extension InsertWordsViewController: UICollectionViewDataSource
{
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return cellCount
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellName, forIndexPath: indexPath) as! InsertCell
		
		cell.textField.text = ""
		cell.alpha = 1.0
		
		return cell
	}
}
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
	// MARK: - Constants
	// Name of the cell on the StoryBoard
	private let cellName = "InsertCell"
	// Cell Size
	let ITEM_SIZE : CGFloat = 200.0
	
	// MARK: - Outlets
	
	@IBOutlet weak var bar: UIProgressView!
	/// Collection View to display the cards
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var skipBtn: UIButton!
	@IBOutlet weak var playBtn: UIButton!
	
	// MARK: - Others Properties
	/// Reference to he Game
	let game = Game.sharedInstance
	/// Number of the cells on the Collection View
	var cellCount : Int = 0
	
	// MARK: - LifeCicle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		cellCount = game.numberOfWords
		
		skipBtn.layer.cornerRadius = skipBtn.frame.height/2
		playBtn.layer.cornerRadius = playBtn.frame.height/2
		
		playBtn.alpha = 0
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.collectionView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Actions Methods
	/**
	Starts the game 
	*/
	@IBAction func startGame(sender: UIButton!)
	{
		if cellCount != 0 {
			game.getWords(cellCount)
		}
		
		self.performSegueWithIdentifier("startGame", sender: self)
	}
	
	@IBAction func goBack(sender: UIButton)
	{
		self.navigationController?.popViewControllerAnimated(true)
	}
}

// MARK: - TextField Delegate
extension InsertWordsViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		if textField.text == "" { return true }
		
		textField.resignFirstResponder()
		
		// Gets the index path from the first cell on the Collection View
		let indexPath = NSIndexPath(forItem: 0, inSection: 0)
		// Gets the cell
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! InsertCell
		
		--cellCount
		
		// Add the new word
		game.insertWord(cell.textField.text!)
		
		// Deletes the cell
		self.collectionView!.performBatchUpdates(
			{ () -> Void in
				self.collectionView!.deleteItemsAtIndexPaths(NSArray(object: indexPath) as! [NSIndexPath])
			}, completion: nil)
		
		bar.setProgress(Float(game.numberOfWords - cellCount)/Float(game.numberOfWords), animated: true)
		
		if cellCount == 0 {
			skipBtn.hidden = true
			
			UIView.animateKeyframesWithDuration(0.5, delay: 0, options: nil, animations: { () -> Void in
				UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: { () -> Void in
					self.playBtn.alpha = 1
					self.playBtn.transform = CGAffineTransformMakeScale(1.3, 1.3)
				})
				UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
					self.playBtn.transform = CGAffineTransformMakeScale(1.0, 1.0)
				})
			}, completion: nil)
		}
		
		return true
	}
}

// MARK: - Collection View DataSource
extension InsertWordsViewController: UICollectionViewDataSource
{
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return cellCount
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellName, forIndexPath: indexPath) as! InsertCell
		// Set the cell
		cell.textField.text = ""
		cell.alpha = 1.0
		
		return cell
	}
}
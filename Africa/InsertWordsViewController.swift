//
//  InsertWordsViewController.swift
//  
//
//  Created by Felipe Eulalio on 13/07/15.
//
//

import UIKit

class InsertWordsViewController: UIViewController {

	@IBOutlet weak var nOfWordsLabel: UILabel!
	@IBOutlet weak var card: CardComponent!
	
	let game = Game.sharedInstance
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		nOfWordsLabel.text = "\(game.missingWords) missing words"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension InsertWordsViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		
		card.animate()
		
		return true
	}
}

//
//  GamePreparationViewController.swift
//
//
//  Created by Felipe Eulalio on 31/07/15.
//
//

import UIKit

class GameplayRulesViewController: UIViewController {
	
	@IBOutlet weak var webView: UIWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let fileName = NSLocalizedString("gameplayRules", comment: "")
		let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "pdf")
		let targetURL = NSURL(fileURLWithPath: path!)
		let request = NSURLRequest(URL: targetURL!)
		
		self.webView.loadRequest(request)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

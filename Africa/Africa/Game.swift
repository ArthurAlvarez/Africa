//
//  Game.swift
//  Africa
//
//  Created by Felipe Eulalio on 07/07/15.
//  Copyright (c) 2015 Arthur Alvarez. All rights reserved.
//

import Foundation

// MARK: - Enums
/**
Enum to the rounds
*/
enum Round {
	case FirstRound
	case SecondRound
	case ThirdRound
    case EndGame
}

/**
Enum to the resource from the words
*/
enum WordsResource {
	case Game
	case Players
}

// MARK: - Word Struct
/**
Struct that have a string to keep the word and a boolean to know if the word alrealdy had been guessed
*/
struct Word {
	var word : String!
	var used : Bool = false
}

// MARK: - Game Class
class Game : NSObject
{
	/// Singleton
	static let sharedInstance = Game()
	
	// MARK: - Properties
	/// Number of words in the game
	var numberOfWords : Int = 20
	/// Number of teams in the game
	var numberOfTeams : Int = 2
	/// Number of players in the game
	var numberOfPlayers : Int = 0
	/// Source from the words
	var source : WordsResource = .Game
	/// Time to end each player turn
	private var time : Int = 0
	/// Timer to end each player turn
	private var	timer = NSTimer()
	/// Turn of the round that the game is
	private var turn : Int = 0
	/// Round that the game is
	var round : Round = .FirstRound
	/// Array with the scores from the teams at the game
	var totalScores : [Float]!
	/// Array with the scores from the teams at this round
	var roundScores : [Float]!
	/// Array to keep the words of the game
	private var words : [Word]!
	/// Number of words already answered
	private var answers : Int = 0
    //Json containing the game provided words
    private var wordsJson : NSDictionary!
	
	// MARK: - Game Cicle Methods
	
	/**
	Set the game basic configurations
	*/
	func startGame()
	{				
		// Init the scores with zero to all teams
		totalScores = [Float](count: numberOfTeams, repeatedValue: 0)
		roundScores = [Float](count: numberOfTeams, repeatedValue: 0)
		
		if source == .Game { self.getWords(numberOfWords) }
	}
	
	
    /**
    Start a new Round
    */
	func startRound() -> Int
	{
        if round != .FirstRound {
			for index in 0...(numberOfTeams - 1) {
				roundScores[index] = 0
			}
		}
		
		answers = 0
		
		return teamPlaying()
	}
	
    /**
	Start a new turn
	*/
    func startTurn() -> Int
    {
        if round == .FirstRound { time = 45 }
        else { time = 60 }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        
        return teamPlaying()
    }
	
	/**
	End a round, keeping the scores from the round on the array from the total scores
	*/
	func endRound()
	{
		// Save the final score
		for index in 0...(numberOfTeams - 1) {
			totalScores[index] += roundScores[index]
		}
		
		for i in 0...(numberOfWords - 1) {
			words[i].used = false
		}
		
        if(self.round == Round.FirstRound){
            self.round = Round.SecondRound
        }
        
        else if(self.round == Round.SecondRound){
            self.round = Round.ThirdRound
        }
        
        else if(self.round == Round.ThirdRound){
            self.round = Round.EndGame
        }
        
		turn = 0
		answers = 0
	}
	
	/**
	End the game, reseting the arrays and the round
	*/
	func endGame()
	{
		roundScores = nil
		totalScores = nil
		words = nil
		
		round = .FirstRound
	}
	
	// MARK: - Word Related Methods
	/**
	Get words from the saved data when the player asks or when the resource is the game
	*/
    func readWordsFomJson(){
        
        let path = NSBundle.mainBundle().pathForResource(NSLocalizedString("wordsJson",comment: ""), ofType: "txt")
        
        let data = NSData(contentsOfFile: path!)
                
        self.wordsJson =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
        
        
        if (self.wordsJson == nil) {
            print("ERROR OPENING JSON!!");
        }
    }
	
	/**
	Get the number of words passed as parameter from the Json file
	*/
	func getWords(size : Int)
	{
        self.readWordsFomJson()
        
        let wordsNumber = (self.wordsJson.objectForKey("size") as! NSString).integerValue
        let jsonWords = self.wordsJson.objectForKey("words") as! NSDictionary
        
        var repeated = [Bool](count: wordsNumber, repeatedValue: false)
        
        if words == nil { words = [Word]() }
		
        for i in 0...size-1{
			var index = NSNumber(unsignedInt: arc4random() % UInt32(wordsNumber)).integerValue
            
			while repeated[index] {
                index++
                if index >= size { index = 0 }
            }
            
            var new = Word()
            new.word = jsonWords.objectForKey("\(index)") as!  String
            new.used = false
            words.append(new)
            
            repeated[index] = true
        }
	}
	
	/**
	Insert a given word on the array of words that are going to be used in the game
	*/
	func insertWord(newWord: String)
	{
		if words == nil { words = [Word]() }
		
		var word = Word()
		
		word.word = newWord
		
		words.append(word)
	}
	
	/**
	Sort randomly the next word to be displayed to the player and increase the score to the team that is playing
	*/
	func nextWord() -> String
	{
		if numberOfWords == answers {
			return ""
		}
		
		var index = NSNumber(unsignedInt: arc4random() % UInt32(numberOfWords)).integerValue
		
		while words[index].used == true {
			index++
            if index == numberOfWords { index = 0 }
		}
				
		return words[index].word
	}
	
	// MARK: - Timer Related Methods
	
	/**
	Uptade the time count
	*/
	func updateTimer()
	{
		if --time == 0 {
			timer.invalidate()
            turn++
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("updateTimer", object: nil, userInfo: ["time": time])
    }
	
	// MARK: - Score Releated Methods
	
	/**
	Method that increase the score and verifies when all the words had been guessed
	*/
    func increaseScore(lastWord : String)
    {
		// Verifies if all the words had been guessed
		if numberOfWords == ++answers {
			timer.invalidate()
		}
		
		var i = 0
		
		for w in words {
			if w.word == lastWord {
				words[i].used = true
				break
			}
			i++
		}
		
        roundScores[teamPlaying()]++
    }
    
	// MARK: - Other Methods
	
	/**
	Returns the team that is playing
	*/
    private func teamPlaying() -> Int
    {
        return turn % numberOfTeams
    }
}

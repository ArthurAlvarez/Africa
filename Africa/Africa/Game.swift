//
//  Game.swift
//  Africa
//
//  Created by Felipe Eulalio on 07/07/15.
//  Copyright (c) 2015 Arthur Alvarez. All rights reserved.
//

import Foundation

enum Round {
	case FirstRound
	case SecondRound
	case ThirdRound
}

enum WordsResource {
	case Game
	case Players
}

struct Word {
	var word : String!
	var used : Bool = false
}

class Game : NSObject
{
	
	static let sharedInstance = Game()
	
	/// Number of words in the game
	var numberOfWords : Int = 0
	/// Number of teams in the game
	var numberOfTeams : Int = 2
	/// Number of players in the game
	var numberOfPlayers : Int = 0
	/// Source from the words
	var source : WordsResource = .Game
	/// Time to end each player turn
	var time : Int = 0
	/// Timer to end each player turn
	var	timer : NSTimer!
	/// Turn of the round that the game is
	var turn : Int = 0
	/// Round that the game is
	var round : Round = .FirstRound
	/// Array with the scores from the teams at the game
	var totalScores : [Int]!
	/// Array with the scores from the teams at this round
	var roundScores : [Int]!
	/// Array to keep the words of the game
	var words : [Word]!
	/// Number of words already answered
	var answers : Int = 0
	
	/**
	Set the game basic configurations
	*/
	func startGame()
	{
		round = .FirstRound
		
		answers = 0
		
		// Init the scores with zero to all teams
		totalScores = [Int](count: numberOfTeams, repeatedValue: 0)
		roundScores = [Int](count: numberOfTeams, repeatedValue: 0)
		
		words = [Word]()
		
		if source == .Game { self.getWords(numberOfWords) }
	}
	
	/**
	Get words from the saved data when the player asks or when the resource is the game
	*/
	func getWords(size : Int)
	{
		
	}
	
	func startTurn() -> Int
	{
		if round == .FirstRound { time = 45 }
		else {
			time = 60
			for index in 0...numberOfTeams {
				roundScores[index] = 0
			}
		}
		
		answers = 0
		
		timer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
		
		return ((turn++) % numberOfTeams)
	}
	
	func endTurn()
	{
		var minScore = roundScores[0]
		
		for score in roundScores {
			if minScore < score { minScore = score }
		}
		
		for index in 0...numberOfTeams {
			totalScores[index] = roundScores[index] - minScore
		}
		
		if answers == numberOfWords {
			if round == .FirstRound { round = .SecondRound }
			else if round == .SecondRound { round = .ThirdRound }
			else {
				
			}
			turn = 0
		}
	}
	
	func updateTimer()
	{
		if --time == 0 {
			timer.invalidate()
			endTurn()
		}
	}
	
	/**
	Sort randomly the next word to be displayed to the player
	*/
	func nextWord() -> String
	{
		if numberOfWords == answers {
			endTurn()
			return ""
		}
		
		var index = Int(arc4random()) % numberOfWords
		
		while words[index].used == true {
			index++
		}
		
		words[index].used = true
		
		return words[index].word
	}
}

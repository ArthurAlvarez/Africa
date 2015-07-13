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
	var numberOfWords : Int = 20
	/// Number of teams in the game
	var numberOfTeams : Int = 2
	/// Number of players in the game
	var numberOfPlayers : Int = 0
	/// Source from the words
	var source : WordsResource = .Game
	/// Time to end each player turn
	var time : Int = 0
	/// Timer to end each player turn
	var	timer = NSTimer()
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
        let word = ["futebol", "trave", "retangulo", "casa", "Parede", "Pedra", "tinta", "roupa", "nova", "Azul",
            "trauma", "cinza", "casamento", "ladrão", "touro", "marreta", "pao", "menta", "caso", "lua"];
        
        for w in word {
            var new = Word()
            new.word = w
            new.used = false
            words.append(new)
        }
		
		if source == .Game { self.getWords(numberOfWords) }
	}
	
	/**
	Get words from the saved data when the player asks or when the resource is the game
	*/
	func getWords(size : Int)
	{
		
	}
	
    /*
    Start a new Round
    */
	func startRound() -> Int
	{
        if round != .FirstRound {
			for index in 0...numberOfTeams {
				roundScores[index] = 0
			}
		}
		
		answers = 0
		
		return startTurn()
	}
    
    func startTurn() -> Int
    {
        if round == .FirstRound { time = 45 }
        else { time = 60 }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        
        return teamPlaying()
    }
	
	func endRound()
	{
		var minScore = roundScores[0]
		
//		for score in roundScores {
//			if minScore < score { minScore = score }
//		}
//		
//		for index in 0...numberOfTeams {
//			totalScores[index] = roundScores[index] - minScore
//		}
		
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
            turn++
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("updateTimer", object: nil, userInfo: ["time": time])
    }
    
    func increaseScore()
    {
        roundScores[teamPlaying()]++
    }
    
	/**
	Sort randomly the next word to be displayed to the player and increase the score to the team that is playing
	*/
    func nextWord() -> String
	{
		if numberOfWords == ++answers {
            timer.invalidate()
			return ""
		}
		
		var index = Int(arc4random()) % numberOfWords
		
		while words[index].used == true {
			index++
		}
		
		words[index].used = true
		
		return words[index].word
	}
    
    private func teamPlaying() -> Int
    {
        return turn % numberOfTeams
    }
}

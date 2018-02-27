//
//  MenuViewController.swift
//  Pong
//
//  Created by Mauricio Takashi Kiyama on 2/6/18.
//  Copyright © 2018 a+. All rights reserved.
//

import Foundation
import UIKit

enum gameType {
    case singleGame
    case player2
}

class MenuViewController: UIViewController {
    
    
    @IBAction func StartGame(_ sender: Any) {
        moveToGame(game: .singleGame)
    }
    @IBAction func Player2(_ sender: Any) {
        moveToGame(game: .player2)
    }
    
    func moveToGame(game: gameType) {
        let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        
        currentGameType = game
        
        self.navigationController?.pushViewController(gameViewController, animated: true)
        
    }
    
}


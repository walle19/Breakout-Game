//
//  GameViewController.swift
//  Breakout
//
//  Created by Nikhil Wali on 23/03/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    /*
     All game related constants used on the screen.
     */
    fileprivate struct GameConstants {
        
        struct WallInfo {
            static let BottomWall = "BottomWall"
        }
        
        struct GameOffSet {
            static let TopOffset:CGFloat = 60.0
        }
        
        struct GameAlert {
            static let GameOverTitle = "Game Over"
            static let GameOverMessage = "Do you want to play again?"
            
            static let NewHighestScore = "New Highest Score\nCongratulations"
            
            static let AppTitle = "Breakout"
            
            static let AlertYes = "Yes"
            static let AlertNo = "No"
        }
        
        struct AudioInfo {
            static let AudioFileName = "background_music"
            static let AudioFileType = "m4a"
        }
    }
    
    // MARK: Game Objects
    
    var brick: Bricks!
    var paddle = Paddle()
    var ball: Ball!
    
    let settings = Settings()
    
    let breakoutBehavior = BreakoutBehavior()
    
    lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.gameView)
        return animator
    }()
    
    @IBOutlet fileprivate weak var gameView: BezierPathsView!
    
    @IBOutlet fileprivate weak var tapToStartView: UIView!
    
    fileprivate var isGameStarted: Bool = true
    
    // MARK: Score And Ball
    
    @IBOutlet fileprivate weak var lifeLineFirst: UIImageView!
    @IBOutlet fileprivate weak var lifeLineSecond: UIImageView!
    @IBOutlet fileprivate weak var lifeLineThird: UIImageView!
    
    @IBOutlet weak var score: UILabel!
    
    fileprivate var gameScore: Int = 0
    
    fileprivate var numberOfLives: Int = 3

    // MARK: Bricks
    
    fileprivate var numberOfBricksRemoved: Int = 0
    
    // MARK: Background music
    
    fileprivate var player: AVAudioPlayer = {
        var player = AVAudioPlayer()
        let url = Bundle.main.url(forResource: GameConstants.AudioInfo.AudioFileName, withExtension: GameConstants.AudioInfo.AudioFileType)!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
        return player
    }()
    
    fileprivate func playOrStopMusic(isPlay: Bool) {
        if isPlay && !player.isPlaying {
            player.numberOfLoops = -1
            player.play()
        }
        else if !isPlay && player.isPlaying {
            player.stop()
        }
    }
    
    // MARK: Viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Build game components
        buildBricks()
        buildPaddle()
        buildBall()
        
        animator.addBehavior(breakoutBehavior)
        breakoutBehavior.collisionDelegate = self
        
        buildBottomWall()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(audioUpdateNotification(_:)), name: .audioUpdateNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ball.speedOfBall = settings.ballSpeed
        ball.ballCount = settings.numberOfBalls
        
        paddle.paddleWidthOffset = settings.paddleWidth
    
        playOrStopMusic(isPlay: settings.isAudioOn)
        
        if tapToStartView.isHidden {
            tapToStartView.isHidden = false
        }
        
        self.view.setNeedsLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove all the existing balls
        for item in breakoutBehavior.items {
            breakoutBehavior.removeBall(item)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isGameStarted || settings.isUpdated {
            settings.isUpdated = false
            isGameStarted = false
            resetGame()
        }
    }
    
    // MARK: Game components and reset
    
    fileprivate func buildBricks() {
        brick =  Bricks(row: 10, column: 5)
        brick.gameView = self.gameView
        brick.breakoutBehavior = self.breakoutBehavior
    }
    
    fileprivate func buildPaddle() {
        paddle.gameView = self.gameView
        paddle.breakoutBehavior = self.breakoutBehavior
        paddle.paddleWidthOffset = settings.paddleWidth
        paddle.setupPaddle()
    }
    
    fileprivate func buildBall() {
        ball = Ball(numberOfBalls: settings.numberOfBalls, speed: settings.ballSpeed)
        ball.gameView = self.gameView
        ball.breakoutBehavior = breakoutBehavior
        ball.paddleHeight = paddle.paddleHeight
    }
    
    fileprivate func resetGame() {
        numberOfBricksRemoved = 0
        paddle.resetPaddle()
        brick.buildBricks()
        showLifeLine()
    }
    
    // MARK: NotificationCentre
    
    @objc fileprivate func audioUpdateNotification(_ notification: NSNotification) {
        playOrStopMusic(isPlay: (notification.userInfo?["isPlay"] as? Bool)!)
    }
    
    // MARK: LifeLines
    
    fileprivate func hideLifeLine() {
        numberOfLives -= 1
        
        switch numberOfLives {
        case 2: lifeLineFirst.isHidden = true
            break
        case 1: lifeLineSecond.isHidden = true
            break
        case 0: lifeLineThird.isHidden = true
            break
        default:
            break
        }
    }
    
    fileprivate func showLifeLine() {
        numberOfLives = 3
        lifeLineFirst.isHidden = false
        lifeLineSecond.isHidden = false
        lifeLineThird.isHidden = false
    }
    
    // MARK: Collision Delegate
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if let identifierString = identifier as? String {
            if let brickIndex = Int(identifierString) {
                animateAndRemoveBrick(brickIndex)
            }
            else if identifierString == GameConstants.WallInfo.BottomWall {
                
                hideLifeLine()  // Hide the lifeline from the view
                
                if numberOfLives == 0 {
                    self.endGame()
                    return
                }
                
                for item in breakoutBehavior.items {
                    breakoutBehavior.removeBall(item)
                }
                tapToStartView.isHidden = false
            }
        }
    }
    
    // MARK: Start Game

    @IBAction fileprivate func startGame(_ sender: UITapGestureRecognizer?) {
        
        if !tapToStartView.isHidden {
            tapToStartView.isHidden = true
        }
        
        if breakoutBehavior.items.count > 0 {
            return
        }
        
        ball.paddleCenter = paddle.paddleCenter
        print("Paddle center: \(paddle.paddleCenter)")
        let pushes = ball.placeBall()
        for push in pushes {
            animator.addBehavior(push)
        }
    }
    
    // MARK: Bottom Wall
    
    fileprivate func buildBottomWall() {
        let barrierOrigin = CGPoint(x: 0, y: gameView.bounds.size.height)
        let barrierSize = CGSize(width: gameView.bounds.size.width, height: 1)
        let path = UIBezierPath(rect: CGRect(origin: barrierOrigin, size: barrierSize))
        breakoutBehavior.addBarrier(path, named: GameConstants.WallInfo.BottomWall)
        gameView.setPath(path, named: GameConstants.WallInfo.BottomWall)
    }
    
    // MARK: Paddle Move
    
    @IBAction fileprivate func movePaddle(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended: fallthrough
        case .changed:
            let translation = sender.translation(in: gameView)
            let positionChange = translation.x
            
            if positionChange != 0 {
                paddle.paddleXPosition += positionChange
                sender.setTranslation(CGPoint.zero, in: gameView)
            }
            
        default: break
        }
    }
    
    // MARK: Brick animate and remove
    
    fileprivate func animateAndRemoveBrick(_ i: Int) {
        breakoutBehavior.removeBarrier(named: "\(i)")
        
        /*
         Formula for score calculation based on speed of ball, width of paddle and ball count
        */
        let scoreForSpeed = 10.0 * ball.speedOfBall
        let scoreForBallCount = 20 * ball.ballCount
        let scoreForPaddleWidth = 50.0 * paddle.paddleWidthOffset
        gameScore += Int(Int(scoreForSpeed) + scoreForBallCount - Int(scoreForPaddleWidth))
        score!.text = "\(gameScore)"
        
        // increment bricks removed counter
        numberOfBricksRemoved += 1
        
        /*
         Animation to fade the collided brick
         */
        UIView.transition(with: brick.bricks[i], duration: 0.1, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            self.brick.bricks[i].backgroundColor = UIColor.white
        }, completion: { (finished) -> Void in
            
            /*
             Animation to remove the collided brick
             */
            UIView.animate(withDuration: 1, delay: 0.4, options: UIViewAnimationOptions(), animations: {
                self.brick.bricks[i].alpha = 0
                
                if self.numberOfBricksRemoved >= self.brick.bricks.count {
                    DispatchQueue.main.async {
                        self.endGame()
                    }
                }
            }, completion: nil)
            
        })
        
    }
    
    // MARK: Game Over
    
    fileprivate func endGame() {
        // Remove all the balls
        for item in breakoutBehavior.items {
            breakoutBehavior.removeBall(item)
        }
        
        // If gameScore is <= highestScore then end game
        if gameScore <= settings.highestScore {
            showEndGameAlert()
            return
        }
        
        // Else set new highest score and show alert for new highest score
        settings.highestScore = gameScore
        
        let alert = UIAlertController(title: GameConstants.GameAlert.AppTitle, message: GameConstants.GameAlert.NewHighestScore, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: GameConstants.GameAlert.AlertYes, style: .default) {
            (action) in
            self.showEndGameAlert()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showEndGameAlert() {
        let alert = UIAlertController(title: GameConstants.GameAlert.GameOverTitle, message: GameConstants.GameAlert.GameOverMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: GameConstants.GameAlert.AlertYes, style: .default) {
            (action) in
            self.tapToStartView.isHidden = false
            self.resetGame()
        })
        
        alert.addAction(UIAlertAction(title: GameConstants.GameAlert.AlertNo, style: .cancel) {
            (action) in
            if self.player.isPlaying { // Stop music if playing
                self.player.stop()
            }
            
            NotificationCenter.default.removeObserver(self, name: .audioUpdateNotification, object: nil)
            
            self .dismiss(animated: true, completion: nil)  // Navigate back to home screen
        })
        
        isGameStarted = true
        
        present(alert, animated: true, completion: nil)
    }
}

// Custom notification type
extension Notification.Name {
    static let audioUpdateNotification = Notification.Name("audioUpdateNotification")
}

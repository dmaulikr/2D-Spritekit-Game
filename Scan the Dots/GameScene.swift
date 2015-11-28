//
//  GameScene.swift
//  Scan the Dots
//
//  Created by Tassilo Lechner von Leheneck on 31/10/15.
//  Copyright (c) 2015 Tassilo Lechner von Leheneck. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene {
    
    let colorChanger = ColorChanger()
    
    var viewController: GameViewController!
    
    var Circle = SKSpriteNode()
    var Person = SKSpriteNode()
    var Dot = SKSpriteNode()
    var Star = SKSpriteNode()
    var Star2 = SKSpriteNode()
    var Star3 = SKSpriteNode()
    var Star4 = SKSpriteNode()
    var Star5 = SKSpriteNode()
    var Star6 = SKSpriteNode()
    var Star7 = SKSpriteNode()
    var Star8 = SKSpriteNode()
    var Star9 = SKSpriteNode()
    var BlackStar = SKSpriteNode()
    var Path = UIBezierPath()
    var bought = Int()
    
    var gameStarted = Bool()
    var movingClockWise = Bool()
    var intersected = false
    
    var ScoreLabel = UILabel()
    var HighScoreLabel = UILabel()
    var RemoveAds = UIButton()
    
    var currentScore = Int()
    var highScore = Int()
    var theSpeed = CGFloat(400)
    
    var soundPoint = SKAction.playSoundFileNamed("sfx_point.mp3", waitForCompletion: false)
    var soundDie = SKAction.playSoundFileNamed("sfx_die.mp3", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        backView()
    }
    
    func backView(){
        
        let Defaults = NSUserDefaults.standardUserDefaults()
        if Defaults.integerForKey("High Score") != -1 {
            highScore = Defaults.integerForKey("High Score") as Int!
        }
        
        viewController.incrementCurrentPercentOfAchievement("Star1", amount: (Double(highScore)/10.0)*100)
        viewController.incrementCurrentPercentOfAchievement("Star2", amount: (Double(highScore)/25.0)*100)
        viewController.incrementCurrentPercentOfAchievement("Star3", amount: (Double(highScore)/50.0)*100)
        viewController.incrementCurrentPercentOfAchievement("Star4", amount: (Double(highScore)/100.0)*100)
        viewController.incrementCurrentPercentOfAchievement("Star5", amount: (Double(highScore)/150.0)*100)
        viewController.incrementCurrentPercentOfAchievement("Star6", amount: (Double(highScore)/200.0)*100)
        viewController.incrementCurrentPercentOfAchievement("Star7", amount: (Double(highScore)/300.0)*100)
        viewController.incrementCurrentPercentOfAchievement("Star8", amount: (Double(highScore)/500.0)*100)
        viewController.incrementCurrentPercentOfAchievement("Star9", amount: (Double(highScore)/750.0)*100)
        viewController.incrementCurrentPercentOfAchievement("BlackStar", amount: (Double(highScore)/1000.0)*100)

            
            let color = colorChanger.randomColor()
            self.scene?.backgroundColor = color
            
            
            ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
            ScoreLabel.center = (self.view?.center)!
            ScoreLabel.textColor = SKColor.whiteColor()
            ScoreLabel.textAlignment = NSTextAlignment.Center
            ScoreLabel.font = UIFont(name: "GROBOLD", size: 80)
            
            self.view?.addSubview(ScoreLabel)
            
            currentScore = viewController.myScore
            bought = viewController.myChoice
            
            viewController.view.userInteractionEnabled = true
            
            if bought == 0 {
                loadMyView()
            }
            else if bought == 1 {
                loadSpecialView()
            }
    }
    
    
    func loadMyView(){
        currentScore = 0
        loadSpecialView()
    }

    func loadSpecialView(){
    
        HighScoreLabel = UILabel(frame: CGRect(x: 7, y: -10, width: 300, height: 100))
        HighScoreLabel.textColor = SKColor.whiteColor()
        HighScoreLabel.textAlignment = NSTextAlignment.Left
        HighScoreLabel.font = UIFont(name: "GROBOLD", size: 30)

        Star = SKSpriteNode(imageNamed: "Star")
        Star.size = CGSize(width: 30, height: 30)
        Star.position = CGPoint(x: CGRectGetMinX(self.frame) + 20, y: CGRectGetMaxY(self.frame) - 75 )
        Star.zPosition = 5.0
        
        Star2 = SKSpriteNode(imageNamed: "Star")
        Star2.size = CGSize(width: 30, height: 30)
        Star2.position = CGPoint(x: CGRectGetMinX(self.frame) + 51, y: CGRectGetMaxY(self.frame) - 75 )
        Star2.zPosition = 5.0
        
        Star3 = SKSpriteNode(imageNamed: "Star")
        Star3.size = CGSize(width: 30, height: 30)
        Star3.position = CGPoint(x: CGRectGetMinX(self.frame) + 82, y: CGRectGetMaxY(self.frame) - 75 )
        Star3.zPosition = 5.0
        
        Star4 = SKSpriteNode(imageNamed: "Star")
        Star4.size = CGSize(width: 30, height: 30)
        Star4.position = CGPoint(x: CGRectGetMinX(self.frame) + 113, y: CGRectGetMaxY(self.frame) - 75 )
        Star4.zPosition = 5.0
        
        Star5 = SKSpriteNode(imageNamed: "Star")
        Star5.size = CGSize(width: 30, height: 30)
        Star5.position = CGPoint(x: CGRectGetMinX(self.frame) + 144, y: CGRectGetMaxY(self.frame) - 75 )
        Star5.zPosition = 5.0
        
        Star6 = SKSpriteNode(imageNamed: "Star")
        Star6.size = CGSize(width: 30, height: 30)
        Star6.position = CGPoint(x: CGRectGetMinX(self.frame) + 175, y: CGRectGetMaxY(self.frame) - 75 )
        Star6.zPosition = 5.0
        
        Star7 = SKSpriteNode(imageNamed: "Star")
        Star7.size = CGSize(width: 30, height: 30)
        Star7.position = CGPoint(x: CGRectGetMinX(self.frame) + 206, y: CGRectGetMaxY(self.frame) - 75 )
        Star7.zPosition = 5.0
        
        Star8 = SKSpriteNode(imageNamed: "Star")
        Star8.size = CGSize(width: 30, height: 30)
        Star8.position = CGPoint(x: CGRectGetMinX(self.frame) + 237, y: CGRectGetMaxY(self.frame) - 75 )
        Star8.zPosition = 5.0
        
        Star9 = SKSpriteNode(imageNamed: "Star")
        Star9.size = CGSize(width: 30, height: 30)
        Star9.position = CGPoint(x: CGRectGetMinX(self.frame) + 268, y: CGRectGetMaxY(self.frame) - 75 )
        Star9.zPosition = 5.0
        
        BlackStar = SKSpriteNode(imageNamed: "BlackStar")
        BlackStar.size = CGSize(width: 30, height: 30)
        BlackStar.position = CGPoint(x: CGRectGetMinX(self.frame) + 299, y: CGRectGetMaxY(self.frame) - 75 )
        BlackStar.zPosition = 5.0
        
        Circle = SKSpriteNode(imageNamed: "Circle")
        Circle.size = CGSize(width: 300, height: 300)
        Circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        Person = SKSpriteNode(imageNamed: "Person")
        Person.size = CGSize(width:40, height: 7)
        Person.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 120)
        Person.zRotation = 3.14/2
        Person.zPosition = 2.0
        
        movingClockWise = true
        
        
        self.addChild(Circle)
        self.addChild(Person)
        addDot()
        
        ScoreLabel.text = "\(currentScore)"
        HighScoreLabel.text = "High Score: \(highScore)"

        self.view?.addSubview(HighScoreLabel)
        
        
        if highScore > 9 && highScore < 25 {
            self.addChild(Star)
        }
        else if highScore > 24 && highScore < 50 {
            self.addChild(Star)
            self.addChild(Star2)
        }
        else if highScore > 49 && highScore < 100 {
            self.addChild(Star)
            self.addChild(Star2)
            self.addChild(Star3)
        }
        else if highScore > 99 && highScore < 150 {
            self.addChild(Star)
            self.addChild(Star2)
            self.addChild(Star3)
            self.addChild(Star4)
        }
        else if highScore > 149 && highScore < 200 {
            self.addChild(Star)
            self.addChild(Star2)
            self.addChild(Star3)
            self.addChild(Star4)
            self.addChild(Star5)
        }
        else if highScore > 199 && highScore < 300 {
            self.addChild(Star)
            self.addChild(Star2)
            self.addChild(Star3)
            self.addChild(Star4)
            self.addChild(Star5)
            self.addChild(Star6)
        }
        else if highScore > 299 && highScore < 500 {
            self.addChild(Star)
            self.addChild(Star2)
            self.addChild(Star3)
            self.addChild(Star4)
            self.addChild(Star5)
            self.addChild(Star6)
            self.addChild(Star7)
        }
        else if highScore > 499 && highScore < 750 {
            self.addChild(Star)
            self.addChild(Star2)
            self.addChild(Star3)
            self.addChild(Star4)
            self.addChild(Star5)
            self.addChild(Star6)
            self.addChild(Star7)
            self.addChild(Star8)
        }
        else if highScore > 749 && highScore < 1000 {
            self.addChild(Star)
            self.addChild(Star2)
            self.addChild(Star3)
            self.addChild(Star4)
            self.addChild(Star5)
            self.addChild(Star6)
            self.addChild(Star7)
            self.addChild(Star8)
            self.addChild(Star9)
        }
        else if highScore > 999 {
            self.addChild(Star)
            self.addChild(Star2)
            self.addChild(Star3)
            self.addChild(Star4)
            self.addChild(Star5)
            self.addChild(Star6)
            self.addChild(Star7)
            self.addChild(Star8)
            self.addChild(Star9)
            self.addChild(BlackStar)
        }
        
        if currentScore > 99 && currentScore < 1000{
            ScoreLabel.font = UIFont(name: "GROBOLD", size: 70)
            ScoreLabel.text = "\(currentScore)"
        }
        else if currentScore > 999 {
            ScoreLabel.font = UIFont(name: "GROBOLD", size: 55)
            currentScore = 1000
            ScoreLabel.text = "1000"
        }
        else{
            ScoreLabel.text = "\(currentScore)"
        }

    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameStarted == false {
            moveClockWise()
            movingClockWise = true
            gameStarted = true
        }
        else if gameStarted == true {
           
            if movingClockWise == true{
                moveCounterClockWise()
                movingClockWise = false
            }
            
            else if movingClockWise == false{
                moveClockWise()
                movingClockWise = true
            }
            dotTouched()
        }
    }
    
    
    func addDot(){
        Dot = SKSpriteNode(imageNamed: "Dot")
        Dot.size = CGSize(width: 30, height: 30)
        Dot.zPosition = 1.0
        
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        
        let rad = atan2(dy, dx)
        
        if movingClockWise == true {
            let tempAngle = CGFloat.random(min: rad - 1.0, max: rad - 2.5)
            let Path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            Dot.position = Path2.currentPoint
        }
        else if movingClockWise == false {
            let tempAngle = CGFloat.random(min: rad + 1.0, max: rad + 2.5)
            let Path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            Dot.position = Path2.currentPoint
            
        }
        self.addChild(Dot)
        
        if currentScore > 99 && currentScore < 1000{
            ScoreLabel.font = UIFont(name: "GROBOLD", size: 70)
            ScoreLabel.text = "\(currentScore)"
        }
        else if currentScore > 999 {
            ScoreLabel.font = UIFont(name: "GROBOLD", size: 55)
            currentScore = 1000
            ScoreLabel.text = "1000"
        }
        else {
            ScoreLabel.text = "\(currentScore)"
        }

    }
    
    func playSound(sound : SKAction)
    {
        runAction(sound)
    }

    func moveClockWise(){
        
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        
        let rad = atan2(dy, dx)
        
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: theSpeed)
        Person.runAction(SKAction.repeatActionForever(follow).reversedAction())
    }
    
    func moveCounterClockWise(){
        
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        
        let rad = atan2(dy, dx)
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: theSpeed)
        Person.runAction(SKAction.repeatActionForever(follow))
    }
    
    func randRange (lower: Int ,upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func dotTouched() {
        if intersected == true {
            playSound(soundPoint)
            Dot.removeFromParent()
            currentScore++
            if theSpeed < 500{
                self.theSpeed += 2
            }
            else if theSpeed > 499{
                self.theSpeed = 500
            }
            
            addDot()
            intersected = false
        }
        else if intersected == false {
            died()
        }
    }
    
    
    func died() {
        playSound(soundDie)
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1, duration: 0.2)
        let color2 = colorChanger.randomColor()
        let action2 = SKAction.colorizeWithColor(color2, colorBlendFactor: 1, duration: 0.2)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        intersected = false
        gameStarted = false
        
        if viewController.LBscore > highScore && viewController.LBscore > currentScore {
            highScore = viewController.LBscore
        }
        else if currentScore > highScore {
            highScore = currentScore
        }
        let Defaults = NSUserDefaults.standardUserDefaults()
        Defaults.setInteger(highScore, forKey: "High Score")
        HighScoreLabel.text = "High Score: \(highScore)"
        
        HighScoreLabel.removeFromSuperview()
        ScoreLabel.removeFromSuperview()
        
        bought = 0
        
        viewController.view.userInteractionEnabled = false
        
        let seconds = 0.2
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.viewController.playerDies()
        })
    }
   
    override func update(currentTime: CFTimeInterval) {
        if Person.intersectsNode(Dot){
            intersected = true
        }
        else {
            if intersected == true {
                if Person.intersectsNode(Dot) == false{
                    died()
                }
            }
        }
    }
}
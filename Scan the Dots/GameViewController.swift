//
//  GameViewController.swift
//  Scan the Dots
//
//  Created by Tassilo Lechner von Leheneck on 31/10/15.
//  Copyright (c) 2015 Tassilo Lechner von Leheneck. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import StoreKit
import GameKit
import GoogleMobileAds
import CoreGraphics
import Foundation

class GameViewController: UIViewController, ADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, GKGameCenterControllerDelegate,GADBannerViewDelegate{
    
    
    @IBOutlet var banner: ADBannerView!
    @IBOutlet var bannerGoogle: GADBannerView!
    
    @IBOutlet var outRemoveAds: UIButton!
    @IBOutlet var outRestorePurchases: UIButton!
    
    @IBOutlet var Infobulle: UIImageView!
    
    
    var iMinSessions = 30
    var iTryAgainSessions = 15
    
    var currentGame: GameScene!
    var menuViewController: MenuViewController?
    
    var myScore = Int()
    var myChoice = Int()
    var LBscore = Int()
    
    var GameCenterAchievements = [String: GKAchievement]()
    
    var shown = false
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as? MenuViewController
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rateMe()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("val") != nil {
            banner.removeFromSuperview()
            bannerGoogle.removeFromSuperview()
            outRemoveAds.removeFromSuperview()
            outRestorePurchases.removeFromSuperview()
        }
        else {
        }
        
        Infobulle.hidden = true
        
        if(SKPaymentQueue.canMakePayments()){
            let productID:NSSet = NSSet(objects:"vonleheneck.iap.removeAdsFromScan")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        }
        else{
            
        }
        
        self.bannerGoogle.rootViewController = self;
        self.bannerGoogle.delegate = self;
        
        bannerGoogle.adUnitID = "ca-app-pub-8506091708334492/3825250561"
        bannerGoogle.loadRequest(GADRequest())
        bannerGoogle.hidden = false
        
        banner.delegate = self
        banner.hidden = false
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            scene.viewController = self
            currentGame = scene
            skView.presentScene(scene)
            
        }
        authenticateLocalPlayer()
        saveHighscore(currentGame.highScore)
        retrieveScore()
        GameCenterAchievements.removeAll()
        loadAchievements()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func ShowInfo(sender: UIButton) {
        if shown == false {
            Infobulle.hidden = false
            shown = true
        }
        else if shown == true {
            Infobulle.hidden = true
            shown = false
        }
    }

    
    //iAd and Admob replacement
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        banner.hidden = false
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.banner.hidden = true
        self.bannerGoogle.hidden = false
    }

  
    //IAP Ads
    
    @IBAction func removeAds(sender: UIButton) {
        for product in list1{
            let prodID1 = product.productIdentifier
            if (prodID1 == "vonleheneck.iap.removeAdsFromScan"){
                p1 = product
                buyProduct()
                break
            }
        }
    }
    @IBAction func restorePurchases(sender: UIButton) {
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    

    
    //IAP Functions
    
    var list1 = [SKProduct]()
    var p1 = SKProduct()
    
    func removeAds(){
        banner.removeFromSuperview()
        bannerGoogle.removeFromSuperview()
        outRemoveAds.removeFromSuperview()
        outRestorePurchases.removeFromSuperview()
        let theValue = 10
        NSUserDefaults.standardUserDefaults().setObject(theValue, forKey: "val")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func buyProduct(){
        let pay1 = SKPayment (product: p1)
        SKPaymentQueue.defaultQueue().addPayment(pay1 as SKPayment)
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        let myOneProduct = response.products
        
        for product in myOneProduct{
            
            list1.append(product as SKProduct)
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        
        for transaction:AnyObject in transactions{
            let transa = transaction as! SKPaymentTransaction
            print(transa.error)
            switch transa.transactionState{
            case .Purchased:
                print(p1.productIdentifier)
                
                let prodID1 = p1.productIdentifier as String
                switch prodID1{
                case "vonleheneck.iap.removeAdsFromScan":
                    
                    removeAds()
                default:
                    break
                }
                queue.finishTransaction(transa)
                break
            case .Failed:
                queue.finishTransaction(transa)
                break
            case .Restored:
                queue.finishTransaction(transa)
                break
            default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        
        _ = []
        for transaction in queue.transactions {
            let t1: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID1 = t1.payment.productIdentifier as String
            switch prodID1{
            case "vonleheneck.iap.removeAdsFromScan":
                removeAds()
            default:
                break
            }
            
            
        }
    }
    func finishTransaction(trans:SKPaymentTransaction){
        //print("Finshed Transaction")
    }
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        //print("Remove Transaction")
    }
    
    // Game Center
    
    
    
    @IBAction func showLeaderBoard(sender: UIButton) {
        showLeader()
        saveHighscore(currentGame.highScore)
    }
    
    
    
    
    func saveHighscore(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "ScanTheDotsLeaderboard") //leaderboard id here
            
            scoreReporter.value = Int64(currentGame.highScore) //score variable here (same as above)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
           GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil {
                }
            })
            
        }
        
    }
    
 
    
    //shows leaderboard screen
    func showLeader() {
        let vc = self
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
                
            else {
            }
        }
        
    }
    
    //retrieve High Score
    
    func retrieveScore(){
        let leaderBoardRequest = GKLeaderboard()
        leaderBoardRequest.identifier = "ScanTheDotsLeaderboard"
        leaderBoardRequest.loadScoresWithCompletionHandler { (scores, error) -> Void in
            if (error != nil) {
            } else if (scores != nil) {
                let localPlayerScore = leaderBoardRequest.localPlayerScore
                self.LBscore = Int(localPlayerScore!.value)
            }
        }
    }
    
    //Achievements
    
    func loadAchievements() {
        GKAchievement.loadAchievementsWithCompletionHandler({(allAchievements,error) -> Void in
            
            if error != nil {
            }
            else {
                if allAchievements != nil{
                    for theAchievement in allAchievements!{
                        if let singleAchievement:GKAchievement = theAchievement{
                            self.GameCenterAchievements[theAchievement.identifier!] = singleAchievement
                        }
                    }
                }
            }
            
        })
    }
    
    func incrementCurrentPercentOfAchievement(identifier: String, amount: Double){
        if GKLocalPlayer.localPlayer().authenticated{
            var currentPercentFound:Bool = false
            if GameCenterAchievements.count != 0 {
                for (id, achievement) in GameCenterAchievements {
                    if (id == identifier){
                        currentPercentFound = true
                        var currentPercent: Double = achievement.percentComplete
                        currentPercent = amount
                        if achievement.percentComplete >= 100 {
                            achievement.showsCompletionBanner = true
                        }
                        reportAchievement(identifier, percentComplete: currentPercent)
                        break
                    }
                }
                
            }
            if currentPercentFound == false {
                reportAchievement(identifier, percentComplete: amount)
            }
        }
    }
  
    func reportAchievement (identifier: String, percentComplete: Double){
        let achievement = GKAchievement(identifier: identifier)
        achievement.percentComplete = percentComplete
        let achievementArray:[GKAchievement] = [achievement]
        GKAchievement.reportAchievements(achievementArray, withCompletionHandler: {
            error -> Void in
            if error != nil {
            }
            else {
                self.GameCenterAchievements.removeAll()
                self.loadAchievements()
            }
        })
    }
    
    func clearAchievements(){
        GKAchievement.resetAchievementsWithCompletionHandler {
            (error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                self.GameCenterAchievements.removeAll()
            }
        }
    }
    
    func rateMe() {
        let neverRate = NSUserDefaults.standardUserDefaults().boolForKey("neverRate")
        var numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches") + 1
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: "Would you like to Rate Us ?", message: "Thanks for using Scan the Dots", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Rate Scan the Dots", style: UIAlertActionStyle.Default, handler: { alertAction in
            UIApplication.sharedApplication().openURL(NSURL(string : "https://itunes.apple.com/ro/app/scan-the-dots/id1055184378?mt=8")!)
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }


    func playerDies(){
        menuViewController?.thatScore = currentGame.currentScore
        self.presentViewController(menuViewController!, animated: true, completion: nil)
    }
}






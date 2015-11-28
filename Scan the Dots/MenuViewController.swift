//
//  MenuViewController.swift
//  Scan the Dots
//
//  Created by Tassilo Lechner von Leheneck on 11/11/15.
//  Copyright © 2015 Tassilo Lechner von Leheneck. All rights reserved.
//

import UIKit
import StoreKit
import Social




class MenuViewController: UIViewController, SKProductsRequestDelegate,SKPaymentTransactionObserver {

    @IBOutlet var outRestart: UIButton!
    @IBOutlet var outBuy: UIButton!
    @IBOutlet var Score: UILabel!
    @IBOutlet var moreApps: UIButton!
    
    var currentGame: GameScene!
    var viewController: GameViewController!

    var thatScore = Int()
    var anotherScore = Int()
    var buyornot = Int()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        outBuy.backgroundColor = UIColor.blackColor()
        outRestart.backgroundColor = UIColor.whiteColor()
        outBuy.titleLabel!.font = UIFont (name: "GROBOLD", size: 30)
        outRestart.titleLabel!.font = UIFont (name: "GROBOLD", size: 30)
        let scene = GameScene(fileNamed:"GameScene")
        currentGame = scene
        
        if thatScore == 1000{
            Score.text = "Amazing! You reached the MAX SCORE: \(thatScore) !"
        }
        else{
            Score.text = "Keep improving your Current Score : \(thatScore)"
        }
        
        anotherScore = thatScore
        
        if(SKPaymentQueue.canMakePayments()){
            //print("IAP is enabled, loading...")
            let productID:NSSet = NSSet(objects:"vonleheneck.iap.buyakeepon")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        }
        else{
            //print("Please enable IAPS")
            
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Back(){
        let destinationVC = self.presentingViewController as! GameViewController
        let aScore = anotherScore
        let choice = buyornot
        destinationVC.myScore = aScore
        destinationVC.myChoice = choice
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)    }

    
    @IBAction func showMoreApps(sender: UIButton) {
        Chartboost.showMoreApps(CBLocationGameOver)
    }
    @IBAction func showOneApp(sender: UIButton) {
        Chartboost.showInterstitial(CBLocationDefault)
    }
    
    @IBAction func restart(sender: UIButton) {
        buyornot = 0
        Back()
    }
    
    @IBAction func buy(sender: UIButton) {
        for product in list{
            let prodID = product.productIdentifier
            if (prodID == "vonleheneck.iap.buyakeepon"){
                p = product
                buyProduct()
                break
            }
        }

    }
    
    //IAP Functions
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func keepOn(){
        buyornot = 1
        Back()
    }
    
    func buyProduct(){
        //print("Buy: "+p.productIdentifier)
        let pay = SKPayment (product: p)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        //print("Product Request")
        let myProduct = response.products
        
        for product in myProduct{
            //print("Product Added")
            //print(product.productIdentifier)
            //print(product.localizedTitle)
            //print(product.localizedDescription)
            //print(product.price)
            
            list.append(product as SKProduct)
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //print("Add Payment")
        
        for transaction:AnyObject in transactions{
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            switch trans.transactionState{
            case .Purchased:
                //print("IAP unlocked")
                //print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID{
                case "vonleheneck.iap.buyakeepon":
                    //print("Keep on")
                    keepOn()
                default:
                    //print("IAP not setup")
                    break
                }
                queue.finishTransaction(trans)
                break
            case .Failed:
                //print ("Buy error")
                queue.finishTransaction(trans)
                break
            default:
                //print("default: Error")
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
    
    
    // Social
    
    
    @IBAction func Fb(sender: UIButton) {
    
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func Twitter(sender: UIButton){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}




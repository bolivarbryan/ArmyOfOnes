//
//  ViewController.swift
//  ArmyOfOnes
//
//  Created by Bryan Bolivar Martinez on 4/29/15.
//  Copyright (c) 2015 Bryan Bolivar Martinez. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var currencies: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //getTodayCurrencies()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateListOfCurrencies()
    }
    
    func updateListOfCurrencies(){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Currency")
        var error: NSError?
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        if let results = fetchedResults {
            currencies = results
            println(results)
            self.tableView.reloadData()
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getTodayCurrencies(){
        var url : String = "https://openexchangerates.org/api/latest.json?app_id=49c35d1117784525aebf0dd6907d4865"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            if (jsonResult != nil) {
                println(jsonResult)
                var currencies = [NSManagedObject]()
                let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext!
                for rate in jsonResult.objectForKey("rates") as! NSDictionary {
                    let entity =  NSEntityDescription.entityForName("Currency",
                        inManagedObjectContext:
                        managedContext)
                    let currency = NSManagedObject(entity: entity!,
                        insertIntoManagedObjectContext:managedContext)
                    currency.setValue(rate.key, forKey: "country")
                    currency.setValue(rate.value, forKey: "value")
                    var error: NSError?
                    if !managedContext.save(&error) {
                        println("Could not save \(error), \(error?.userInfo)")
                    }
                    currencies.append(currency)
                }
                self.updateListOfCurrencies()
            } else {
            }
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! CurrencyTableViewCell
        
        //cell.textLabel?.text = "sss"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}


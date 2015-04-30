//
//  ViewController.swift
//  ArmyOfOnes
//
//  Created by Bryan Bolivar Martinez on 4/29/15.
//  Copyright (c) 2015 Bryan Bolivar Martinez. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext?
    @IBOutlet weak var tableView: UITableView!
    var currencies: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
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
            if currencies.isEmpty {
                getTodayCurrencies()
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
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
                var myMO:NSManagedObject
                for rate in jsonResult.objectForKey("rates") as! NSDictionary {
                        myMO = NSEntityDescription.insertNewObjectForEntityForName("Currency", inManagedObjectContext: managedContext) as! NSManagedObject
                        myMO.setValue(rate.key as! String, forKey: "country")
                        myMO.setValue(rate.value as! NSNumber, forKey: "value")
                }
                self.updateListOfCurrencies()
            } else {
            }
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CurrencyTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! CurrencyTableViewCell
        var currency: NSManagedObject = currencies[indexPath.row]
        let value: NSNumber = currency.valueForKey("value") as! NSNumber
        let country: String = currency.valueForKey("country")  as! String
        cell.currency.text = "\(country): \(value) "
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}


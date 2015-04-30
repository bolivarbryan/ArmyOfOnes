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
    @IBOutlet weak var dolarTextField: UITextField!
    @IBOutlet weak var lastUpdated: UILabel!
    
    @IBAction func convert(sender: AnyObject) {
        dolarTextField.resignFirstResponder()
        tableView.reloadData()
    }
    @IBAction func updateValues(sender: AnyObject) {
        tableView.reloadData()
    }
    var currencies: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        dolarTextField.text = "1"
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateListOfCurrencies()
    }
    //get data from Core Data
    func updateListOfCurrencies(){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Currency")
        let sortDescriptor = NSSortDescriptor(key: "country", ascending: true, selector: "localizedCaseInsensitiveCompare:")
        fetchRequest.sortDescriptors = [sortDescriptor]
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
                self.lastUpdated.text = "Last Updated: \(self.dateToString())"
            })
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //API CALL For getting currencies and store them in database
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
        var value: NSNumber = makeConversionFromDollars((dolarTextField.text as NSString).doubleValue, currency: (currency.valueForKey("value") as! NSNumber).doubleValue)
        let country: String = currency.valueForKey("country")  as! String
        cell.currency.text = "\(country): \(value)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    // clears database and gets current currencies
    @IBAction func getDataFromServer(sender: AnyObject) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        for cur in currencies {
            context.deleteObject(cur as NSManagedObject)
        }
        currencies.removeAll(keepCapacity: false)
        context.save(nil)
        getTodayCurrencies()
        lastUpdated.text = "Last Updated: \(dateToString())"
    }
    
    //Function that returns current date
    func dateToString()->String{
        let date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM/dd/yyyy hh:mm"
        var dateString = dateFormatter.stringFromDate(date)
        println(dateString)
        return dateString
    }
    
    func makeConversionFromDollars(dollarValue: Double, currency: Double) -> Double{
        return dollarValue * currency
    }
    
}


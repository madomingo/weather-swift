//
//  ViewController.swift
//  MasterDetailSample
//
//  Created by Miguel Angel Domingo on 29/6/16.
//  Copyright © 2016 Movilok. All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var cityTextField: UITextField!

    @IBOutlet weak var loadButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let API_KEY = "1a876efec1057b15bfb1d8c37c4de7cb"
    private let URL_STRING = "http://api.openweathermap.org/data/2.5/forecast?q=%1$s&APPID=%2$s&units=metric"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    
    @IBAction func onTextEntered(sender: AnyObject) {
        onSearch()
    }

    @IBAction func onButtonClicked(sender: UIButton) {
        onSearch()
    }
    
    func onSearch() {
        let text = cityTextField.text
        if ((text != nil) && (text?.characters.count > 0)) {
            showProgress()
            let city = text!
            print("Finding \(city)")
            let escapedCity = city.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            let urlString = URL_STRING.stringByReplacingOccurrencesOfString("%1$s", withString: escapedCity!)
                .stringByReplacingOccurrencesOfString("%2$s", withString: API_KEY)
            Alamofire.request(.GET, urlString)
                .validate()
                .responseJSON{ response in
                    switch response.result {
                    case .Success(let data):
                        let json = JSON(data)
                        let name = json["city"]["name"].stringValue
                        let country = json["city"]["country"].stringValue
                        print("The city found was: \(name),\(country)")
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                    }
            }
            hideProgress()
            
        } else {
            showSimpleAlert("Error", message: "City cannot be empty")
        }
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showProgress() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    }
    
    func hideProgress() {
        activityIndicator.stopAnimating()
    }

}


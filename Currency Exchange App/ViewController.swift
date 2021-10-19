//
//  ViewController.swift
//  Currency Exchange App
//
//  Created by Carolyn Pan on 10/18/21.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "http://api.exchangeratesapi.io/v1/latest?"
    let apiKey = "dd730fb6fcb04e6ac704773ac3f5f7c1"
//  let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var currency:[String] = []
    var values:[Double] = []
    
    var currencyFrom:String = ""
    var currencyTo:String = ""
    var valueFrom:Double = 0
    var valueTo:Double = 0
    
    @IBOutlet weak var pickerFrom: UIPickerView!
    
    @IBOutlet weak var pickerTo: UIPickerView!
    
    @IBOutlet weak var lblRate: UILabel!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            currencyFrom = currency[row]
            valueFrom = values[row]
        }
        if (pickerView.tag == 2) {
            currencyTo = currency[row]
            valueTo = values[row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "http://api.exchangeratesapi.io/v1/latest?access_key=dd730fb6fcb04e6ac704773ac3f5f7c1")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error != nil {
                print("error")
            } else {
                if let content = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        if let rates = myJson["rates"] as? NSDictionary {
                            for (key, value) in rates {
                                self.currency.append((key as? String)!)
                                self.values.append((value as? Double)!)
                            }
                        }
                    }
                    catch {
                        
                    }
                }
            }
            self.pickerFrom.reloadAllComponents()
            self.pickerTo.reloadAllComponents()
        }
        task.resume()
    }


    @IBAction func getExchangeRate(_ sender: Any) {
        
//        if pickerFrom.text == "" {
//            return;
//        }
        
        //let url = baseURL + "access_key=" + apiKey
        
        SwiftSpinner.show("Getting Exchange Rate")
        
        SwiftSpinner.hide()
            
        if currencyFrom == "" || currencyTo == "" {
            print("error")
            return
        } else {
            var rate: Double = valueFrom / valueTo
            var rateStr = String(format: "%.10f", rate)
            self.lblRate.text = "1 \(currencyFrom) =  \(rateStr) \(currencyTo)"
        }
    }
}


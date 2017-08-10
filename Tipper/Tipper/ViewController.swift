//
//  ViewController.swift
//  Tipper
//
//  Created by Isaac Kim on 8/8/17.
//  Copyright © 2017 kimbros. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var billText: UITextField!
    @IBOutlet var tipTextField: UITextField!
    @IBOutlet var splitTextField: UITextField!
    
    @IBOutlet var totalTipLabel: UILabel!
    @IBOutlet var tipPerPersonLabel: UILabel!
    
    @IBOutlet var totalWithTipLabel: UILabel!
    @IBOutlet var totalPerPersonLabel: UILabel!
    
    var bill: Float = 0.0
    var tipPercent: Int = 15
    var splitAmount: Int = 1
    
    var totalTip: Float = 0.0
    var tipPerPerson: Float = 0.0
    
    var totalWithTip: Float = 0.0
    var totalPerPerson: Float = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // Done button for number pads
        // Credits to Arundas from Stackoverflow
        // for this implementation.
        let toolBar: UIToolbar = UIToolbar()
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.pressDone))]
        toolBar.sizeToFit()
        billText.inputAccessoryView = toolBar
        tipTextField.inputAccessoryView = toolBar
        splitTextField.inputAccessoryView = toolBar
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text)?.characters.index(of: ".") != nil && string == "." {
            return false
        }
        else {
            return true
        }
    }
    
    func updateValues() {
        bill = Float(billText.text!)!
        tipPercent = Int(tipTextField.text!)!
        splitAmount = Int(splitTextField.text!)!
        
        
        billText.text = "\(bill)"
        billText.text = String(format:"%.2f", bill)
        if bill == 0.0 {
            billText.text = "0.00"
        }
        
        tipTextField.text = "\(tipPercent)"
        splitTextField.text = "\(splitAmount)"
        
        
        // Calculation
        totalTip = (Float(tipPercent) / 100.0) * bill
        tipPerPerson = totalTip / Float(splitAmount)
        totalWithTip = bill + totalTip
        totalPerPerson = totalWithTip / Float(splitAmount)
        
        
        totalTipLabel.text = "$" + String(format:"%.2f", totalTip)
    
        // Check that tip per person is rounded up
        tipPerPersonLabel.text = "$" + String(format:"%.2f", tipPerPerson)
        let temptipPerPerson = String(format:"%.2f", tipPerPerson)
        var curtipPerPerson = Float(temptipPerPerson)!
        
        var test = Float(splitAmount) * curtipPerPerson
        let testToStr = String(format:"%.2f", test)
        test = Float(testToStr)!
        
        let totalTipToStr = String(format:"%.2f", totalTip)
        totalTip = Float(totalTipToStr)!
        
        // If the current tipPerPerson times Split
        // is less than the totalTip, it should keep 
        // rounding up by 0.01 until is no longer than.
        if test < totalTip {
            while (Float(splitAmount) * curtipPerPerson) < totalTip {
                curtipPerPerson += 0.01
            }
            tipPerPerson = curtipPerPerson
            tipPerPersonLabel.text = "$" + String(format:"%.2f", tipPerPerson)
        }
        // End
        
        totalWithTipLabel.text = "$" + String(format:"%.2f", ceil(totalWithTip*100)/100)
        totalPerPersonLabel.text = "$" + String(format:"%.2f", ceil(totalPerPerson*100)/100)
    }
    
    @IBAction func minusTipPercentBtn(_ sender: Any) {
        if tipPercent > 0 {
            tipPercent -= 1
        }
        tipTextField.text = "\(tipPercent)"
        updateValues()
    }
    @IBAction func plusTipPercentBtn(_ sender: Any) {
        tipPercent += 1
        tipTextField.text = "\(tipPercent)"
        updateValues()
    }
    @IBAction func minusSplitBtn(_ sender: Any) {
        if splitAmount > 1 {
            splitAmount -= 1
        }
        splitTextField.text = "\(splitAmount)"
        updateValues()
    }
    @IBAction func plusSplitBtn(_ sender: Any) {
        splitAmount += 1
        splitTextField.text = "\(splitAmount)"
        updateValues()
    }
    
    
    func pressDone() {
        billText.resignFirstResponder()
        tipTextField.resignFirstResponder()
        splitTextField.resignFirstResponder()
        
        if (billText.text!) == "" || (Float(billText.text!)! < 0.01) {
            billText.text = "0.00"
        }
        
        if (tipTextField.text!) == "" {
            tipTextField.text = "0"
        }
        
        if (splitTextField.text!) == "" {
            splitTextField.text = "0"
        }
        
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Dismiss Keypad
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if (billText.text!) == "" || (Float(billText.text!)! < 0.01) {
            billText.text = "0.00"
        }
        
        if (tipTextField.text!) == "" {
            tipTextField.text = "0"
        }
        
        if (splitTextField.text!) == "" {
            splitTextField.text = "0"
        }
        
        updateValues()
    }

    
}


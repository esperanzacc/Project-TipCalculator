//
//  ViewController.swift
//  TipCalculator
//
//  Created by Esperanza on 1/16/22.
//

import UIKit

class ViewController: UIViewController {
   
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var billAmountField: UITextField!
    @IBOutlet var tipAmountLabel: UILabel!
    @IBOutlet var tipPercentageTextField: UITextField!
    @IBOutlet var useSliderToAdjustTip: UILabel!
    @IBOutlet var sliderTip: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        registerForKeyboardNotification()

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // I search how i can dismiss keyboard after typing textfield. And find a solution from https://www.codegrepper.com/code-examples/swift/dismiss+keyboard+when+tap+outside+swift

    func registerForKeyboardNotification() {
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)

      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(_ notification: NSNotification) {
      // 1. what is the height of the keyboard?
      guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }

      let keyboardFrame = keyboardFrameValue.cgRectValue
      let keyboardSize = keyboardFrame.size
      // 2. tell the scroll view to scroll up
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
      scrollView.contentInset = UIEdgeInsets.zero
      scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }


    @IBAction func calculateTip(_ sender: Any) {
        guard let totalAmount = Double(billAmountField.text!), billAmountField.text != "" else { return }
        let tip = totalAmount * 0.15
        tipAmountLabel.text = "Tip Amount is $\(tip.rounded(toPlaces: 2))"
    }
    
    @IBAction func tipPercentageChanged(_ sender: UITextField) {
        guard let totalAmount = Double(billAmountField.text!), billAmountField.text != "" else { return }
        guard let userTypeTip = Double(tipPercentageTextField.text!), tipPercentageTextField.text != "" else { return }
        let newTip = (totalAmount * userTypeTip) / 100.0
        tipAmountLabel.text = ""
        tipAmountLabel.text = "Tip Amount is $\(newTip.rounded(toPlaces: 2))"
    }
  
    @IBAction func adjustTipPercentage(_ sender: UISlider) {
        let showAdjustPercentage = Double(sender.value)
        useSliderToAdjustTip.text! = String(showAdjustPercentage.rounded(toPlaces: 2))
        let totalAmount = Double(billAmountField.text!)!
        let adjustTip = Double(sender.value)
        let newAdjustTip = (totalAmount * adjustTip) / 100.0
        tipAmountLabel.text = "Tip Amount is $\(newAdjustTip.rounded(toPlaces: 2))"
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        billAmountField.text = ""
        tipAmountLabel.text = ""
        tipPercentageTextField.text = ""
        useSliderToAdjustTip.text = ""
        useSliderToAdjustTip.text! = "Adjust your tip percentage(Rounding):"
        sliderTip!.resetValue(sliderTip)
        
    }

}


extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(2))
        return (self * divisor).rounded() / divisor
    }
}

extension UISlider {
    func resetValue(_ sender: UISlider) {
        sender.value = 15.0
    }
}


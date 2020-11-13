//
//  AddItemsViewController.swift
//  TaxCalculator_TCS
//
//  Created by Charlie Nnguyen on 08/07/19.
//  Copyright © 2019 Charlie Nnguyen. All rights reserved.
//

import UIKit

class AddItemsViewController: UIViewController {
    
    @IBOutlet weak var itemFieldsStackView: UIStackView!
    @IBOutlet weak var stateCodeTextField: UITextField!
    @IBOutlet weak var itemLabelTextField: UITextField!
    @IBOutlet weak var itemQuantityTextField: UITextField!
    @IBOutlet weak var itemUnitPriceTextField: UITextField!
    @IBOutlet weak var printReceiptButton: UIButton!
    
    private var taxEngine: TaxCalculatorEngine!
    
    private func show(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func setStateButtonTapped(_ sender: UIButton) {
        guard let stateCodeString = stateCodeTextField.text,
            let taxEngine = TaxCalculatorEngine(with: stateCodeString) else {
                itemFieldsStackView.isHidden = true
                printReceiptButton.isHidden = true
                show(errorMessage: "Please enter a valid state.")
                return
        }
        self.taxEngine = taxEngine
        itemFieldsStackView.isHidden = false
    }
    
    @IBAction func addItemButtonTapped(_ sender: UIButton) {
        guard let label = itemLabelTextField.text, let quantityString = itemQuantityTextField.text,
            let quantity = Int(quantityString), let unitPriceString = itemUnitPriceTextField.text,
            let unitPrice = Double(unitPriceString) else {
                show(errorMessage: "Please enter a valid item data.")
                return
        }
        
        taxEngine.add(TaxCalculatorEngine.Item(label: label, quantity: quantity, unitPrice: unitPrice))
        printReceiptButton.isHidden = !(taxEngine.items.count > 0)
        
        itemLabelTextField.text = ""
        itemQuantityTextField.text = ""
        itemUnitPriceTextField.text = ""
    }
    
    @IBAction func printReceiptButtonTapped(_ sender: UIButton) {
        guard let result = taxEngine.calculate() else {
            show(errorMessage: "Could not calculate.")
            return
        }
        performSegue(withIdentifier: "segueShowReceipt", sender: result)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReceiptViewController, let result = sender as? TaxCalculatorEngine.Result {
            destination.result = result
        }
    }
}


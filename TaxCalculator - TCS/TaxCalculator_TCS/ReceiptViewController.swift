//
//  ReceiptViewController.swift
//  TaxCalculator_TCS
//
//  Created by Charlie Nnguyen on 08/07/19.
//  Copyright © 2019 Charlie Nnguyen. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {
    
    var result: TaxCalculatorEngine.Result!
    
    @IBOutlet weak var receiptDisplayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptDisplayLabel.text = generateReceiptString(from: result)
    }
    
    private func generateReceiptString(from result: TaxCalculatorEngine.Result) -> String {
        var itemStrings = [String]()
        for item in result.items {
            itemStrings.append("\(item.label)     \(item.quantity)   \(item.unitPrice)   \(item.calculateTotalPrice())")
        }
        
        return """
        \(itemStrings.joined(separator: "\n"))
        
        -----------------------------------------------------
        Total without taxes                             \(result.totalWithoutTaxes)
        Discout \(result.discountPercentage)%                                       -\(result.discountAmount)
        Tax \(result.taxPercentage)%                                           +\(result.taxAmount)
        -----------------------------------------------------
        Total price                                    \(result.totalPrice)
"""
    }
}

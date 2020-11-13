//
//  TaxCalculatorEngine.swift
//  TaxCalculator_TCS
//
//  Created by Charlie Nnguyen on 08/07/19.
//  Copyright © 2019 Charlie Nnguyen. All rights reserved.
//

import Foundation

extension TaxCalculatorEngine {
    enum StateCode: String {
        case AL
        case AK
        case AZ
        case AR
        case CA
        case CO
        case CT
        case DE
        case FL
        case GA
        case HI
        case ID
        case IL
        case IN
        case IA
        case KS
        case KY
        case LA
        case ME
        case MD
        case MA
        case MI
        case MN
        case MS
        case MO
        case MT
        case NE
        case NV
        case NH
        case NJ
        case NM
        case NY
        case NC
        case ND
        case OH
        case OK
        case OR
        case PA
        case RI
        case SC
        case SD
        case TN
        case TX
        case UT
        case VT
        case VA
        case WA
        case WV
        case WI
        case WY
    }
    
    var stateTaxRates: [StateCode: Double] {
        return [
            .AL: 4,
            .AK: 0,
            .AZ: 5.6,
            .AR: 6.5,
            .CA: 7.25,
            .CO: 2.9,
            .CT: 6.35,
            .DE: 0,
            .FL: 6,
            .GA: 4,
            .HI: 4.166,
            .ID: 6,
            .IL: 6.25,
            .IN: 7,
            .IA: 6,
            .KS: 6.5,
            .KY: 6,
            .LA: 4.45,
            .ME: 5.5,
            .MD: 6,
            .MA: 6.25,
            .MI: 6,
            .MN: 6.875,
            .MS: 7,
            .MO: 4.225,
            .MT: 0,
            .NE: 5.5,
            .NV: 6.85,
            .NH: 0,
            .NJ: 6.625,
            .NM: 5.125,
            .NY: 4,
            .NC: 4.75,
            .ND: 5,
            .OH: 5.75,
            .OK: 4.5,
            .OR: 0,
            .PA: 6,
            .RI: 7,
            .SC: 6,
            .SD: 4,
            .TN: 7,
            .TX: 6.25,
            .UT: 5.95,
            .VT: 6,
            .VA: 5.3,
            .WA: 6.5,
            .WV: 6,
            .WI: 5,
            .WY: 4,
        ]
    }
    
    struct Item: Equatable {
        var label: String
        var quantity: Int
        var unitPrice: Double
        
        func calculateTotalPrice() -> Double {
            return Double(quantity) * unitPrice
        }
    }
    
    struct Result {
        let items: [Item]
        let totalWithoutTaxes: Double
        let discountPercentage: Double
        let discountAmount: Double
        let taxPercentage: Double
        let taxAmount: Double
        let totalPrice: Double
    }
}

final class TaxCalculatorEngine {
    
    /* Steps
     - Accept 4 inputs from the user for one or many items : * Label of item * Quantity of item * Price of item * letter state code
     - With a given 2 letters state code, we can compute the tax rate
     - With total price (without tax) we can compute a discount see tabular at end of subject.
     - Output the recipe like :
     label of item     Quantity   Unit price   Total price
     label of item     Quantity   Unit price   Total price
     
     -----------------------------------------------------
     Total without taxes                             XXXXX
     Discout X%                                       -YYY
     Tax Y%                                           +ZZZ
     -----------------------------------------------------
     Total price                                    XXXXXX
     */
    /*
     Discount rate
     > 1000    3%
     > 5000    5%
     > 7000    7%
     > 10000   10%
     > 50000   15%
     
     - | State | Tax rate | | UT | 6.85% | | NV | 8.00% | | TX | 6.25% | | AL | 4.00% | | CA | 8.25% |
     
     - For other state tax rate see : https://en.wikipedia.org/wiki/Sales_taxes_in_the_United_States
     */
    
    private(set) var items = [Item]()
    private var state: StateCode
    
    init?(with stateCodeString: String) {
        guard let state = StateCode(rawValue: stateCodeString) else {
            return nil
        }
        self.state = state
    }
    
    func add(_ item: Item) {
        items.append(item)
    }
    
    func calculate() -> Result? {
        let totalWithoutTaxes = calculateTotalPriceWithoutTaxes()
        let discountPercentage = getDiscountPercentage(for: totalWithoutTaxes)
        let discountAmount = totalWithoutTaxes * discountPercentage / 100
        guard let taxPercentage = stateTaxRates[state] else { return nil }
        let taxAmount = (totalWithoutTaxes - discountAmount) * taxPercentage / 100
        let totalPrice = totalWithoutTaxes - discountAmount + taxAmount
        
        let result = Result(items: items,
                            totalWithoutTaxes: totalWithoutTaxes,
                            discountPercentage: discountPercentage,
                            discountAmount: discountAmount,
                            taxPercentage: taxPercentage,
                            taxAmount: taxAmount,
                            totalPrice: totalPrice)
        return result
    }
    
    private func calculateTotalPriceWithoutTaxes() -> Double {
        return items.reduce(0, { $0 + $1.calculateTotalPrice() })
    }
    
    private func getDiscountPercentage(for amount: Double) -> Double {
        switch amount {
        case 50001...: return 15
        case 10001...: return 10
        case 7001...: return 7
        case 5001...: return 5
        case 1001...: return 3
        default: return 0
        }
    }
}

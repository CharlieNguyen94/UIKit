//
//  TaxCalculatorEngineTests.swift
//  TaxCalculatorEngineTests
//
//  Created by Charlie Nnguyen on 08/07/19.
//  Copyright © 2019 Charlie Nnguyen. All rights reserved.
//

import XCTest
@testable import TaxCalculator_TCS

class TaxCalculatorEngineTests: XCTestCase {
    
}

// Testing initialisation
extension TaxCalculatorEngineTests {
    func test_Initialisation_Success() {
        // given
        let stateCodeString = "UT"
        
        // when
        let sut = TaxCalculatorEngine(with: stateCodeString)
        
        // then
        XCTAssertNotNil(sut)
    }
    
    func test_Initialisation_Failure() {
        // given
        let stateCodeString = "SS"
        
        // when
        let sut = TaxCalculatorEngine(with: stateCodeString)
        
        // then
        XCTAssertNil(sut)
    }
}

// Testing add function
extension TaxCalculatorEngineTests {
    func test_AddFunction_AddsAnItem() {
        // given
        let sut = TaxCalculatorEngine(with: "AL")!
        
        // when
        sut.add(TaxCalculatorEngine.Item(label: "label", quantity: 3, unitPrice: 11.3))
        
        // then
        XCTAssertEqual(sut.items.count, 1)
        XCTAssertEqual(sut.items.first?.label, "label")
        XCTAssertEqual(sut.items.first?.quantity, 3)
        XCTAssertEqual(sut.items.first?.unitPrice, 11.3)
    }
}

// Testing with different states
extension TaxCalculatorEngineTests {
    func test_CalculateTax_StateUT_NoDiscount() {
        // given
        let sut = TaxCalculatorEngine(with: "UT")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 4, unitPrice: 10.2),
            TaxCalculatorEngine.Item(label: "label3", quantity: 1, unitPrice: 167)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 207.8, accuracy: 0.01)
        XCTAssertEqual(result!.discountPercentage, 0)
        XCTAssertEqual(result!.discountAmount, 0)
        XCTAssertEqual(result!.taxPercentage, 5.95)
        XCTAssertEqual(result!.taxAmount, 12.3641, accuracy: 0.0001)
        XCTAssertEqual(result!.totalPrice, 220.1641, accuracy: 0.0001)
    }
    
    func test_CalculateTax_StateOR_Discount5Percentage_ZeroTax() {
        // given
        let sut = TaxCalculatorEngine(with: "OR")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 10, unitPrice: 500),
            TaxCalculatorEngine.Item(label: "label3", quantity: 1, unitPrice: 167)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 5167, accuracy: 0.01)
        XCTAssertEqual(result!.discountPercentage, 5)
        XCTAssertEqual(result!.discountAmount, 258.35, accuracy: 0.01)
        XCTAssertEqual(result!.taxPercentage, 0)
        XCTAssertEqual(result!.taxAmount, 0)
        XCTAssertEqual(result!.totalPrice, 4908.65, accuracy: 0.01)
    }
}

// Testing with different discount percentages
extension TaxCalculatorEngineTests {
    
    func test_CalculateTax_StateUT_Discount0Percentage() {
        // given
        let sut = TaxCalculatorEngine(with: "UT")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 1, unitPrice: 500),
            TaxCalculatorEngine.Item(label: "label3", quantity: 1, unitPrice: 167)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 667, accuracy: 0.01)
        XCTAssertEqual(result!.discountPercentage, 0)
        XCTAssertEqual(result!.discountAmount, 0)
        XCTAssertEqual(result!.taxPercentage, 5.95)
        XCTAssertEqual(result!.taxAmount, 39.6865, accuracy: 0.0001)
        XCTAssertEqual(result!.totalPrice, 706.6865, accuracy: 0.0001)
    }
    
    func test_CalculateTax_StateUT_Discount3Percentage() {
        // given
        let sut = TaxCalculatorEngine(with: "UT")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 2, unitPrice: 500),
            TaxCalculatorEngine.Item(label: "label3", quantity: 1, unitPrice: 167)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 1167, accuracy: 0.01)
        XCTAssertEqual(result!.discountPercentage, 3)
        XCTAssertEqual(result!.discountAmount, 35.01, accuracy: 0.01)
        XCTAssertEqual(result!.taxPercentage, 5.95)
        XCTAssertEqual(result!.taxAmount, 67.353405, accuracy: 0.0001)
        XCTAssertEqual(result!.totalPrice, 1199.343405, accuracy: 0.0001)
    }
    
    func test_CalculateTax_StateUT_Discount5Percentage() {
        // given
        let sut = TaxCalculatorEngine(with: "UT")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 10, unitPrice: 500),
            TaxCalculatorEngine.Item(label: "label3", quantity: 1, unitPrice: 167)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 5167, accuracy: 0.01)
        XCTAssertEqual(result!.discountPercentage, 5)
        XCTAssertEqual(result!.discountAmount, 258.35, accuracy: 0.01)
        XCTAssertEqual(result!.taxPercentage, 5.95)
        XCTAssertEqual(result!.taxAmount, 292.064675, accuracy: 0.0001)
        XCTAssertEqual(result!.totalPrice, 5200.714675, accuracy: 0.0001)
    }
    
    func test_CalculateTax_StateUT_Discount7Percentage() {
        // given
        let sut = TaxCalculatorEngine(with: "UT")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 14, unitPrice: 500),
            TaxCalculatorEngine.Item(label: "label3", quantity: 1, unitPrice: 167)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 7167)
        XCTAssertEqual(result!.discountPercentage, 7)
        XCTAssertEqual(result!.discountAmount, 501.69, accuracy: 0.01)
        XCTAssertEqual(result!.taxPercentage, 5.95)
        XCTAssertEqual(result!.taxAmount, 396.585945, accuracy: 0.0001)
        XCTAssertEqual(result!.totalPrice, 7061.895945, accuracy: 0.0001)
    }
    
    func test_CalculateTax_StateUT_Discount10Percentage() {
        // given
        let sut = TaxCalculatorEngine(with: "UT")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 20, unitPrice: 500),
            TaxCalculatorEngine.Item(label: "label3", quantity: 1, unitPrice: 167)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 10167, accuracy: 0.01)
        XCTAssertEqual(result!.discountPercentage, 10)
        XCTAssertEqual(result!.discountAmount, 1016.7, accuracy: 0.01)
        XCTAssertEqual(result!.taxPercentage, 5.95)
        XCTAssertEqual(result!.taxAmount, 544.44285, accuracy: 0.0001)
        XCTAssertEqual(result!.totalPrice, 9694.74285, accuracy: 0.0001)
    }
    
    func test_CalculateTax_StateUT_Discount15Percentage() {
        // given
        let sut = TaxCalculatorEngine(with: "UT")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 100, unitPrice: 500),
            TaxCalculatorEngine.Item(label: "label3", quantity: 1, unitPrice: 167)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 50167)
        XCTAssertEqual(result!.discountPercentage, 15)
        XCTAssertEqual(result!.discountAmount, 7525.05, accuracy: 0.01)
        XCTAssertEqual(result!.taxPercentage, 5.95)
        XCTAssertEqual(result!.taxAmount, 2537.196025, accuracy: 0.0001)
        XCTAssertEqual(result!.totalPrice, 45179.146025, accuracy: 0.0001)
    }
    
    func test_CalculateTax_StateUT_Discount0Percentage_TaxableAmount1000() {
        // given
        let sut = TaxCalculatorEngine(with: "UT")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 100, unitPrice: 10)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 1000)
        XCTAssertEqual(result!.discountPercentage, 0)
        XCTAssertEqual(result!.discountAmount, 0)
        XCTAssertEqual(result!.taxPercentage, 5.95)
        XCTAssertEqual(result!.taxAmount, 59.5, accuracy: 0.1)
        XCTAssertEqual(result!.totalPrice, 1059.5, accuracy: 0.1)
    }
    
    func test_CalculateTax_StateUT_Discount3Percentage_TaxableAmount1001() {
        // given
        let sut = TaxCalculatorEngine(with: "UT")!
        let items = [
            TaxCalculatorEngine.Item(label: "label1", quantity: 100, unitPrice: 10),
            TaxCalculatorEngine.Item(label: "label2", quantity: 1, unitPrice: 1)
        ]
        
        // when
        for item in items { sut.add(item) }
        let result = sut.calculate()
        
        // then
        XCTAssertEqual(result!.items, items)
        XCTAssertEqual(result!.totalWithoutTaxes, 1001)
        XCTAssertEqual(result!.discountPercentage, 3)
        XCTAssertEqual(result!.discountAmount, 30.03)
        XCTAssertEqual(result!.taxPercentage, 5.95)
        XCTAssertEqual(result!.taxAmount, 57.772715, accuracy: 0.00001)
        XCTAssertEqual(result!.totalPrice, 1028.742715, accuracy: 0.00001)
    }
}

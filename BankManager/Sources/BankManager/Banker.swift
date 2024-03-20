//
//  File.swift
//  
//
//  Created by Diana, Hamzzi on 3/20/24.
//

import Foundation

struct Banker {
    var totalCustomers: Int = 0
    var totalProcessingTime: Double = 0
    
    func processCustomer(_ customer: Customer) async {
        print("\(customer.name) 업무 시작")
        
        if #available(iOS 13.0, *) {
            do {
                try await Task.sleep(nanoseconds: 700_000_000)
            } catch {
                //error
            }
        }
        
        print("\(customer.name) 업무 완료")
    }
}
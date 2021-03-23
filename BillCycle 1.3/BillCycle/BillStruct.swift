//
//  Bill.swift
//  BillCycle
//
//  Created by Tiberiu on 13.02.2021.
//

import Foundation


struct BillStruct: Identifiable, Codable {
    static let statusTypes = ["Paid", "Unpaid"]
    
    var id = UUID()
    var title: String
    var description: String
    var status = statusTypes[1]
    var paidDate = Date()
    
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: paidDate)
    }
    
}

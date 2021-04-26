//
//  Bill.swift
//  BillCycle
//
//  Created by Tiberiu on 13.02.2021.
//

import Foundation


struct BillStruct: Identifiable, Codable {
    
    var id = UUID()
    var title: String
    var description: String
    var status = StatusTypes.unpaid.rawValue
    var paidDate = Date()
    
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: paidDate)
    }
    
}

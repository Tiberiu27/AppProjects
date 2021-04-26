//
//  SearchBar.swift
//  BillCycle
//
//  Created by Tiberiu on 10.04.2021.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    var body: some View {

        TextField("Search...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                    }
                )
                .padding(.horizontal, 10)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}

//
//  InventoryView.swift
//  OpusTV
//
//  Created by Andrea Iannaccone on 06/03/25.
//


import SwiftUI

struct InventoryView: View {
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                // Placeholder for inventory item
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    .padding(4)
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .padding()
    }
}
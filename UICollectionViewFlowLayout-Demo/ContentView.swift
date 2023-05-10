//
//  ContentView.swift
//  UICollectionViewFlowLayout-Demo
//
//  Created by Armand Kaguermanov on 10/05/2023.
//

import SwiftUI

struct ContentView: View {
    let mockData: [ColorData] = [
        ColorData(name: "Red", color: Color.red),
        ColorData(name: "Blue", color: Color.blue),
        ColorData(name: "Green", color: Color.green),
    ]
    
    var body: some View {
        CollectionView(data: mockData) { indexPath in
            print("Selected item at \(indexPath)")
        }
        .padding()
        .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

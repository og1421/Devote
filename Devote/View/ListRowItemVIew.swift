//
//  ListRowItemVIew.swift
//  Devote
//
//  Created by Orlando Moraes Martins on 15/02/23.
//

import SwiftUI

struct ListRowItemVIew: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item: Item
    
    
    //MARK: - Body
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? Color.pink : Color.primary)
                .padding(.vertical, 12)
                .animation(.default)
        }//: Toggle
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange ) { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        }
    }
}


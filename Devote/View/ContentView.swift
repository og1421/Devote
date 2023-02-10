//
//  ContentView.swift
//  Devote
//
//  Created by Orlando Moraes Martins on 10/02/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - Properties
    @Environment (\.managedObjectContext) private var viewContext
    
    @FetchRequest (
    sortDescriptors: [NSSortDescriptor (keyPath: \Item.timestamp, ascending:
    true) ], animation: .default)
    
    private var items: FetchedResults<Item>
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach (items) { item in
                    Text ("Item at \(item.timestamp!, formatter: itemFormatter)")
                }
            .onDelete (perform: deleteItems)
            } //: LIST
            .toolbar {
                #if os (iOS)
                ToolbarItem(placement: .navigationBarLeading ){
                    EditButton ( )
                }
                #endif
                
                ToolbarItem(placement: .navigationBarTrailing ) {
                    Button (action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            } //:Toolbar
        } // :Navigation
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

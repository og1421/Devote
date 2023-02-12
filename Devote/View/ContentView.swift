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
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    
    //MARK: - Fetching data
    @Environment (\.managedObjectContext) private var viewContext
    
    @FetchRequest (
    sortDescriptors: [NSSortDescriptor (keyPath: \Item.timestamp, ascending:
    true) ], animation: .default)
    
    private var items: FetchedResults<Item>
    
    //MARK: - Function
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                //MARK: - Main View
                VStack {
                    //MARK: - Header
                    Spacer(minLength: 80)
                    
                    //MARK: - New Task button
                    Button {
                        showNewTaskItem = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                    )
                    
                    //MARK: - task
                    List {
                        ForEach (items) { item in
                            VStack (alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text ("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } //: VSTACK
                        }
                    .onDelete (perform: deleteItems)
                    } //: LIST
                    .cornerRadius(20) // 1.
                    .listStyle(.inset) // 2.
                    .padding(20) // 3.
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                }//: VSTACK
                //MARK: - Add new item
                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            withAnimation( ){
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView( isShowing: $showNewTaskItem)
                }
                
            }//: ZSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear //Doesn't work anymore
            }
            .navigationBarTitle("Daily tasks", displayMode: .large)
            .toolbar {
                #if os (iOS)
                ToolbarItem(placement: .navigationBarTrailing ){
                    EditButton ( )
                }
                #endif
                
                //                ToolbarItem(placement: .navigationBarTrailing ) {
                //                    Button (action: addItem) {
                //                        Label("Add Item", systemImage: "plus")
                //                    }
                //                }
            }//:Toolbar
            .background( backgroundGradient.ignoresSafeArea(.all))
        } // :Navigation
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

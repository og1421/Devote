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
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    //MARK: - Fetching data
    @Environment (\.managedObjectContext) private var viewContext
    
    @FetchRequest (
    sortDescriptors: [NSSortDescriptor (keyPath: \Item.timestamp, ascending:
    true) ], animation: .default)
    
    private var items: FetchedResults<Item>
    
    //MARK: - Function
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
        }
    }
    
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
                VStack {
                    VStack(spacing: 16) {
                        TextField("New Task", text: $task)
                            .padding()
                            .background(
                                Color(UIColor.systemGray6)
                            )
                            .cornerRadius(10)
                        
                        Button {
                            addItem()
                        } label: {
                            Spacer()
                            Text("Save".uppercased())
                            Spacer()
                        }
                        .disabled(isButtonDisabled)
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? Color.gray : Color.pink)
                        .cornerRadius(12)
                        
                    }//: VSTACk
                    .padding()
                    
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

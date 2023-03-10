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
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
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
                    HStack(spacing: 10 ){
                        //:TITLE
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        //: EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule().stroke(Color.white, lineWidth: 2)
                            )
                        
                        //: APPEARENCE BUTTON
                        Button {
                            //Toggle appeareence
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                            
                        }label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" :  "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }
                        
                    }//:HSTACK
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    //MARK: - New Task button
                    Button {
                        showNewTaskItem = true
                        feedback.notificationOccurred(.success)
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
                            ListRowItemVIew(item: item)
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
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation( withAnimation{.easeOut(duration: 0.5)})
                
                //MARK: - Add new item
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkMode ?  Color.black : Color.gray,
                        backgroundOpacity: isDarkMode ?  0.3 : 0.5)
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
            .navigationBarHidden(true)
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

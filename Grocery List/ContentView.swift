//
//  ContentView.swift
//  Grocery List
//
//  Created by Abiodun Osagie on 03/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // MARK: - PROPERTIES
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var item: String = ""
    @FocusState private var isFocused: Bool
    // MARK: - FUCNTIONS
    func addEssentialFoods() {
        modelContext.insert(Item(title: "Bakery & Bread", isCompleted: false))
        modelContext.insert(Item(title: "Meat & Seafood", isCompleted: true))
        modelContext.insert(Item(title: "Cereals", isCompleted: Bool.random()))
        modelContext.insert(Item(title: "Pasta & Rice", isCompleted: Bool.random()))
        modelContext.insert(Item(title: "Cheese & Eggs", isCompleted: Bool.random()))
    }

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    Text(item.title)
                        .foregroundStyle(
                            item.isCompleted == false ? Color.primary
                            : Color.orange)
                        .strikethrough(item.isCompleted)
                        .italic(item.isCompleted)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    modelContext.delete(item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button(
                                "Done",
                                systemImage: item.isCompleted == false ? "checkmark.circle" : "x.circle"
                            ) {
                                item.isCompleted.toggle()
                            }
                            .tint(
                                item.isCompleted == false ? .green : .red
                            )
                        }
                }
            }//: LIST
            .navigationTitle("Grocery List")
            .toolbar {
                if items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            addEssentialFoods()
                        }label: {
                            Label("Essentials", systemImage: "carrot")
                        }
                    }
                }
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(
                        "Empty Cart",
                        systemImage: "cart.circle",
                        description:Text("Add some items to the shopping list.")
                    )
                }
            }//: OVERLAY
            .safeAreaInset(
edge: .bottom,
 content: {
     VStack(spacing: 12){
                    TextField("", text: $item)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(.tertiary)
                        .cornerRadius(12)
                        .font(.title)
                        .fontWeight(.light)
                        .focused($isFocused)
                    Button {
                        guard !item.isEmpty else {
                            return
                        }
                        let newItem = Item(title: item, isCompleted: false)
                        modelContext.insert(newItem)
                        item = ""
                        isFocused = false
                    } label: {
                        Text("Save")
                            .font(.title)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.extraLarge)
                    
                }//: VSTACK
               .padding()
               .background(.bar)
            })
        }//: NAVIGATION STACK
    }
}



    // MARK: - PREVIEW
#Preview("Sample Data") {
    let sampleData: [Item] = [
        Item(title: "Bakery & Bread", isCompleted: false),
        Item(title: "Meat & Seafood", isCompleted: true),
        Item(title: "Cereals", isCompleted: Bool.random()),
        Item(title: "Pasta & Rice", isCompleted: Bool.random()),
        Item(title: "Cheese & Eggs", isCompleted: Bool.random())
    ]
    
    let container = try! ModelContainer(
        for: Item.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    // Insert sample data into the container context
    for item in sampleData {
        container.mainContext.insert(item)
    }
    
    return ContentView()
        .modelContainer(container)
}

#Preview("Empty view") {
    let container = try! ModelContainer(
        for: Item.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    return ContentView()
        .modelContainer(container)
}

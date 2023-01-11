//
//  TransactionsListView.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Amaechi Chukwu on 11/01/2023.
//

import SwiftUI

struct TransactionsListView: View {
    
    @State private var shouldShowAddTransactionForm = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<CardTransaction>
    
    var body: some View {
        VStack {
            
            Text("Get Started by adding your first transaction")
            
            Button {
                shouldShowAddTransactionForm.toggle()
            } label: {
                Text("+ Transaction")
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                    .background(Color.black)
                    .foregroundColor(Color(.systemBackground))
                    .font(.headline)
                    .cornerRadius(5)
            }
            .fullScreenCover(isPresented: $shouldShowAddTransactionForm) {
                AddTransactionForm()
            }
            ForEach(transactions) { transaction in
                CardTransactionView(transaction: transaction)
                
            }
        }
    }
    
    
    struct CardTransactionView: View {
        let transaction: CardTransaction
        
        // MARK: Date Formatter
        private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }()
        
        @State var shouldPresentActionSheet = false
        
        private func handleDelete() {
            withAnimation {
                do {
        
                    let context = PersistenceController.shared.container.viewContext
                    
                    context.delete(transaction)
                    
                    try context.save()
                } catch {
                    print("Failed to delete transaction: ", error)
                }
            }
        }
        
        var body: some View {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(transaction.name ?? "")
                            .font(.headline)
                        if let date = transaction.timestamp {
                            Text(dateFormatter.string(from: date))
                        }
                        
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Button  {
                            shouldPresentActionSheet.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 24))
                        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                            .actionSheet(isPresented: $shouldPresentActionSheet) {
                                .init(title: Text(transaction.name ?? ""), message: nil, buttons: [
                                        .destructive(Text("Delete"), action: handleDelete),
                                      .cancel()
                                      
                                      ])
                            }
                        
                        Text(String(format: "$%.2f",transaction.amount )) // Took off nil coalescing here *for future reference
                    }
                }
                if let photoData = transaction.photoData,
                   let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                }
                
            }
            .foregroundColor(Color(.label))
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .shadow(radius: 5)
            .padding()
        }
    }
    
}

struct TransactionsListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ScrollView {
            TransactionsListView()
        }
        .environment(\.managedObjectContext, context)
    }
}

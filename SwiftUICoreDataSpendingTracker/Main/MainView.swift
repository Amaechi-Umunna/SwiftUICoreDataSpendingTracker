//
//  MainView.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Amaechi Chukwu on 08/12/2022.
//

import SwiftUI


struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                TabView {
                    ForEach(0..<5) { num in
                        CreditCardView()
                            .padding(.bottom, 50)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 280)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                // Hack
                //                .onAppear {
                //                    shouldPresentAddCardForm.toggle()
                //                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm) {
                        AddCardForm()

                    }
                
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(trailing: addCardButton)
        }
    }
    
    
    // MARK: Add Card
    var addCardButton: some View {
        Button (action:  {
            // Trigger action
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
//        AddCardForm()
    }
}


// MARK: Credit Card Nav
struct CreditCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Apple Blue Visa Card")
                .font(.system(size: 24, weight: .semibold))
            
            
            HStack {
                Image("visa")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                    .clipped()
                
                
                
                Spacer()
                Text("Balance: $5,000")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            
            Text("1234 1234 1234 1234")
            
            Text("Credit Limit: $50,000")
            
            HStack { Spacer() }
        }
        .foregroundColor(.white)
        .padding()
        .background(
            LinearGradient(colors: [
                Color.blue.opacity(0.6), Color.blue
            ], startPoint: .top, endPoint: .bottom)
        )
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.black.opacity(0.5), lineWidth: 1)
        )
        
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

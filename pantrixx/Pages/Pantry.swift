//
//  ContentView.swift
//  pantrix
//
//  Created by student on 19/11/24.
//

import SwiftUI
struct FoodCategory: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
}

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let age: String
    let image: String
}

struct Pantry: View {
    @State private var isAddPantryPresented: Bool = false
    let foodCategories: [FoodCategory] = [
        FoodCategory(name: "All", count: 10),
        FoodCategory(name: "Vegetables", count: 3),
        FoodCategory(name: "Protein", count: 2),
        FoodCategory(name: "Fruits", count: 8),
    ]
    let foodItems: [FoodItem] = [
        FoodItem(name: "Strawberry", age: "2 days old", image: "strawberry"),
        FoodItem(name: "Mango", age: "5 days old", image: "mango"),
        FoodItem(name: "Nugget", age: "5 days old", image: "nugget"),
        FoodItem(name: "Egg", age: "5 days old", image: "egg"),
    ]
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 5){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10) {
                            ForEach(foodCategories) { category in
                                Button(action: {
                                    
                                }){
                                    Text("\(category.name) (\(category.count))")
                                        .font(.subheadline)
                                        .foregroundColor(category.name == "All" ? Color.white : Color.black)
                                        .padding(.init(top: 6, leading:10, bottom: 6, trailing: 10))
                                        .lineLimit(1)
                                        .background(category.name == "All" ? Color(red: 0.39215686274509803, green: 0.5529411764705883, blue: 0.40784313725490196) : Color(red: 0.8745098039215686, green: 0.8745098039215686, blue: 0.8745098039215686))
                                        .cornerRadius(10)
                                    
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Text("Eat Me First")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    Text("Help this food before it goes to waste.")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(foodItems) { item in
                                VStack(alignment: .center) {
                                    ZStack(alignment: .top) {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white)
                                            .shadow(color: .gray.opacity(0.1), radius: 10, x: 1, y: 1)
                                            .frame(width: 120, height: 200)
                                        VStack {
                                            // Priority Label
                                            Text("Priority")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 8)
                                                .background(Color.orange)
                                                .cornerRadius(5)
                                                .padding(.top, 8)
                                            
                                            // Food Image
                                            Image(item.image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                                .padding(.top, 8)
                                            Text(item.name)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal, 20)
                                            
                                            Text(item.age)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal, 20)
                                                .padding(.bottom, 20)
                                        }
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                    
                    
                    Text("Vegetables")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                   
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(foodItems) { item in
                                VStack(alignment: .center) {
                                    ZStack(alignment: .top) {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white)
                                            .shadow(color: .gray.opacity(0.1), radius: 10, x: 1, y: 1)
                                            .frame(width: 120, height: 200)
                                        VStack {
                                            // Priority Label
//                                            Text("Priority")
//                                                .font(.caption)
//                                                .fontWeight(.bold)
//                                                .foregroundColor(.white)
//                                                .padding(.vertical, 4)
//                                                .padding(.horizontal, 8)
//                                                .background(Color.orange)
//                                                .cornerRadius(5)
//                                                .padding(.top, 8)
                                            
                                            // Food Image
                                            Image(item.image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                                .padding(.top, 8)
                                            Text(item.name)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal, 20)
                                            
                                            Text(item.age)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal, 20)
                                                .padding(.bottom, 20)
                                        }
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Kitchen")
            .overlay(
                         Button(action: {
                             // Add action for the button
                             isAddPantryPresented.toggle()
                         }) {
                             Image(systemName: "plus.circle.fill")
                                 .font(.system(size: 40))
                                 .foregroundColor(.white)
                                 .padding()
                                 .background(Circle().fill(Color(red: 0.06274509803921569, green: 0.5058823529411764, blue: 0.2823529411764706)))
                                 .shadow(radius: 10)
                         }
                         // Position it towards the bottom
                            .padding(.trailing, 20) // Position it towards the right side
                         , alignment: .bottomTrailing
            )
            .sheet(isPresented: $isAddPantryPresented) {
                AddPantry() // Make sure AddPantry is a valid view
            }
            //            .toolbar{
            //                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        // Add the edit functionality here
//                        print("Edit button tapped")
//                    }) {
//                        Image(systemName: "pencil.and.ellipsis.rectangle")
//                            .font(.title2)
//                            .foregroundColor(.blue)
//                    }
//                }
//            }
        }
        
        
    }
}

#Preview {
    Pantry()
}

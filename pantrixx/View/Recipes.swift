//
//  Recipes.swift
//  pantrix
//
//  Created by student on 22/11/24.
//

import SwiftUI

struct Recipes: View {
    // View Properties
    @State private var activeTab: Tab = .pantry
    // For smooth shape Sliding Effect
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
//    init(){
//        // Hiding Tab Bar due To swift ios 16 Bug
//        UITabBar.appearance.isHidden = true
//    }
    var body: some View {
        VStack(spacing:0){
            TabView(selection: $activeTab){
                Text("Recipes")
                    .tag(Tab.recipes)
                    // Hiding Native Tab Bar
//                    .toolbar(.hidden, for: .tabBar)
                
                Text("Meal Plan")
                    .tag(Tab.mealplan)
                    // Hiding Native Tab Bar
//                    .toolbar(.hidden, for: .tabBar)
                
                Pantry()
                    .tag(Tab.pantry)
                    // Hiding Native Tab Bar
//                    .toolbar(.hidden, for: .tabBar)
                
                Text("Shopping List")
                    .tag(Tab.shoppinglist)
                    // Hiding Native Tab Bar
//                    .toolbar(.hidden, for: .tabBar)
                
                Text("Profile")
                    .tag(Tab.profile)
                // Hiding Native Tab Bar
//                .toolbar(.hidden, for: .tabBar)
            }
            CustomTabBar()
        }
    }
    
    // Custom Tab Bar
    @ViewBuilder
    func CustomTabBar(_ tint: Color = .blue, _ inactiveTint: Color = .blue)->
    some View{
        // Moving all the remaining Tab Item's to Bottom
        HStack(alignment: .bottom, spacing: 0){
            ForEach(Tab.allCases, id: \.rawValue){
                Tabitem(
                    tint: tint,
                    inactiveTint: inactiveTint,
                    tab: $0,
                    animation: animation,
                    activeTab: $activeTab,
                    position: $tabShapePosition
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(content: {
            TabShape(midpoint: tabShapePosition.x)
                .fill(.white)
                .ignoresSafeArea()
            // add blur+ shadow
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        })
        // adding animation
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7 ,blendDuration: 0.7), value: activeTab)
    }
}

// Tab Bar Item
struct Tabitem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    var animation : Namespace.ID
    @Binding var activeTab: Tab
    @Binding var position: CGPoint
    @State private var tabPosition : CGPoint = .zero

    
    var body: some View {
        VStack(spacing: 5){
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : inactiveTint)
            // Increasing Size For the active tab
            
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background{
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            
            Text(tab.rawValue)
                .font(.caption)
                .foregroundColor(activeTab == tab ? tint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .viewPosition(completion: {
            rect in tabPosition.x = rect.midX
            
            /// updating active position
            if activeTab == tab{
                position.x = rect.midX
            }
        })
        .onTapGesture {
            activeTab = tab
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                position.x = tabPosition.x
            }
        }
    }
}

struct Recipes_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}


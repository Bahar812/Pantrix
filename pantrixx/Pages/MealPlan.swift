import SwiftUI

struct MealPlan: View {
    @State var currentDate: Date = .init()
    @State var weekSlider: [[Date.WeekDay]] = []
    @State var currentWeekIndex: Int = 0
    @State var selectedMealType: String = "Lunch"
    @State private var showingAddMealPlan: Bool = false
    @State var mealItems: [MealItem] = [
        MealItem(name: "Nasi Cap Cay", time: 30, servings: 2, image: "capcay", isFavorite: false),
        MealItem(name: "Salad", time: 10, servings: 2, image: "salad", isFavorite: false),
        MealItem(name: "Es Durian", time: 3, servings: 1, image: "es_durian", isFavorite: false)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Text("Meal Plan")
                .font(.system(size: 36, weight: .semibold))
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Weekly Plan")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                // Week Slider - Calendar
                TabView(selection: $currentWeekIndex) {
                         ForEach(weekSlider.indices, id: \.self) { index in
                             let week = weekSlider[index]
                             weekView(week, currentDate: $currentDate)
                                 .tag(index)
                                 .onChange(of: currentWeekIndex) { newIndex in
                                     if newIndex == weekSlider.count - 1 {
                                         loadNextWeek()
                                     } else if newIndex == 0 {
                                         loadPreviousWeek()
                                     }
                                 }


                         }
                     }
                     .tabViewStyle(.page(indexDisplayMode: .never))
                     .frame(height: 120)
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Meal Type Tabs
            HStack {
                ForEach(["Breakfast", "Lunch", "Dinner"], id: \.self) { mealType in
                    Text(mealType)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(selectedMealType == mealType ? .black : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedMealType == mealType ? Color.orange.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedMealType = mealType
                        }
                }
            }
            .padding()
            
            // Meal Items List
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(mealItems) { item in
                        MealItemView(item: item)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Add Meal Button
            HStack {
                Spacer()
                Button(action: {
                    showingAddMealPlan = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.green))
                }
                .sheet(isPresented: $showingAddMealPlan) {
                    AddMealPlan()
                }
                .padding()
            }
        }
        .onAppear {
            setupWeeks()
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
    }
    
    func setupWeeks() {
        var weeks: [[Date.WeekDay]] = []
        
        for i in -2...2 {
            if let week = Calendar.current.date(byAdding: .weekOfYear, value: i, to: currentDate)?.fetchWeek() {
                weeks.append(week)
            }
        }
        
        weekSlider = weeks
        currentWeekIndex = 2
    }
    
    func loadNextWeek() {
        if let lastDate = weekSlider.last?.last?.date {
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: lastDate) ?? lastDate
            let nextWeek = nextDate.fetchWeek(date: nextDate)
            weekSlider.append(nextWeek)
        }
    }

    func loadPreviousWeek() {
        if let firstDate = weekSlider.first?.first?.date {
            let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: firstDate) ?? firstDate
            let previousWeek = previousDate.fetchWeek(date: previousDate)
            weekSlider.insert(previousWeek, at: 0)
            currentWeekIndex += 1 // Menyesuaikan indeks agar minggu tetap terlihat
        }
    }

}

// Meal Item Model
struct MealItem: Identifiable {
    let id = UUID()
    let name: String
    let time: Int // Preparation time in minutes
    let servings: Int // Number of servings
    let image: String // Image name
    var isFavorite: Bool
}

// Meal Item View
struct MealItemView: View {
    @State var item: MealItem
    
    var body: some View {
        HStack(spacing: 10) {
            Image(item.image) // Replace with actual image asset
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.headline)
                
                HStack {
                    Text("\(item.time) Min")
                    Text("\(item.servings) Serve")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                item.isFavorite.toggle()
            }) {
                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(item.isFavorite ? .red : .gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Week View
@ViewBuilder
func weekView(_ week: [Date.WeekDay], currentDate: Binding<Date>) -> some View {
    HStack(spacing: 10) {
        ForEach(week) { day in
            VStack {
                Text(day.date.format("E"))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(day.date.format("dd"))
                    .font(.system(size: 20))
                    .frame(width: 40, height: 75)
                    .foregroundColor(isSameDate(day.date, currentDate.wrappedValue) ? .white : .black)
                    .background(
                        Group {
                            if isSameDate(day.date, currentDate.wrappedValue) {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.orange)
                            }
                            
                            if day.date.isToday {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 5, height: 5)
                                    .padding(.top, 40)
                            }
                        }
                    )
            }
            .onTapGesture {
                currentDate.wrappedValue = day.date
            }
        }
    }
}

#Preview {
    MealPlan()
}

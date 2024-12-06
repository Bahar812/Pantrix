import SwiftUI

struct PageRecipes: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Search Bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray) // Ikon kaca pembesar di sebelah kiri
                        TextField("Do I have...", text: .constant(""))
                            .foregroundColor(.black)
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 1)
                }
                .padding(.horizontal, 10)
                .padding(.top, 20)
                
                // Help Card
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Need Help?")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("Ask Pantrix!")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Get personalized suggestions, tips, and more with a quick question.")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text("Tap here to start chatting.")
                            .font(.callout)
                            .foregroundColor(.white)
                            .underline()
                    }
                    .padding()
                    
                    Spacer()
                    
//                    Image(systemName: "person.crop.circle.badge.questionmark")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50, height: 50)
//                        .foregroundColor(.white)
                }
                .background(Color.green)
                .cornerRadius(15)
                .padding(.horizontal, 10)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                
                // Section Title
                Text("Based on inventory")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                
                // Recipe List
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(Recipe.sampleData) { recipe in
                            HStack {
                                Image(recipe.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(recipe.title)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Text(recipe.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Image(systemName: "clock")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(recipe.time)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                
                                VStack {
                                    Button(action: {}) {
                                        Image(systemName: "heart")
                                            .font(.title3)
                                            .foregroundColor(.orange)
                                    }
                                    Spacer()
                                    Button(action: {}) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

// Recipe Model
struct Recipe: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
    let time: String
    
    static let sampleData: [Recipe] = [
        Recipe(imageName: "nasgor", title: "Nasi Goreng", subtitle: "You have 5 ingredients", time: "15 min"),
        Recipe(imageName: "naspad", title: "Nasi Padang", subtitle: "You have all ingredients", time: "1 hour 5 min"),
        Recipe(imageName: "buryam", title: "Bubur Ayam", subtitle: "You have all ingredients", time: "15 min")
    ]
}

#Preview {
    PageRecipes()
}

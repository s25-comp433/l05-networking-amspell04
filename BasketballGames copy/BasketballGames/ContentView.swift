//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//
import SwiftUI

struct Result: Codable {
    var id: Int
    var team: String
    var opponent: String
    var isHomeGame: Bool
    var score: Score
    var date: String
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Result]()

    var body: some View {
        NavigationStack {
            List(results, id: \.id) { item in
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(item.team) vs \(item.opponent)")
                                .font(.headline)
                            Text("Date: \(item.date)")
                        }
                        Spacer()
                        VStack {
                            Text(" \(item.score.unc) -  \(item.score.opponent)")
                            Text(item.isHomeGame ? "Home Game" : "Away Game")
                        }
                    }
                }
            }
            .navigationTitle("UNC Basketball")
        }
        .task {
            await loadData()
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}

//
//  BudgetDetailScreen.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 6/21/24.
//

import SwiftUI

struct BudgetDetailScreen: View {
    
    let budget: Budget
    
    @State private var name: String = ""
    @State private var limit: Double?
    
    @Environment(\.supabaseClient) private var supabaseClient
    
    private func updateBudget() async {
        
        guard let limit = limit,
              let id = budget.id
        else { return }
        
        let updatedBudget = Budget(name: name, limit: limit)
        
        do {
            try await supabaseClient
                .from("budgets")
                .update(updatedBudget)
                .eq("id", value: id)
                .execute()
        } catch {
            print(error)
        }
        
    }
    
    var body: some View {
        Form {
            TextField("Enter name", text: $name)
            TextField("Enter limit", value: $limit, format: .number)
            Button("Update") {
                Task {
                    await updateBudget()
                }
            }
        }
        .onAppear(perform: {
            name = budget.name
            limit = budget.limit
        })
        .navigationTitle(budget.name)
    }
}

#Preview {
    NavigationStack {
        BudgetDetailScreen(budget: Budget(name: "Groceries", limit: 500))
    }.environment(\.supabaseClient, .development)
}

//
//  ContentView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 6/20/24.
//

import SwiftUI

struct BudgetListScreen: View {
    
    @Environment(\.supabaseClient) private var supabaseClient
    @State private var budgets: [Budget] = []
    
    @State private var isPresented: Bool = false
    
    private func fetchBudgets() async {
          
        do {
            budgets = try await supabaseClient
                .from("budgets")
                .select()
                .execute()
                .value
        } catch {
            print(error)
        }
    }
    
    private func deleteBudget(_ budget: Budget) async {
        
        guard let id = budget.id else { return }
        
        do {
            try await supabaseClient
                .from("budgets")
                .delete()
                .eq("id", value: id)
                .execute()
            
            // remove budget from budgets array
            budgets = budgets.filter { $0.id! != id }
            
        } catch {
            print(error)
        }
        
    }
    
    var body: some View {
        List {
            ForEach(budgets) { budget in
                NavigationLink {
                    BudgetDetailScreen(budget: budget)
                } label: {
                    BudgetCellView(budget: budget)
                }
            }.onDelete(perform: { indexSet in
                guard let index = indexSet.last else { return }
                let budget = budgets[index]
                Task {
                    await deleteBudget(budget)
                }
            })
        }.task {
            await fetchBudgets()
        }
        .navigationTitle("Budgets")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add New") {
                    isPresented = true
                }
            }
        })
        .sheet(isPresented: $isPresented, content: {
            NavigationStack {
                AddBudgetScreen(budgets: $budgets)
            }
        })
    }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
    }.environment(\.supabaseClient, .development)
}

struct BudgetCellView: View {
    
    let budget: Budget
    
    var body: some View {
        HStack {
            Text(budget.name)
            Spacer()
            Text(budget.limit, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}

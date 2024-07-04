//
//  AddBudgetScreen.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 6/21/24.
//

import SwiftUI
import Supabase

struct AddBudgetScreen: View {
    
    @State private var name: String = ""
    @State private var limit: Double?
    
    @Environment(\.supabaseClient) private var supabaseClient
    @Environment(\.dismiss) private var dismiss
    
    // Passing data to the BudgetListScreen so BudgetListScreen can refresh
    // and show the newly added budget
    
    // Option 1
    // let onSave: (Budget) -> Void
    
    // Option 2
    // Using Binding
    @Binding var budgets: [Budget]
    
    private func saveBudget() async {
        
        guard let limit = limit else { return }
        
        let budget = Budget(name: name, limit: limit)
        
        do {
            let newBudget: Budget = try await supabaseClient
                .from("budgets")
                .insert(budget)
                .select()
                .single()
                .execute()
                .value
            
            budgets.append(newBudget)
            
            //onSave(newBudget)
            
            dismiss()
            
        } catch {
            print(error)
        }
        
    }
    
    var body: some View {
        Form {
            TextField("Enter name", text: $name)
            TextField("Enter limit", value: $limit, format: .number)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await saveBudget()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        // AddBudgetScreen(onSave: { _ in })
        AddBudgetScreen(budgets: .constant([]))
    }
}

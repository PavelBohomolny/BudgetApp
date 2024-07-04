import SwiftUI
import Supabase

@main
struct BudgetAppApp: App {
    let client = SupabaseClient(
        supabaseURL: URL(string: "ADD_YOUR_LINK")!,
        supabaseKey: "ADD_YOUR_KEY"
    )
    
    var body: some Scene {
        WindowGroup {
            BudgetListScreen()
        }
    }
}

import Foundation
import Supabase

extension SupabaseClient {
    static var development: SupabaseClient {
        SupabaseClient(
            supabaseURL: URL(string: "ADD_YOUR_LINK")!,
            supabaseKey: "ADD_YOUR_KEY"
        )
    }
}

//
//  SearchView.swift
//  Memo
//
//  Created by koohyunmo on 2/17/24.
//

import SwiftUI

struct SearchView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("검색", text: $text)
        }
        .padding(10)
        .background(Color(.systemGray5))
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    SearchView(text: .constant(""))
}

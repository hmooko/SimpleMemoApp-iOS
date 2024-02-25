//
//  MemoCard.swift
//  Memo
//
//  Created by koohyunmo on 2/17/24.
//

import SwiftUI

struct MemoRow: View {
    var memo: Memo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if memo.text.count != 0 {
                    Text(memo.text)
                        .font(.headline)
                        .lineLimit(1)
                    if memo.text.split(separator: "\n").count > 1 {
                        Text(memo.text.split(separator: "\n")[1])
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                } else {
                    Text("제목 없음").font(.headline)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    MemoRow(memo: fakeMemo)
}

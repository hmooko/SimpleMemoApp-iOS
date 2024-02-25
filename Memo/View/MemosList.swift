//
//  MemosList.swift
//  Memo
//
//  Created by koohyunmo on 2/25/24.
//

import SwiftUI

struct MemosList: View {
    @Binding var memosArrangedByDate: Dictionary<String, [Memo]>
    @Binding var multiSelection: Set<Int>
    @Binding var searchText: String
    @Binding var isEditMode: Bool
    
    var body: some View {
        if memosArrangedByDate.count != 0 {
            List(selection: $multiSelection) {
                ForEach(Array(memosArrangedByDate.keys).sorted(by: >), id: \.self) { key in
                    if searchText.count != 0 {
                        let memos = memosArrangedByDate[key]!.filter {
                            $0.text.lowercased().contains(searchText.lowercased())
                        }
                        
                        if (memos.count != 0) {
                            Section(key.split(separator: " ")[0]) {
                                ForEach(memos.sorted(by: {
                                    return $0.date > $1.date
                                })) { memo in
                                    NavigationLink(value: memo) {
                                        MemoRow(memo: memo)
                                    }
                                }
                            }
                        }
                    } else {
                        Section(key.split(separator: " ")[0]) {
                            ForEach(memosArrangedByDate[key]!.sorted(by: {
                                return $0.date > $1.date
                            })) { memo in
                                NavigationLink(value: memo) {
                                    MemoRow(memo: memo)
                                }
                            }
                        }
                    }
                }
            }
            .environment(\.editMode, .constant(self.isEditMode ? EditMode.active : EditMode.inactive))
        }
    }
}

#Preview {
    MemosList(
        memosArrangedByDate: .constant(["2024-01-01": fakeMemoArray]),
        multiSelection: .constant(Set<Int>()),
        searchText: .constant(""),
        isEditMode: .constant(false)
    )
}

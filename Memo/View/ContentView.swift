//
//  ContentView.swift
//  Memo
//
//  Created by koohyunmo on 2/17/24.
//

import SwiftUI

struct ContentView: View {
    
    private let memoManager = MemoManager.shared
    let dateFormatter = DateFormatter()
    @State private var path = NavigationPath()
    @State private var searchText: String = ""
    @State private var multiSelection = Set<Int>()
    @State private var memosArrangedByDate = Dictionary<String, [Memo]>()
    @State private var isEditMode = false
    
    init() {
        self._memosArrangedByDate = State<Dictionary<String, [Memo]>>(initialValue: memoManager.sortedByDate())
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                SearchView(text: $searchText)
                    .padding()
                if memosArrangedByDate.count != 0 {
                    MemosList(
                        memosArrangedByDate: self.$memosArrangedByDate,
                        multiSelection: self.$multiSelection,
                        searchText: self.$searchText,
                        isEditMode: self.$isEditMode
                    )
                }
                
                Spacer()
            }
            .toolbar {
                NavigationLink(value: Memo(id: 0, date: "", text: "")) { // writeButton
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(Color.yellow)
                }
                
                Button { // editButton
                    withAnimation {
                        self.isEditMode.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(Color.yellow)
                }
            }
            .toolbar {
                if isEditMode {
                    ToolbarItemGroup(placement: .bottomBar) { // 편집 도구 그룹
                        Button { // deleteButton for id in multiSelection { memoManager.deleteMemos(id) }
                            withAnimation {
                                memosArrangedByDate = memoManager.sortedByDate()
                                isEditMode.toggle()
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.yellow)
                        }
                    }
                }
            }
            .navigationTitle("Memo")
            .background(Color(.systemGray6))
            .navigationDestination(for: Memo.self) { memo in
                if memo.id == 0 {
                    WritingView(path: $path, MemosArrangedByDate: $memosArrangedByDate)
                } else {
                    WritingView(memo: memo, path: $path, MemosArrangedByDate: $memosArrangedByDate)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

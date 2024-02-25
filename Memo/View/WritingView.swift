//
//  WritingView.swift
//  Memo
//
//  Created by koohyunmo on 2/18/24.
//

import SwiftUI

struct WritingView: View {
    @State var text: String = ""
    @Binding var path: NavigationPath
    @Binding var presentedMemos: Dictionary<String, [Memo]>
    var memo: Memo? = nil
    let dateFormatter = DateFormatter()
    private let memoManager = MemoManager.shared
    
    private init(path: Binding<NavigationPath>, presentedMemos: Binding<Dictionary<String, [Memo]>>) {
        self._path = path
        self._presentedMemos = presentedMemos
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    init(path: Binding<NavigationPath>, MemosArrangedByDate: Binding<Dictionary<String, [Memo]>>) {
        self.init(path: path, presentedMemos: MemosArrangedByDate)
    }
    
    init(memo: Memo, path: Binding<NavigationPath>, MemosArrangedByDate: Binding<Dictionary<String, [Memo]>>) {
        self.init(path: path, presentedMemos: MemosArrangedByDate)
        self.memo = memo
        self._text = State(initialValue: memo.text)
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                Button {
                    path = .init()
                    
                    if let memo = self.memo {
                        if memo.text != self.text {
                            memoManager.updateMemo(id: memo.id, date: dateFormatter.string(from: Date()), text: self.text)
                        }
                    } else {
                        memoManager.insertMemo(date: dateFormatter.string(from: Date()), text: self.text)
                    }
                    
                    presentedMemos = self.memoManager.sortedByDate()
                    print(presentedMemos)
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    WritingView(memo: fakeMemo, path: .constant(NavigationPath()), MemosArrangedByDate: .constant(Dictionary<String, [Memo]>()))
}

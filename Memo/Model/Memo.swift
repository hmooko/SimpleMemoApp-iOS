//
//  Memo.swift
//  Memo
//
//  Created by koohyunmo on 2/17/24.
//

import Foundation

struct Memo: Hashable, Identifiable, Codable {
    var id: Int
    var date: String
    var text: String
}

var fakeMemo = Memo(
    id: 0,
    date: "2022-1-3",
    text: "text"
)

let fakeMemoArray = [
    Memo(id: 1, date: "2022-1-3", text: "text"),
    Memo(id: 2, date: "2022-1-3", text: "text"),
    Memo(id: 3, date: "2022-1-3", text: "text")
]

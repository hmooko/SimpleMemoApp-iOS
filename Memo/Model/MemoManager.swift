//
//  MemoManager.swift
//  Memo
//
//  Created by koohyunmo on 2/18/24.
//

import Foundation
import SQLite3

class MemoManager {
    static let shared = MemoManager()
    
    private var db: OpaquePointer?
    private let databaseName = "memodb.sqlite"
    
    init() {
        self.db = createDB()
        createTable()
    }
    
    private func createDB() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        do {
            let dbPath: String = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ).appendingPathComponent(databaseName).path
            
            if sqlite3_open(dbPath, &db) == SQLITE_OK {
                print("Successfully created DB. Path: \(dbPath)")
                return db
            }
        } catch {
            print("Error while creating Database -\(error.localizedDescription)")
        }
        return nil
    }
    
    private func createTable() {
        let query = """
                   CREATE TABLE IF NOT EXISTS memoTable(
                   id INTEGER PRIMARY KEY autoincrement,
                   date TEXT,
                   text TEXT
                   );
                   """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Creating table has been succesfully done. db: \(String(describing: self.db))")
                
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nsqlte3_step failure while creating table: \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("\nsqlite3_prepare failure while creating table: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
    }
    
    func insertMemo(date: String, text: String) {
        let insertQuery = "INSERT into memoTable (id, date, text) values (?, ?, ?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 2, NSString(string: date).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, NSString(string: text).utf8String, -1, nil)
            print("sqlite binding success")
        }
        else {
            print("sqlite binding failure")
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("sqlite insertion success")
        }
        else {
            print("sqlite step failure")
        }
    }
    
    func readMemos() -> [Memo] {
        let query: String = "SELECT * FROM memoTable;"
        var statement: OpaquePointer? = nil
        var memos: [Memo] = []
        
        if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return []
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int(statement, 0)
            let date = String(cString: sqlite3_column_text(statement, 1))
            let text = String(cString: sqlite3_column_text(statement, 2))
            
            memos.append(Memo(id: Int(id), date: String(date), text: String(text)))
        }
        sqlite3_finalize(statement)
        
        return memos
    }
    
    func readById(_ id: Int) -> Memo? {
        let query: String = "SELECT * FROM memoTable WHERE id==\(id);"
        var statement: OpaquePointer? = nil
        var memo: Memo? = nil
        
        if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return nil
        }
        if sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int(statement, 0)
            let date = String(cString: sqlite3_column_text(statement, 1))
            let text = String(cString: sqlite3_column_text(statement, 2))
            
            memo = Memo(id: Int(id), date: String(date), text: String(text))
        }
        return memo
    }
    
    func deleteMemos(_ id: Int) {
        let query = "DELETE FROM memoTable WHERE id==\(id)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete data success")
            } else {
                print("delete data step fail")
            }
        } else {
            print("delete data prepare fail")
        }
        sqlite3_finalize(statement)
    }
    
    func updateMemo(id: Int, date: String, text: String) {
        let query = "UPDATE memoTable SET date = '\(date)', text = '\(text)' WHERE id = \(id)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("success updateData")
            } else {
                print("updataData sqlite3 step fail")
            }
        } else {
            print("updateData prepare fail")
        }
    }
    
    func sortedByDate() -> Dictionary<String, [Memo]> {
        var result = Dictionary<String, [Memo]>()
        
        for memo in self.readMemos() {
            let date = String(memo.date.split(separator: " ")[0])
            if result[date] == nil {
                result[date] = [memo]
            } else {
                result[date]?.append(memo)
            }
        }
        
        return result
    }
}

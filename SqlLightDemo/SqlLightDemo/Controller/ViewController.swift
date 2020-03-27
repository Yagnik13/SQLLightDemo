//
//  ViewController.swift
//  SqlLightDemo
//
//  Created by Yagnik Suthar on 27/03/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    //MARK:- Properties
    var db: OpaquePointer?
    
    var heroList = [HeroModel]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //1
        creatingDB()
        
        //5
        insertionInDb()
        
        //7
        readValues()

    }
    
    //MARK:- Custom methods
    private func creatingDB() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("HeroesDatabase.sqlite")
        
        //2 check sql db created or not
        print("db path: \(fileURL.path)")
        
        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return
        }
        
        //3 creating data base
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    //4
    private func insertionInDb() {
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Heroes (name, powerrank) VALUES (?,?)"
        
        //preparing the query
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, "Yagnik", -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 2, ("1" as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        //6
        readValues()
        
        //displaying a success message
        print("Herro saved successfully")
    }
    
    private func readValues(){
        
        //first empty the list of heroes
        heroList.removeAll()
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //this is our select query
        let queryString = "SELECT * FROM Heroes"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let powerrank = sqlite3_column_int(stmt, 2)
            
            //adding values to list
            heroList.append(HeroModel(id: Int(id), name: String(describing: name), powerRanking: Int(powerrank)))
        }
        
        // temp check value is there or not
        for (_,value) in heroList.enumerated() {
            print(value.name)
        }
        
    }
    
}


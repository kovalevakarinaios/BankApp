//
//  Storage.swift
//  BankApp
//
//  Created by Karina Kovaleva on 2.09.24.
//

import Foundation
import SQLite3

class Storage {
    
    static let db = openDatabase()
    
    private static let createMainTableAtm = """
    CREATE TABLE ATM(
    atmID TEXT PRIMARY KEY NOT NULL,
    type TEXT,
    baseCurrency TEXT,
    currency TEXT,
    atmPrinter INTEGER CHECK (atmPrinter IN (0, 1)),
    currentStatus TEXT,
    addressID INTEGER,
    availabilityID INTEGER,
    phoneNumber TEXT,
    FOREIGN KEY (addressID) REFERENCES Address(addressID),
    FOREIGN KEY (availabilityID) REFERENCES Availability(availabilityID));
    """
    
    private static let createTableAddress = """
    CREATE TABLE Address(
    addressID INTEGER PRIMARY KEY AUTOINCREMENT,
    streetName TEXT,
    buildingNumber TEXT,
    townName TEXT,
    countrySubDivision TEXT,
    country TEXT,
    addressLine TEXT,
    description TEXT,
    geolocationID INTEGER,
    FOREIGN KEY (geolocationID) REFERENCES Geolocation(geolocationID));
    """
    
    private static let createTableGeolocation = """
    CREATE TABLE Geolocation(
    geolocationID INTEGER PRIMARY KEY AUTOINCREMENT,
    latitude TEXT,
    longitude TEXT);
    """
    
    private static let createTableAvailability = """
    CREATE TABLE Availability(
    availabilityID INTEGER PRIMARY KEY AUTOINCREMENT,
    access24Hours INTEGER CHECK (access24Hours IN (0, 1)),
    isRestricted INTEGER CHECK (isRestricted IN (0, 1)),
    sameAsOrganization INTEGER CHECK (sameAsOrganization IN (0, 1)));
    """
    
    private static let createTableDay = """
    CREATE TABLE Day(
    dayID INTEGER PRIMARY KEY AUTOINCREMENT,
    availabilityID INTEGER,
    dayCode TEXT,
    openingTime TEXT,
    closingTime TEXT,
    breakFromTime TEXT,
    breakToTime TEXT,
    FOREIGN KEY (availabilityID) REFERENCES Availability(availabilityID));
    """
    
    private static let createTableService = """
    CREATE TABLE Service(
    serviceID INTEGER PRIMARY KEY AUTOINCREMENT,
    atmID TEXT,
    serviceType TEXT,
    description TEXT,
    FOREIGN KEY (atmID) REFERENCES ATM(atmID));
    """
    
    private static let createTableCards = """
    CREATE TABLE Cards(
    atmID TEXT,
    cardType TEXT,
    FOREIGN KEY (atmID) REFERENCES ATM(atmID));
    """
    
    static func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        
        let pathDb = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "myDatabase.sqlite")
        
        guard let pathDb = pathDb else {
            print("pathDb is nil")
            return nil
        }
        
        if sqlite3_open(pathDb.path(), &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(pathDb)")
            return db
        } else {
            print("Unable to open database.")
            return nil
        }
    }
    
    static func createTable() {
        
        let tables = [self.createMainTableAtm, self.createTableAddress, self.createTableGeolocation, self.createTableAvailability, self.createTableDay, self.createTableService, self.createTableCards]
        
        var createTableStatement: OpaquePointer?
        tables.forEach {
            if sqlite3_prepare_v2(db, $0, -1, &createTableStatement, nil) == SQLITE_OK {
                if sqlite3_step(createTableStatement) == SQLITE_DONE {
                    print("\nTable created.")
                } else {
                    print("\nTable is not created.")
                }
            } else {
                print("\nCREATE TABLE statement is not prepared.")
            }
            sqlite3_finalize(createTableStatement)
        }
      
    }
    
    static func insert(atm: ATM) {
        var insertStatement: OpaquePointer?
        
        let insertStatementGeolocation = "INSERT INTO Geolocation (latitude, longitude) VALUES (?, ?);"
        
        if sqlite3_prepare_v2(self.db, insertStatementGeolocation, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, NSString(string: atm.address.geolocation.geographicCoordinates.latitude).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string: atm.address.geolocation.geographicCoordinates.longitude).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
            
            sqlite3_finalize(insertStatement)
        } else {
            print("\nINSERT Geolocation statement is not prepared.")
        }
        
        let geolocationId = sqlite3_last_insert_rowid(db)
        
        let insertStatementAddress = "INSERT INTO Address (streetName, buildingNumber, townName, countrySubDivision, country, addressLine, description, geolocationID) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
        
        if sqlite3_prepare_v2(self.db, insertStatementAddress, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, NSString(string: atm.address.streetName).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string: atm.address.buildingNumber).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string: atm.address.townName).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, NSString(string: atm.address.countrySubDivision).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, NSString(string: atm.address.country).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, NSString(string: atm.address.addressLine).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, NSString(string: atm.address.description).utf8String, -1, nil)
            sqlite3_bind_int64(insertStatement, 8, geolocationId)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
            
            sqlite3_finalize(insertStatement)
        } else {
            print("\nINSERT Address statement is not prepared.")
        }
        
        let insertStatementAvailability = "INSERT INTO Availability (access24Hours, isRestricted, sameAsOrganization) VALUES (?, ?, ?);"
       
        
        if sqlite3_prepare_v2(self.db, insertStatementAvailability, -1, &insertStatement, nil) == SQLITE_OK {
            let access24Hours = atm.availability.access24Hours ? Int64(1) : Int64(0)
            let isRestricted = atm.availability.access24Hours ? Int64(1) : Int64(0)
            let sameAsOrganization = atm.availability.access24Hours ? Int64(1) : Int64(0)
            
            sqlite3_bind_int64(insertStatement, 1, access24Hours)
            sqlite3_bind_int64(insertStatement, 2, isRestricted)
            sqlite3_bind_int64(insertStatement, 3, sameAsOrganization)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
            
            sqlite3_finalize(insertStatement)
        } else {
            print("\nINSERT Availability statement is not prepared.")
        }
        
        let availabilityId = sqlite3_last_insert_rowid(db)
        let insertStatementDay = "INSERT INTO Day (availabilityID, dayCode, openingTime, closingTime, breakFromTime, breakToTime) VALUES (?, ?, ?, ?, ?, ?);"
        
        if sqlite3_prepare_v2(self.db, insertStatementDay, -1, &insertStatement, nil) == SQLITE_OK {
            atm.availability.standardAvailability.day.forEach {
                sqlite3_bind_int64(insertStatement, 1, availabilityId)
                sqlite3_bind_text(insertStatement, 2, NSString(string: $0.dayCode).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, NSString(string: $0.openingTime).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, NSString(string: $0.closingTime).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, NSString(string: $0.dayBreak.breakFromTime).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, NSString(string: $0.dayBreak.breakToTime).utf8String, -1, nil)
            }
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
            sqlite3_finalize(insertStatement)
        } else {
            print("\nINSERT Day statement is not prepared.")
        }
        
        let insertStatementService = "INSERT INTO Service (atmID, serviceType, description) VALUES (?, ?, ?);"
        
        if sqlite3_prepare_v2(self.db, insertStatementService, -1, &insertStatement, nil) == SQLITE_OK {
            atm.services.forEach {
                sqlite3_bind_text(insertStatement, 1, NSString(string: atm.atmID).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, NSString(string: $0.serviceType).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, NSString(string: $0.description).utf8String, -1, nil)
            }
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
            sqlite3_finalize(insertStatement)
        } else {
            print("\nINSERT Service statement is not prepared.")
        }
        
        var insertStatementCards = "INSERT INTO Cards (atmID, cardType) VALUES (?, ?);"
        
        if sqlite3_prepare_v2(self.db, insertStatementCards, -1, &insertStatement, nil) == SQLITE_OK {
            atm.cards.forEach {
                sqlite3_bind_text(insertStatement, 1, NSString(string: atm.atmID).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, NSString(string: $0).utf8String, -1, nil)
            }
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
            
            sqlite3_finalize(insertStatement)
        } else {
            print("\nINSERT Cards statement is not prepared.")
        }
        
        let insertMainAtmTable = "INSERT INTO ATM (atmID, type, baseCurrency, currency, atmPrinter, currentStatus, addressID, availabilityID, phoneNumber) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        let addressId = sqlite3_last_insert_rowid(self.db)
        
        if sqlite3_prepare_v2(self.db, insertMainAtmTable, -1, &insertStatement, nil) == SQLITE_OK {
            let atmPrinter = atm.atmPrinter ? Int64(1) : Int64(0)
            
            sqlite3_bind_text(insertStatement, 1, NSString(string: atm.atmID).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string: atm.type).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string: atm.baseCurrency).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, NSString(string: atm.currency).utf8String, -1, nil)
            sqlite3_bind_int64(insertStatement, 5, atmPrinter)
            sqlite3_bind_text(insertStatement, 6, NSString(string: atm.currentStatus).utf8String, -1, nil)
            sqlite3_bind_int64(insertStatement, 7, addressId)
            sqlite3_bind_int64(insertStatement, 8, availabilityId)
            sqlite3_bind_text(insertStatement, 9, NSString(string: atm.contactDetails.phoneNumber).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
            
            sqlite3_finalize(insertStatement)
        } else {
            print("\nINSERT ATM statement is not prepared.")
        }
    }
    
    static func query() {
        var queryStatement: OpaquePointer?
        let queryStatementString = "SELECT * FROM Geolocation;"
        
        if sqlite3_prepare_v2(self.db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                guard let latitude = sqlite3_column_text(queryStatement, 0) else {
                    print("Query result is nil")
                    return
                }
                guard let longitude = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    return
                }
                let latitudeName = String(cString: latitude)
                let longitudeName = String(cString: longitude)
                // 5
                print("\nQuery Result:")
                print("\(latitudeName) | \(longitudeName)")
            } else {
                print("\nQuery returned no results.")
            }
        }  else {
            // 6
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
    }
}



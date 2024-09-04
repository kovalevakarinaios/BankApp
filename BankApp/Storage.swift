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
    streetName TEXT,
    buildingNumber TEXT,
    townName TEXT,
    countrySubDivision TEXT,
    country TEXT,
    addressLine TEXT,
    description TEXT,
    latitude TEXT,
    longitude TEXT,
    access24Hours INTEGER CHECK (access24Hours IN (0, 1)),
    isRestricted INTEGER CHECK (isRestricted IN (0, 1)),
    sameAsOrganization INTEGER CHECK (sameAsOrganization IN (0, 1)),
    mondayDayCode TEXT,
    mondayOpeningTime TEXT,
    mondayClosingTime TEXT,
    mondayBreakFromTime TEXT,
    mondayBreakToTime TEXT,
    tuesdayDayCode TEXT,
    tuesdayOpeningTime TEXT,
    tuesdayClosingTime TEXT,
    tuesdayBreakFromTime TEXT,
    tuesdayBreakToTime TEXT,
    wednesdayDayCode TEXT,
    wednesdayOpeningTime TEXT,
    wednesdayClosingTime TEXT,
    wednesdayBreakFromTime TEXT,
    wednesdayBreakToTime TEXT,
    thursdayDayCode TEXT,
    thursdayOpeningTime TEXT,
    thursdayClosingTime TEXT,
    thursdayBreakFromTime TEXT,
    thursdayBreakToTime TEXT,
    fridayDayCode TEXT,
    fridayOpeningTime TEXT,
    fridayClosingTime TEXT,
    fridayBreakFromTime TEXT,
    fridayBreakToTime TEXT,
    saturdayDayCode TEXT,
    saturdayOpeningTime TEXT,
    saturdayClosingTime TEXT,
    saturdayBreakFromTime TEXT,
    saturdayBreakToTime TEXT,
    sundayDayCode TEXT,
    sundayOpeningTime TEXT,
    sundayClosingTime TEXT,
    sundayBreakFromTime TEXT,
    sundayBreakToTime TEXT,
    services TEXT,
    cards TEXT,
    phoneNumber TEXT);
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
        
        let tables = [self.createMainTableAtm]
        
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

        let insertMainAtmTable = "INSERT INTO ATM (atmID, type, baseCurrency, currency, atmPrinter, currentStatus, streetName, buildingNumber, townName, countrySubDivision, country, addressLine, description, latitude, longitude, access24Hours, isRestricted, sameAsOrganization, mondayDayCode, mondayOpeningTime, mondayClosingTime, mondayBreakFromTime, mondayBreakToTime, tuesdayDayCode, tuesdayOpeningTime, tuesdayClosingTime, tuesdayBreakFromTime, tuesdayBreakToTime, wednesdayDayCode, wednesdayOpeningTime, wednesdayClosingTime, wednesdayBreakFromTime, wednesdayBreakToTime, thursdayDayCode, thursdayOpeningTime, thursdayClosingTime, thursdayBreakFromTime, thursdayBreakToTime, fridayDayCode, fridayOpeningTime, fridayClosingTime, fridayBreakFromTime, fridayBreakToTime, saturdayDayCode, saturdayOpeningTime, saturdayClosingTime, saturdayBreakFromTime, saturdayBreakToTime, sundayDayCode, sundayOpeningTime, sundayClosingTime, sundayBreakFromTime , sundayBreakToTime, services, cards, phoneNumber) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        let access24Hours = atm.availability.access24Hours ? Int64(1) : Int64(0)
        let isRestricted = atm.availability.access24Hours ? Int64(1) : Int64(0)
        let sameAsOrganization = atm.availability.access24Hours ? Int64(1) : Int64(0)
        let availability = atm.availability.standardAvailability.day
        
        if sqlite3_prepare_v2(self.db, insertMainAtmTable, -1, &insertStatement, nil) == SQLITE_OK {
            let atmPrinter = atm.atmPrinter ? Int64(1) : Int64(0)
            
            sqlite3_bind_text(insertStatement, 1, NSString(string: atm.atmID).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string: atm.type).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string: atm.baseCurrency).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, NSString(string: atm.currency).utf8String, -1, nil)
            sqlite3_bind_int64(insertStatement, 5, atmPrinter)
            sqlite3_bind_text(insertStatement, 6, NSString(string: atm.currentStatus).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, NSString(string: atm.address.streetName).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, NSString(string: atm.address.buildingNumber).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, NSString(string: atm.address.townName).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, NSString(string: atm.address.countrySubDivision).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 11, NSString(string: atm.address.country).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 12, NSString(string: atm.address.addressLine).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 13, NSString(string: atm.address.description).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 14, NSString(string: atm.address.geolocation.geographicCoordinates.latitude).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 15, NSString(string: atm.address.geolocation.geographicCoordinates.longitude).utf8String, -1, nil)
            sqlite3_bind_int64(insertStatement, 16, access24Hours)
            sqlite3_bind_int64(insertStatement, 17, isRestricted)
            sqlite3_bind_int64(insertStatement, 18, sameAsOrganization)
            availability.forEach {
                switch $0.dayCode {
                case "01":
                    sqlite3_bind_text(insertStatement, 19, NSString(string: $0.dayCode).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 20, NSString(string: $0.openingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 21, NSString(string: $0.closingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 22, NSString(string: $0.dayBreak.breakFromTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 23, NSString(string: $0.dayBreak.breakToTime).utf8String, -1, nil)
                case "02":
                    sqlite3_bind_text(insertStatement, 24, NSString(string: $0.dayCode).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 25, NSString(string: $0.openingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 26, NSString(string: $0.closingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 27, NSString(string: $0.dayBreak.breakFromTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 28, NSString(string: $0.dayBreak.breakToTime).utf8String, -1, nil)
                case "03":
                    sqlite3_bind_text(insertStatement, 29, NSString(string: $0.dayCode).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 30, NSString(string: $0.openingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 31, NSString(string: $0.closingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 32, NSString(string: $0.dayBreak.breakFromTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 33, NSString(string: $0.dayBreak.breakToTime).utf8String, -1, nil)
                case "04":
                    sqlite3_bind_text(insertStatement, 34, NSString(string: $0.dayCode).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 35, NSString(string: $0.openingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 36, NSString(string: $0.closingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 37, NSString(string: $0.dayBreak.breakFromTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 38, NSString(string: $0.dayBreak.breakToTime).utf8String, -1, nil)
                case "05":
                    sqlite3_bind_text(insertStatement, 39, NSString(string: $0.dayCode).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 40, NSString(string: $0.openingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 41, NSString(string: $0.closingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 42, NSString(string: $0.dayBreak.breakFromTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 43, NSString(string: $0.dayBreak.breakToTime).utf8String, -1, nil)
                case "06":
                    sqlite3_bind_text(insertStatement, 44, NSString(string: $0.dayCode).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 45, NSString(string: $0.openingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 46, NSString(string: $0.closingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 47, NSString(string: $0.dayBreak.breakFromTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 48, NSString(string: $0.dayBreak.breakToTime).utf8String, -1, nil)
                case "07":
                    sqlite3_bind_text(insertStatement, 49, NSString(string: $0.dayCode).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 50, NSString(string: $0.openingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 51, NSString(string: $0.closingTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 52, NSString(string: $0.dayBreak.breakFromTime).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 53, NSString(string: $0.dayBreak.breakToTime).utf8String, -1, nil)
                default:
                    break
                }
            }

            sqlite3_bind_text(insertStatement, 54, NSString(string: atm.services.map { $0.serviceType }.joined(separator: ", ")).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 55, NSString(string: atm.cards.joined(separator: ", ")).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 56, NSString(string: atm.contactDetails.phoneNumber).utf8String, -1, nil)

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
                print("\nQuery Result:")
                print("\(latitudeName) | \(longitudeName)")
            } else {
                print("\nQuery returned no results.")
            }
        }  else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
    }
}



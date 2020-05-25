//
//  VenuesModelTests.swift
//  FoodForPlatesTests
//
//  Created by Sean Williams on 22/05/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import XCTest
@testable import Food_For_Plates


class VenuesModelTests: XCTestCase {
    
    private var venues: [Venue]!
    
    
    override func setUpWithError() throws {
        
        venues = try XCTUnwrap(Venue.allVenues)
        
    }
    
    func testLoadVenuesQuickly() {
        measure {
            _ = Venue.allVenues
        }
    }
    
    
    func testVenuesCount() throws {
        
        XCTAssertEqual(venues.count, 26)
        
        venues.removeFirst()
        
        XCTAssertEqual(venues.count, 25)
    }
    
    func testFirstVenueAttributes() throws {
        let firstVenue = try XCTUnwrap(venues.first)
        
        XCTAssertEqual(firstVenue.name, "SMOKESTAK")
        XCTAssertEqual(firstVenue.category, "Food")
        XCTAssertEqual(firstVenue.area, "Shoreditch & Hoxton")
        XCTAssertEqual(firstVenue.phone, "020 3873 1733")
        XCTAssertEqual(firstVenue.email, "book@smokestak.co.uk")
        XCTAssertNotNil(firstVenue.address)
        XCTAssertEqual(firstVenue.description?.count, 3138)
        XCTAssertNil(firstVenue.tags)
    }
    
    func testAllVenuesHaveNames() {
        for venue in venues {
            XCTAssertFalse(venue.name.isEmpty, "missing venue name")
        }
    }
    
    func testAllVenuesHaveCategories() {
        for venue in venues {
            XCTAssertFalse(venue.category.isEmpty, "missing category")
        }
    }
    
    
    func testAddressFormatting() {
        Address.allCases.forEach {
            XCTAssertFalse($0.rawValue.contains("/n"), "New line address formatting incorrect for \($0)")
        }
    }
    
    func testDescriptionFormatting() {
        Description.allCases.forEach {
            XCTAssertFalse($0.rawValue.contains("/n"), "New line address formatting incorrect for \($0)")
        }
    }
    
    func testTelephoneFormatting() {
        Telephone.allCases.forEach {
            let telNumber = $0.rawValue.replacingOccurrences(of: " ", with: "")
            XCTAssertEqual(telNumber.count, 11, "Telephone number formatting incorrect for \($0)")
        }
    }
}

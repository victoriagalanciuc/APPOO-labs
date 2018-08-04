//
//  EntityTypes.swift
//  CoreDataCRUD
//
//  Created by Victoria on 7/10/18.
//  Copyright © 2018 Victoria. All rights reserved.
//
import Foundation

/**
    Enum for holding different entity type names (Coredata Models)
*/
enum EntityTypes: String {
    case Event = "Event"
    //case Foo = "Foo"
    //case Bar = "Bar"

    static let getAll = [Event] //[Event, Foo,Bar]
}

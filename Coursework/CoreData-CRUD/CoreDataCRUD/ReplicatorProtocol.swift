//
//  ReplicatorProtocol.swift
//  CoreDataCRUD
//
//  Created by Victoria on 10/10/18.
//  Copyright © 2018 Victoria. All rights reserved.
//

import Foundation

//Methods that must be implemented by every class that extends it.
protocol ReplicatorProtocol {
    func fetchData()
    func processData(_ jsonResult: AnyObject?)
}

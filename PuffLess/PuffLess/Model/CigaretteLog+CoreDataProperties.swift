//
//  CigaretteLog+CoreDataProperties.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 23.09.2024.
//
//

import Foundation
import CoreData


extension CigaretteLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CigaretteLog> {
        return NSFetchRequest<CigaretteLog>(entityName: "CigaretteLog")
    }

    @NSManaged public var date: Date?
    @NSManaged public var quantitiy: Int16
    @NSManaged public var id: UUID?

}

extension CigaretteLog : Identifiable {

}


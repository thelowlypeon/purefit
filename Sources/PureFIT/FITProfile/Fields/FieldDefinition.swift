//
//  FieldDefinition.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

protocol FieldDefinition: Sendable {
    associatedtype Value: FieldValue

    // TODO: need to think about whether this should require a name (which is known for standard fields, not known for unrecognized fields, and *maybe* known for developer fields)
    // TODO: need to think about whether this should require a field definition number (which is known for standard fields, not known for unrecognized fields, and *maybe* defined alongside an optional message type for developer fields)
    // UPDATE: i think the field definition should have neither the field number nor the name. developer field definitions don't fit into this profile anyway
    // UPDATE UPDATE: i cna't get the name without knowing the message type, which is determined at runtime, not compile time
    var name: String { get }
    var baseType: FITBaseType { get }

    func parse(values: [FITValue]) -> Value?
}

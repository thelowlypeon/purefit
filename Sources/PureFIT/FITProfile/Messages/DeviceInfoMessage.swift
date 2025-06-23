//
//  DeviceInfoMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 5/29/25.
//

public struct DeviceInfoMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .deviceInfo
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case timestamp             = 253
        case deviceIndex           =   0
        // case deviceType         =   1  // TODO: four-value array containing ble_device_type antplus_device_type ant_device_type local_device_type
        case manufacturer          =   2
        case serialNumber          =   3
        case product               =   4
        case softwareVersion       =   5
        case hardwareVersion       =   6
        case cumulativeOperatingTime =   7
        case batteryVoltage        =  10
        case batteryStatus         =  11
        case sensorPosition        =  18
        case descriptor            =  19
        case antTransmissionType   =  20
        case antDeviceNumber       =  21
        case antNetwork            =  22
        case sourceType            =  25
        case productName           =  27
        case batteryLevel          =  32

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .timestamp:
                return DateField(name: "Timestamp")
            case .deviceIndex:
                return IndexField(name: "Device Index", baseType: .uint8)
            case .manufacturer:
                return EnumField<Manufacturer>(name: "Manufacturer", baseType: .uint16, enumType: .garmin)
            case .serialNumber:
                return IntegerField(name: "Serial Number", baseType: .uint32z)
            case .product:
                return IntegerField(name: "Product", baseType: .uint16)
            case .softwareVersion:
                return IntegerField(name: "Software Version", baseType: .uint16, scale: 100)
            case .hardwareVersion:
                return IntegerField(name: "Hardware Version", baseType: .uint8)
            case .cumulativeOperatingTime:
                return DurationField(name: "Cumulative Operating Time", baseType: .uint32, unit: .seconds, scale: 1, offset: 0)
            case .batteryVoltage:
                return IntegerField(name: "Battery Voltage", baseType: .uint16, unitSymbol: "V", scale: 256)
            case .batteryStatus:
                return EnumField<BatteryStatus>(name: "Battery Status", baseType: .uint8, enumType: BatteryStatus.unknown)
            case .sensorPosition:
                return EnumField<BodyLocation>(name: "Sensor Position", baseType: .uint8, enumType: BodyLocation.neck)
            case .descriptor:
                return StringField(name: "Descriptor")
            case .antTransmissionType:
                return IntegerField(name: "ANT Transmission Type", baseType: .uint8)
            case .antDeviceNumber:
                return IntegerField(name: "ANT Device Number", baseType: .uint16)
            case .antNetwork:
                return IntegerField(name: "ANT Network", baseType: .uint8)
            case .sourceType:
                return EnumField<SourceType>(name: "Source Type", baseType: .uint8, enumType: SourceType.other)
            case .productName:
                return StringField(name: "Product Name")
            case .batteryLevel:
                return IntegerField(name: "Battery Level", baseType: .uint8, unitSymbol: "%")
            }
        }
    }
}

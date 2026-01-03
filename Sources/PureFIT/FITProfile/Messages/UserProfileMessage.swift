//
//  ActivityMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public struct UserProfileMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .userProfile
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case messageIndex = 254
        case friendlyName = 0 // Used for Morning Report greeting
        case gender = 1
        case age = 2 // years
        case height = 3 // 100 m
        case weight = 4 // 10 kg
        case language = 5
        case elevationSetting = 6
        case weightSetting = 7
        case restingHeartRate = 8 // bpm
        case defaultMaxRunningHeartRate = 9 // bpm
        case defaultMaxBikingHeartRate = 10 // bpm
        case defaultMaxHeartRate = 11 // bpm
        case hrSetting = 12
        case speedSetting = 13
        case distanceSetting = 14
        case powerSetting = 16
        case activityClass = 17
        case positionSetting = 18
        case temperatureSetting = 21
        case localId = 22
        // case globalId = 23 // byte array of length 6
        case wakeTime = 28 // Typical wake time
        case sleepTime = 29 // Typical bed time
        case heightSetting = 30
        case userRunningStepLength = 31 // User defined running step length set to 0 for auto length
        case userWalkingStepLength = 32 // User defined walking step length set to 0 for auto length
        case depthSetting = 47
        case diveCount = 49

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .messageIndex: CompositeField<MessageIndex>(name: "Message Index", baseType: .uint16)
            case .friendlyName: StringField(name: "Friendly Name")
            case .gender: EnumField<Gender>(name: "Gender", baseType: .enum, enumType: .female)
            case .age: IntegerField(name: "Age", baseType: .uint8, unitSymbol: "Years")
            case .height: DistanceField(name: "Height", baseType: .uint8, unit: .meters, scale: 100, offset: 0)
            case .weight: MassField(name: "Weight", baseType: .uint16, unit: .kilograms, scale: 10, offset: 0)
            case .language: EnumField<Language>(name: "Language", baseType: .uint8, enumType: .english)
            case .elevationSetting: EnumField<DisplayMeasure>(name: "Elevation Setting", baseType: .uint8, enumType: .metric)
            case .weightSetting: EnumField<DisplayMeasure>(name: "Weight Setting", baseType: .uint8, enumType: .metric)
            case .restingHeartRate: IntegerField(name: "Resting Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .defaultMaxRunningHeartRate: IntegerField(name: "Default Max Running Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .defaultMaxBikingHeartRate: IntegerField(name: "Default Max Biking Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .defaultMaxHeartRate: IntegerField(name: "Default Max Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .hrSetting: EnumField<DisplayHeartRate>(name: "Heart Rate Setting", baseType: .uint8, enumType: .bpm)
            case .speedSetting: EnumField<DisplayMeasure>(name: "Speed Setting", baseType: .uint8, enumType: .metric)
            case .distanceSetting: EnumField<DisplayMeasure>(name: "Distance Setting", baseType: .uint8, enumType: .metric)
            case .powerSetting: EnumField<DisplayPower>(name: "Power Setting", baseType: .uint8, enumType: .watts)
            case .activityClass: EnumField<ActivityClass>(name: "Activity Class", baseType: .uint8, enumType: .level)
            case .positionSetting: EnumField<DisplayPosition>(name: "Position Setting", baseType: .uint8, enumType: .degree)
            case .temperatureSetting: EnumField<DisplayMeasure>(name: "Temperature Setting", baseType: .uint8, enumType: .metric)
            case .localId: EnumField<UserLocalID>(name: "Local ID", baseType: .uint16, enumType: .localMax)
            case .wakeTime: DurationField(name: "Wake Time", baseType: .uint32, unit: .seconds, scale: 1, offset: 0) // number of seconds into the day since local 00:00:00
            case .sleepTime: DurationField(name: "Sleep Time", baseType: .uint32, unit: .seconds, scale: 1, offset: 0) // number of seconds into the day since local 00:00:00
            case .heightSetting: EnumField<DisplayMeasure>(name: "Height Setting", baseType: .uint8, enumType: .metric)
            case .userRunningStepLength: DistanceField(name: "User Running Step Length", baseType: .uint16, unit: .meters, scale: 1000, offset: 0)
            case .userWalkingStepLength: DistanceField(name: "User Walking Step Length", baseType: .uint16, unit: .meters, scale: 1000, offset: 0)
            case .depthSetting: EnumField<DisplayMeasure>(name: "Depth Setting", baseType: .uint8, enumType: .metric)
            case .diveCount: IntegerField(name: "Dive Count", baseType: .uint32)
            }
        }
    }
}

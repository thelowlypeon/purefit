//
//  DeviceSettingsMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//

public struct DeviceSettingsMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .deviceSettings
    public let fields: [FieldDefinitionNumber : [FITValue]]

    // all fields as of FIT 21.188.00
    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case activeTimeZone = 0 // Index into time zone arrays.
        case utcOffset = 1 // Offset from system time. Required to convert timestamp from system time to UTC.
        case timeOffset = 2 // Offset from system time.
        case timeMode = 4 // Display mode for the time
        case timeZoneOffset = 5 // timezone offset in 1/4 hour increments
        case backlightMode = 12 // Mode for backlight
        case activityTrackerEnabled = 36 // Enabled state of the activity tracker functionality
        case clockTime = 37 // UTC timestamp used to set the devices clock and date
        case pagesEnabled = 40 // Bitfield to configure enabled screens for each supported loop
        case moveAlertEnabled = 46 // Enabled state of the move alert
        case dateMode = 47 // Display mode for the date
        case displayOrientation = 55
        case mountingSide = 56
        case defaultPage = 57 // Bitfield to indicate one page as default for each supported loop
        case autosyncMinSteps = 58 // Minimum steps before an autosync can occur
        case autosyncMinTime = 59 // Minimum minutes before an autosync can occur
        case lactateThresholdAutoDetectEnabled = 80
        case bleAutoUploadEnabled = 86 // Automatically upload using BLE
        case autoSyncFrequency = 89 // Helps to conserve battery by changing modes
        case autoActivityDetect = 90 // Specific activities auto-activity detect enabled/disabled settings
        case numberOfScreens = 94 // Number of screens configured to display
        case smartNotificationDisplayOrientation = 95 // Smart Notification display orientation
        case tapInterface = 134 // Tap interface switch
        case tapSensitivity = 174 // Used to hold the tap threshold setting

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .activeTimeZone: IntegerField(name: "Active TimeZone", baseType: .uint8)
            case .utcOffset: IntegerField(name: "UTC Offset", baseType: .uint32)
            case .timeOffset: IntegerField(name: "Time Offset", baseType: .uint32, unitSymbol: "s")
            case .timeMode: EnumField<TimeMode>(name: "Time Mode", baseType: .uint8, enumType: .utc)
            case .timeZoneOffset: IntegerField(name: "TimeZone Offset", baseType: .sint8, unitSymbol: "hr", scale: 4)
            case .backlightMode: EnumField<BacklightMode>(name: "Backlight Mode", baseType: .uint8, enumType: .autoBrightness)
            case .activityTrackerEnabled: BooleanField(name: "Activity Tracker Enabled")
            case .clockTime: DateField(name: "Clock Time")
            case .pagesEnabled: MultipleValueField(singleFieldDefinition: IndexField(name: "Pages Enabled", baseType: .uint16))
            case .moveAlertEnabled: BooleanField(name: "Move Alert Enabled")
            case .dateMode: EnumField<DateMode>(name: "Date Mode", baseType: .uint8, enumType: .dayMonth)
            case .displayOrientation: EnumField<DisplayOrientation>(name: "Display Orientation", baseType: .uint8, enumType: .portrait)
            case .mountingSide: EnumField<Side>(name: "Mounting Side", baseType: .uint8, enumType: .left)
            case .defaultPage: MultipleValueField(singleFieldDefinition: IndexField(name: "Default Page", baseType: .uint16))
            case .autosyncMinSteps: IntegerField(name: "Autosync Min Steps", baseType: .uint16, unitSymbol: "Steps")
            case .autosyncMinTime: DurationField(name: "Autosync Min Time", baseType: .uint16, unit: .minutes, scale: 1, offset: 0)
            case .lactateThresholdAutoDetectEnabled: BooleanField(name: "Lactate Threshold Auto-detect Enabled")
            case .bleAutoUploadEnabled: BooleanField(name: "BLE Auto Upload Enabled")
            case .autoSyncFrequency: EnumField<AutoSyncFrequency>(name: "Auto Sync Frequency", baseType: .uint8, enumType: .never)
            case .autoActivityDetect: EnumField<AutoActivityDetect>(name: "Auto Activity Detect", baseType: .uint8, enumType: .none)
            case .numberOfScreens: IntegerField(name: "Number Of Screens", baseType: .uint8)
            case .smartNotificationDisplayOrientation: EnumField<DisplayOrientation>(name: "Smart Notification Display Orientation", baseType: .uint8, enumType: .portrait)
            case .tapInterface: EnumField<Switch>(name: "Tap Interface", baseType: .uint8, enumType: .off)
            case .tapSensitivity: EnumField<TapSensitivity>(name: "Tap Sensitivity", baseType: .uint8, enumType: .medium)
            }
        }
    }
}

//
//  GlobalMessageType.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public enum GlobalMessageType: UInt16, CaseIterable {
    case fileID = 0
    case session = 18
    case lap = 19
    case record = 20
    case event = 21
    case deviceInfo = 23
    case activity = 34
    case hrv = 78
    case fieldDescription = 206
    case timeInZone = 216

    public var name: String {
        switch self {
        case .fileID: "File ID"
        case .session: "Session"
        case .lap: "Lap"
        case .record: "Record"
        case .event: "Event"
        case .deviceInfo: "Device Info"
        case .activity: "Activity"
        case .hrv: "HRV"
        case .fieldDescription: "Field Description"
        case .timeInZone: "Time in Zone"
        }
    }
}

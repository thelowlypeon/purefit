//
//  GlobalMessageType.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public enum GlobalMessageType: UInt16, FITEnum, CaseIterable, Sendable {
    case fileID = 0
    case capabilities = 1
    case deviceSettings = 2
    case userProfile = 3
    case hrmProfile = 4
    case sdmProfile = 5
    case bikeProfile = 6
    case zonesTarget = 7
    case hrZone = 8
    case powerZone = 9
    case metZone = 10
    case sport = 12
    case goal = 15
    case session = 18
    case lap = 19
    case record = 20
    case event = 21
    case deviceInfo = 23
    case workout = 26
    case workoutStep = 27
    case schedule = 28
    case weightScale = 30
    case course = 31
    case coursePoint = 32
    case totals = 33
    case activity = 34
    case software = 35
    case fileCapabilities = 37
    case mesgCapabilities = 38
    case fieldCapabilities = 39
    case fileCreator = 49
    case bloodPressure = 51
    case speedZone = 53
    case monitoring = 55
    case trainingFile = 72
    case hrv = 78
    case antRx = 80
    case antTx = 81
    case antChannelID = 82
    case length = 101
    case monitoringInfo = 103
    case pad = 105
    case slaveDevice = 106
    case connectivity = 127
    case weatherConditions = 128
    case weatherAlert = 129
    case cadenceZone = 131
    case hr = 132
    case segmentLap = 142
    case memoGlob = 145
    case segmentID = 148
    case segmentLeaderboardEntry = 149
    case segmentPoint = 150
    case segmentFile = 151
    case workoutSession = 158
    case watchfaceSettings = 159
    case gpsMetadata = 160
    case cameraEvent = 161
    case timestampCorrelation = 162
    case gyroscopeData = 164
    case accelerometerData = 165
    case threeDSensorCalibration = 167
    case videoFrame = 169
    case obdiiData = 174
    case nmeaSentence = 177
    case aviationAttitude = 178
    case video = 184
    case videoTitle = 185
    case videoDescription = 186
    case videoClip = 187
    case ohrSettings = 188
    case exdScreenConfiguration = 200
    case exdDataFieldConfiguration = 201
    case exdDataConceptConfiguration = 202
    case fieldDescription = 206
    case developerDataID = 207
    case magnetometerData = 208
    case barometerData = 209
    case oneDSensorCalibration = 210
    case monitoringHrData = 211
    case timeInZone = 216
    case set = 225
    case stressLevel = 227
    case maxMetData = 229
    case diveSettings = 258
    case diveGas = 259
    case diveAlarm = 262
    case exerciseTitle = 264
    case diveSummary = 268
    case spo2Data = 269
    case sleepLevel = 275
    case jump = 285
    case beatIntervals = 290
    case respirationRate = 297
    case split = 312
    case splitSummary = 313
    case climbPro = 317
    case tankUpdate = 319
    case tankSummary = 323
    case sleepAssessment = 346
    case hrvStatusSummary = 370
    case hrvValue = 371
    case deviceAuxBatteryInfo = 375
    case diveApneaAlarm = 393
    case mfgRangeMin = 0xFF00
    case mfgRangeMax = 0xFFFE

    public var name: String {
        switch self {
        case .fileID: return "File ID"
        case .capabilities: return "Capabilities"
        case .deviceSettings: return "Device Settings"
        case .userProfile: return "User Profile"
        case .hrmProfile: return "Hrm Profile"
        case .sdmProfile: return "Sdm Profile"
        case .bikeProfile: return "Bike Profile"
        case .zonesTarget: return "Zones Target"
        case .hrZone: return "Hr Zone"
        case .powerZone: return "Power Zone"
        case .metZone: return "Met Zone"
        case .sport: return "Sport"
        case .goal: return "Goal"
        case .session: return "Session"
        case .lap: return "Lap"
        case .record: return "Record"
        case .event: return "Event"
        case .deviceInfo: return "Device Info"
        case .workout: return "Workout"
        case .workoutStep: return "Workout Step"
        case .schedule: return "Schedule"
        case .weightScale: return "Weight Scale"
        case .course: return "Course"
        case .coursePoint: return "Course Point"
        case .totals: return "Totals"
        case .activity: return "Activity"
        case .software: return "Software"
        case .fileCapabilities: return "File Capabilities"
        case .mesgCapabilities: return "Mesg Capabilities"
        case .fieldCapabilities: return "Field Capabilities"
        case .fileCreator: return "File Creator"
        case .bloodPressure: return "Blood Pressure"
        case .speedZone: return "Speed Zone"
        case .monitoring: return "Monitoring"
        case .trainingFile: return "Training File"
        case .hrv: return "HRV"
        case .antRx: return "Ant Rx"
        case .antTx: return "Ant Tx"
        case .antChannelID: return "Ant Channel ID"
        case .length: return "Length"
        case .monitoringInfo: return "Monitoring Info"
        case .pad: return "Pad"
        case .slaveDevice: return "Slave Device"
        case .connectivity: return "Connectivity"
        case .weatherConditions: return "Weather Conditions"
        case .weatherAlert: return "Weather Alert"
        case .cadenceZone: return "Cadence Zone"
        case .hr: return "Hr"
        case .segmentLap: return "Segment Lap"
        case .memoGlob: return "Memo Glob"
        case .segmentID: return "Segment ID"
        case .segmentLeaderboardEntry: return "Segment Leaderboard Entry"
        case .segmentPoint: return "Segment Point"
        case .segmentFile: return "Segment File"
        case .workoutSession: return "Workout Session"
        case .watchfaceSettings: return "Watchface Settings"
        case .gpsMetadata: return "Gps Metadata"
        case .cameraEvent: return "Camera Event"
        case .timestampCorrelation: return "Timestamp Correlation"
        case .gyroscopeData: return "Gyroscope Data"
        case .accelerometerData: return "Accelerometer Data"
        case .threeDSensorCalibration: return "Three D Sensor Calibration"
        case .videoFrame: return "Video Frame"
        case .obdiiData: return "Obdii Data"
        case .nmeaSentence: return "Nmea Sentence"
        case .aviationAttitude: return "Aviation Attitude"
        case .video: return "Video"
        case .videoTitle: return "Video Title"
        case .videoDescription: return "Video Description"
        case .videoClip: return "Video Clip"
        case .ohrSettings: return "Ohr Settings"
        case .exdScreenConfiguration: return "Exd Screen Configuration"
        case .exdDataFieldConfiguration: return "Exd Data Field Configuration"
        case .exdDataConceptConfiguration: return "Exd Data Concept Configuration"
        case .fieldDescription: return "Field Description"
        case .developerDataID: return "Developer Data ID"
        case .magnetometerData: return "Magnetometer Data"
        case .barometerData: return "Barometer Data"
        case .oneDSensorCalibration: return "One D Sensor Calibration"
        case .monitoringHrData: return "Monitoring Hr Data"
        case .timeInZone: return "Time in Zone"
        case .set: return "Set"
        case .stressLevel: return "Stress Level"
        case .maxMetData: return "Max Met Data"
        case .diveSettings: return "Dive Settings"
        case .diveGas: return "Dive Gas"
        case .diveAlarm: return "Dive Alarm"
        case .exerciseTitle: return "Exercise Title"
        case .diveSummary: return "Dive Summary"
        case .spo2Data: return "Spo2 Data"
        case .sleepLevel: return "Sleep Level"
        case .jump: return "Jump"
        case .beatIntervals: return "Beat Intervals"
        case .respirationRate: return "Respiration Rate"
        case .split: return "Split"
        case .splitSummary: return "Split Summary"
        case .climbPro: return "Climb Pro"
        case .tankUpdate: return "Tank Update"
        case .tankSummary: return "Tank Summary"
        case .sleepAssessment: return "Sleep Assessment"
        case .hrvStatusSummary: return "HRV Status Summary"
        case .hrvValue: return "HRV Value"
        case .deviceAuxBatteryInfo: return "Device Aux Battery Info"
        case .diveApneaAlarm: return "Dive Apnea Alarm"
        case .mfgRangeMin: return "Mfg Range Min"
        case .mfgRangeMax: return "Mfg Range Max"
        }
    }
}

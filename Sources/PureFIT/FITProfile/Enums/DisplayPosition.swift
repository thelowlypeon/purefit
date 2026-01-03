//
//  DisplayPosition.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum DisplayPosition: UInt8, FITEnum, Sendable {
    case degree = 0 // dd.dddddd
    case degreeMinute = 1 // dddmm.mmm
    case degreeMinuteSecond = 2 // dddmmss
    case austrianGrid = 3 // Austrian Grid (BMN)
    case britishGrid = 4 // British National Grid
    case dutchGrid = 5 // Dutch grid system
    case hungarianGrid = 6 // Hungarian grid system
    case finnishGrid = 7 // Finnish grid system Zone3 KKJ27
    case germanGrid = 8 // Gausss Krueger (German)
    case icelandicGrid = 9 // Icelandic Grid
    case indonesianEquatorial = 10 // Indonesian Equatorial LCO
    case indonesianIrian = 11 // Indonesian Irian LCO
    case indonesianSouthern = 12 // Indonesian Southern LCO
    case indiaZone0 = 13 // India zone 0
    case indiaZoneIA = 14 // India zone IA
    case indiaZoneIB = 15 // India zone IB
    case indiaZoneIIA = 16 // India zone IIA
    case indiaZoneIIB = 17 // India zone IIB
    case indiaZoneIIIA = 18 // India zone IIIA
    case indiaZoneIIIB = 19 // India zone IIIB
    case indiaZoneIVA = 20 // India zone IVA
    case indiaZoneIVB = 21 // India zone IVB
    case irishTransverse = 22 // Irish Transverse Mercator
    case irishGrid = 23 // Irish Grid
    case loran = 24 // Loran TD
    case maidenheadGrid = 25 // Maidenhead grid system
    case mgrsGrid = 26 // MGRS grid system
    case newZealandGrid = 27 // New Zealand grid system
    case newZealandTransverse = 28 // New Zealand Transverse Mercator
    case qatarGrid = 29 // Qatar National Grid
    case modifiedSwedishGrid = 30 // Modified RT-90 (Sweden)
    case swedishGrid = 31 // RT-90 (Sweden)
    case southAfricanGrid = 32 // South African Grid
    case swissGrid = 33 // Swiss CH-1903 grid
    case taiwanGrid = 34 // Taiwan Grid
    case unitedStatesGrid = 35 // United States National Grid
    case utmUpsGrid = 36 // UTM/UPS grid system
    case westMalayan = 37 // West Malayan RSO
    case borneoRso = 38 // Borneo RSO
    case estonianGrid = 39 // Estonian grid system
    case latvianGrid = 40 // Latvian Transverse Mercator
    case swedishRef99Grid = 41 // Reference Grid 99 TM (Swedish)
}

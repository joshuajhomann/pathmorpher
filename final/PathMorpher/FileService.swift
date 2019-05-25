//
//  FileService.swift
//  PathMorpher
//
//  Created by Joshua Homann on 5/24/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import Foundation

enum FileService {
    static var urls: [URL] {
    return (try? FileManager
        .default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false))
        .flatMap {
            try? FileManager
                .default
                .contentsOfDirectory(at: $0, includingPropertiesForKeys: nil, options: [.skipsSubdirectoryDescendants])
        } ?? []
    }
    static func write<Encoded: Encodable>(_ encodable: Encoded, to filename: String) throws {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(filename)
        let data = try JSONEncoder().encode(encodable)
        try data.write(to: fileURL)
    }

    static func read<Decoded: Decodable>(type: Decoded.Type, from filename: String) throws -> Decoded  {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(filename)
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(type, from: data)
    }

    static func delete(filename: String) throws {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(filename)
        try FileManager.default.removeItem(at: fileURL)
    }
}

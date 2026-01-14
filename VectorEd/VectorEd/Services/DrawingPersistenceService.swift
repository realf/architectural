//
//  DrawingPersistenceService.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import Foundation

protocol DrawingPersistence {
    func save(_ document: DrawingDocument) throws
    func load(documentId: UUID) throws -> DrawingDocument
}

class DrawingPersistenceService: DrawingPersistence {
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func save(_ document: DrawingDocument) throws {
        let url = fileURL(for: document.id)

        let directoryURL = url.deletingLastPathComponent()
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

        let data = try encoder.encode(document)
        try data.write(to: url)
    }

    func load(documentId: UUID) throws -> DrawingDocument {
        let url = fileURL(for: documentId)
        let data = try Data(contentsOf: url)
        return try decoder.decode(DrawingDocument.self, from: data)
    }

    // MARK: - Private

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func fileURL(for documentId: UUID) -> URL {
        documentsDirectory
            .appendingPathComponent("drawings")
            .appendingPathComponent("\(documentId.uuidString).json")
    }
}

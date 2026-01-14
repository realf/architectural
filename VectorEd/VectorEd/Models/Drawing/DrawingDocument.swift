//
//  DrawingDocument.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import Foundation

/// Documnt model representing a complete drawing
struct DrawingDocument: Codable {
    let id: UUID
    var metadata: DocumentMetadata

    /// All shapes in z-index order
    var shapes: [AnyShape]
    var canvasSize: CGSize

    init(
        id: UUID = UUID(),
        canvasSize: CGSize,
        shapes: [any Shape] = []
    ) {
        self.id = id
        self.canvasSize = canvasSize
        self.shapes = shapes.map { AnyShape($0) }
        self.metadata = DocumentMetadata(
            createdAt: Date(),
            modifiedAt: Date()
        )
    }

    mutating func updateModifiedDate() {
        metadata.modifiedAt = Date()
    }
}

struct DocumentMetadata: Codable {
    let createdAt: Date
    var modifiedAt: Date
    var title: String?
}

/// Type-erased wrapper for Shape protocol to enable encoding/decoding of heterogeneous shape arrays
struct AnyShape: Codable {
    private let _shape: any Shape
    private let _shapeType: ShapeType

    init(_ shape: any Shape) {
        self._shape = shape
        self._shapeType = shape.shapeType
    }

    var shape: any Shape {
        _shape
    }

    // MARK: - Codable

    private enum CodingKeys: String, CodingKey {
        case shapeType
        case shapeData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ShapeType.self, forKey: .shapeType)

        switch type {
        case .circle:
            _shape = try container.decode(Circle.self, forKey: .shapeData)
        case .rectangle:
            _shape = try container.decode(Rectangle.self, forKey: .shapeData)
        case .freehand, .triangle:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unsupported shape type: \(type)"
                )
            )
        }
        _shapeType = type
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_shapeType, forKey: .shapeType)

        switch _shape {
        case let circle as Circle:
            try container.encode(circle, forKey: .shapeData)
        case let rectangle as Rectangle:
            try container.encode(rectangle, forKey: .shapeData)
        default:
            throw EncodingError.invalidValue(
                _shape,
                EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: "Unsupported shape type"
                )
            )
        }
    }
}

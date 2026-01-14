//
//  ShapeFactory.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import UIKit

/// Factory for creating shape instances
class ShapeFactory {
    static func createShape(
        type: ShapeType,
        bounds: CGRect,
        style: DrawingStyle
    ) -> any Shape {
        switch type {
        case .circle:
            return Circle(bounds: bounds, style: style)
        case .rectangle:
            return Rectangle(bounds: bounds, style: style)
        case .triangle:
            fatalError("Triangle not yet implemented")
        case .freehand:
            fatalError("Freehand not yet implemented")
        }
    }
}

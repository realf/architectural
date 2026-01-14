//
//  DrawingViewModel.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import UIKit
import Combine

class DrawingViewModel {
    /// Current drawing document
    @Published private(set) var document: DrawingDocument

    /// Runtime drawing state
    @Published private(set) var state: DrawingState = DrawingState()

    /// Current tool selection
    @Published var currentTool: Tool = .rectangle {
        didSet {
            state.currentTool = currentTool
        }
    }

    /// Current drawing style
    @Published var currentStyle: DrawingStyle {
        didSet {
            state.currentStyle = currentStyle
        }
    }

    // MARK: - Private Properties

    private let persistenceService: any DrawingPersistence
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        canvasSize: CGSize,
        persistenceService: any DrawingPersistence =
            DrawingPersistenceService()
    ) {
        self.document = DrawingDocument(canvasSize: canvasSize)
        self.persistenceService = persistenceService
        self.currentStyle = DrawingStyle()
    }

    // MARK: - Drawing Operations

    /// Begin drawing a new shape
    func beginDrawing(at point: CGPoint) {
        state.touchStartPoint = point
        state.isDrawing = true

        // Create temporary shape
        let shapeType = shapeTypeForTool(currentTool)
        let bounds = CGRect(origin: point, size: .zero)
        state.temporaryShape = ShapeFactory.createShape(
            type: shapeType,
            bounds: bounds,
            style: currentStyle
        )
    }

    /// Update shape being drawn
    func updateDrawing(to point: CGPoint) {
        guard state.isDrawing, var tempShape = state.temporaryShape else { return }

        if currentTool == .rectangle {
            guard let startPoint = state.touchStartPoint else { return }

            let bounds = CGRect(
                x: min(startPoint.x, point.x),
                y: min(startPoint.y, point.y),
                width: abs(point.x - startPoint.x),
                height: abs(point.y - startPoint.y)
            )

            tempShape.bounds = bounds
            state.temporaryShape = tempShape
        }
    }

    /// Finish drawing current shape
    func endDrawing() {
        guard state.isDrawing, let shape = state.temporaryShape else { return }

        addShape(shape)

        state.isDrawing = false
        state.temporaryShape = nil
        state.touchStartPoint = nil
    }

    private func addShape(_ shape: any Shape) {
        // Add shape to document
        document.shapes.append(AnyShape(shape))
        document.updateModifiedDate()
    }

    // MARK: - Helpers

    private func shapeTypeForTool(_ tool: Tool) -> ShapeType {
        switch tool {
        case .circle: return .circle
        case .rectangle: return .rectangle
        }
    }

    // MARK: - Persistence

    func save()  {
        // TODO
    }

    func load(documentId: UUID) {
        // TODO
    }
}

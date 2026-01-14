//
//  DrawingViewModel.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import Foundation

class DrawingViewModel {
    private let persistenceService: any DrawingPersistence

    init(
        canvasSize: CGSize,
        persistenceService: any DrawingPersistence =
            DrawingPersistenceService()
    ) {
        self.persistenceService = persistenceService
    }
}

//
//  AppCoordinator.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import UIKit

class AppCoordinator {

    private let window: UIWindow
    private var drawingViewController: DrawingViewController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        // Create services
        let persistenceService = DrawingPersistenceService()

        // Create view model with dependencies
        let canvasSize = DrawingConstants.defaultCanvasSize
        let viewModel = DrawingViewModel(
            canvasSize: canvasSize,
            persistenceService: persistenceService
        )

        // Create view controller
        let viewController = DrawingViewController(viewModel: viewModel)

        // Set as root
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        self.drawingViewController = viewController
    }
}

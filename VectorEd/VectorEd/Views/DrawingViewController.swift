//
//  DrawingViewController.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import UIKit
import Combine

class DrawingViewController: UIViewController {
    private let viewModel: DrawingViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Views

    private lazy var canvasView: DrawingCanvasView = {
        let view = DrawingCanvasView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    // MARK: - Initialization

    init(viewModel: DrawingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
        setupBindings()
        setupGestures()
    }

    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(canvasView)
        // TODO: Other views
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])

        // TODO: other views
    }

    private func setupBindings() {
        viewModel.$document
            .sink { [weak self] document in
                self?.canvasView.render(document: document)
            }
            .store(in: &cancellables)

        viewModel.$state
            .sink { [weak self] state in
                self?.canvasView.updateState(state)
            }
            .store(in: &cancellables)
    }

    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        canvasView.addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        canvasView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Gesture Handlers

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: canvasView)

        switch gesture.state {
        case .began:
            viewModel.beginDrawing(at: location)

        case .changed:
            viewModel.updateDrawing(to: location)

        case .ended, .cancelled:
            viewModel.endDrawing()

        default:
            break
        }
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: canvasView)
        viewModel.beginDrawing(at: location)
        viewModel.endDrawing()
    }
}

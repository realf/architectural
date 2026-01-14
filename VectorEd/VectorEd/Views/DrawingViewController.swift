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

    private lazy var rectangleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rectangle", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(rectangleToolTapped), for: .touchUpInside)
        return button
    }()

    private lazy var circleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Circle", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(circleToolTapped), for: .touchUpInside)
        return button
    }()

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
        view.addSubview(rectangleButton)
        view.addSubview(circleButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            circleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            circleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            rectangleButton.topAnchor.constraint(equalTo: circleButton.topAnchor),
            rectangleButton.trailingAnchor.constraint(equalTo: circleButton.leadingAnchor, constant: -10),

            canvasView.topAnchor.constraint(equalTo: circleButton.bottomAnchor, constant: 20),
            canvasView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            canvasView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            canvasView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
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

    // MARK: - ACtions

    @objc private func circleToolTapped() {
        viewModel.currentTool = .circle
    }

    @objc private func rectangleToolTapped() {
        viewModel.currentTool = .rectangle
    }
}

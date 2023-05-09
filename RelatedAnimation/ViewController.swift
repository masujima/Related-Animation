//
//  ViewController.swift
//  RelatedAnimation
//
//  Created by Yernar Masujima on 07.05.2023.
//

import UIKit

class ViewController: UIViewController {
	
	private var animator: UIViewPropertyAnimator!
	
	private lazy var blueView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemBlue
		view.layer.cornerRadius = 10
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private lazy var slider: UISlider = {
		let slider = UISlider()
		slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
		slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
		slider.translatesAutoresizingMaskIntoConstraints = false
		
		return slider
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
			self.blueView.frame = self.blueView.frame.offsetBy(dx: self.view.bounds.width - self.blueView.bounds.width * 1.5, dy: 0)

			self.blueView.transform = CGAffineTransform(rotationAngle: .pi / 2).scaledBy(x: 1.5, y: 1.5)
		}
		
		setupBlueView()
		setupSlider()
	}
	
	private func setupBlueView() {
		view.addSubview(blueView)
		NSLayoutConstraint.activate([
			blueView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			blueView.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
			blueView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -32),
			blueView.heightAnchor.constraint(equalToConstant: 100),
			blueView.widthAnchor.constraint(equalToConstant: 100)
		])
	}
	
	private func setupSlider() {
		view.addSubview(slider)
		NSLayoutConstraint.activate([
			slider.topAnchor.constraint(equalTo: blueView.bottomAnchor, constant: 32),
			slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
		])
	}
	
	@objc
	private func sliderChanged(sender: UISlider) {
		animator.fractionComplete = CGFloat(sender.value)
	}
	
	@objc
	private func sliderDidEndSliding() {
		if animator.isRunning {
			animator.fractionComplete = CGFloat(slider.value)
		} else {
			UIView.animate(withDuration: 1) {
				self.slider.setValue(1, animated: true)
			}
			
			animator.pausesOnCompletion = true
			animator.startAnimation()
		}
	}
}

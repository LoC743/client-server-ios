//
//  PhotoViewerViewController.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 22.10.2020.
//

import UIKit

class PhotoViewerViewController: UIViewController {
    
    var photos: [UIImage] = []
    var currentIndex: Int = 0 {
        didSet {
            if self.currentIndex < 0 {
                self.currentIndex = 0
            } else if currentIndex >= photos.count {
                self.currentIndex = photos.count - 1
            }
        }
    }
    
    var currentImage: UIImage? {
        get {
            guard photos.count > 0 else { return nil }
            
            return photos[currentIndex]
        }
    }
    
    lazy var currentImageView: UIImageView = {
        var imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "default-profile")

        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        
        var pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(sender:)))
        imageView.addGestureRecognizer(pan)
        
//        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleLeftSwipe))
//        swipeLeft.direction = .left
//        imageView.addGestureRecognizer(swipeLeft)
//
//        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleRightSwipe))
//        swipeRight.direction = .right
//        imageView.addGestureRecognizer(swipeRight)
        
        imageView.isUserInteractionEnabled = true

        return imageView
    }()
    
    // MARK: ImageView для свайпов
    
//    lazy var additionalImageView: UIImageView = {
//        var imageView = UIImageView(frame: self.view.frame)
//        imageView.image = UIImage(named: "default-profile")
//
//        imageView.isHidden = true
//        imageView.backgroundColor = .black
//        imageView.contentMode = .scaleAspectFit
//
//        return imageView
//    }()
    
    // MARK: ImageView для Pan
    
    lazy var leftImageView: UIImageView = {
        let frame = CGRect(x: -view.frame.maxX, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
        var imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "default-profile")

        imageView.isHidden = true
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let frame = CGRect(x: view.frame.maxX, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
        var imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "default-profile")

        imageView.isHidden = true
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    var currentImageViewOldCenter = CGPoint()
    var leftImageViewOldCenter = CGPoint()
    var rightImageViewOldCenter = CGPoint()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setCurrentImageView()
        
        setupAdditionalImageViews()
        
        view.addSubview(currentImageView)
//        view.addSubview(additionalImageView)
        view.addSubview(leftImageView)
        view.addSubview(rightImageView)
        
        currentImageViewOldCenter = currentImageView.center
        leftImageViewOldCenter = leftImageView.center
        rightImageViewOldCenter = rightImageView.center
    }
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setCurrentImageView() {
        guard photos.count > 0,
              currentIndex > -1,
              photos.count > currentIndex else { return }
        
        currentImageView.image = currentImage
    }
    
    func getPhotosData(photos: [UIImage], currentIndex: Int) {
        self.photos = photos
        self.currentIndex = currentIndex
    }
    
    // MARK: Анимации для Swipe-ов
    
//    private func setAdditionalImageViewRightSide() {
//        self.currentIndex += 1
//        additionalImageView.frame = CGRect(x: self.view.frame.maxX, y: self.view.frame.minY, width: self.view.frame.maxX, height: self.view.frame.maxY)
//        self.additionalImageView.isHidden = false
//        additionalImageView.image = currentImage
//    }
//
//    private func animateSwipe(direction: UISwipeGestureRecognizer.Direction) {
//        var translationX: CGFloat = 0
//
//        if direction == .left {
//            translationX = -self.view.frame.maxX
//        } else if direction == .right {
//            translationX = self.view.frame.maxX
//        }
//
//        UIView.animate(withDuration: 0.4) {
//            // Main ImageView
//            self.currentImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
//            // Additional ImageView
//            self.additionalImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
//
//        } completion: { (_) in
//            // Main ImageView
//            self.currentImageView.image = self.currentImage
//
//            self.currentImageView.transform = .identity
//            self.currentImageView.alpha = 1
//
//            // Additional ImageView
//            self.additionalImageView.transform = .identity
//            self.additionalImageView.isHidden = true
//        }
//    }
//
//    @objc func handleLeftSwipe(sender: UISwipeGestureRecognizer) {
//        guard currentIndex + 1 != photos.count else { return }
//        setAdditionalImageViewRightSide()
//        animateSwipe(direction: sender.direction)
//    }
//
//    private func setAdditionalImageViewLeftSide() {
//        self.currentIndex -= 1
//        additionalImageView.frame = CGRect(x: -self.view.frame.maxX, y: self.view.frame.minY, width: self.view.frame.maxX, height: self.view.frame.maxY)
//        self.additionalImageView.isHidden = false
//        additionalImageView.image = currentImage
//    }
//
//    @objc func handleRightSwipe(sender: UISwipeGestureRecognizer) {
//        guard currentIndex - 1 >= 0 else { return }
//        setAdditionalImageViewLeftSide()
//        animateSwipe(direction: sender.direction)
//    }
    
    // MARK: Интерактивное перелистывание через Pan
    
    private func setupAdditionalImageViews() {
        if currentIndex - 1 >= 0 {
            leftImageView.isHidden = false
            leftImageView.image = photos[currentIndex - 1]
        } else {
            leftImageView.isHidden = true
            leftImageView.image = nil
        }
        
        if currentIndex + 1 != photos.count {
            rightImageView.isHidden = false
            rightImageView.image = photos[currentIndex + 1]
        } else {
            rightImageView.isHidden = true
            rightImageView.image = nil
        }
        
    }
    
    private func moveLeft() {
        self.currentIndex += 1
        UIView.animate(withDuration: 0.4) {
            // Main ImageView
            self.currentImageView.center = self.leftImageViewOldCenter
            // Additional ImageViews
            self.rightImageView.center = self.currentImageViewOldCenter
            self.leftImageView.center = self.leftImageViewOldCenter
        } completion: { (_) in
            // Main ImageView
            self.currentImageView.image = self.currentImage
            self.currentImageView.center = self.currentImageViewOldCenter
            
            // Additional ImageView
            self.leftImageView.center = self.leftImageViewOldCenter
            self.rightImageView.center = self.rightImageViewOldCenter
            
            self.setupAdditionalImageViews()
        }
    }
    
    private func moveRight() {
        self.currentIndex -= 1
        UIView.animate(withDuration: 0.4) {
            // Main ImageView
            self.currentImageView.center = self.rightImageViewOldCenter
            // Additional ImageViews
            self.leftImageView.center = self.currentImageViewOldCenter
            self.rightImageView.center = self.rightImageViewOldCenter
        } completion: { (_) in
            // Main ImageView
            self.currentImageView.image = self.currentImage
            self.currentImageView.center = self.currentImageViewOldCenter
            
            // Additional ImageView
            self.leftImageView.center = self.leftImageViewOldCenter
            self.rightImageView.center = self.rightImageViewOldCenter
            
            self.setupAdditionalImageViews()
        }
    }
    
    private func moveDefault() {
        UIView.animate(withDuration: 0.8) {
            self.leftImageView.center = self.leftImageViewOldCenter
            self.currentImageView.center = self.currentImageViewOldCenter
            self.rightImageView.center = self.rightImageViewOldCenter
        }
    }
    
    private func handleEndOfPan() {
        if currentImageView.center.x > 380 {
            moveRight()
        } else if currentImageView.center.x < 40 {
            moveLeft()
        } else {
            moveDefault()
        }
    }

    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if currentIndex - 1 < 0 && translation.x > 0 && currentImageView.center.x > currentImageViewOldCenter.x {
            moveDefault()
            return
        }
        
        if currentIndex + 1 == photos.count && translation.x < 0 && currentImageView.center.x < currentImageViewOldCenter.x {
            moveDefault()
            return
        }
        
        leftImageView.center = CGPoint(x: leftImageView.center.x + translation.x, y: leftImageView.center.y)
        currentImageView.center = CGPoint(x: currentImageView.center.x + translation.x, y: currentImageView.center.y)
        rightImageView.center = CGPoint(x: rightImageView.center.x + translation.x, y: rightImageView.center.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        switch sender.state {
        case .ended:
            handleEndOfPan()
        default:
            break
        }
    }
}

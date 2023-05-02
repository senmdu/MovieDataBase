//
//  ImageViewer.swift
//  PremierSwift
//
//  Created by Senthil Kumar on 30/04/23.
//  Copyright © 2023 Deliveroo. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}
    
class ImageViewer: UIViewController {
    
    let image : UIImage
    
    let backGroundColor : UIColor = .clear
    
    private var orginalFrame : CGRect?
    
    var transitionFrame : CGRect?
    
    let imageView : UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.contentMode = .scaleAspectFit
        imgView.isUserInteractionEnabled = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    
    private let closeButton : UIButton = {
        let button = UIButton(type: .close)
        if #available(iOS 15.0, *) {
            var conf = UIButton.Configuration.filled()
            conf.cornerStyle = .capsule
            button.configuration = conf
        }
        button.tintColor = UIColor.Text.grey
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private lazy var blurView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    private init(image: UIImage) {
        self.image = image
        self.imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func loadUI() {
        view.backgroundColor = backGroundColor
        view.addSubview(blurView)
        view.addSubview(imageView)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                        action:
                                                                        #selector(self.handleTapImageView)))
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        self.view.layoutIfNeeded()
        self.orginalFrame = self.imageView.frame
    }
    
    @objc func handleTapImageView() {
    let isHidden = self.closeButton.isHidden
       if isHidden {
           self.closeButton.alpha = 0
           self.closeButton.isHidden = false
        }
        UIView.animate(withDuration: 0.3) {  [weak self]  in
            guard let self = self else {return}
            self.closeButton.alpha = isHidden ? 1 : 0
        } completion: { [weak self] _ in
            guard let self = self else {return}
            self.closeButton.isHidden = !isHidden
        }
     }
    
    class func show(from vc : UIViewController, image: UIImage, touchView: UIView? = nil) {
        let imageViewer = ImageViewer(image: image)
        if let touch = touchView {
            let frameInView = touch.convert(touch.frame, to: vc.view)
            imageViewer.transitionFrame = frameInView
        }
        
        vc.addChild(imageViewer)
        vc.view.addSubview(imageViewer.view)
        imageViewer.didMove(toParent: vc)
        
        imageViewer.blurView.alpha = 0
        imageViewer.imageView.alpha = 0
        if imageViewer.transitionFrame != nil {
            imageViewer.transitionFrame!.origin.y -= imageViewer.view.safeAreaInsets.top
            imageViewer.imageView.frame =  imageViewer.transitionFrame!
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .transitionCrossDissolve) {
            imageViewer.blurView.alpha = 1
            imageViewer.imageView.alpha = 1
            if imageViewer.transitionFrame != nil {
                imageViewer.imageView.frame = imageViewer.orginalFrame ?? imageViewer.view.bounds
            }
        }
    }
    
    @objc func closeView() {
        self.closeButton.removeFromSuperview()
        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        self.view.translatesAutoresizingMaskIntoConstraints = true
        if transitionFrame != nil {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1) { [weak self] in

                self?.imageView.frame = self?.transitionFrame ?? .zero
                self?.blurView.alpha = 0
            } completion: { _ in
                
                removeFromView()
            }
        }else {
            removeFromView()
        }
        
        func removeFromView() {
            UIView.animate(withDuration: 0.3) {  [weak self]  in
                self?.imageView.alpha = 0
                self?.blurView.alpha = 0
            } completion: { [weak self] _ in
                self?.willMove(toParent: nil)
                self?.view.removeFromSuperview()
                self?.removeFromParent()
            }
        }

    }
    
    deinit {
        print("deinit")
    }

}

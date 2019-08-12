//
//  ViewController.swift
//  Slide Out
//
//  Created by Saliou DJALO on 12/08/2019.
//  Copyright © 2019 Saliou DJALO. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var updateCount = 0
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var mapView = MKMapView()
    var locationManager  = CLLocationManager()
    var cardViewController: CardViewController!
    //var visualEffectView:UIVisualEffectView!
    
    let cardHeight:CGFloat = 600
    let cardHandleAreaHeight:CGFloat = 70
    
    var isCardVisible = false
    var nextState: CardState {
        if isCardVisible {
            return .collapsed
        }
        return .expanded
    }
    
    var compassButton: UIButton = {
        var but = UIButton()
        but.setImage(UIImage(named: "compass"), for: .normal)
        but.addTarget(self, action: #selector(updateUserLocation), for: .touchUpInside)
        return but
    }()
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        processCLLocationManager()
        view.addSubview(mapView)
        
        // jajoute la compass
        view.addSubview(compassButton)
        compassButton.frame = CGRect(x: view.frame.maxX - 50 - 16, y: view.frame.maxY - 140, width: 50, height: 50)
        
        processCard()
    }
    
    @objc func updateUserLocation() {
        //print("Button clicked!")
        updateCount = 2
        processCLLocationManager()
    }
    
    
    fileprivate func processCard() {
        //visualEffectView = UIVisualEffectView()
        //visualEffectView.frame = self.view.frame
        //self.view.addSubview(visualEffectView)
        
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        // ajout des gestures recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleCardPan(recognizer:)))
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // start animation
            startInteractiveTransition(state: nextState, duration: 1)
        case .changed:
            // update transition
            let translation = recognizer.translation(in: cardViewController.handleArea)
            var fractionCompleted = translation.y / cardHeight
            if !isCardVisible {
                fractionCompleted = -fractionCompleted
            }
            updateInteractiveTransition(fractionCompleted: fractionCompleted)
        case .ended:
            //continue
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            frameAnimator.addCompletion { (_) in
                self.isCardVisible = !self.isCardVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 12
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            // run animations
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
        
    }
    
    func continueInteractiveTransition() {
        
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
        
    }
    
}


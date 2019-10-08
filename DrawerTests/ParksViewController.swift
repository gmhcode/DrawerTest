//
//  ParksViewController.swift
//  DrawerTests
//
//  Created by Greg Hughes on 10/8/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//


import UIKit
class ParksViewController: UIViewController {

    @IBOutlet weak var drawerView: UIView!
    @IBOutlet var drawerPanGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var mapView: UIView!
    
    private var topDrawerTarget = CGFloat()
    private var bottomDrawerTarget = CGFloat()
    private var impact = UIImpactFeedbackGenerator(style: .light)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           bottomDrawerTarget = mapView.frame.maxY
           topDrawerTarget = mapView.frame.maxY / 3
        
        

       }
   
    @IBAction func panGestureActivated(_ sender: UIPanGestureRecognizer) {
        
        switch drawerPanGestureRecognizer.state {
        case .began:
            
            panDrawer(withPanPoint: CGPoint(x: drawerView.center.x, y: drawerView.center.y + drawerPanGestureRecognizer.translation(in: drawerView).y))
            drawerPanGestureRecognizer.setTranslation(CGPoint.zero, in: drawerView)
        case .changed:
            panDrawer(withPanPoint: CGPoint(x: drawerView.center.x, y: drawerView.center.y + drawerPanGestureRecognizer.translation(in: drawerView).y))
            drawerPanGestureRecognizer.setTranslation(CGPoint.zero, in: drawerView)
        case .ended:
            drawerPanGestureRecognizer.setTranslation(CGPoint.zero, in: drawerView)
            panDidEnd()
            
        default:
            return
        }
    }
    
  
    
    func distance(from lhs: CGPoint, to rhs: CGPoint) -> CGFloat {
        let xDistance = lhs.x - rhs.x
        let yDistance = lhs.y - rhs.y
        return (xDistance * xDistance + yDistance * yDistance).squareRoot()
    }
}

extension ParksViewController {
    
    func openDrawer() {
        
        // Sets target locations of views & then animates.
        let target = topDrawerTarget
        self.userInteractionAnimate(view: self.drawerView, edge: self.drawerView.frame.minY, to: target, velocity: drawerPanGestureRecognizer.velocity(in: drawerView).y)
    }
    
    func closeDrawer() {
        let target = bottomDrawerTarget
        self.userInteractionAnimate(view: drawerView, edge: drawerView.frame.minY, to: target, velocity: drawerPanGestureRecognizer.velocity(in: drawerView).y)

    }
    
    ///sets the view to new target location / animates
    func userInteractionAnimate(view: UIView, edge: CGFloat, to target: CGFloat, velocity: CGFloat) {
        let distanceToTranslate = target - edge
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.97, initialSpringVelocity: abs(velocity) * 0.01, options: .curveEaseOut , animations: {
            
            //Sets view to new location (target
            view.frame =  view.frame.offsetBy(dx: 0, dy: distanceToTranslate)
        
        }, completion: { (success) in
           
            if success {
                self.impact.prepare()
                self.impact.impactOccurred()
            }
            
        })
    }
    
    
    
    
    ///determines where to put the drawer view based off where the finger is
    func panDrawer(withPanPoint panPoint: CGPoint) {
        if drawerView.frame.maxY < mapView.frame.maxY {
            
            // the /2 slows down then ability for the user to keep swiping past a certain point
            drawerView.center.y += drawerPanGestureRecognizer.translation(in: drawerView).y / 2
            
        } else {
            drawerView.center.y += drawerPanGestureRecognizer.translation(in: drawerView).y
        }
    }
    
    //determines whether the drawer should be opened or closed, depending on how fast a swip was or when the user ended the swipe at
    func panDidEnd() {
        let aboveHalfWay = drawerView.frame.minY < ((mapView.frame.maxY) * 0.5)
        let velocity = drawerPanGestureRecognizer.velocity(in: drawerView).y
        if velocity > 500 {
            self.closeDrawer()
        } else if velocity < -500 {
            self.openDrawer()
        } else if aboveHalfWay {
            self.openDrawer()
        } else if !aboveHalfWay {
            self.closeDrawer()
        }
    }
}


























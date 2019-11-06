//
//  ViewController.swift
//  loady
//
//  Created by farshad jahanmanesh on 2/2/19.
//  Copyright © 2019 farshadJahanmanesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tempTimer1 : Timer?
    var tempTimer2 : Timer?
    var tempTimer3 : Timer?
    var tempTimer4 : Timer?
    var tempTimer : Timer?
    var fourPhaseTempTimer : Timer?
    @IBOutlet var circleView : LoadyButton!
    @IBOutlet var allInOneview : LoadyButton!
    @IBOutlet var uberLikeView : LoadyButton!
    @IBOutlet var fillingView : LoadyButton!
    @IBOutlet var indicatorViewLike : LoadyButton!
    @IBOutlet var appstore : LoadyButton!
    @IBOutlet var androidLoading : LoadyButton!
    @IBOutlet var downloading : LoadyButton!
    @IBOutlet var fourPhases : LoadyFourPhaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start and stop animating on user touch
        self.circleView.addTarget(self, action: #selector(animateView(_:)), for: .touchUpInside)
        self.allInOneview.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.uberLikeView.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.fillingView.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.indicatorViewLike.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.appstore.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.fourPhases.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.androidLoading.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.downloading.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
     
		self.circleView.setAnimation(LoadyAnimationType.circleAndTick())
//		self.allInOneview.setAnimation(LoadyAnimationType.all)
		self.uberLikeView.setAnimation(LoadyAnimationType.topLine())
		self.fillingView.setAnimation(LoadyAnimationType.backgroundHighlighter())
		self.indicatorViewLike.setAnimation(LoadyAnimationType.indicator(with: .init(indicatorViewStyle: .light)))
		self.androidLoading.setAnimation(LoadyAnimationType.android())
		self.downloading.setAnimation(LoadyAnimationType.downloading(with: .init(
			downloadingLabel: (title: "Copying Data...", font: UIFont.boldSystemFont(ofSize: 18), textColor : UIColor(red:0, green:0.71, blue:0.8, alpha:1)),
			percentageLabel: (font: UIFont.boldSystemFont(ofSize: 14), textColor : UIColor(red:0, green:0.71, blue:0.8, alpha:1)),
			downloadedLabel: (title: "Completed.", font: UIFont.boldSystemFont(ofSize: 20), textColor : UIColor(red:0, green:0.71, blue:0.8, alpha:1))
			)
		))

		self.appstore.setAnimation(LoadyAnimationType.appstore(with: .init(shrinkFrom: .fromLeft)))
        self.appstore?.pauseImage =  UIImage(named: "pause-button")
		self.appstore?.backgroundFillColor = UIColor.lightGray.withAlphaComponent(0.4)

        // sets the color that fills the button after percent value changed
        self.allInOneview?.backgroundFillColor = UIColor(red:0.118, green:0.509, blue:0.299, alpha:1)
        
        // sets the indicator color above the button
        self.allInOneview?.loadingColor = UIColor(red:0.00, green:0.49, blue:0.90, alpha:1.0)
        
        // sets the indictore view color (dark or light) inside the button
        self.allInOneview?.indicatorViewStyle = .light
        
        // some animations have image inside (e.g appstore pause image), this line sets that image
        self.allInOneview?.pauseImage = UIImage(named: "pause-button")
        
        // starts loading animation
        // self.allInOneview?.startLoading()
        
        // some animations have filling background, or change the circle stroke, this sets the filling percent, number is something between 0 to 100
        self.allInOneview?.fillTheButton(with: 10)
        self.fourPhases.loadingColor = UIColor(red:0.38, green:0.66, blue:0.09, alpha:1.0)
		self.fourPhases.setPhases(phases: .init(normalPhase:
		(title: "Lock", image: UIImage(named: "unlocked"), background: UIColor(red:0.00, green:0.49, blue:0.90, alpha:1.0)), loadingPhase:
		(title: "Waiting...", image: UIImage(named: ""), background: UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)), successPhase:
		(title: "Activated", image: UIImage(named: "locked"), background: UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)), errorPhase:
		(title: "Error", image: UIImage(named: "unlocked"), background: UIColor(red:0.64, green:0.00, blue:0.15, alpha:1.0))))
	}
    
    @IBAction func animateView(_ sender : UIButton){
		if let button = sender as? LoadyFourPhaseButton {
			if button.loadingIsShowing() {
				button.stopLoading()
				return
			}
			button.startLoading()
			self.fourPhaseTempTimer?.invalidate()
            self.fourPhaseTempTimer = nil
			self.fourPhases.loadingPhase()
            self.fourPhaseTempTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true){(t) in
                    if self.fourPhases.tag  == 0 {
                        self.fourPhases.errorPhase()
                        self.fourPhases.tag = 1
                    }else if self.fourPhases?.tag  == 1{
                        self.fourPhases.successPhase()
                        self.fourPhases.tag = 2
                    } else{
                        self.fourPhases.normalPhase()
                        self.fourPhases.tag = 0
                    }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.fourPhaseTempTimer?.fire()
            }
			return
		}
		
		guard let button = sender as? LoadyButton else {
			return
		}
		if button.loadingIsShowing() {
			button.stopLoading()
			return
		}
		button.startLoading()
        var percent : CGFloat = 0
        switch button.animationType {
        case LoadyBackgroundHighlighterAnimation.animationTypeKey:
            self.tempTimer1?.invalidate()
            self.tempTimer1 = nil
            self.tempTimer1 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                percent += CGFloat.random(in: 0...10)
                button.fillTheButton(with: percent)
                if percent > 105 {
                    percent = 100
                    self.tempTimer1?.invalidate()
                }
            }
            self.tempTimer1?.fire()
        case LoadyCircleAndTickAnimation.animationTypeKey:
            self.tempTimer2?.invalidate()
            self.tempTimer2 = nil
            self.tempTimer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                percent += CGFloat.random(in: 0...10)
                button.fillTheButton(with: percent)
                if percent > 105 {
                    percent = 100
                    self.tempTimer2?.invalidate()
                }
            }
            self.tempTimer2?.fire()
		case LoadyAppStoreAnimation.animationTypeKey:
            self.tempTimer3?.invalidate()
            self.tempTimer3 = nil
            self.tempTimer3 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                percent += CGFloat.random(in: 0...10)
                button.fillTheButton(with: percent)

                if percent > 105 {
                    percent = 100
                    self.tempTimer3?.invalidate()
                }

            }
            self.tempTimer3?.fire()
//        case LoadyAnimationType.all:
//            self.tempTimer?.invalidate()
//            self.tempTimer = nil
//            self.tempTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){(t) in
//                percent += CGFloat.random(in: 0...10)
//                button.fillTheButton(with: percent)
//                if percent > 105 {
//                    percent = 100
//                    self.tempTimer?.invalidate()
//                }
//            }
//            self.tempTimer?.fire()
        case LoadyDownloadingAnimation.animationTypeKey:
            self.tempTimer4?.invalidate()
            self.tempTimer4 = nil
            self.tempTimer4 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){(t) in
                percent += CGFloat.random(in: 5...10)
                
                button.fillTheButton(with: percent)
                if percent > 105 {
                    percent = 100
                    self.tempTimer4?.invalidate()
                }
            }
            self.tempTimer4?.fire()
        default:
            break;
        }
    }
    
    
}


// YOU CAN USE NVActivityIndicatorView VERY EASY LIKE THIS
//
// extension NVActivityIndicatorView : LoadyActivityIndicator {
//
// }
//
// let av2 = NVActivityIndicatorView(frame: .zero)
// av2.type = .orbit
// av2.color = UIColor(red:0, green:0.71, blue:0.8, alpha:1)
// av2.padding = 12
// self.allInOneview?.activiyIndicator = av2

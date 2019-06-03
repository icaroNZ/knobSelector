//
//  ViewController.swift
//  RotaryWheel
//
//  Created by Icaro Lavrador on 2/06/19.
//  Copyright © 2019 Icaro Lavrador. All rights reserved.
//

import UIKit
import GLKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var view9: UIView!

    @IBOutlet weak var knobView: Knob!
    
    @IBOutlet weak var changeWheelPositionButton: UIBarButtonItem!
    @IBOutlet weak var knobRightAlignConstratin: NSLayoutConstraint!
    @IBOutlet weak var knobLeftAlignConstrain: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewRightConstraint: NSLayoutConstraint!
    @IBAction func changeWheelPositionAction(_ sender: Any) {
        changeWheelPosition()
    }
    
    var currentView = 0
    var previusView = 0
    var views: [UIView]!
    var numberOfViews = 0
    
    let clickSound = AVAudioPlayer(fileName: "click")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
        setupRotaryWheel()
        if traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self , sourceView: view)
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        stackViewRightConstraint.isActive = true
        stackViewLeftConstraint.isActive = true
        if (fromInterfaceOrientation.isPortrait){
            if changeWheelPositionButton.title == "Left" {
                stackViewLeftConstraint.isActive = false
            } else {
                stackViewRightConstraint.isActive = false
            }
        }
        self.view.layoutIfNeeded()
    }
    
    private func setupRotaryWheel(){
        knobView.maximumValue = Float(numberOfViews)
        knobView.lineWidth = 6
        knobView.tintColor = .black
        knobView.setValue(Float(currentView))
        knobView.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
    }
    
    @objc private func handleValueChanged(_ sender: Any) {
        currentView = Int(knobView.value)
        if currentView != previusView {
            previusView = currentView
            changeActiveView()
        }
    }
    private func loadViews() {
        self.views = self.view.allSubViews.filter{ $0.tag > 0 }.sorted(by: { $0.tag < $1.tag })
        numberOfViews = self.views.count - 1
        views[currentView].backgroundColor = .red
    }
    
    private func changeActiveView() {
        UIView.animate(withDuration: 0.2) {
            
            self.views.forEach{$0.backgroundColor = .gray}
            self.views[self.currentView].backgroundColor = .red
            self.clickSound.play()
        }
    }
    
    private func changeWheelPosition() {
        let deviceIsOnPortrait = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
        
        changeWheelPositionButton.title = !knobLeftAlignConstrain.isActive ? "Right" : "Left"
        
        knobLeftAlignConstrain.isActive = !knobLeftAlignConstrain.isActive
        knobRightAlignConstratin.isActive = !knobRightAlignConstratin.isActive
        
        stackViewLeftConstraint.isActive = knobLeftAlignConstrain.isActive || deviceIsOnPortrait
        stackViewRightConstraint.isActive = knobRightAlignConstratin.isActive || deviceIsOnPortrait
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController: UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let view = views[currentView]
        let frame = view.convert(view.frame, to: view)
        previewingContext.sourceRect = frame
        if let finalView = storyboard?.instantiateViewController(withIdentifier: "Peak View") as? PeakViewController {
            finalView.loadView()
            let label = view.subviews.compactMap{ $0 as? UILabel }.first
            finalView.valueLabel.text = label?.text ?? "No Info"
            finalView.descriptionLabel.text = "Details for \(currentView + 1)"

            return finalView
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
}


//
//  ShowCardNumberView.swift
//  Runner
//

import Foundation
import UIKit
import VGSShowSDK

/// Native UIView subclass, holds VGSLabels.
class ShowCardNumberView: UIView {
    
    // MARK: - Vars
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var cardNumberVGSLabel: VGSLabel = {
        let label = ShowCardNumberView.provideStylesVGSLabel()
        
        label.placeholder = "**** **** **** ****"
        label.contentPath = "data.attributes.pan"
        
        // Create regex object, split card number to XXXX XXXX XXXX XXXX format.
        do {
            let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"
            let template = "$1 $2 $3 $4"
            let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])
            
            // Add transformation regex to label.
            label.addTransformationRegex(regex, template: template)
        } catch {
            assertionFailure("invalid regex, error: \(error)")
        }
        
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(cardNumberVGSLabel)
        
        cardNumberVGSLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func subscribeViewsToShow(_ vgsShow: VGSShow) {
        vgsShow.subscribe(cardNumberVGSLabel)
    }
    
    // MARK: - Private
    
    static private func provideStylesVGSLabel() -> VGSLabel {
        let label = VGSLabel()
        label.translatesAutoresizingMaskIntoConstraints = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.05, green: 0.11, blue: 0.26, alpha: 1.00)
        label.placeholderStyle.font = UIFont.systemFont(ofSize: 14)
        label.placeholderStyle.color = .black
        label.placeholderStyle.textAlignment = .right
        label.textAlignment = .right
        label.borderColor = UIColor.clear
        
        return label
    }
}

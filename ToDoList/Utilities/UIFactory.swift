//
//  UIFactory.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 26/2/2568 BE.
//


import UIKit

final class UIFactory {
    
    static func createLabel(
        text: String = "",
        font: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = .white,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createTextField(
        placeholder: String = "",
        font: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = .white
    ) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = font
        textField.textColor = textColor
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

    static func createTextView(
        font: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = .white,
        backgroundColor: UIColor = .clear
    ) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.textColor = textColor
        textView.backgroundColor = backgroundColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    static func createButton(
        systemImageName: String,
        tintColor: UIColor = .darkGray,
        size: CGFloat = 24
    ) -> UIButton {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: .medium)
        button.setImage(UIImage(systemName: systemImageName, withConfiguration: config), for: .normal)
        button.tintColor = tintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    static func createTextButton(
        title: String,
        titleColor: UIColor = .systemYellow,
        font: UIFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        button.alpha = 0
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    static func createContainerView(
        backgroundColor: UIColor = .black,
        cornerRadius: CGFloat = 12
    ) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

//
//  DateHelper.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 26/2/2568 BE.
//

import UIKit

struct DateHelper {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    static func formattedDate(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

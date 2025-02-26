//
//  DateHelper.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 26/2/2568 BE.
//

import UIKit

struct DateHelper {
    static func formattedDate(from date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }
}

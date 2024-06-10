//
//  Constants.swift
//  Tracker
//
//  Created by Anton Filipchuk on 10.05.2024.
//

import Foundation

enum Localization {
    
    //MARK: - OnboardingViewController
    static let onboardingBlueLabel = NSLocalizedString("onboardingBlueLabel", comment:"")
    static let onboardingRedLabel = NSLocalizedString("onboardingRedLabel", comment:"")
    
    //MARK: - OnboardingView
    static let onboardingButton = NSLocalizedString("onboardingButton", comment:"")
    
    // MARK: - TrackersViewController
    static let dataPlaceholderLabel = NSLocalizedString("dataPlaceholderLabel", comment: "")
    static let searchPlaceholderLabel = NSLocalizedString("searchPlaceholderLabel", comment: "")
    static let trackersViewControllerName = NSLocalizedString("trackersViewControllerName", comment: "")
    static let searchFieldPlaceholder = NSLocalizedString("searchFieldPlaceholder", comment: "")
    static let contextMenuPinLabel = NSLocalizedString("contextMenuPinLabel", comment: "")
    static let contextMenuUnpinLabel = NSLocalizedString("contextMenuUnpinLabel", comment: "")
    static let contextMenuEditLabel = NSLocalizedString("contextMenuEditLabel", comment: "")
    static let contextMenuDelLabel = NSLocalizedString("contextMenuDelLabel", comment: "")
    static let pinnedCategory = NSLocalizedString("pinnedCategory", comment: "")
    static let deleteAlertMessage = NSLocalizedString("deleteAlertMessage", comment: "")
    static let filtersButton = NSLocalizedString("filtersButton", comment: "")
    
    //MARK: - TrackerCollectionViewCell
    static let numberOfDays = "numberOfDays"
    
    //MARK: - AddTrackerViewController
    static let habitButtonLabel = NSLocalizedString("habitButtonLabel", comment: "")
    static let eventButtonLabel = NSLocalizedString("eventButtonLabel", comment: "")
    static let addTrackerViewControllerName = NSLocalizedString("addTrackerViewControllerName", comment: "")
    
    //MARK: - NewTrackerViewController
    static let newHabbit = NSLocalizedString("newHabbit", comment: "")
    static let newEvent = NSLocalizedString("newEvent", comment: "")
    static let textFieldLabel = NSLocalizedString("textFieldLabel", comment: "")
    static let everyDaySubtext = NSLocalizedString("everyDaySubtext", comment: "")
    static let categoryLabel = NSLocalizedString("categoryLabel", comment: "")
    static let scheduleLabel = NSLocalizedString("scheduleLabel", comment: "")
    static let localizedMessage = NSLocalizedString("limitMessage", comment: "")
    static let limitMessage = String(format: localizedMessage, Constants.limit)
    static let editingLabel = NSLocalizedString("editingLabel", comment: "")
    static let saveButtonLabel = NSLocalizedString("saveButtonLabel", comment: "")
    
    //MARK: - CategoryViewController
    static let addCategoryButtonLabel = NSLocalizedString("addCategoryButtonLabel", comment: "")
    static let categoryPlaceholderLabel = NSLocalizedString("categoryPlaceholderLabel", comment: "")
    static let categoryViewControllerName = NSLocalizedString("categoryViewControllerName", comment: "")
    
    //MARK: - AddCategoryViewController
    static let doneButtonLabel = NSLocalizedString("doneButtonLabel", comment: "")
    static let categoryNamePlaceholderLabel = NSLocalizedString("categoryNamePlaceholderLabel", comment: "")
    static let addCategoryViewControllerName = NSLocalizedString("addCategoryViewControllerName", comment: "")
    
    //MARK: - ScheduleViewController
    static let scheduleViewControllerName = NSLocalizedString("scheduleViewControllerName", comment: "")
    
    //MARK: - TabBarController
    static let trackersLabel = NSLocalizedString("trackersLabel", comment: "")
    static let statisticsLabel = NSLocalizedString("statisticsLabel", comment: "")
    
    //MARK: - CancelButton
    static let cancelButton = NSLocalizedString("cancelButton", comment: "")
    
    //MARK: - CreateButton
    static let createButton = NSLocalizedString("createButton", comment: "")
    
    //MARK: - TrackerProperties
    static let emojiLabel = NSLocalizedString("emojiLabel", comment: "")
    static let colorLabel = NSLocalizedString("colorLabel", comment: "")
    
    //MARK: - WeekDays
    static let mondayLong = NSLocalizedString("mondayLong", comment: "")
    static let tuesdayLong = NSLocalizedString("tuesdayLong", comment: "")
    static let wednesdayLong = NSLocalizedString("wednesdayLong", comment: "")
    static let thursdayLong = NSLocalizedString("thursdayLong", comment: "")
    static let friedayLong = NSLocalizedString("friedayLong", comment: "")
    static let saturdayLong = NSLocalizedString("saturdayLong", comment: "")
    static let sundayLong = NSLocalizedString("sundayLong", comment: "")
    
    static let mondayShort = NSLocalizedString("mondayShort", comment: "")
    static let tuesdayShort = NSLocalizedString("tuesdayShort", comment: "")
    static let wednesdayShort = NSLocalizedString("wednesdayShort", comment: "")
    static let thursdayShort = NSLocalizedString("thursdayShort", comment: "")
    static let friedayShort = NSLocalizedString("friedayShort", comment: "")
    static let saturdayShort = NSLocalizedString("saturdayShort", comment: "")
    static let sundayShort = NSLocalizedString("sundayShort", comment: "")
    
    //MARK: - FiltersViewController
    static let filtersViewControllerName = NSLocalizedString("filtersViewControllerName", comment: "")
    static let filterAllTrackers = NSLocalizedString("filterAllTrackers", comment: "")
    static let filterTodayTrackers = NSLocalizedString("filterTodayTrackers", comment: "")
    static let filterCompletedTrackers = NSLocalizedString("filterCompletedTrackers", comment: "")
    static let filterNotCompletedTrackers = NSLocalizedString("filterNotCompletedTrackers", comment: "")
    
    //MARK: - StatsViewController
    static let statsViewControllerName = NSLocalizedString("statsViewControllerName", comment: "")
    static let statsPlaceholderLabel = NSLocalizedString("statsPlaceholderLabel", comment: "")
    static let statsBestPeriod = NSLocalizedString("statsBestPeriod", comment: "")
    static let statsPerfectDays = NSLocalizedString("statsPerfectDays", comment: "")
    static let statsTrackersСompleted = NSLocalizedString("statsTrackersСompleted", comment: "")
    static let statsAverageValue = NSLocalizedString("statsAverageValue", comment: "")
    
}

enum Images {
    //MARK: - OnboardingViewController
    static let onboardingBlueImage = "blue"
    static let onboardingRedImage = "red"
    
    // MARK: - TrackersViewController
    static let dataPlaceholderImage = "Start"
    static let searchPlaceholderImage = "Error"
    
    //MARK: - CategoryViewController
    static let categoryPlaceholderImage =  "Start"
    
    //MARK: - TabBarController
    static let trackersIcon = "trackers"
    static let statisticsIcon = "stats"
    
    //MARK: - StatsViewController
    static let statsPlaceholderImage = "statsPlaceholder"
}

enum Constants {
    //MARK: - NewTrackerViewController
    static let limit = 38
    
    //MARK: - YandexMobileMetrica
    static let apiKey = "87d0a1e3-d5e0-4667-a41c-98538160191b"
    
}



//
//  Constants.swift
//  Tracker
//
//  Created by Anton Filipchuk on 10.05.2024.
//

import Foundation

enum Constants {
    
    //MARK: - OnboardingViewController
    static let onboardingBlue = OnboardingView("blue", "Отслеживайте только \n то, что хотите")
    static let onboardingRed = OnboardingView("red", "Даже если это \n не литры воды и йога")
    
    //MARK: - OnboardingView
    static let onboardingButton = BlackButton(title: "Вот это технологии!")
    
    // MARK: - TrackersViewController
    static let dataPlaceholder = TrackersPlaceholder(title: "Что будем отслеживать?", image: "Start")
    static let searchPlaceholder = TrackersPlaceholder(title: "Ничего не найдено", image: "Error")
    static let trackersViewControllerName = "Трекеры"
    static let searchFieldPlaceholder = "Поиск"
    
    //MARK: - AddTrackerViewController
    static let habitButton = BlackButton(title: "Привычка")
    static let eventButton = BlackButton(title: "Нерегулярное событие")
    static let addTrackerViewControllerName = "Создание трекера"
    
    //MARK: - NewTrackerViewController
    static let newHabbit = "Новая привычка"
    static let newEvent = "Новое нерегулярное событие"
    static let textField = TextField(placeholder: "Введите название трекера")
    static let limitMessage = "Ограничение \(limit) символов"
    static let limit = 38
    
    //MARK: - CategoryViewController
    static let addCategoryButton = BlackButton(title: "Добавить категорию")
    static let categoryPlaceholder = TrackersPlaceholder(title: "Привычки и события можно\nобъединять по смыслу", image: "Start")
    static let categoryViewControllerName = "Категория"
    
    //MARK: - AddCategoryViewController
    static let doneButton = BlackButton(title: "Готово")
    static let categoryName = TextField(placeholder: "Введите название категории")
    static let addCategoryViewControllerName = "Новая категория"
    
    //MARK: - ScheduleViewController
    static let scheduleViewControllerName = "Расписание"
    
    //MARK: - TabBarController
    static let trackers = "Трекеры"
    static let trackersIcon = "trackers"
    static let statistics = "Статистика"
    static let statisticsIcon = "stats"
    
    //MARK: - CancelButton
    static let cancelButton = "Отменить"
    
    //MARK: - CreateButton
    static let createButton = "Создать"
    
    
    
    
}

//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Anton Filipchuk on 03.05.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    private lazy var pages: [UIViewController] = {
        let blue = OnboardingView(Images.onboardingBlueImage, Localization.onboardingBlueLabel)
        let red = OnboardingView(Images.onboardingRedImage, Localization.onboardingRedLabel)
        return [blue, red]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = pages.count
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .yBlack
        pc.pageIndicatorTintColor = .yBlack.withAlphaComponent(0.3)
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addPageControl()
        dataSource = self
        delegate = self
    }
}

private extension OnboardingViewController {
    func setup() {
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
    func addPageControl() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168)
        ])
    }
    
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

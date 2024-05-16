//
//  PageViewController.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/16/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pages: [HomeViewController] = []
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setup() {
        dataSource = self
        delegate = self
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.viewModel = viewModel
        homeViewController.pageViewController = self
        pages.append(homeViewController)
        setViewControllers(pages, direction: .forward, animated: true)
    }

    private func fetchData() {
        viewModel.fetchSurvey().drive(onNext: { [weak self] surveys in
            self?.reconfigureUI(surveys)
        })
        .disposed(by: disposeBag)
    }

    private func reconfigureUI(_ surveys: SurveyResponseEntity) {
        guard let data = surveys.data else { return }
        var newPages = [HomeViewController]()
        for survey in data {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            homeViewController.viewModel = viewModel
            homeViewController.pageViewController = self
            homeViewController.loadView()
            homeViewController.pageControl.numberOfPages = data.count
            homeViewController.reconfigureUI(survey)
            newPages.append(homeViewController)
        }
        pages = newPages
        setViewControllers([pages[0]], direction: .forward, animated: false)
    }
}

extension PageViewController {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! HomeViewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            return nil
        } else {
            return pages[previousIndex]
        }
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! HomeViewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        if nextIndex < pages.count {
            return pages[nextIndex]
        } else {
            return nil
        }
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first as? HomeViewController,
               let index = pages.firstIndex(of: currentViewController) {
                viewModel.currentSurveyIndex = index
                currentViewController.pageControl.currentPage = index
            }
        }
    }
}

extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
            }
        }
    }

    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let previousPage = dataSource?.pageViewController(self, viewControllerBefore: currentViewController){
                setViewControllers([previousPage], direction: .reverse, animated: true, completion: completion)
            }
        }
    }
}

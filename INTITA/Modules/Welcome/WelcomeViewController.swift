//
//  WelcomeViewController.swift
//  INTITA
//
//  Created by Svitlana Korostelova on 01.11.2020.
//

import UIKit
// перезалить картинку лого
// корнер радиус 10
class WelcomeViewController: UIViewController, Storyboarded, UIScrollViewDelegate {
    @IBOutlet weak var mottoLabel: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    var coordinator: WelcomeCoordinator?
    @IBOutlet weak var line: UIView!
    
    @IBOutlet weak var skipBtn: UIButton!
    private var scrollView = UIScrollView(frame: .zero)
    private var stackView = UIStackView(frame: .zero)
    var views:[UIView] = []
    private var pageControl = UIPageControl()
    
    let texts = ["promo1".localized,
                 "promo2".localized,
                 "promo3".localized,
                 "promo4".localized,
                 "promo5".localized,
                 "promo6".localized,
                 "promo7".localized,]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 10.0
        startBtn.setTitle("start".localized, for: .normal)
        startBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        startBtn.titleLabel?.textAlignment = .center
        startBtn.titleLabel?.font = UIFont.primaryFontRegular
        
        mottoLabel.text = "moto".localized
        mottoLabel.textAlignment = .center
        mottoLabel.adjustsFontSizeToFitWidth = true
        mottoLabel.font = UIFont.primaryFontRegular
        
        skipBtn.setTitle("skip".localized, for: .normal)
        skipBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        skipBtn.titleLabel?.font = UIFont.primaryFontThin
        skipBtn.titleLabel?.textAlignment = .left

        logo.layer.cornerRadius = 10.0
        setupPageControll()
        setupScrollView()
        setupStackView(scrollView: scrollView)
        views = createAndAddViews(to: stackView)
    }
    
    @IBAction func goToLogInBtn(_ sender: UIButton) {
        coordinator?.displayLogin()
    }
    func setupScrollView() {
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      scrollView.backgroundColor = .white
      scrollView.showsHorizontalScrollIndicator = false
      scrollView.isPagingEnabled = true
      scrollView.delegate = self
      
      self.view.addSubview(scrollView)
      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: self.line.bottomAnchor, constant: 32),
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
        scrollView.bottomAnchor.constraint(equalTo: self.pageControl.topAnchor, constant: -24)
        ])
    }

    func setupStackView(scrollView: UIScrollView) {
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.distribution = .equalSpacing
      stackView.spacing = 0

      scrollView.addSubview(stackView)
      NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    func createAndAddViews(to stackView: UIStackView) -> [UIView] {
      var views:[UIView] = []
        texts.forEach { (text) in
            let pageView = PromoTextView(promoText: text)
            views.append(pageView)
        }

      
      views.forEach { (view) in
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(view)
        view.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
      }
      return views
    }
    
    @objc func pageControlTapped(sender: UIPageControl) {
      let pageWidth = scrollView.bounds.width
      let offset = sender.currentPage * Int(pageWidth)
      UIView.animate(withDuration: 0.33, animations: { [weak self] in
        self?.scrollView.contentOffset.x = CGFloat(offset)
      })
    }
    
    func setupPageControll() {
//        pageControl.backgroundColor = .none
//        pageControl.pageIndicatorTintColor = .black
//        UIColor(named: "mainColor")
        pageControl.currentPageIndicatorTintColor = UIColor(named: "mainColor")
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
//        pageControl.subviews[0].subviews[0].subviews[0].layer.borderWidth = 5
        
//        let dot = UIImage()
//        dot.backgroundColor = .black
//        dot.layer.borderColor = UIColor.red.cgColor
//        dot.layer.borderWidth = 5
        
//        pageControl.subviews[0].subviews[0].insertSubview(dot, at: 0)
//        subviews[0].layer.borderColor = UIColor.red.cgColor
        
        pageControl.preferredIndicatorImage = UIImage(named: "dotPageControl")
        
        
        
//        print(dots)
//        pageControl.subviews.forEach { (view) in
////            print(view.subviews.count)
//            view.layer.borderWidth = 2
//            view.layer.borderColor = UIColor.green.cgColor
//            view.subviews[0].layer.borderWidth = 2
//            view.subviews[0].layer.borderColor = UIColor.red.cgColor
//            view.subviews[0].subviews[0].layer.borderWidth = 5
//            view.subviews[0].subviews[0].layer.borderColor = UIColor.blue.cgColor
//        }
//        pageControl.subviews[0].subviews[0].
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.startBtn.topAnchor, constant: -50).isActive = true
        pageControl.numberOfPages = texts.count
            //  if switch pages will be required by user click
//        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        
//        pageControl.setIndicatorImage(UIImage(named: "dotPageControl"), forPage: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let pageWidth = scrollView.bounds.width
      let pageFraction = scrollView.contentOffset.x/pageWidth
      let constantFraction = pageFraction
      
      pageControl.currentPage = Int((round(pageFraction)))
      
      for (index, view) in views.enumerated() {
        guard let view = view as? PromoTextView else { return }
        let constant = pageWidth * (CGFloat(index) - constantFraction)
        view.updateViewCenterXAnchor(with: constant)
      }
    }
}





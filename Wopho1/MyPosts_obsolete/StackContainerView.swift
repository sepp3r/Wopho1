//
//  StackContainerView.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 09.11.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit

protocol cardRespone {
    func respon()
}

protocol cardCheck {
    func fewCards()
}

protocol swipeIndex {
    func swipe()
}

class StackContainerView: UIView, SwipeCardDelegate {
    
    // kann evtl. gelöscht werden wenn func deleteTheFirstCard funktioniert
    func deleteView(by view: SwipeableView) {
        
    }
    
    
    // MARK: - var / let
    var swipeOutCard: Int = 0
    var swipeOutCardCounter: Int = 0
    var visibleShowCards: Int = 3
    static let cardsToBeVisible: Int = 3
    private var cardViews : [SwipeCardViewCard] = []
    fileprivate var remainingcards: Int = 0
    
//    private var currentCardIndex = 0
//    private var countOfCards = 0
    
    var delegate: SwipeCardViewDelegate?
    var responeDelegate: cardRespone?
    var fewCardsDelegate: cardCheck?
    var swiperDelegate: swipeIndex?
    
    static let horizontalInset: CGFloat = 10.0
    static let verticalInset: CGFloat = 10.0
    
    private var visibleCards: [SwipeCardViewCard] {
        return subviews as? [SwipeCardViewCard] ?? []
//        print("StackContainer #1")
    }
    
    var dataSource: SwipeCardDataSource? {
        didSet {
            reloadData()
//            print("StackContainer #2")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
//        print("StackContainer #3")
    }
    

    func reloadDataTest() {
//        print("StackContainer #4")
        print("reloadData-----------TEST--------------")
//        print("löschfälscher RELOADDATATEST")
        //removeAllCardView()
        guard let dataSource = dataSource else { return }
        let numberOfCards = dataSource.numberOfCardToShow()
        let cardsOfCount = dataSource.numberOfCardToShow()
        remainingcards = numberOfCards
        swipeOutCard = cardsOfCount
        layoutIfNeeded()
//        print("reloadDataTEst")
        
        for index in 0..<min(remainingcards, swipeOutCard) {
            addCardViewTest(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
        
        if let emptyView = dataSource.emptyView() {
            addSubview(emptyView)
        }
        
        setNeedsLayout()
    }
    
    // MARK: - Configuration
    private func setFrameTest(forCardView cardView: SwipeCardViewCard, atIndex index: Int) {
//        print("StackContainer #5")
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * StackContainerView.horizontalInset)
        let verticalInset = (CGFloat(index) * StackContainerView.verticalInset)
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardViewTest() {
//        print("StackContainer #6")
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
        
    }
    
    private func addCardViewTest(cardView: SwipeCardViewCard, atIndex index: Int) {
//        print("StackContainer #7")
        cardView.delegate = self
        setFrameTest(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 2)
        
        if remainingcards != 0 {
            remainingcards -= 1
        }
        
        swipeOutCard -= 1
    }
    
    private func addRefreshCardView(cardView: SwipeCardViewCard, atIndex index: Int) {
        print("out of Range research x.0")
        cardView.delegate = self
        print("out of Range research x.1")
        setFrameTest(forCardView: cardView, atIndex: index)
        print("out of Range research x.2")
        cardViews.append(cardView)
        print("out of Range research x.3")
        insertSubview(cardView, at: 2)
        print("out of Range research x.4")
    }
    
    private func deleteCardViewTest(cardView: SwipeCardViewCard, atIndex index: Int) {
//        print("StackContainer #8")
        cardView.delegate = self
        cardViews.remove(at: 0)
    }
    

    
    func reventAction() {
//        print("StackContainer #9")
//        print("löschfälscher REVENTACTION")
        guard let dataSource = dataSource else { return }
        if remainingcards > 0 {
            let newIndex = dataSource.numberOfCardToShow() - remainingcards
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func reloadData() {
//        print("StackContainer #10")
//        print("löschfälscher RELOADDATA")
//        print("reloadData-------------------------")
        removeAllCardView()
        guard let dataSource = dataSource else { return }
        let numberOfCards = dataSource.numberOfCardToShow()
        let cardsOfCount = dataSource.numberOfCardToShow()
        remainingcards = numberOfCards
        swipeOutCard = cardsOfCount
        
//        print("gehts bis dahin???")
//
//        print("remaining->_>_>_>_>_>teeeest\(remainingcards)")
        layoutIfNeeded()
        
        for index in 0..<min(numberOfCards, cardsOfCount, StackContainerView.cardsToBeVisible) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
        
        if let emptyView = dataSource.emptyView() {
            addSubview(emptyView)
        }
        // Karten manchmal doppelt lösch verlauf fehlerhaft -> 02.10.20
//        remainingcards += 1
//        swipeOutCard -= 1
        // Ende
        setNeedsLayout()
    }
    
    func refreshData() {
        guard let dataSource = dataSource else { return }
        layoutIfNeeded()
//        print("refresh test 1")
        
        print("How much visible Cards \(visibleCards.count)")
        
        switch visibleCards.count {
        case 2:
            let refreshSecond = visibleCards[1]
            refreshSecond.removeFromSuperview()
        case 1:
            let refreshTheLast = visibleCards[0]
            refreshTheLast.removeFromSuperview()
        default:
            let refreshTopCard = visibleCards[2]
            refreshTopCard.removeFromSuperview()
        }
        print("refresh test 2")
        let newIndex = dataSource.numberOfCardToShow() - swipeOutCard
        let equalNewIndex = newIndex - 1
        print("refresh test 2.3 === newIndex \(newIndex) &&& equalNewIndex \(equalNewIndex)")
//        addCardViewTest(cardView: dataSource.card(forItemAtIndex: equalNewIndex), atIndex: 0)
        addRefreshCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 0)
        print("refresh test 2.5")
        for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
            UIView.animate(withDuration: 0.2) {
                cardView.center = self.center
                self.setFrameTest(forCardView: cardView, atIndex: cardIndex)
                self.layoutIfNeeded()
            }
        }
        print("refresh test 3")
        if let emptyView = dataSource.emptyView() {
            addSubview(emptyView)
        }
        setNeedsLayout()
    }
    
    
    
    // MARK: - Configuration
    private func addCardView(cardView: SwipeCardViewCard, atIndex index: Int) {
//        print("StackContainer #11")
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        // if Anweisung, weil remainingcards ins minus geht
        if remainingcards != 0 {
            remainingcards -= 1
        }
        // TEST
        
        
//        remainingcards -= 1
        
        
//        print("test------- \(cardViews))")
    }
    
    private func setFrame(forCardView cardView: SwipeCardViewCard, atIndex index: Int) {
//        print("StackContainer #12")
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * StackContainerView.horizontalInset)
        let verticalInset = (CGFloat(index) * StackContainerView.verticalInset)
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardView() {
//        print("StackContainer #13")
        for cardView in visibleCards {
            cardView.removeFromSuperview()
            
        }
        cardViews = []
    }
    
    func removeAndMoveAllCards() {
//        print("StackContainer #4")
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    
    func didTap(view: SwipeableView) {
        if let cardView = view as? SwipeCardViewCard,
            let index = cardViews.index(of: cardView) {
            delegate?.didSelect(card: cardView, atIndex: index)
//            print("StackContainer #15")
        }
    }
    
    
    
    func swipeEnd(on view: SwipeableView) {
        print("StackContainer #16")
//        print("löschfälscher SWIPEEND")
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()
        
        if remainingcards == 0 {
            visibleShowCards -= 1
        }
//        print("remainingcards 1.0---\(remainingcards)")
        if remainingcards > 0 {
            swiper()
            print("StackContainer #16....1")
            let newIndex = datasource.numberOfCardToShow() - remainingcards
            addCardView(cardView: datasource.card(forItemAtIndex: newIndex), atIndex: 0)
            
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    //self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                }
            }
        } else {
            swiper()
            print("StackContainer #16....2222")
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                }
            }
        }
        
        swipeOutCardCounter += 1
        if swipeOutCard != 0 {
            swipeOutCard -= 1
        }
        responCheck()
//        print("responeCheck")
//        print(print("Swipe_swipeOutCard--\(swipeOutCard)"))
//        print(print("Swipe_swipeOutCardCounter--\(swipeOutCardCounter)"))
//        print(print("Swipe_visibleShowCard--s\(visibleShowCards)"))
//        print(print("Swipe_remainingcards--\(remainingcards)"))
//        print(print("Swipe_numberOfCard--\(datasource.numberOfCardToShow())"))

    }
    
    func backCard() {
//        print("StackContainer #17")
//        print("löschfälscher BACKCARD")
        guard let dataSource = dataSource else { return }
        layoutIfNeeded()
        
//        print("visibleShowCards \(visibleShowCards)")
//        print("swipeOutCardCounter \(swipeOutCardCounter)")
//        print("swipeOutCard \(swipeOutCard)")
//        print("remainingcards \(remainingcards)")
        
//        print("numberOfCards \(dataSource.numberOfCardToShow())")
        
//        print(print("back_1_swipeOutCard--\(swipeOutCard)"))
//        print(print("back_1_swipeOutCardCounter--\(swipeOutCardCounter)"))
//        print(print("back_1_visibleShowCards--\(visibleShowCards)"))
//        print(print("back_1_remainingcards--\(remainingcards)"))
//        print(print("back_1_numberOfCard--\(dataSource.numberOfCardToShow())"))
        
        if swipeOutCardCounter != 0 {
            visibleShowCards += 1
        }
        
        if visibleShowCards > 3 {
            remainingcards += 2
            visibleShowCards -= 1
            let removeLastCard = visibleCards[0]
            removeLastCard.removeFromSuperview()
        }
        
        if visibleCards.count == 15 {
            print("return section 11111")
            let newIndex = dataSource.numberOfCardToShow() - (swipeOutCardCounter - 1)
            addCardViewTest(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 0)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.setFrameTest(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                }
            }
        } else if swipeOutCardCounter != 0 {
            print("return section 22222")
            let newIndex = dataSource.numberOfCardToShow() - swipeOutCard
            let equalNewIndex = newIndex - 1
            print("refresh ECHT VERSION 2.3 === newIndex \(newIndex) &&& equalNewIndex \(equalNewIndex)")
            addCardViewTest(cardView: dataSource.card(forItemAtIndex: equalNewIndex), atIndex: 0)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.setFrameTest(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                }
            }
            swipeOutCard += 2
            swipeOutCardCounter -= 1
        }
        if let emptyView = dataSource.emptyView() {
            addSubview(emptyView)
        }
        setNeedsLayout()
    }
    
    func responCheck() {
        responeDelegate?.respon()
//        print("in der Funktion ob Rückmeldung entsteht")
    }
    
    func fewCardsCheck() {
        fewCardsDelegate?.fewCards()
    }
    
    func swiper() {
        swiperDelegate?.swipe()
    }
    
    
    
    // test f. Remove one Card
    func deleteTheFirstCard() {
        print("StackContainer #18")
        guard let dataSource = dataSource else { return }
        
//        print(print("Del_1_swipeOutCard--\(swipeOutCard)"))
//        print(print("Del_1_swipeOutCardCounter--\(swipeOutCardCounter)"))
//        print(print("Del_1_visibleShowCards--\(visibleShowCards)"))
//        print(print("Del_1_remainingcards--\(remainingcards)"))
//        print(print("Del_1_numberOfCard--\(dataSource.numberOfCardToShow())"))
        print("11111deleteCardCount -- \(visibleCards.count)")
        
        switch visibleCards.count {
        case 2:
            let deleteACard = visibleCards[1]
            deleteACard.removeFromSuperview()
        case 1:
            let deleteTheLastCard = visibleCards[0]
            deleteTheLastCard.removeFromSuperview()
        default:
            let deleteFirstCard = visibleCards[2]
            deleteFirstCard.removeFromSuperview()
        }
//        let deleteFirstCard = visibleCards[2]
//        deleteFirstCard.removeFromSuperview()
        
        print("22222deleteCardCount -- \(visibleCards.count)")
        
        
        
//        if remainingcards == 0 {
//            visibleShowCards -= 1
//        }
        
//        visibleShowCards -= 1
//        swipeOutCardCounter -= 1
//        swipeOutCard -= 1
        
        
        if remainingcards > 0 {
            print("StackContainer #18----if")
            let newIndex = dataSource.numberOfCardToShow() - remainingcards
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 0)
            
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                    print("18 -- If -- Ending")
                }
            }
        } else {
            print("StackContainer #18----else")
            fewCardsCheck()
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                }
            }
        }
        
//        swipeOutCardCounter += 1
//        if swipeOutCard != 0 {
//            swipeOutCard -= 1
//        }
//        remainingcards += 1
        print("respon at StackContainer")
        responCheck()
        swipeOutCard -= 1
//        print("==========findet das bei der Löschung in Stack zustande ---!!")
        
//        print(print("Del_2_swipeOutCard--\(swipeOutCard)"))
//        print(print("Del_2_swipeOutCardCounter--\(swipeOutCardCounter)"))
//        print(print("Del_2_visibleShowCards--\(visibleShowCards)"))
//        print(print("Del_2_remainingcards--\(remainingcards)"))
//        print(print("Del_2_numberOfCard--\(dataSource.numberOfCardToShow())"))
        
    }
    
}

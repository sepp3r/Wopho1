//
//  StackContainerPost.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 27.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

protocol likeAndUnlikeDelegate {
    func likeAndUnlike()
}

protocol comparisonID {
    func compareID()
}

class StackContainerPost: UIView, PostCardDelegate {
    
    // MARK: - var / let
    var swipeOutCard: Int = 0
    var swipeOutCardCounter: Int = 0
    var visibleShowCards: Int = 3
   
    // var´s evtl. nicht erforderlich
    var swipeOutCardLast: Int = 1
    var swipeOutCardTheFirst: Int = 1
    var resultCard: Int = 0
    // Ende
    
    // TEST VAR 1x
    private var storageLastCard: [ SwipePostViewCard] = []
    //
    
    static let cardsToBeVisible: Int = 3
    
    
    private var cardViews: [SwipePostViewCard] = []
    
    
    // neue variable
//    fileprivate var loadedCards = [SwipePostViewCard]()
//    fileprivate var currentCard : SwipePostViewCard!
    // Ende
    fileprivate var remainingcards: Int = 0
    
    var delegate: PostCardViewDelegate?
    
    // test
    var likeDelegate: likeAndUnlikeDelegate?
    var compareIdDelegate: comparisonID?
    // ende
    
    static let horizontaleInset: CGFloat = 9.0
    static let verticalInset: CGFloat = 9.0
    
//    // TEST
//    var visibleCards: [SwipePostViewCard] {
//        return subviews as? [SwipePostViewCard] ?? []
//    }
    
//    ECHT VERSION
    private var visibleCards: [SwipePostViewCard] {
        return subviews as? [SwipePostViewCard] ?? []
    }
    
    var dataSource: PostCardDataSource? {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
//    // MARK: - functions
//    func reloadDataTwoTest() {
//        UIView.animate(withDuration: 0.5, animations: {
//            self.alpha = 0
//        }) { (_) in
//            self.removeFromSuperview()
//        }
//    }
    
    func reloadDataTest() {
//        removeAllCardViewTest()
        guard let dataSource = dataSource else { return }
        let numberOfCards = dataSource.numberOfCardToShow()
        let cardsOfCount = dataSource.numberOfCardToShow()
        // evtl. nicht sicher
        remainingcards = numberOfCards
        swipeOutCard = cardsOfCount
        // ende
        layoutIfNeeded()
        
        for index in 0..<min(remainingcards, swipeOutCard) {
            addCardViewTest(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
        
        if let emptyView = dataSource.emptyView() {
            addSubview(emptyView)
        }
        
        setNeedsLayout()
        print("nach jeden swipe")
    }
    
    private func addCardViewTest(cardView: SwipePostViewCard, atIndex index: Int) {
//        let cardResult = (swipeOutCard) -= (remainingcards + StackContainerPost.cardsToBeVisible)
        cardView.delegate = self
        
//        cardViews.insert(cardView, at: cardViews.startIndex)
        setFrameTest(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 2)
        
//        print("addCardViewTest------------------------1111")
        
        // if Anweisung, weil remainingcards ins minus geht
        if remainingcards != 0 {
            remainingcards -= 1
        }
        
        // test für swipeOutCard bei 0 visibleCards
        swipeOutCard -= 1
//        if swipeOutCard != 0 {
//            swipeOutCard -= 1
//        }
        
        // ENDE des TESTS
        
        // TEST
//        remainingcards -= 1
    }
    
    private func deleteCardViewTest(cardView: SwipePostViewCard, atIndex index: Int) {
        cardView.delegate = self
//        cardView.removeFromSuperview()
        cardViews.remove(at: 0)
        
    }
    
    func deleteTheFirst(cardView: SwipePostViewCard, atIndex index: Int) {
        cardView.delegate = self
        cardViews.remove(at: 0)
    }
    
    private func setFrameTest(forCardView cardView: SwipePostViewCard, atIndex index: Int) {
        var cardViewFrame = bounds
        let horizontaleInset = (CGFloat(index) * StackContainerPost.horizontaleInset)
        let verticalInset = (CGFloat(index) * StackContainerPost.verticalInset)
        
        cardViewFrame.size.width -= 2 * horizontaleInset
        cardViewFrame.origin.x += horizontaleInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
//        print("------FRAME--1.0--- \(cardView.frame)")
//        print("set Frame TEST ------11111")
    }
    
    private func removeAllCardViewTest() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    
    func reloadData() {
//        print("------FRAME--XXXXX.0--- reload data")
        print("visible Cards __Back_OutCard_XXX X.o \(swipeOutCardCounter)")
        print("visible Cards _-X____ Reload Data----\(visibleShowCards)")
        
        // Wichtige funktion kann zu fehler führen, swipeOutCardCounter geht nicht auf null nach unwind
        swipeOutCardCounter = 0
        if visibleShowCards != 3 {
            
        }
        // ENDD
        
        removeAllCardView()
//        print("------FRAME--XXXXX.1--- reload data")
        guard let dataSource = dataSource else { return }
        
        print("visible Cards _-XStartX_swipeOutCardCounter >>> \(swipeOutCardCounter)")
        print("visible Cards _-XStartX_swipeOutCard>>> \(swipeOutCard)")
        print("visible Cards _-XStartX_DataSource >>> \(dataSource.numberOfCardToShow())")
        
        let numberOfCards = dataSource.numberOfCardToShow()
        let cardsOfCount = dataSource.numberOfCardToShow()
        remainingcards = numberOfCards
        swipeOutCard = cardsOfCount
        layoutIfNeeded()
//        print("------FRAME--XXXXX.2--- reload data \(numberOfCards)")
        for index in 0..<min(numberOfCards, cardsOfCount, StackContainerPost.cardsToBeVisible) {
            
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
//            print("------FRAME--XXXXX.3--- reload data")
        }
        
        if let emptyView = dataSource.emptyView() {
            addSubview(emptyView)
        }
        
        setNeedsLayout()
//        print("visible Cards __DataSource >>> XX1.o \(dataSource.numberOfCardToShow())")
//        print("swipeOutCard->\(swipeOutCard)")
        
        print("visible Cards _-XEndeX_swipeOutCardCounter >>> \(swipeOutCardCounter)")
        print("visible Cards _-XEndeX_swipeOutCard>>> \(swipeOutCard)")
        print("visible Cards _-XEndeX_DataSource >>> \(dataSource.numberOfCardToShow())")
    }
    
    private func addCardView(cardView: SwipePostViewCard, atIndex index: Int) {
//        print("------FRAME--2.ooo--- \(cardView.frame)")
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        // if Anweisung, weil remainingcards ins minus geht
        if remainingcards != 0 {
            remainingcards -= 1
        }
        // TEST
        
//        if swipeOutCard != 0 {
//            swipeOutCard -= 1
//        }
        
//        remainingcards -= 1
//        print("addCardView")
    }
    
    private func setFrame(forCardView cardView: SwipePostViewCard, atIndex index: Int) {
        var cardViewFrame = bounds
//        print("cardViewFrame !!!!!!!!\(cardViewFrame)")
        let horizontaleInset = (CGFloat(index) * StackContainerPost.horizontaleInset)
        let verticalInset = (CGFloat(index) * StackContainerPost.verticalInset)
        
//        print("frames 1.5 x \(cardView.frame)")
        
        cardViewFrame.size.width -= 3 * horizontaleInset
        cardViewFrame.origin.x += horizontaleInset
        cardViewFrame.origin.y += verticalInset
        
//        print("frames 2.0 x \(cardView.frame)")
        
        
        cardView.frame = cardViewFrame
//        print("------FRAME--2.0--- \(cardView.frame)")
//        print("setFrame Func----1111")
    }
    
    private func removeAllCardView() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    
    
    
    func didTap(view: PostableView) {
        if let cardView = view as? SwipePostViewCard, let index = cardViews.index(of: cardView) {
            delegate?.didSelect(card: cardView, atIndex: index)
        }
    }
    
    func swipeEnd(on view: PostableView) {
//        print("---^^^Bist du die Kartenanzeige-1 \(cardViews.count)")
        guard let dataSource = dataSource else { return }
        view.removeFromSuperview()
        if remainingcards == 0 {
            visibleShowCards -= 1
        }
        
        if remainingcards > 0 {
            let newIndex = dataSource.numberOfCardToShow() - remainingcards
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 0)
            
            // TEST 1.0
//            if swipeOutCardLast < 2 {
//                swipeOutCardTheFirst += 1
//                swipeOutCard += 1
////                print("swipeOutCardLast", "\(swipeOutCardLast)")
//            } else {
//                swipeOutCardLast += 1
//                swipeOutCard += 1
//            }
//            // TEST 1.0
            
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
//                    print("setFrame 1.0 ---")
                }
                
            }
//            print("addCardView-----")
        } else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
//                    print("setFrame 2.0 ---")
                }
            }
            
//            print("ohne----addCardView")
                    // TEST 1.0
//            if swipeOutCardLast < 2 && swipeOutCardTheFirst == 0{
//                swipeOutCardTheFirst += 1
//                swipeOutCard += 1
////                           print("swipeOutCardLast", "\(swipeOutCardLast)")
////                        print("swipeOutCardTheFirst", "\(swipeOutCardTheFirst)")
//            } else {
//                swipeOutCardLast += 1
//                swipeOutCard += 1
////                        print("swipeOutCardLast---else", "\(swipeOutCardLast)")
//
//            }
                       // TEST 1.0
        }
//        print("swipeOutCardLast", "\(swipeOutCardLast)")
//        print("swipeOutCardTheFirst", "\(swipeOutCardTheFirst)")
//        print("-TEST-remaining---\(remainingcards)")
//        print("visible Cards __Back_OutCard_XXX 1.o \(swipeOutCardCounter)")
        swipeOutCardCounter += 1
        if swipeOutCard != 0 {
            swipeOutCard -= 1
        }
//        likeAndUnlikeSetting()
        compareIdCheck()
//        print("visible Cards __swipeOutCard>>>2.o \(swipeOutCard)")
//        print("visible Cards __DataSource >>> XX2.o \(dataSource.numberOfCardToShow())")
        
        print("visible Cards _-XSwipeEndeX_swipeOutCardCounter >>> \(swipeOutCardCounter)")
        print("visible Cards _-XSwipeEndeX_swipeOutCard>>> \(swipeOutCard)")
        print("visible Cards __XSwipeEndeX_DataSource >>> \(dataSource.numberOfCardToShow())")
        print("visible Cards _-X___ SwipeEnd \(visibleShowCards)")
    }
    
    func likeAndUnlikeSetting() {
        likeDelegate?.likeAndUnlike()
    }
    
    func compareIdCheck() {
        compareIdDelegate?.compareID()
        print("compareID CHECK --- JETZT")
    }
    
    
    func backCard() {
//        compareIdCheck()
        // test f. visibleCards bzw. Index 4 löschen f. 03.04.20
        guard let dataSource = dataSource else { return }
        // Karte muss gezählt werden bevor die Index Abfragung bzw. Löschung kommt
        
        print("visible Cards __DataSource >>> \(dataSource.numberOfCardToShow())")

        layoutIfNeeded()
        
//        if visibleCards.count == 0 {
//
//            let newIndex = dataSource.numberOfCardToShow()
//
//            addCardViewTest(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 0)
//            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
//                UIView.animate(withDuration: 0.2) {
//                    cardView.center = self.center
//                    self.setFrameTest(forCardView: cardView, atIndex: cardIndex)
//                    self.layoutIfNeeded()
//                }
//            }
//
//
//        } else if swipeOutCardCounter != 0 {
//            let newIndex = dataSource.numberOfCardToShow() - swipeOutCard
//            let equalNewIndex = newIndex - 1
//
//            // atIndex <- evtl. wieder auf Wert 0 (int) setzen
//
//            // Test ->> atIndex: numbersOfCards geändert auf 0
//            addCardViewTest(cardView: dataSource.card(forItemAtIndex: equalNewIndex), atIndex: 0)
//            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
//                UIView.animate(withDuration: 0.2) {
//                    cardView.center = self.center
//                    self.setFrameTest(forCardView: cardView, atIndex: cardIndex)
//                    self.layoutIfNeeded()
//                }
//            }
//            swipeOutCard += 2
//            swipeOutCardCounter -= 1
//
//            visibleShowCards += 1
//
//                    if visibleShowCards >= 3 {
//                        remainingcards += 2
//                        visibleShowCards -= 1
//                        let removeLastCard = visibleCards[0]
//            //            remainingcards  = removeLastCard
//            //            print("1----CardViews\(dataSource.card(forItemAtIndex: <#T##Int#>))")
//            //            var storageLastCard = visibleCards[0]
//
//                        print("2------removeLastCard\(visibleCards[0])")
//
//                        // test for loop -> gelöschte Karte wird nicht mehr geladen -> läuft auf fehler lädt alles nochmal und fügt es an -> letztes, gelöschtes Array laden
//            //            insertSubview(test, at: 0)
//                        print("11111--CardViews\(cardViews.count)")
//
//                        removeLastCard.removeFromSuperview()
//            //            cardViews.append(test)
//            //            insertSubview(test, at: 0)
//            //            setFrame(forCardView: test, atIndex: 0)
//
//
//
//                        // muss nur den Index hinzugefügt werden----------<
//                        print("22222--CardViews\(cardViews.count)")
//
//                        print("remainingcards ---- 1 backCard \(remainingcards)")
//
//                    }
//        }
        
        // test für o.g. else if swipeOutCardCounter != 0
        print("visible Cards __Back_OutCard_ \(swipeOutCardCounter)")
        if swipeOutCardCounter != 0 {
            visibleShowCards += 1
        }
        
        print("visible Cards _-X___ removeLastCard \(visibleShowCards)")
        if visibleShowCards > 3 {
            print("visible Cards _-X___ removeLastCard")
            remainingcards += 2
            visibleShowCards -= 1
            let removeLastCard = visibleCards[0]
            removeLastCard.removeFromSuperview()
        }
        
        // if Anweisung mit visibleCards.count == 15 löschen wenn alles sauber verläuft, allerdings else if behalten
        if visibleCards.count == 15 {
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
            let newIndex = dataSource.numberOfCardToShow() - swipeOutCard
            let equalNewIndex = newIndex - 1
            
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
        
        print("visible Cards __swipeOutCard>>> \(swipeOutCard)")
        print("visible Cards __Back_OutCard_ 2.o>>> \(swipeOutCardCounter)")

        // einfach funktionierente Version
//        if swipeOutCardCounter != 0 {
//            // let numbersOfCards -> Auswirkung von atIndex: 0
////            let numbersOfCards = dataSource.numberOfCardToShow()
//            let newIndex = dataSource.numberOfCardToShow() - swipeOutCard
//            let equalNewIndex = newIndex - 1
//
//            // atIndex <- evtl. wieder auf Wert 0 (int) setzen
//
//            // Test ->> atIndex: numbersOfCards geändert auf 0
//            addCardViewTest(cardView: dataSource.card(forItemAtIndex: equalNewIndex), atIndex: 0)
//            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
//                UIView.animate(withDuration: 0.2) {
//                    cardView.center = self.center
//                    self.setFrameTest(forCardView: cardView, atIndex: cardIndex)
//                    self.layoutIfNeeded()
//                }
//            }
//            swipeOutCard += 2
//            swipeOutCardCounter -= 1
//
////            visibleShowCards += 1
//            print("visibleShowCards.count 1.66---->>>\(visibleShowCards)")
//
////            if visibleShowCards > 3 {
////                remainingcards += 2
////                visibleShowCards -= 1
////                let removeLastCard = visibleCards[0]
////                removeLastCard.removeFromSuperview()
////                print("geht das WAS!!!")
////            }
//
////                    if visibleShowCards >= 3 {
////                        remainingcards += 2
////                        visibleShowCards -= 1
////                        let removeLastCard = visibleCards[0]
////            //            remainingcards  = removeLastCard
////            //            print("1----CardViews\(dataSource.card(forItemAtIndex: <#T##Int#>))")
////            //            var storageLastCard = visibleCards[0]
////
////
////                        // test for loop -> gelöschte Karte wird nicht mehr geladen -> läuft auf fehler lädt alles nochmal und fügt es an -> letztes, gelöschtes Array laden
////            //            insertSubview(test, at: 0)
////
////                        removeLastCard.removeFromSuperview()
////            //            cardViews.append(test)
////            //            insertSubview(test, at: 0)
////            //            setFrame(forCardView: test, atIndex: 0)
////
////
////
////                        // muss nur den Index hinzugefügt werden----------<
////
////                    }
//
//            print("visibleShowCards.count 1.75---->>>\(visibleShowCards)")
//        }
        if let emptyView = dataSource.emptyView() {
            addSubview(emptyView)
        }
        setNeedsLayout()
//        compareIdCheck()
//        likeAndUnlikeSetting()
        
        print("visible Cards _-XBackX_swipeOutCardCounter >>> \(swipeOutCardCounter)")
        print("visible Cards _-XBackX_swipeOutCard>>> \(swipeOutCard)")
        print("visible Cards _-XBackX_DataSource >>> \(dataSource.numberOfCardToShow())")
    }
    
//    func backCard() {
//        guard let dataSource = dataSource else { return }
//        layoutIfNeeded()
//
//        print("-TEST-1-remaining---\(remainingcards)")
//
//        if swipeOutCardLast + swipeOutCardTheFirst == dataSource.numberOfCardToShow() {
//
//            let newIndexOne = dataSource.numberOfCardToShow() - swipeOutCardLast
//
//            addCardView(cardView: dataSource.card(forItemAtIndex: newIndexOne), atIndex: 0)
//
//            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
//                UIView.animate(withDuration: 0.2) {
//                    cardView.center = self.center
//                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
//                    self.layoutIfNeeded()
//                }
//
//                print("V1_\(swipeOutCardLast)")
//                print("V1_\(swipeOutCardTheFirst)")
//                print("V1_\(dataSource.numberOfCardToShow())")
//                print("backCard----1--\(newIndexOne)")
//                print("Version_1")
//            }
//        } else if remainingcards == 0 {
//
//            let newIndexFour = dataSource.numberOfCardToShow() - swipeOutCard
//
//            addCardView(cardView: dataSource.card(forItemAtIndex: newIndexFour), atIndex: 0)
//
//            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
//                UIView.animate(withDuration: 0.2) {
//                    cardView.center = self.center
//                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
//                    self.layoutIfNeeded()
//                }
//                print("backCard----4--\(newIndexFour)")
//                print("Version_2")
//            }
//
//        } else {
//            let newIndexTwo = dataSource.numberOfCardToShow() - (StackContainerPost.cardsToBeVisible + remainingcards)
//            let newIndexThree = dataSource.numberOfCardToShow() - newIndexTwo
//
//            addCardView(cardView: dataSource.card(forItemAtIndex: newIndexThree), atIndex: 0)
//
//            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
//                UIView.animate(withDuration: 0.2) {
//                    cardView.center = self.center
//                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
//                    self.layoutIfNeeded()
//                }
//                print("backCard----4--\(newIndexThree)")
//                print("Version_3")
//            }
//        }
//
//        if let emptyView = dataSource.emptyView() {
//            addSubview(emptyView)
//        }
//
//        if swipeOutCard < 2 && swipeOutCardTheFirst == 2 {
//            swipeOutCardTheFirst -= 1
//        } else if swipeOutCard > 1 {
//            swipeOutCard -= 1
//        }
//
//        swipeOutCard -= 1
//        setNeedsLayout()
//    }
    
    func swipeBack(on view: PostableView) {
    }
    
    func reventAction() {
        guard let dataSource = dataSource else { return }
        if remainingcards > 0 {
            let newIndex = dataSource.numberOfCardToShow() - remainingcards
            addCardViewTest(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.setFrameTest(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    
}

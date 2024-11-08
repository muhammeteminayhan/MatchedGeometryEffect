//
//  ContentView.swift
//  MatchedGeometryEffect
//
//  Created by Muhammet Emin Ayhan on 8.11.2024.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
    let imageName: String
    let fullText: String
}

extension Color {
    static func random() -> Color {
        return Color(
            red:     .random(in: 0.3...1),
            green:   .random(in: 0.3...1),
            blue:    .random(in: 0.3...1)
        )
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            ExpandableCardListView()
        }
    }
}

struct ExpandableCardListView: View {
    @Namespace private var animationNamespace
    @State private var selectedCardID: UUID?
    private let cards: [Card] = (1...20).map { index in
        Card(
            color: .random(),
            title: "Title \(index)",
            imageName: "\(index % 5)",
            fullText: "This is the detailed description for card number \(index). Here you can add more information about the card"
        )
    }
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(cards){ card in
                    if selectedCardID == card.id {
                        ExpandedCardView(card: card, animation: animationNamespace) {
                            toggleExpansion(of: nil)
                        }
                    } else {
                        CollapsedCardView(card: card, animation: animationNamespace) {
                            toggleExpansion(of: card.id)
                        }
                    }
                    
                }
            }
            .padding()
        }
        .animation(.spring, value: selectedCardID)
    }
    private func toggleExpansion(of cardID: UUID?) {
        selectedCardID = cardID
    }
}

struct ExpandedCardView: View {
    let card: Card
    let animation: Namespace.ID
    let onTap: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                    .matchedGeometryEffect(id: "image\(card.id)", in: animation)
                
                Button {
                    onTap()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                }

            }
            Text(card.title)
                .font(.title)
                .bold()
                .foregroundColor(.black)
                .padding(.horizontal)
                .matchedGeometryEffect(id: "title\(card.id)", in: animation)
            Text(card.fullText)
                .font(.body)
                .foregroundColor(.black)
                .padding([.horizontal, .bottom])
                .matchedGeometryEffect(id: "text\(card.id)", in: animation)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(card.color)
                .matchedGeometryEffect(id: "background\(card.id)", in: animation)
        )
        .onTapGesture {
            
        }
        .padding(.horizontal)
    }
}

struct CollapsedCardView: View {
    let card: Card
    let animation: Namespace.ID
    let onTap: () -> Void
    var body: some View {
        HStack(spacing: 15) {
            Image(card.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(10)
                .matchedGeometryEffect(id: "image\(card.id)", in: animation)
            Text("\(card.title)...")
                .font(.headline)
                .foregroundColor(.white)
                .matchedGeometryEffect(id: "title\(card.id)", in: animation)
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(card.color)
                .matchedGeometryEffect(id: "background\(card.id)", in: animation)
        )
        .onTapGesture {
            onTap()
        }
        .padding([.horizontal])
    }
}

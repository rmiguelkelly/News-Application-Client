//
//  TopicChooser.swift
//  NewsApp
//
//  Created by Ronan Kelly on 6/13/21.
//

import SwiftUI

struct TopicChooser: View {
    
    @Binding var chosenTopic:Topic
    
    let onChosen:((Topic) -> Void)
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            ScrollViewReader { reader in
                HStack {
                    ForEach(Topic.allCases, id: \.self, content: { topic in
                        renderTopic(topic)
                            .onTapGesture {
                                chosenTopic = topic
                                onChosen(topic)
                            }
                            .id(topic)
                    })
                }
            }
        })
    }
    
    private func renderTopic(_ topic:Topic) -> some View {
        Text(topic.rawValue.capitalized(with: .current))
            .bold()
            .font(.system(size: 14))
            .foregroundColor(.white)
            .padding(2)
            .padding(.horizontal, 10)
            .background(Color(Theme.primary).opacity(topic == chosenTopic ? 1.0 : 0.5))
            .clipShape(Capsule())
    }
}

struct TopicChooser_Previews: PreviewProvider {
    static var previews: some View {
        TopicChooser(chosenTopic: .constant(.entertainment), onChosen: { _ in })
    }
}

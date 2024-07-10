//
//  ContentView.swift
//  UNMe
//
//  Created by BongjinLee on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPreference: String = "선호"
    
    let GoOutList = [
        "영화관", "노래방", "식물원", "미술관",
        "커피숍", "도서관", "놀이공원", "박물관", "수족관",
        "쇼핑몰", "공원", "스파", "수영장", "산책로",
        "요가 센터", "피트니스 센터", "레스토랑", "바",
        "동물원", "바다", "산", "테마파크", "극장",
        "전통시장", "플라워샵"
    ]
    
    var body: some View {
        VStack {
            // 상단 1/3 지점에 3개의 칸 배치
            HStack(spacing: 16) {
                PreferenceView(title: "선호", isSelected: selectedPreference == "선호")
                    .onTapGesture {
                        selectedPreference = "선호"
                    }
                PreferenceView(title: "보통", isSelected: selectedPreference == "보통")
                    .onTapGesture {
                        selectedPreference = "보통"
                    }
                PreferenceView(title: "불호", isSelected: selectedPreference == "불호")
                    .onTapGesture {
                        selectedPreference = "불호"
                    }
            }
            .frame(height: UIScreen.main.bounds.height / 3)
            .padding()
            
            // 나머지 2/3 지점에 GoOutList 표시
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    // Custom layout
                    FlowLayout(items: GoOutList, itemSpacing: 8, lineSpacing: 8)
                }
                .padding()
            }
        }
    }
}

struct PreferenceView: View {
    var title: String
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(.top)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.blue : Color.gray)
        .border(Color.black, width: 1)
    }
}

struct FlowLayout: View {
    var items: [String]
    var itemSpacing: CGFloat
    var lineSpacing: CGFloat
    
    var body: some View {
        var totalWidth = CGFloat.zero
        var totalHeight = CGFloat.zero
        
        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(8)
                        .alignmentGuide(.leading) { d in
                            if (abs(totalWidth - d.width) > geometry.size.width) {
                                totalWidth = 0
                                totalHeight -= d.height + lineSpacing
                            }
                            let result = totalWidth
                            if item == items.last! {
                                totalWidth = 0 // last item
                            } else {
                                totalWidth -= d.width + itemSpacing
                            }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = totalHeight
                            if item == items.last! {
                                totalHeight = 0 // last item
                            }
                            return result
                        }
                }
            }
        }
        .frame(height: totalHeight * -1) // ZStack is upside down
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



#Preview {
    ContentView()
}

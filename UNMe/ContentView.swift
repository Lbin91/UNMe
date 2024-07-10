//
//  ContentView.swift
//  UNMe
//
//  Created by BongjinLee on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPreference: String = "선호"
    @State private var preferenceItems: [String: [String]] = [
        "선호": [],
        "보통": [],
        "불호": []
    ]
    
    @State private var GoOutList = [
        "영화관", "노래방", "식물원", "미술관",
        "커피숍", "도서관", "놀이공원", "박물관", "수족관",
        "쇼핑몰", "공원", "스파", "수영장", "산책로",
        "요가 센터", "피트니스 센터", "레스토랑", "바",
        "동물원", "바다", "산", "테마파크", "극장",
        "전통시장", "플라워샵"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 상단 1/3 지점에 3개의 칸 배치
                HStack(spacing: 16) {
                    PreferenceView(
                        title: "선호",
                        isSelected: selectedPreference == "선호",
                        items: preferenceItems["선호"] ?? [],
                        fullWidth: selectedPreference == "선호" ? geometry.size.width * 0.5 : geometry.size.width * 0.25
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedPreference = "선호"
                        }
                    }
                    PreferenceView(
                        title: "보통",
                        isSelected: selectedPreference == "보통",
                        items: preferenceItems["보통"] ?? [],
                        fullWidth: selectedPreference == "보통" ? geometry.size.width * 0.5 : geometry.size.width * 0.25
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedPreference = "보통"
                        }
                    }
                    PreferenceView(
                        title: "불호",
                        isSelected: selectedPreference == "불호",
                        items: preferenceItems["불호"] ?? [],
                        fullWidth: selectedPreference == "불호" ? geometry.size.width * 0.5 : geometry.size.width * 0.25
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedPreference = "불호"
                        }
                    }
                }
                .frame(height: geometry.size.height / 3)
                .padding(.horizontal, 16)
                .padding(.top)
                
                // 나머지 2/3 지점에 GoOutList 표시
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        FlowLayout(items: GoOutList, itemSpacing: 8, lineSpacing: 8) { item in
                            withAnimation {
                                if let index = GoOutList.firstIndex(of: item) {
                                    GoOutList.remove(at: index)
                                    preferenceItems[selectedPreference]?.append(item)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct PreferenceView: View {
    var title: String
    var isSelected: Bool
    var items: [String]
    var fullWidth: CGFloat
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(.top)
            
            FlowLayoutSmall(items: items, itemSpacing: 4, lineSpacing: 4, font: isSelected ? .caption : .footnote)
                .padding(.top, 8)
            
            Spacer()
        }
        .frame(width: fullWidth, height: .infinity) // 수정된 부분
        .background(isSelected ? Color.blue : Color.gray)
        .cornerRadius(10)
        .border(Color.black, width: 1)
    }
}

struct FlowLayout: View {
    var items: [String]
    var itemSpacing: CGFloat
    var lineSpacing: CGFloat
    var onItemTap: (String) -> Void
    
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
                        .onTapGesture {
                            onItemTap(item)
                        }
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

struct FlowLayoutSmall: View {
    var items: [String]
    var itemSpacing: CGFloat
    var lineSpacing: CGFloat
    var font: Font
    
    var body: some View {
        var totalWidth = CGFloat.zero
        var totalHeight = CGFloat.zero
        
        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(font) // 작은 폰트 크기 설정
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.3))
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

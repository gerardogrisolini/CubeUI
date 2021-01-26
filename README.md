# ZenUI

### Getting Started

#### Adding a dependencies clause to your Package.swift

```
dependencies: [
    .package(url: "https://github.com/gerardogrisolini/ZenUI.git", from: "1.2.5")
]
```

#### Example ZenNavigationView

```
import SwiftUI
import ZenUI

struct ContentView: View {    
    var body: some View {
        ZenNavigationView(transitionType: .default) {
            HomePage()
        }
    }
}

struct HomePage: View {
    var body: some View {
        VStack {
            PushView(destination: DetailPage()) {
                Text("DetailPage")
            }
        }
        .navigationToolbar(title: "Home", backButton: false, closeButton: false)
    }
}

struct DetailPage: View {
    @Environment(\.router) var router

    var body: some View {
        VStack {
            Button("InfoPage") {
                router.setCheckpoint(withId: "detail")
                router.push(content: InfoPage())
            }
        }
        .navigationToolbar(title: "Detail", closeButton: false)
    }
}

struct InfoPage: View {
    @Environment(\.router) var router

    var body: some View {
        VStack {
            PopView {
                Text("Back")
            }
            Button("Checkpoint") {
                router.popToCheckpoint()
            }
        }
        .navigationToolbar(title: "Info")
    }
}
```

#### Example ZenCubeView

```
import SwiftUI
import ZenUI

struct ContentView: View {
    @State private var index: Int = 0
    
    var body: some View {
    
        ZenCubeView(index: $index, mode: .drag) {
        
            SideView(number: 1, color: .blue)
            SideView(number: 2, color: .orange)
            SideView(number: 3, color: .green)
            SideView(number: 4, color: .yellow)
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { index = 0 }) {
                    Image(systemName: "line.horizontal.3")
                }
            }
        }
    }
}

struct SideView: View {
    var number: Int
    var color: Color
    
    var body: some View {
        Text("Content \(number)")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
    }
}
```

#### Example ZenScrollView

```
import SwiftUI
import ZenUI

struct ScrollScreen: View {
    @Environment(\.router) var router

    @State private var index: Int = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var isRefreshing: Bool = false
    @State private var data: [Int] = []

    var body: some View {
        ZenScrollView(offset: $scrollOffset) {
            ZenRefreshView(scrollOffset: $scrollOffset, isRefreshing: $isRefreshing, onRefreshing: refresh, refreshOffset: 200) {
        
                LazyVStack(alignment: .leading, spacing: 1) {
                    ForEach(data, id: \.self) { value in
                        Text(value.description)
                            .frame(maxWidth: .infinity)
                            .font(.title3)
                            .padding()
                    }
                }
            }
        }
        .navigationToolbar(title: "Scroll \(Int(scrollOffset))", offset: scrollOffset)
        .onAppear {
            refresh()
        }
    }
    
    private func refresh() {
        isRefreshing = true
        data.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            data.append(contentsOf: 0...30)
            isRefreshing = false
        }
    }
}
```

#### Example ZenSidebarView

```
import SwiftUI
import ZenUI

struct SidebarPage: View {
    @State private var show = false

    var body: some View {
        ZenSidebarView(width: 200, show: $show) {
            // Sidebar content here
        } content: {
            // Main content here
        }
    }
}
```

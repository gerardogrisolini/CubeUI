# ZenUI

### Getting Started

#### Adding a dependencies clause to your Package.swift

```
dependencies: [
    .package(url: "https://github.com/gerardogrisolini/ZenUI.git", from: "1.2.3")
]
```

#### Example ZenNavigationView

```
import SwiftUI
import ZenUI

struct ContentView: View {    
    var body: some View {
        
        ZenNavigationView(transitionType: .default) {
            PushView(destination: Text("LoginScreen"), destinationId: "login") {
                Text("LoginScreen")
            }
            .navigationToolbar(title: "Home", backButton: false, closeButton: false)
        }
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

struct ContentView: View {
    @State private var offset: CGFloat = 0
    @State private var isRefreshing: Bool = false
    @State private var data: [Int] = []
    
    var body: some View {
        NavigationView {

            ZenScrollView(offset: $offset) {
                ZenRefreshView(scrollOffset: $offset, isRefreshing: $isRefreshing, onRefreshing: refresh) {
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
            .navigationTitle("\(offset)")
        }
        .onAppear {
            refresh()
        }
    }
    
    private func refresh() {
        isRefreshing = true
        data.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            data.append(contentsOf: 0...100)
            isRefreshing = false
        }
    }
}
```

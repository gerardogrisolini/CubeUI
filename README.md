# CubeUI

### Getting Started

#### Adding a dependencies clause to your Package.swift

```
dependencies: [
    .package(url: "https://github.com/gerardogrisolini/CubeUI.git", from: "1.0.9")
]
```

#### Example CubeView

```
import SwiftUI
import CubeUI

struct ContentView: View {

    @State private var index: Int = 1

    var body: some View {
        CubeView(index: $index, mode: .drag) {
            Text("1")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.orange)
            Text("2")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
            Text("3")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green)
            Text("4")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: { index = 0 }) {
                    Image(systemName: "line.horizontal.3")
                }
            }
        }
    }
}
```

# 🖥️ WinTool-MacOS
## About
App for aligning windows on macOS (in progress)
## Roadmap:
- [x] running app
- [x] basic app on a bar
- [x] windows list
- [x] buttons in the menu
- [x] current app in the menu (not kinda)
- [x] app resizing
- [x] app struct
- [x] window size and position calculation
- [x] launching on startup
- [ ] error handling
- [ ] better UI
- [ ] window hoverover and aling (WH&A)
- [x] screen detection and some stuff with this
- [ ] global shortcuts and shortcut editor
- [ ] more features
- [ ] README.md to fix 😭
- [ ] snapping
## How to run this app?
### First of all you need to install the compiler for swift
if you have already it installed you should check the version by typing:
```zsh
swift
```
you can exit the swift env by typing:
```zsh
:q
```
#### Installing the command-line-tools:
```zsh
xcode-select --install
```
#### Updating the packages in the project:
```zsh
swift package update
```
#### Compiling the project:
```zsh
swift build
```
#### Running the project
```zsh
./.build/debug/build
```

# Settlement Builder and Placer VR

DLL companion to do per frame updates for Skyrim Settlement Builder and Placer VR

## Requirements

- [CMake](https://cmake.org/)
  - Add this to your `PATH`
- [PowerShell](https://github.com/PowerShell/PowerShell/releases/latest)
- [Vcpkg](https://github.com/microsoft/vcpkg)
  - Add the environment variable `VCPKG_ROOT` with the value as the path to the folder containing vcpkg
- [Visual Studio Community 2022](https://visualstudio.microsoft.com/)
  - Desktop development with C++
- [CommonLibVR](https://github.com/alandtse/CommonLibVR)
  - Add this as as an environment variable `CommonLibVRPath`

## User Requirements

- [VR Address Library for SKSEVR](https://www.nexusmods.com/skyrimspecialedition/mods/58101)
  - Needed for VR

## Register Visual Studio as a Generator

- Open `x64 Native Tools Command Prompt`
- Run `cmake`
- Close the cmd window

### VR

```
cmake --preset vs2022-windows-vcpkg-vr
cmake --build buildvr --config Release
```

---

# SKYRIM - SETTLEMENT BUILDER VR

Dependencies-

Skyrim - Settlement Builder
https://www.nexusmods.com/skyrimspecialedition/mods/58021

SkyUI - VR
https://www.nexusmods.com/skyrimspecialedition/mods/91535

Skyrim VR Tools
https://www.nexusmods.com/skyrimspecialedition/mods/27782

Constructible Object Custom Keyword System
https://www.nexusmods.com/skyrimspecialedition/mods/81409

Constructible Objects Custom Keyword Framework - Settlement Builder Patch
https://www.nexusmods.com/skyrimspecialedition/mods/114117

Skyrim Settlement Builder VR — Quick Start

1. Launch the game, open MCM → Settlement Builder VR.
2. Toggle “Start Mod” to initialize.
3. Choose “Add All Powers.” This is the FREE-BUILD/TEST mode — it gives you every build power at once.

Build flow: 4) In Magic → Powers, select the “Full List” power. 5) Cast it to open the build menu with every placeable item. 6) Pick an item; a matching object appears in Inventory → Misc. 7) Open Inventory → Misc and DROP that item to enter placement/preview mode. 8) Use the controls below to position it, then press A to place. 9) Repeat steps 4–8 to add more items.

Controls in placement/preview:
• Left Trigger / Right Trigger: Rotate the object.
• Right Stick Up / Down: Move the object closer to or farther from you.
• A: Place the object.

Pickup (current behavior):
• Crouch near some placed objects to open a small menu with an option to pick the item back up.
• Not all objects support pickup yet; expanding this to all items is planned.

## License

[MIT](LICENSE)

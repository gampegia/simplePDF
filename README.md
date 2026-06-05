# SimplePDF

A sleek, lightweight PDF viewer for macOS. No bloatware, no popups, and no subscription... ever.

**[Download & Website ↗](https://sunkarr.github.io/simplePDF)**

![Native macOS App](https://img.shields.io/badge/macOS-Native-blue)
![Free and Open Source](https://img.shields.io/badge/Open-Source-green)

## Features
- Native implementation using Swift and PDFKit.
- Minimal UI with some handy features.
- Standalone `.dmg` installation.
- Completely free and open-source, no mandatory payment or subscriptions.

## Development
SimplePDF is a Swift Package Manager project and can be run directly from the command line or packaged as a macOS app bundle.

### Requirements
- macOS 14 Sonoma or newer
- Xcode Command Line Tools with Swift 5.9 or newer
- `create-dmg` if you want to build the installer DMG

Install the optional DMG packaging tool with Homebrew:

```sh
brew install create-dmg
```

### Run locally
Clone the repository, enter the project folder, and run the executable:

```sh
git clone https://github.com/Sunkarr/simplePDF.git
cd simplePDF
swift run SimplePDF
```

You can also pass a PDF path as the first argument:

```sh
swift run SimplePDF /path/to/document.pdf
```

### Build the app bundle
Use the included build script to generate `SimplePDF.app` in the repository root:

```sh
./build.sh
```

The script generates the app icon, compiles the Swift sources for Apple Silicon macOS 14, writes the `Info.plist`, and assembles the `.app` bundle.

After building, launch the app with:

```sh
open SimplePDF.app
```

### Build the DMG installer
To create a distributable `SimplePDF.dmg`, run:

```sh
./create_dmg.sh
```

This script rebuilds `SimplePDF.app`, copies it into a temporary packaging folder, creates the DMG with `create-dmg`, and cleans up the temporary files.

### Basic usage
- Start SimplePDF and drag a PDF onto the landing page, or click **Choose PDF...**.
- Use `Cmd + O` to open PDFs as tabs.
- Use `Cmd + N` to open PDFs in a separate window.
- Use `Cmd + W` to close the current document.
- Use `Cmd + F` to search inside the current PDF.
- Use `Cmd + P` to jump to a page.
- Use `Cmd + 0` to toggle fit-to-page/fit-to-width zoom.
- Use `Cmd + I` to open the metadata inspector.
- Use `Cmd + Option + P` to enter or leave presentation mode.

The toolbar lets you switch between single-page, two-page, and presentation viewing modes. The status bar shows page dimensions, zoom controls, and the current page. Open documents are saved and restored on launch by default.

### Settings
Open the macOS settings window for SimplePDF to configure:

- Page dimension units
- Launch at login
- Session restore
- Default PDF reader integration
- Presentation progress bar appearance
- Settings import/export
- Debug logging
- Maximum PDF file size
- Custom keyboard shortcuts

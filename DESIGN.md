---
name: SimplePDF
description: A focused, modern macOS PDF workspace for small multi-document workflows.
colors:
  accent-red: "#D73535"
  accent-red-strong: "#B91F2A"
  ink: "#1D1D1F"
  secondary-ink: "#5E6066"
  app-background: "#F5F5F7"
  panel: "#FFFFFF"
  panel-soft: "#F0F1F4"
  divider: "#D7D8DE"
  selected-fill: "#FCEAEA"
typography:
  headline:
    fontFamily: "SF Pro, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: "22px"
    fontWeight: 700
    lineHeight: 1.18
  title:
    fontFamily: "SF Pro, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: "15px"
    fontWeight: 650
    lineHeight: 1.25
  body:
    fontFamily: "SF Pro, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: "13px"
    fontWeight: 400
    lineHeight: 1.35
  label:
    fontFamily: "SF Pro, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: "11px"
    fontWeight: 600
    lineHeight: 1.2
rounded:
  xs: "4px"
  sm: "6px"
  md: "8px"
  lg: "12px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "24px"
components:
  button-primary:
    backgroundColor: "{colors.accent-red}"
    textColor: "#FFFFFF"
    rounded: "{rounded.sm}"
    padding: "6px 12px"
  surface-panel:
    backgroundColor: "{colors.panel}"
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
    padding: "16px"
---

# Design System: SimplePDF

## 1. Overview

**Creative North Star: "The Focused Document Bench"**

SimplePDF should feel like a quiet, capable workspace where the document is centered and every control has a reason to exist. The visual system is modern and branded, but not decorative. Accent red gives the app identity and hierarchy, while the rest of the interface relies on macOS-native typography, measured density, and calm tonal surfaces.

The UI rejects heavy Acrobat-style toolbars, generic glass cards, loud gradients, and random rounded containers. It should feel ready for future editing tools: annotations, inspector panels, tool modes, and custom themes should all have clear places to attach.

**Key Characteristics:**
- Document-first composition
- Restrained branded accent
- Compact power-user controls
- Tokenized surfaces, spacing, radius, and states
- Native macOS behavior with a recognizable SimplePDF identity

## 2. Colors

The palette is restrained: neutral surfaces carry the workspace, red marks SimplePDF identity and active state.

### Primary
- **Simple Red** (#D73535): primary action, active selection, progress, and app identity.
- **Deep Simple Red** (#B91F2A): pressed states and high-emphasis accents.

### Neutral
- **Ink** (#1D1D1F): primary text.
- **Secondary Ink** (#5E6066): secondary labels and metadata.
- **App Background** (#F5F5F7): window and landing surfaces.
- **Panel** (#FFFFFF): elevated controls, settings sections, and inspectors.
- **Panel Soft** (#F0F1F4): sidebar, status bar, and recessed controls.
- **Divider** (#D7D8DE): separators and quiet borders.
- **Selected Fill** (#FCEAEA): low-chroma selection background.

### Named Rules

**The Accent Rarity Rule.** Red appears only for selection, primary action, progress, focus, and identity. If more than one area is screaming red, the screen is wrong.

## 3. Typography

**Display Font:** SF Pro with system fallback
**Body Font:** SF Pro with system fallback
**Label/Mono Font:** SF Mono only for page numbers, dimensions, and zoom values

**Character:** Native, precise, and compact. Typography should help scanning rather than create a marketing voice.

### Hierarchy
- **Headline** (700, 22px equivalent, 1.18): landing headline and sheet titles.
- **Title** (650, 15px equivalent, 1.25): settings section titles and panel headings.
- **Body** (400, 13px equivalent, 1.35): labels, explanatory copy, and metadata.
- **Label** (600, 11px equivalent, 1.2): small controls, badges, and compact state text.
- **Mono Label** (SF Mono, 11-12px): dimensions, page counters, zoom percentages.

### Named Rules

**The Product Type Rule.** No display fonts in controls, buttons, labels, metadata, or toolbar UI.

## 4. Elevation

SimplePDF uses tonal layering first and shadows sparingly. The PDF page can cast a soft visual weight; app controls stay mostly flat so they do not compete with the document.

### Shadow Vocabulary
- **Popover Shadow** (`0 8px 24px rgba(0,0,0,0.18)` equivalent): search and page-jump HUDs only.
- **Thumbnail Shadow** (`0 2px 6px rgba(0,0,0,0.12)` equivalent): page previews only.

### Named Rules

**The Flat Workspace Rule.** Persistent chrome is tonal, not floating. Shadows are for temporary overlays or document previews.

## 5. Components

### Buttons
- **Shape:** compact rounded rectangle (6px).
- **Primary:** Simple Red fill, white text, used for the main action in empty states and overlays.
- **Hover / Focus:** native macOS control behavior plus accent focus where available.
- **Secondary / Ghost:** neutral surface with quiet border or plain icon-only treatment.

### Chips
- **Style:** low-contrast fill with selected state using Selected Fill and Simple Red text or border.
- **State:** selected states should be obvious without relying on color alone.

### Cards / Containers
- **Corner Style:** 8px for panels, 12px only for larger empty-state surfaces.
- **Background:** Panel or Panel Soft.
- **Shadow Strategy:** no persistent card shadow.
- **Border:** one-pixel divider color when needed.
- **Internal Padding:** 12px or 16px.

### Inputs / Fields
- **Style:** native field styling where possible, with compact height and consistent radius.
- **Focus:** accent focus ring or native focus state.
- **Error / Disabled:** semantic red for error text; disabled controls reduce contrast and pointer affordance.

### Navigation
- Sidebar uses segmented tabs for Pages and Outline, selected thumbnails use red stroke plus fill, and outline rows stay plain with clear hover/active behavior.

## 6. Do's and Don'ts

### Do:
- **Do** keep the PDF page as the visual center of the app.
- **Do** route all new colors, spacing, radii, and materials through design tokens.
- **Do** use red for active state, progress, primary action, and identity.
- **Do** keep controls compact enough for two or three PDFs across tabs/windows.
- **Do** preserve native macOS interaction patterns.

### Don't:
- **Don't** create Acrobat-like dense toolbars before editing tools actually require them.
- **Don't** use decorative glassmorphism, loud gradients, or multicolor surfaces.
- **Don't** add nested cards or large floating panels around every section.
- **Don't** hard-code new theme colors in views.
- **Don't** make standard controls unfamiliar for personality alone.

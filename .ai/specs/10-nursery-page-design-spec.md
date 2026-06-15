# Nursery Page — Flutter Design Spec

> Reference images: `design-system/nursary-page-1.png`, `design-system/nursary-page-2.png`
> Reference React: `horta-platform/legacy_react/src/App.tsx` (`Home` component)
> Target Flutter: `horta-platform/lib/app/modules/nursery/presenter/`

---

## 1. Theme — Light Mode

The target design is **light**, not dark. Every component must reflect this.

| Token | Value | Notes |
|---|---|---|
| `background` | `#EEF3F1` | Muted light gray-green page background |
| `surface` (card) | `#FFFFFF` | Pure white cards |
| `surfaceBorder` | `#E2EAE6` | Subtle card border |
| `textPrimary` | `#0A0F0D` | Near-black titles |
| `textSecondary` | `#64748B` | Slate gray descriptions |
| `emerald` | `#10B981` | Primary accent |
| `emeraldLight` | `#D1FAE5` | Icon container bg tint |

Font: **Inter** (900 weight for headings, 500 for body). Already pulled via `google_fonts`.

---

## 2. Page Layout

```
┌─────────────────────────────────────────────────────────┐
│  Navbar (HortaNavbar)                                    │
├─────────────────────────────────────────────────────────┤
│  24px horizontal padding                                 │
│  ┌── Hero section ──────────────────────────────────┐   │
│  │  [Logo]  HORTA                                   │   │
│  │          CULTIVE CONHECIMENTO (muted italic)     │   │
│  │          subtitle                  [+ PLANT IDEA]│   │
│  │                                    [GARDEN CARE] │   │
│  └──────────────────────────────────────────────────┘   │
│  TagFilterBar (horizontal scroll pill bar)               │
│  ┌── Survey Grid ───────────────────────────────────┐   │
│  │  [  Card[0] — 2 cols wide  ] [  Card[1]  ]       │   │
│  │  [  Card[2]  ] [  Card[3]  ] [  Card[4]  ]       │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 3. Hero Section (`_HeroRow`)

### Layout
- `Row` with `crossAxisAlignment: CrossAxisAlignment.end`
- Left: `Expanded` column (logo + title + subtitle)
- Right: `Column` with two buttons stacked vertically

### Logo
- `HortaLogo` widget, size `72` on desktop / `48` on mobile
- Hidden on mobile (only show on `isDesktop`)
- Positioned left of the title text via `Row` inside the left column

### Title block
```
Row(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    HortaLogo(size: 72),          // only desktop
    SizedBox(width: 20),
    RichText(
      "HORTA\n"      → color #0A0F0D, size 80/52, weight 900, letterSpacing -4, height 0.9
      "CULTIVE\nCONHECIMENTO"  → color #0A0F0D.withValues(alpha:0.18), same size, italic
    )
  ]
)
```

### Subtitle
```
Text(
  'app.description'.tr(),
  style: TextStyle(color: #64748B, fontSize: 18, fontWeight: w500, letterSpacing: -0.3)
)
```

### Action buttons (right column)
```
Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    // Primary — filled emerald pill
    PillButton(label: 'PLANT IDEA', icon: Icons.add, onTap: ...),
    SizedBox(height: 12),
    // Secondary — outlined pill (only if isAdmin)
    OutlinedPillButton(label: 'GARDEN CARE', icon: Icons.shield_outlined, onTap: ...),
  ]
)
```

**`OutlinedPillButton`** (new widget needed):
```dart
OutlinedButton.icon(
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: #0A0F0D.withValues(alpha:0.15), width: 1.5),
    foregroundColor: #0A0F0D,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: StadiumBorder(),
  ),
)
```

---

## 4. Tag Filter Bar (`TagFilterBar`)

### Container
```dart
Container(
  padding: EdgeInsets.all(6),
  decoration: BoxDecoration(
    color: Colors.white,                         // ← was black/40
    borderRadius: BorderRadius.circular(999),
    border: Border.all(color: #E2EAE6),          // ← was white/5
    boxShadow: [BoxShadow(color: #0A0F0D.withValues(alpha:0.06), blurRadius: 12, offset: Offset(0,4))],
  ),
)
```

### Chip — "ENTIRE FIELD" selected state
```
background: #10B981 (emerald)
text: white
```

### Chip — tag selected state
```
background: #10B981 (emerald)
text: white
```

### Chip — unselected
```
background: transparent
text: #0A0F0D (dark)   // ← was #64748B
```

---

## 5. Survey Card (`SurveyCard` + `BentoCard`)

### Card container (update `BentoCard` or pass overrides)
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,                          // ← was #0A0A0F
    borderRadius: BorderRadius.circular(20),      // ← was 40
    border: Border.all(color: #E2EAE6, width: 1),
    boxShadow: [
      BoxShadow(color: #0A0F0D.withValues(alpha:0.06), blurRadius: 24, offset: Offset(0, 8)),
    ],
  ),
)
```

### Card content
```
Top row:
  Left:  Icon container (52×52, radius 12, bg: accent.withValues(alpha:0.1), border: accent.withValues(alpha:0.15))
           → Icon: Icons.spa (or category-specific), color: accent
  Right: category label — accent color, 10px, w900, letterSpacing 2, UPPERCASE

Title:
  color: #0A0F0D, size: isFirst ? 32 : 22, w900, letterSpacing -1, height 1.1
  maxLines: 3, overflow: ellipsis

Description:
  color: #64748B, size: 13, height: 1.6
  maxLines: 4, overflow: ellipsis

Bottom row:
  Left:
    tags as "#tag" — accent.withValues(alpha:0.7), 9px, w900
    Below tags: "NURTURING ECOSYSTEM" — #10B981 w/ opacity 0.5, 8px, w900, letterSpacing 1.5
  Right:
    Water-drop share icon button:
      48×48 container, radius 14
      bg: accent.withValues(alpha:0.08), border: accent.withValues(alpha:0.1)
      icon: Icons.water_drop (or Icons.ios_share), color: accent
```

### Watermark (decorative ID chars top-right)
```dart
Text(
  survey.id.substring(0, 2).toUpperCase(),
  style: TextStyle(
    fontSize: 120, fontWeight: w900,
    color: accent.withValues(alpha:hovered ? 0.06 : 0.03),
  ),
)
```
Same as current — no change needed.

---

## 6. Grid Layout — First Card Spans 2 Columns

The target design shows `Card[0]` filling 2 columns on desktop. Current Flutter grid uses uniform `crossAxisCount: 3`.

### Fix: Use `SliverMasonryGrid` or custom layout

**Recommended approach** — replace `SliverGrid` with a manual layout:

```dart
// On desktop (width > 900), first card is 2-col wide:
SliverPadding(
  padding: EdgeInsets.fromLTRB(24, 0, 24, 40),
  sliver: _NurseryGrid(surveys: state.filtered, accentFor: accentFor, lang: lang),
)

class _NurseryGrid extends StatelessWidget {
  // Desktop: wrap in LayoutBuilder, build a Column of Rows manually:
  // Row 0: [Card(0, flex:2), Card(1, flex:1)]
  // Row 1: [Card(2), Card(3), Card(4)]
  // ...etc
  //
  // Mobile: single-column ListView
}
```

**Implementation**:
```dart
Widget _buildDesktopGrid(List<Survey> surveys) {
  final rows = <Widget>[];
  int i = 0;

  // First row: first card takes 2/3, second takes 1/3
  if (surveys.isNotEmpty) {
    rows.add(IntrinsicHeight(
      child: Row(children: [
        Expanded(flex: 2, child: _card(surveys, 0)),
        const SizedBox(width: 16),
        if (surveys.length > 1)
          Expanded(flex: 1, child: _card(surveys, 1)),
      ]),
    ));
    i = 2;
  }

  // Remaining rows: 3 columns each
  while (i < surveys.length) {
    final rowItems = surveys.skip(i).take(3).toList();
    rows.add(const SizedBox(height: 16));
    rows.add(IntrinsicHeight(
      child: Row(
        children: rowItems.asMap().entries.map((e) => [
          if (e.key > 0) const SizedBox(width: 16),
          Expanded(child: _card(surveys, i + e.key)),
        ]).expand((x) => x).toList(),
      ),
    ));
    i += 3;
  }

  return Column(children: rows);
}
```

Height constraint for cards: `min-height: 320` on desktop (via `ConstrainedBox`).

---

## 7. Empty State (`NurseryEmptyState`)

Already exists. Update colors:
- Icon color: `#10B981` (keep)
- Title: `#0A0F0D`
- Description: `#64748B`
- Button: filled emerald (keep `PillButton`)
- Card border: dashed — use `CustomPaint` or `DashedBorder` approach with `#E2EAE6`

---

## 8. Files to Change

| File | Change |
|---|---|
| `lib/app/core/theme/app_theme.dart` | Add light theme tokens / or pass them via context |
| `lib/app/core/widgets/bento_card.dart` | Accept `isLight` flag OR move card styling to `SurveyCard` directly |
| `lib/app/modules/nursery/presenter/nursery_screen.dart` | Fix grid (first card 2-col), pass light bg scaffold |
| `lib/app/modules/nursery/presenter/widgets/survey_card.dart` | Light card colors, `accent.withValues(alpha:0.1)` icon bg, "NURTURING ECOSYSTEM" label |
| `lib/app/modules/nursery/presenter/widgets/tag_filter_bar.dart` | White container, dark unselected text |
| `lib/app/modules/nursery/presenter/widgets/pill_button.dart` | Add `OutlinedPillButton` variant |
| `lib/app/modules/nursery/presenter/widgets/nursery_empty_state.dart` | Light text colors |

---

## 9. Accent Colors — Per-Card Icon Background

For light theme, icon containers use `accent.withValues(alpha:0.1)` bg and `accent.withValues(alpha:0.15)` border — this makes them tinted (e.g., red for AI card, blue for infra card) as seen in the design.

Accent palette (unchanged from current):
```dart
static const _accentColors = [
  Color(0xFFEF4444), // red
  Color(0xFF3B82F6), // blue
  Color(0xFFEC4899), // pink
  Color(0xFFF97316), // orange
  Color(0xFFA855F7), // purple
  Color(0xFFEAB308), // yellow
];
```

---

## 10. Footer

From the reference, the footer at page bottom is an **emerald green bar**:
```
bg: #10B981
text: white, 10px, w700, uppercase, letterSpacing 0.2em
left: "ECOSYSTEM: BLOOMING" | "HORTA V2.0"
right: "SOW INITIAL DATA" (tappable) | "NURTURED BY LUCAS BATISTA"
```

This is in `MainShell` / `App` — update colors there as well.

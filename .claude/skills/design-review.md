# Design Review

Review a screen or component against the canonical specification principles.

## Arguments

- `screen` (optional): The screen file to review (e.g., "HomeScreen")

## Instructions

When the user invokes this skill, perform a comprehensive design review:

### 1. Read the Target Screen

If a screen name is provided, read the file from `Percepta/Features/**/{screen}.swift`.
If no screen is specified, ask which screen to review.

### 2. Evaluate Against Specification Principles

#### Core Philosophy
- [ ] Tracks perception, not performance?
- [ ] Guides direction without recommending actions?
- [ ] No warnings or action recommendations?
- [ ] Treats silence as a valid state?

#### UI & Readability (per spec)
- [ ] No charts, no numbers, no jargon?
- [ ] 8-11 short lines total per section?
- [ ] Clear conclusions with calm explanations?
- [ ] Visual comfort is prioritized?

#### Component Requirements
- [ ] Macro Thinking uses button-based input only (no free text)?
- [ ] Daily Macro Brief has 5 parts with "Why"?
- [ ] Insight Card is conditional and rule-based?
- [ ] Thinking Timeline shows days without records as valid empty states?

### 3. Check Design System Usage

#### Colors
- [ ] Uses `DSColor.*` tokens only (no hex values in views)?
- [ ] Follows 70/20/10 ratio (surfaces/accent/text)?

#### Typography
- [ ] Uses `DSTypography.*` only?
- [ ] Proper hierarchy (titleLarge → title → body → caption)?

#### Spacing (8pt Grid)
- [ ] Uses `DSSpacing.*` constants?
- [ ] Values are multiples of 8 (4, 8, 16, 24, 32, 48)?

#### Components
- [ ] Uses `DSCard` for card containers?
- [ ] Uses `DSPrimaryButton` for primary actions?
- [ ] Button heights are 56pt for primary actions?

### 4. Generate Report

Provide a structured report with:

1. **Summary**: Overall compliance score with brief rationale
2. **Spec Violations**: Any deviations from canonical specification
3. **Design System Issues**: Missing token usage
4. **Recommendations**: Actionable fixes with code examples

Example output format:

```
## Design Review: {ScreenName}

### Summary
Compliance: 8/10 - Mostly follows spec, minor issues with text length.

### Spec Violations
1. Insight card shows a recommendation (spec says no recommendations)
2. Macro thinking has a text field (spec says button-based only)

### Design System Issues
1. Line 45: Uses Color.gray instead of DSColor.textTertiary
2. Line 72: Uses .font(.body) instead of DSTypography.body

### Recommendations

1. Remove action recommendation:
\`\`\`swift
// Before
Text("금리를 확인하세요")
// After
Text("금리 변화가 관찰되고 있습니다")
\`\`\`

2. Use design system color:
\`\`\`swift
.foregroundColor(DSColor.textTertiary)  // was Color.gray
\`\`\`
```

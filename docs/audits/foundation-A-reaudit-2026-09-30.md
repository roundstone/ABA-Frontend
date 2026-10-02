# Audit Report: Foundation Group A (Design Tokens)

**Date**: 2026-09-30
**Target**: Group A (REQ-01-001 to REQ-01-123)
**Spec**: /docs/spec/ABA-ERP-01-Global-Design-System.md, §1 to §5

## 1. Summary Counts & Coverage

- **Total In Scope**: 63 (excludes Deferred)
- **✅ Verified**: 55
- **🟡 Partial**: 3
- **❌ Missing**: 4
- **⚠️ Wrong**: 1
- **⏭️ Deferred**: 60

**Coverage (Pass/Total)**: 87%

### VERDICT: FAIL ❌

## 2. Quality Gates

- **Typecheck & Lint & Build**: Could not verify zero warnings. `command not found: pnpm/npm`. The environment lacks the package manager to run the commands.
- **Raw Hex Codes Check**: PASS ✅ (0 instances found outside `globals.css`).
- **Mobile Rules Check**: PASS ✅ (14px body text, 16px inputs are defined in `globals.css`).
- **Mono-font Utility & Shadows & Status Map**: PASS ✅ (All present).

## 3. Fix List (Gaps)

1. **REQ-01-021**: The `AmountText` component adds `tabular-nums` but does not enforce `right-aligned` (like `text-right`) natively. (Partial)
2. **REQ-01-064**: `globals.css` maps `--chart-1` to semantic colors (e.g. `--brand-500`), but the spec strictly requires the exact hex codes `#2F6BFF`, `#12B76A`, etc. (Wrong)
3. **REQ-01-065**: The charts must group data beyond 7 series into "Other", which is not implemented. (Missing)
4. **REQ-01-066**: Color pairing with legend/patterns for charts is missing. (Missing)
5. **REQ-01-069**: A global rule for numeric columns to use `tabular-nums` is missing outside of specific text classes. (Partial)
6. **REQ-01-121**: Resting cards should enforce "border only, with no shadow", but there is no specific card shadow reset defined. (Missing)
7. **REQ-01-122**: Surface hierarchy variables exist, but the "overlays" rule is partially implemented (variables exist, but overlay specifically not). (Partial)
8. **REQ-01-123**: The 40% black scrim (`rgba(15,23,42,.4)`) rule for overlays is missing. (Missing)

## 4. Full Table (123 Rows)

| REQ | Verdict | Evidence (file:line) | Gap |
| --- | --- | --- | --- |
| REQ-01-001 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-002 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-003 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-004 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-005 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-006 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-007 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-008 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-009 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-010 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-011 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-012 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-013 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-014 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-015 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-016 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-017 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-018 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-019 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-020 | ✅ Verified | apps/web/src/lib/format.ts:70 | |
| REQ-01-021 | 🟡 Partial | apps/web/src/components/patterns/AmountText.tsx:34 | Right-alignment not enforced |
| REQ-01-022 | ✅ Verified | apps/web/src/components/patterns/AmountText.tsx:14 | |
| REQ-01-023 | ✅ Verified | apps/web/src/app/globals.css:60 | |
| REQ-01-024 | ✅ Verified | grep_search | |
| REQ-01-025 | ✅ Verified | apps/web/src/app/globals.css:61 | |
| REQ-01-026 | ✅ Verified | apps/web/src/app/globals.css:62 | |
| REQ-01-027 | ✅ Verified | apps/web/src/app/globals.css:63 | |
| REQ-01-028 | ✅ Verified | apps/web/src/app/globals.css:64 | |
| REQ-01-029 | ✅ Verified | apps/web/src/app/globals.css:65 | |
| REQ-01-030 | ✅ Verified | apps/web/src/app/globals.css:66 | |
| REQ-01-031 | ✅ Verified | apps/web/src/app/globals.css:68 | |
| REQ-01-032 | ✅ Verified | apps/web/src/app/globals.css:69 | |
| REQ-01-033 | ✅ Verified | apps/web/src/app/globals.css:70 | |
| REQ-01-034 | ✅ Verified | apps/web/src/app/globals.css:71 | |
| REQ-01-035 | ✅ Verified | apps/web/src/app/globals.css:72 | |
| REQ-01-036 | ✅ Verified | apps/web/src/app/globals.css:73 | |
| REQ-01-037 | ✅ Verified | apps/web/src/app/globals.css:74 | |
| REQ-01-038 | ✅ Verified | apps/web/src/app/globals.css:75 | |
| REQ-01-039 | ✅ Verified | apps/web/src/app/globals.css:76 | |
| REQ-01-040 | ✅ Verified | apps/web/src/app/globals.css:77 | |
| REQ-01-041 | ✅ Verified | apps/web/src/app/globals.css:79-81 | |
| REQ-01-042 | ✅ Verified | apps/web/src/app/globals.css:83-85 | |
| REQ-01-043 | ✅ Verified | apps/web/src/app/globals.css:87-89 | |
| REQ-01-044 | ✅ Verified | apps/web/src/app/globals.css:91-93 | |
| REQ-01-045 | ✅ Verified | apps/web/src/app/globals.css:95-97 | |
| REQ-01-046 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-047 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-048 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-049 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-050 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-051 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-052 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-053 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-054 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-055 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-056 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-057 | ✅ Verified | apps/web/src/lib/statusMap.ts:10-14 | |
| REQ-01-058 | ✅ Verified | apps/web/src/lib/statusMap.ts:15-20 | |
| REQ-01-059 | ✅ Verified | apps/web/src/lib/statusMap.ts:21-22,37,42,49,61 | |
| REQ-01-060 | ✅ Verified | apps/web/src/lib/statusMap.ts:23-25,34,36,38,43,48,55,57,60 | |
| REQ-01-061 | ✅ Verified | apps/web/src/lib/statusMap.ts:26-29,35,44-45,50,62 | |
| REQ-01-062 | ✅ Verified | apps/web/src/lib/statusMap.ts | |
| REQ-01-063 | ✅ Verified | grep_search | No other module defines status badges |
| REQ-01-064 | ⚠️ Wrong | apps/web/src/app/globals.css:115-119 | Used semantic colors instead of exact hex |
| REQ-01-065 | ❌ Missing | - | Not implemented |
| REQ-01-066 | ❌ Missing | - | Not implemented |
| REQ-01-067 | ✅ Verified | apps/web/src/app/globals.css:7 | |
| REQ-01-068 | ✅ Verified | apps/web/src/app/layout.tsx:8 | |
| REQ-01-069 | 🟡 Partial | apps/web/src/app/globals.css | Specific classes have it, not generally numeric columns |
| REQ-01-070 | ✅ Verified | apps/web/src/app/layout.tsx:13 | |
| REQ-01-071 | ✅ Verified | apps/web/src/app/globals.css:142 | |
| REQ-01-072 | ✅ Verified | apps/web/src/app/globals.css:155 | |
| REQ-01-073 | ✅ Verified | apps/web/src/app/globals.css:161 | |
| REQ-01-074 | ✅ Verified | apps/web/src/app/globals.css:167 | |
| REQ-01-075 | ✅ Verified | apps/web/src/app/globals.css:173 | |
| REQ-01-076 | ✅ Verified | apps/web/src/app/globals.css:179 | |
| REQ-01-077 | ✅ Verified | apps/web/src/app/globals.css:185 | |
| REQ-01-078 | ✅ Verified | apps/web/src/app/globals.css:191 | |
| REQ-01-079 | ✅ Verified | apps/web/src/app/globals.css:199 | |
| REQ-01-080 | ✅ Verified | apps/web/src/app/globals.css:205 | |
| REQ-01-081 | ✅ Verified | apps/web/src/app/globals.css:211 | |
| REQ-01-082 | ⏭️ Deferred | N/A | Deferred to Group B |
| REQ-01-083 | ⏭️ Deferred | N/A | Deferred to Group B |
| REQ-01-084 | ✅ Verified | apps/web/src/app/globals.css:232 | |
| REQ-01-085 | ✅ Verified | apps/web/src/app/globals.css:246 | |
| REQ-01-086 | ✅ Verified | apps/web/src/app/globals.css:148 | |
| REQ-01-087 | ✅ Verified | apps/web/src/app/globals.css:239 | |
| REQ-01-088 | ✅ Verified | apps/web/src/app/globals.css:304 | |
| REQ-01-089 | ✅ Verified | apps/web/src/app/globals.css:301 | |
| REQ-01-090 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-091 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-092 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-093 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-094 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-095 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-096 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-097 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-098 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-099 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-100 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-101 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-102 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-103 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-104 | ⏭️ Deferred | N/A | Deferred to Group C |
| REQ-01-105 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-106 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-107 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-108 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-109 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-110 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-111 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-112 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-113 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-114 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-115 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-116 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-117 | ⏭️ Deferred | N/A | Deferred to Group B/C/D |
| REQ-01-118 | ✅ Verified | apps/web/src/app/globals.css:52 | |
| REQ-01-119 | ✅ Verified | apps/web/src/app/globals.css:53 | |
| REQ-01-120 | ✅ Verified | apps/web/src/app/globals.css:54 | |
| REQ-01-121 | ❌ Missing | apps/web/src/app/globals.css | Missing border only, no shadow for resting cards |
| REQ-01-122 | 🟡 Partial | apps/web/src/app/globals.css | Surface hierarchy partially defined |
| REQ-01-123 | ❌ Missing | apps/web/src/app/globals.css | Scrim missing |

# Prohibited patterns

| Prohibited | Use instead |
|---|---|
| `Dio()` outside `lib/core/api/` | Inject/use `ApiClient` through a feature repository |
| API work or business workflow in `build` | Controller/use-case/repository; widget dispatches intent |
| Raw `Color(0x...)`, padding, radius, shadow, motion, text style | Semantic `Iba*` tokens and theme |
| Hardcoded user text | Generated `AppLocalizations` key in all three ARBs |
| Physical left/right layout | Directional padding, alignment, positioning, radius, icons |
| Tokens or secrets in shared preferences | `SecureStore`; preferences only for non-secrets |
| Full payload/header logging, `print`, unrestricted `debugPrint` | Minimal structured `SafeLogger` event with redaction |
| Broad exception swallowing | Typed failure mapping; preserve unexpected errors/cancellation |
| Fake/optimistic financial success | Server-confirmed, pending, declined, reversed, or unknown state |
| Blind retry after financial timeout | Stable idempotency key and status lookup |
| Giant widgets or local copies of shared components | Cohesive composition; extend/reuse `Iba*` |
| Navigation from transport/infrastructure | App/feature navigation boundary and route guards |
| Production mock data or fabricated backend fields | Contract-backed data or documented unavailable state |
| Disabled/skipped tests or weaker lints/assertions | Fix cause; document a reviewed exception if unavoidable |
| Manual edits to generated localization | Edit all ARBs and regenerate |
| Runtime font download | Bundled Inter/Noto Naskh assets |
| Secret in source/config or commit | Environment/secure platform mechanism and secret scanning |
| Implicit commit or Git initialization | Only when current task explicitly authorizes it |
| Redesigning an approved screen or using a generic substitute | Implement its binding reference |
| Changing approved color, icons, radii, navigation, scan centering, sections, or actions | Match it or obtain an exception |
| Merging states or changing balance visibility | Preserve approved variants |
| Placeholder copy when approved copy exists | Localize approved meaning |
| Broken LTR reused for RTL | Directional mirroring without redesign |
| Creating, editing, or deleting references during coding | Preserve them; use change control |
| Ignoring difficult visual detail | Record the gap before implementation |

The validator automates only high-confidence subsets; absence of a validator
finding does not make a prohibited pattern acceptable.

# Pre-migration image inventory

Created before moving any source image. Every file was opened visually; hashes
and dimensions were checked independently. All files are RGB, non-interlaced
PNG exports. Landscape boards contain multiple portrait mobile screens unless
noted. Visible copy is predominantly English (LTR), with Dari/Pashto samples on
localization boards. Confidence is high for every classification.

| # | Original path | Dimensions | Proposed category and name | State / variation | Duplicate status | Decision | Notes |
|---:|---|---:|---|---|---|---|---|
| 01 | `temp/ChatGPT Image Jul 19, 2026, 08_16_12 AM.png` | 1672×941 | flow: customer authentication entry | splash, language, mobile login, PIN, biometric | unique | keep | Five-screen application flow; English with Dari/Pashto language labels. |
| 02 | `temp/ChatGPT Image Jul 19, 2026, 08_16_18 AM.png` | 1024×1536 | flow: customer authentication and signup | splash through signup success | unique | keep | Portrait composite foundation board; includes English, Dari and Pashto choices. |
| 03 | `temp/ChatGPT Image Jul 19, 2026, 08_16_24 AM.png` | 1536×1024 | flow: customer core application | home, accounts, transfer, services, profile | unique | keep | Phase 3 board; multiple customer states. |
| 04 | `temp/ChatGPT Image Jul 19, 2026, 08_16_31 AM (1).png` | 1536×1024 | flow: customer financial | transfer entry through receipt | retained target for 06 | keep | Phase 4 financial flows board. |
| 05 | `temp/ChatGPT Image Jul 19, 2026, 08_16_31 AM (2).png` | 1536×1024 | flow: customer money transfer | dashboard through transfer receipt | retained target for 07 | keep | Phase 4 money transfers and payments board. |
| 06 | `temp/ChatGPT Image Jul 19, 2026, 08_16_35 AM (1).png` | 1536×1024 | duplicate of 04 | identical | exact SHA-256 duplicate | remove | Byte-for-byte and visually identical to 04. |
| 07 | `temp/ChatGPT Image Jul 19, 2026, 08_16_35 AM (2).png` | 1536×1024 | duplicate of 05 | identical | exact SHA-256 duplicate | remove | Byte-for-byte and visually identical to 05. |
| 08 | `temp/ChatGPT Image Jul 19, 2026, 08_16_38 AM.png` | 1536×1024 | flow: customer mobile top-up | provider, amount, review, processing, success | unique | keep | Phase 5 top-up board. |
| 09 | `temp/ChatGPT Image Jul 19, 2026, 08_16_41 AM.png` | 1536×1024 | flow: customer beneficiaries | list, add, verify, success, details, delete | unique | keep | Phase 5 beneficiary board. |
| 10 | `temp/ChatGPT Image Jul 19, 2026, 08_16_43 AM.png` | 1536×1024 | flow: customer transactions | history, filters, search, details, actions | unique | keep | Phase 6 board. |
| 11 | `temp/ChatGPT Image Jul 19, 2026, 08_16_46 AM.png` | 1536×1024 | flow: customer profile and security | profile, personal info, PIN, biometrics, logout | unique | keep | Phase 7 board. |
| 12 | `temp/ChatGPT Image Jul 19, 2026, 08_16_49 AM.png` | 1536×1024 | flow: staff walk-in customer onboarding | customer form, document capture, review, success | unique | keep | Phase 8 staff flow. |
| 13 | `temp/ChatGPT Image Jul 19, 2026, 08_16_52 AM.png` | 1536×1024 | flow: customer bill payment | categories, bill entry, review, PIN, success | unique | keep | Phase 9 board. |
| 14 | `temp/ChatGPT Image Jul 19, 2026, 08_16_54 AM.png` | 1536×1024 | flow: customer top-up and withdrawal | top-up, withdraw, review, PIN, processing, success | unique | keep | Phase 10 board. |
| 15 | `temp/ChatGPT Image Jul 19, 2026, 08_16_57 AM.png` | 1536×1024 | flow: staff agent services | agent dashboard, service, customer, review, success | unique | keep | Phase 11 board. |
| 16 | `temp/ChatGPT Image Jul 19, 2026, 08_17_00 AM.png` | 1536×1024 | flow: customer transaction history | list, filters, details, receipt | unique | keep | Phase 12 board; intentionally overlaps 10 with distinct screens. |
| 17 | `temp/ChatGPT Image Jul 19, 2026, 08_17_03 AM.png` | 1536×1024 | flow: customer statements | accounts, date range, generating, statement, share | unique | keep | Phase 13 board. |
| 18 | `temp/ChatGPT Image Jul 19, 2026, 08_17_06 AM.png` | 1536×1024 | flow: customer settings and security | settings, language, notification, PIN, biometrics | unique | keep | Phase 14 board. |
| 19 | `temp/ChatGPT Image Jul 19, 2026, 08_17_08 AM.png` | 1536×1024 | flow: staff administration overview | dashboard, users, agents, transactions, system | unique | keep | Phase 15 mobile staff/admin board. |
| 20 | `temp/ChatGPT Image Jul 19, 2026, 08_17_11 AM.png` | 1536×1024 | flow: staff reports and analytics | overview, filters, charts, export, result | unique | keep | Phase 16 board. |
| 21 | `temp/ChatGPT Image Jul 19, 2026, 08_17_14 AM.png` | 1536×1024 | flow: customer support | help, FAQ, search, article, contact, ticket | unique | keep | Phase 17 board. |
| 22 | `temp/ChatGPT Image Jul 19, 2026, 08_17_17 AM.png` | 1536×1024 | flow: customer notifications | list, filter, details, preferences | unique | keep | Phase 18 board. |
| 23 | `temp/ChatGPT Image Jul 19, 2026, 08_17_20 AM.png` | 1536×1024 | flow: staff security and permissions | roles, permissions, PIN, confirmation, success | unique | keep | Phase 19 board. |
| 24 | `temp/ChatGPT Image Jul 19, 2026, 08_17_23 AM.png` | 1536×1024 | flow: staff system settings | configuration, limits, integrations, maintenance | unique | keep | Phase 20 board. |
| 25 | `temp/ChatGPT Image Jul 19, 2026, 08_17_27 AM.png` | 1536×1024 | flow: customer profile preferences | profile, information, preferences, language | unique | keep | Phase 21 board. |
| 26 | `temp/ChatGPT Image Jul 19, 2026, 08_17_30 AM.png` | 1536×1024 | flow: staff reports analytics | dashboard, financial, user, export | unique | keep | Phase 22 board; distinct report variants from 20. |
| 27 | `temp/ChatGPT Image Jul 19, 2026, 08_17_32 AM.png` | 1536×1024 | flow: customer transaction recovery | pending, delayed, failed, reversed, unavailable | unique | keep | Phase A exception and recovery states. |
| 28 | `temp/ChatGPT Image Jul 19, 2026, 08_17_35 AM.png` | 1536×1024 | flow: customer PIN recovery | request, OTP, new PIN, success, lockout | unique | keep | Phase B recovery flow. |
| 29 | `temp/ChatGPT Image Jul 19, 2026, 08_17_39 AM.png` | 1536×1024 | flow: customer KYC status | unverified through approved/rejected/review | unique | keep | Phase C account-state journey. |
| 30 | `temp/ChatGPT Image Jul 19, 2026, 08_17_41 AM.png` | 1536×1024 | flow: customer legal consent | terms, privacy, consent, confirmation | unique | keep | Phase D legal and consent journey. |
| 31 | `temp/ChatGPT Image Jul 19, 2026, 08_17_44 AM.png` | 1536×1024 | flow: customer security response | warnings, device/session response, locked states | unique | keep | Phase E security response center. |
| 32 | `temp/ChatGPT Image Jul 19, 2026, 08_17_47 AM.png` | 1536×1024 | flow: customer system states | empty, offline, maintenance, restricted, error | unique | keep | Phase F system and empty states. |
| 33 | `temp/ChatGPT Image Jul 19, 2026, 08_17_49 AM.png` | 1536×1024 | flow: customer recipient validation | lookup, validation, risk, review, result | unique | keep | Phase 1 recipient and transaction validation. |
| 34 | `temp/ChatGPT Image Jul 19, 2026, 08_17_57 AM.png` | 1536×1024 | flow: customer transaction warnings | limits, risk, warning, confirmation, result | unique | keep | Phase 2 transaction risk and warnings. |
| 35 | `temp/ChatGPT Image Jul 19, 2026, 08_18_00 AM.png` | 1536×1024 | flow: customer account and balance states | active, hidden, low, frozen, closed, error | unique | keep | Phase 3 financial visibility/state board. |
| 36 | `temp/ChatGPT Image Jul 19, 2026, 08_18_03 AM.png` | 1536×1024 | flow: customer transaction dispute | select, reason, evidence, review, submitted | unique | keep | Phase 4 dispute flow. |
| 37 | `temp/ChatGPT Image Jul 19, 2026, 08_18_06 AM.png` | 1536×1024 | flow: customer app permissions | permission prompts, denied, settings, success | unique | keep | Phase 5 OS states. |
| 38 | `temp/ChatGPT Image Jul 19, 2026, 08_18_12 AM.png` | 1536×1024 | component: reusable financial components | cards, amount, keypad, recipient, receipt | unique | keep | Phase 6 approved component board. |
| 39 | `temp/ChatGPT Image Jul 19, 2026, 08_18_15 AM.png` | 1536×1024 | foundation: design system | colors, typography, spacing, radii, icons, states | unique | keep | Approved foundation board. |
| 40 | `temp/ChatGPT Image Jul 19, 2026, 08_18_17 AM.png` | 1536×1024 | component: buttons | variants and states | unique | keep | DS component board 01. |
| 41 | `temp/ChatGPT Image Jul 19, 2026, 08_18_20 AM.png` | 1536×1024 | component: inputs and forms | default, focus, filled, error, disabled | unique | keep | DS component board 02. |
| 42 | `temp/ChatGPT Image Jul 19, 2026, 08_18_22 AM.png` | 1536×1024 | component: navigation and layout | app bars, bottom navigation, sheets, layout | unique | keep | DS component board 03. |
| 43 | `temp/ChatGPT Image Jul 19, 2026, 08_18_25 AM.png` | 1536×1024 | component: feedback and states | banners, badges, progress, empty, result | unique | keep | DS component board 04. |
| 44 | `temp/ChatGPT Image Jul 19, 2026, 08_18_28 AM.png` | 1536×1024 | component: fintech | account, balance, recipient, transaction, receipt | unique | keep | DS component board 05. |
| 45 | `temp/ChatGPT Image Jul 19, 2026, 08_18_31 AM.png` | 1536×1024 | component: security and privacy | PIN, OTP, masking, biometric, session | unique | keep | DS component board 06. |
| 46 | `temp/ChatGPT Image Jul 19, 2026, 08_18_34 AM.png` | 1536×1024 | foundation: localization and RTL | English, Dari, Pashto, bidi examples | unique | keep | DS component board 07. |
| 47 | `temp/ChatGPT Image Jul 19, 2026, 08_18_36 AM.png` | 1536×1024 | foundation: accessibility | contrast, semantics, focus, large text, motion | unique | keep | DS component board 08. |
| 48 | `temp/ChatGPT Image Jul 19, 2026, 08_18_39 AM.png` | 1536×1024 | component: navigation layouts | responsive navigation and layout states | unique | keep | DS component board 09. |
| 49 | `temp/ChatGPT Image Jul 19, 2026, 08_18_45 AM.png` | 1536×1024 | component: feedback and status | alert, inline, loading, empty, result states | unique | keep | DS component board 10; intentional expansion of 43. |
| 50 | `temp/ChatGPT Image Jul 19, 2026, 08_18_47 AM.png` | 1024×1536 | component: screen templates | fifteen page patterns | unique | keep | DS-11 portrait board; supporting patterns, not individual screens. |
| 51 | `temp/ChatGPT Image Jul 19, 2026, 08_18_50 AM.png` | 1536×1024 | foundation: motion and haptics | durations, transitions, feedback, reduced motion | unique | keep | DS-12 board. |
| 52 | `temp/ChatGPT Image Jul 19, 2026, 08_18_53 AM.png` | 1536×1024 | foundation: content and UX writing | voice, terminology, errors, finance copy | unique | keep | DS-13 board. |
| 53 | `temp/ChatGPT Image Jul 19, 2026, 08_18_55 AM.png` | 1536×1024 | foundation: API error mapping | error families, UI states, retry guidance | unique | keep | DS-14 board. |
| 54 | `temp/ChatGPT Image Jul 19, 2026, 08_18_58 AM.png` | 1024×1536 | foundation: Flutter component/token map | tokens, theme, catalog, states, structure | unique | keep | DS-15 portrait handoff board. |

## Hash duplicate decisions

- 06 and 04 share SHA-256
  `0a7b61491b56dd8caf6202b25105847a6a38bec668b38e183b3176c212523ffb`.
- 07 and 05 share SHA-256
  `03546a997d0a6b96d496049060b6d30c772b973f367ae2c81111579ef5cb9052`.
- No other exact duplicate hashes were found.
- Similar transaction, navigation, feedback, authentication, and report boards
  were retained because visual comparison found distinct states or guidance.

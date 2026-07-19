# Approved-design migration report

## Outcome

- Total files inspected visually and by metadata: **54**.
- Retained, renamed, and moved without image-content changes: **52**.
- Exact duplicates removed: **2**.
- Near-duplicates retained: authentication, transaction, reports, navigation,
  feedback, financial-component, and profile/settings boards where each carries
  distinct states or guidance.
- Unclear files archived: **0**.
- Meaningless, invalid, blank, corrupted, or unrelated files removed: **0**.
- Superseded files archived: **0**.
- Final `temp` status: removed after becoming empty.

All 52 retained files have the same SHA-256 hash as their source inventory
counterpart. No image was resized, recompressed, converted, cropped, annotated,
or otherwise edited.

## Removed files

| Original path | Decision and reason | Duplicate target | SHA-256 | Visual comparison |
|---|---|---|---|---|
| `temp/ChatGPT Image Jul 19, 2026, 08_16_35 AM (1).png` | Removed exact duplicate; no unique design information. | `design-references/flows/transfer/customer-financial-transfer-flow-en-ltr-v1.png` | `0a7b61491b56dd8caf6202b25105847a6a38bec668b38e183b3176c212523ffb` | Pixel content visually identical; dimensions and bytes match. |
| `temp/ChatGPT Image Jul 19, 2026, 08_16_35 AM (2).png` | Removed exact duplicate; no unique design information. | `design-references/flows/transfer/customer-money-transfer-payment-flow-en-ltr-v1.png` | `03546a997d0a6b96d496049060b6d30c772b973f367ae2c81111579ef5cb9052` | Pixel content visually identical; dimensions and bytes match. |

## Classification notes

The source set consists of composite flow boards, component boards, and
foundation boards—not standalone screen exports. Customer/staff role, visible
copy, state labels, device orientation, and board headings were inspected.
Overlapping boards were not collapsed merely for looking similar. Staff/admin
boards remain visual authorities, but do not establish roles, APIs, or business
capabilities. The generic screen-template and Flutter-map boards are supporting
rather than screen-specific authorities.

Unresolved questions: the boards do not provide separate full-size single-screen
exports or complete Dari/Pashto screen variants. These gaps must be recorded per
implementation; they do not authorize redesign.

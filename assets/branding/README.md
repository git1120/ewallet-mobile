# IBA mobile branding assets

These files were copied byte-for-byte from the sibling IBA admin-panel working
copy with explicit approval for reuse in the Flutter mobile application:

| Mobile asset | Admin-panel source | SHA-256 (source and copy) | Approved use |
|---|---|---|---|
| `iba-logo.png` | `web/public/images/iba-logo.png` | `8f4447bc57d6bb2c3c2548c3277060b33b766a31b7a6b52df4041595efdc2d2f` | Standard seal on light surfaces. |
| `iba-logo-white.png` | `web/public/images/logo_white.png` | `0fa6a49db7bfa75b8ed582f4d90ae0cb76cc51b5c736da5dc5294200b0d0d0f9` | White-backed seal on dark or institutional-green surfaces. |

Both are transparent 8-bit sRGB PNGs. The standard asset is 1463×1447 RGBA in
palette-plus-alpha mode, 239,542 bytes, with non-transparent bounds 1441×1441
at +12+0. The white variant is 928×926 RGBA in truecolor-plus-alpha mode
(1-bit alpha), 156,741 bytes, with non-transparent bounds 907×906 at +10+9.
Neither is materially cropped; both contain only minimal edge padding. The seal
is appropriate at the reviewed 88 logical-pixel authentication size. At
compact sizes it remains a brand cue, but its ring text is not treated as UI
copy.

The approved files must not be redrawn, recolored, regenerated, enhanced,
cropped, resized, recompressed, or otherwise altered. Runtime rendering uses
aspect-ratio-preserving containment and never recolors the PNG pixels. The app
references these local copies and has no runtime dependency on the admin panel.

These are existing IBA project assets approved for internal mobile reuse. This
record makes no additional legal or ownership claim.

The temporary geometric security mark may be used only when it communicates a
separate security or reassurance concept, or when explicitly requested as the
approved fallback. It must not replace the official logo in a primary brand
region.

Related visual reference: `flow-auth-entry-v1`. Related decisions:
`DDR-AUTH-ENTRY-01` (approved and resolved branding asset),
`DDR-AUTH-ENTRY-02` (unsupported visual actions), `DDR-AUTH-ENTRY-03`
(backend-compatible mobile presentation), and `DDR-AUTH-ENTRY-04`
(security-required mobile masking).

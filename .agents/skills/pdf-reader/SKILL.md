---
name: pdf-reader
description: Read PDF sources inside the current DSH session workspace with text and visual evidence. Use for PDF inspection or as the PDF-input stage of another Skill; do not use it to decide note-writing format.
---

# PDF Reader

Use the `dsh-pdf-reader` tools by default. Start with `pdf_scan` to map the requested page range, then read each needed page with `pdf_read_page(mode="mixed")`.

Inspect every returned `fullPage` and relevant region path with `read_image`. Formulas, diagrams, figures, tables, layout, and annotations require visual evidence; text extraction alone is insufficient. Use `pdf_render_region` only when a mixed result leaves a specific area unreadable or ambiguous.

For an exhaustive request, cover every page in the user-requested range without sampling or silently skipping pages.

Keep the PDF and `.dsh-pdf-reader` output inside the current session workspace. Normally do not call `pdfinfo`, `pdftotext`, `pdftoppm`, or write through `%TEMP%` / `$env:TEMP`. Use a fallback only when the plugin is unavailable or fails; keep fallback scratch files in a workspace-local directory and preserve the same text-plus-visual evidence standard.

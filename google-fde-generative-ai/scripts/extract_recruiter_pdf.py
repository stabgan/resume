#!/usr/bin/env python3
"""Extract text + hyperlinks from the recruiter FDE prep PDF."""
import pypdf
from pathlib import Path

PDF = Path(__file__).resolve().parents[1] / "GenAI Forward Deployed Engineer (FDE) Prep Doc (1).pdf"

reader = pypdf.PdfReader(str(PDF))

print("=" * 80)
print(f"PDF: {PDF.name}")
print(f"Pages: {len(reader.pages)}")
print(f"Metadata: {reader.metadata}")
print("=" * 80)

# Extract all links from the PDF
print("\n=== HYPERLINKS (all pages) ===\n")
links = []
for page_num, page in enumerate(reader.pages, start=1):
    if "/Annots" in page:
        for annot_ref in page["/Annots"]:
            try:
                annot = annot_ref.get_object()
                if annot.get("/Subtype") == "/Link":
                    action = annot.get("/A")
                    if action:
                        uri = action.get("/URI")
                        if uri:
                            # Try to get the surrounding text via Rect
                            rect = annot.get("/Rect")
                            links.append((page_num, str(uri), rect))
            except Exception as e:
                pass

for page_num, uri, rect in links:
    print(f"[p{page_num}] {uri}")

print(f"\nTotal links: {len(links)}")

# Full text extraction per page
print("\n" + "=" * 80)
print("=== FULL TEXT ===")
print("=" * 80)
for i, page in enumerate(reader.pages, start=1):
    print(f"\n--- PAGE {i} ---\n")
    text = page.extract_text() or ""
    print(text)
    print()

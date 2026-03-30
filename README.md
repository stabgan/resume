# Resume — Kaustabh Ganguly

3-page ATS-optimized LaTeX resume for Senior AI/ML Engineer roles. Every design decision is backed by research in color psychology, eye-tracking, cognitive science, and behavioral economics.

## Build

```bash
# Using tectonic (recommended)
tectonic resume_single.tex

# Using pdflatex
pdflatex resume_single.tex && pdflatex resume_single.tex
```

Requires the [Lato](https://fonts.google.com/specimen/Lato) font (bundled with most TeX distributions).

## Design System

Single accent color: **dark navy `#003366`** (`RGB 0, 51, 102`).

Applied to: name, section headings, section rules, hyperlinks, page footer. Body text remains black. No other colors used.

## Research Basis

Every design and layout choice maps to published research. Sources below.

### Color Psychology

| Finding | Source | How Applied |
|---|---|---|
| Blue conveys **competence and trustworthiness** — the two traits most valued in hiring contexts | Labrecque & Milne (2012), *Journal of the Academy of Marketing Science* | Dark navy accent on headings, rules, name, links |
| Blue resumes rated "competent, confident, resilient, reliable" (n=91). B&W rated "cold, indifferent, unimaginative" | CUHK Social Psychology study (Wong et al., 2024) | Moved from pure B&W to single blue accent |
| Colors affect psychological functioning; single accent > multi-color (mixed colors create "disorganised impressions") | Elliot, Maier & Fiske (2014), *Annual Review of Psychology* | ONE color only — no warm/cool mixing |
| 85% of consumers make decisions based on color alone | Vorecol (2024), citing color psychology research | Color is not decorative — it's a decision lever |

### Eye-Tracking Research

| Finding | Source | How Applied |
|---|---|---|
| Recruiters spend **7.4 seconds** on initial scan, following an **F-pattern** (top → left side → occasional right) | TheLadders eye-tracking study (2018, n=30 recruiters over 10 weeks) | Single-column, left-aligned layout. Key info in top-left quadrant |
| **6 fixation points** capture ~80% of attention: (1) Name, (2) Current title, (3) Current company, (4) Dates, (5) Previous title, (6) Education | TheLadders (2018), confirmed by Wonsulting (2025) | These 6 elements are visually prominent. Job titles NOT shrunk with `\small` |
| "The first 2-3 words of each line are the only words guaranteed to be seen during vertical scanning" | ResumeHeatMap.com synthesis of multiple studies | Bold labels at start of every bullet in recent roles |
| "Location matters more than content quality" — page 2 gets almost no attention during initial screening | ResumeHeatMap.com, TheLadders (2018) | Experience before Education. Gracenote (current role) starts on page 1 |
| F-pattern confirmed with hidden eye-tracker in 2025 | Wonsulting (Jerry Lee, 2025) | Layout unchanged — F-pattern is consistent across methodologies |

### Cognitive Science & Behavioral Economics

| Finding | Source | How Applied |
|---|---|---|
| **Fluency heuristic**: well-formatted text perceived as more credible, even with identical words | Applied Cognitive Psychology research; Resumly.ai synthesis | Clean formatting, consistent spacing, generous white space |
| **Primacy effect**: first information anchors entire evaluation | Panna.ai resume psychology analysis; Asch (1946) | Summary leads with concrete metrics (AUROC 0.95, 3x cost reduction). IIT Madras mentioned in summary even though Education section is later |
| **Recency effect**: last items leave lasting impression | Panna.ai | Recommendations section closes the resume — ends on a human, warm note |
| **Anchoring bias**: first piece of information disproportionately influences perception of the rest | Panna.ai; Forbes (2021) cognitive bias in hiring | First bullet of each role is the strongest quantified achievement |
| **Halo effect**: one positive trait colors perception of everything else | Panna.ai; general cognitive bias literature | IIT Madras and Gracenote (Nielsen) brand names appear early |
| **Cognitive load theory**: dense text blocks are skipped entirely | Panna.ai; Nielsen Norman Group | Bullet points, bold labels, section chunking with rules. No paragraphs in experience |
| **Chunking**: section headers with visual breaks improve recall | Resumly.ai; Applied Cognitive Psychology | Blue section rules create visual chunks. Clear hierarchy |

### Typography & Readability

| Finding | Source | How Applied |
|---|---|---|
| Sans-serif fonts feel "modern, straightforward, clean" — ideal for tech roles | Resumly.ai; ResumeLab 2024 survey (n=1,003 hiring managers) | Lato font (clean sans-serif) |
| 10-12pt body text, 1.0-1.15 line spacing optimal | Resumly.ai; Indeed career advice | 11pt body, standard line spacing |
| 61% of hiring managers believe resume design impacts chances | StandOut CV survey | Design is intentional, not decorative |
| Bold job titles and company names for scannability | ResumeWorded (2026 ML resume guide) | Company names bold, job titles italic at normal size |
| White space improves readability and conveys order | Wichita State University typography research; WashU career center | 0.4in margins, eased subheading spacing (-5pt not -7pt) |

### ATS Optimization

| Finding | Source | How Applied |
|---|---|---|
| ATS scans for keywords, structure, clarity, and formatting consistency | Toptal TechResume (2025), citing Gartner | Standard section headers, consistent formatting, no tables/columns |
| 87% of companies report widening skills gap — skills-based hiring increasing | McKinsey Global Institute | Technical Skills section is the keyword hub (7 categories, 50+ specific tools) |
| "Your skills section is prime real estate for both ATS and human reviewers" | Marisa Goldberg, Senior Director of Recruiting, Toptal | Skills section placed immediately after summary, before experience |
| Spell out acronyms AND include abbreviations for dual-form matching | Multiple ATS guides | "named entity recognition (NER)", "Retrieval-Augmented Generation (RAG)", etc. |
| Colors don't affect ATS text parsing | Toptal (2025); general ATS documentation | Navy accent is purely visual — all text content parses identically to B&W |
| Separate "Core Competencies" keyword grids are outdated; single Skills section preferred | Toptal (2025), ResumeWorded (2026), ResumeFlex (2025) | Removed Core Competencies, expanded Technical Skills as single keyword hub |

### Resume Content Best Practices

| Finding | Source | How Applied |
|---|---|---|
| Quantify achievements with metrics (accuracy, cost savings, latency, scale) | ResumeWorded ML resume guide; Toptal (2025) | Every role has bold metrics: AUROC 0.95, 3x cost reduction, 100x optimization, 97% precision |
| "Show the impact of your ML projects" — tie to business outcomes | ResumeWorded | Bullets frame ML work in business terms (hours saved, approval rates, false positive reduction) |
| For senior roles, experience before education | Toptal (2025); ResumeWorded | Experience section precedes Education |
| Include relevant certifications inline or as short section | ResumeWorded; Toptal | Compact Certifications section with AI/ML-only certs |
| Recommendations add warmth and verifiability | ResumeFlex (2025) | Select Recommendations with verbatim quotes and attribution |
| Focus on 5-7 highly relevant competencies, not 20+ | ResumeFlex core competencies guide | Technical Skills has 7 focused categories, not a keyword dump |


## Section Order Rationale

```
Summary          → Primacy effect: anchors with metrics + IIT Madras brand
Technical Skills → ATS keyword hub; recruiter decides fit in seconds
Experience       → F-pattern hot zone on page 1; strongest content first
Education        → IIT Madras brand already anchored in summary; details here
Publications     → Research credibility (45 citations, h-index 4)
Open Source      → Demonstrates initiative beyond day job
Projects         → Academic/personal work with public repos
Certifications   → AI/ML-only credentials
Achievements     → GATE ranks, scholarships, recognition
Recommendations  → Recency effect: ends on warm, human note
```

## References

1. Labrecque, L. I., & Milne, G. R. (2012). Exciting red and competent blue: The importance of color in marketing. *Journal of the Academy of Marketing Science*, 40(5), 711–727.
2. Elliot, A. J., Maier, M. A., & Fiske, S. (2014). Color psychology: Effects of perceiving color on psychological functioning in humans. *Annual Review of Psychology*, 65(1), 95–120.
3. Wong, S. et al. (2024). Impact of Resume Color on Job Applicant Perception. CUHK Department of Psychology (PSYC 5160).
4. TheLadders (2018). Eye-Tracking Study: How Recruiters View Resumes. (n=30 recruiters, 10-week study with eye-tracking technology)
5. Wonsulting (2025). Hidden Eye Tracker: How Recruiters Actually Read Resumes. Jerry Lee.
6. ResumeHeatMap.com (2025). Resume Eye-Tracking Study: Where Recruiters Actually Look.
7. Panna.ai (2024). The Psychology of Resume Reading: Inside the Mind of a Hiring Manager.
8. Resumly.ai (2025). The Psychology of Resume Design: Fonts, Layouts, and First Impressions.
9. ResumeLab (2024). Best Resume Fonts Survey. (n=1,003 hiring managers)
10. Toptal TechResume (2025). The Perfect Tech Resume in 2025: Key Trends, ATS Keywords, and Formatting Tips.
11. ResumeWorded (2026). 5 Machine Learning Resume Examples.
12. ResumeFlex (2025). Core Competencies Section Examples and Best Practices.
13. Asch, S. E. (1946). Forming impressions of personality. *The Journal of Abnormal and Social Psychology*, 41(3), 258–290.
14. Nielsen Norman Group. F-Shaped Pattern of Reading on the Web.
15. McKinsey Global Institute. Skills-based hiring and the widening skills gap (87% of companies).
16. Gartner (2025). Future of Work Trends — hiring managers prioritize specific, in-demand tech skills.
17. StandOut CV. Resume Statistics — 61% of hiring managers say design impacts chances.
18. Wichita State University. Typography and legibility research.
19. Forbes (2021). 4 Cognitive Biases That Hijack Your Hiring Decisions.

## License

Personal resume. Not licensed for reuse of content. LaTeX tem
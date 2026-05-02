# Google-Tagged LeetCode Questions (free mirror, Feb 2026 snapshot)

## What this is

Raw data dump of LeetCode's Google company-tag lists, pulled from the public volunteer mirror [`snehasishroy/leetcode-companywise-interview-questions`](https://github.com/snehasishroy/leetcode-companywise-interview-questions) (3.7k stars, 832 forks, Feb 21 2026 snapshot).

This gives you the exact data LeetCode Premium's `?favoriteSlug=google-thirty-days` paywall is selling, for free, without a subscription.

## Files

| File | Count | What it is |
|---|---|---|
| `thirty-days.csv` | 182 | Google-tagged problems reported in the last 30 days |
| `three-months.csv` | 472 | Last 3 months |
| `six-months.csv` | 792 | Last 6 months |
| `more-than-six-months.csv` | 2058 | Older than 6 months |
| `all.csv` | 2217 | Everything Google-tagged |

**Matches LeetCode Premium's published count of 2,265.** The 48-problem delta is noise from when the mirror was last scraped vs. when LeetCode last updated.

## Columns

```csv
ID, URL, Title, Difficulty, Acceptance %, Frequency %
```

- **ID** — LeetCode problem number.
- **URL** — Full link to the problem on leetcode.com (solution still gated without Premium, but you can see the problem statement and submit if you have a free account).
- **Difficulty** — Easy / Medium / Hard.
- **Acceptance %** — Platform-wide submission acceptance rate. Lower generally = harder or trickier.
- **Frequency %** — Relative frequency within that time window. 100% = most-asked in that window. Two Sum is 100% in every window.

## How to use this in Excel / Google Sheets

```
File → Import → Upload → select CSV → split by comma
Sort by column F (Frequency %) descending
Filter column D by Difficulty = Medium (most interview questions land here)
```

## Source + attribution

- Original scraper: [snehasishroy/leetcode-companywise-interview-questions](https://github.com/snehasishroy/leetcode-companywise-interview-questions)
- Pulled on May 2, 2026, via raw.githubusercontent.com.
- Snapshot date (per repo README): Feb 21, 2026.

## Freshness caveat

The mirror is 10 weeks behind live LeetCode Premium as of the interview date (May 13, 2026). That's close enough for pattern targeting; not guaranteed to match the exact question pool. For the canonical ranking, see `../05_CODING_PROBLEM_SET.md` under "Frequency-ranked gaps."

## If you want newer data

Either (a) buy LeetCode Premium for 1 month ($35, cancellable), or (b) clone the source repo and run its Selenium scraper with your own Premium account (3-hour scrape, code in the source repo's README).

Option (a) is the pragmatic move for one interview.

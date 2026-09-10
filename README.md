<h1 align="center">Conversion Rate Analysis</h1>

## Background and Overview

Online retailers live and die by conversion rate — the share of browsing sessions that actually turn into a purchase. This project analyzes the UCI "Online Shoppers Purchasing Intention" dataset, 12,330 real browsing sessions from an online retailer, to understand which visitor types, timing patterns, traffic sources, and on-site behaviors are associated with higher conversion, and where the business should focus attention to lift it.

The analysis was built in DuckDB (SQL) and visualized in Power BI.

## Data Structure Overview

The raw data lives in a single table, `shoppers`, loaded from `online_shoppers_intention.csv`. Each row is one browsing session.
 
| Category | Fields | Description |
|---|---|---|
| Session behavior | `Administrative`, `Administrative_Duration`, `Informational`, `Informational_Duration`, `ProductRelated`, `ProductRelated_Duration` | Page counts and time spent across the three page types in the session |
| Engagement quality | `BounceRates`, `ExitRates`, `PageValues` | Google Analytics–style metrics on how engaged and valuable the session was |
| Session context | `Month`, `Weekend`, `SpecialDay` | Time-based fields, including closeness to a special shopping day |
| Technical context | `OperatingSystems`, `Browser`, `Region`, `TrafficType` | Anonymized numeric codes for the device and traffic source |
| Visitor context | `VisitorType` | New, Returning, or Other |
| Outcome | `Revenue` | Boolean flag for whether the session ended in a purchase — the conversion target |

From this table, a set of SQL views was built in `cr.sql`, each computing conversion rate (converted sessions / total sessions) sliced by one dimension: `cr_overall`, `cr_by_visitor_type`, `cr_by_month`, `cr_by_weekend`, `cr_by_traffic_type`, and `cr_by_region`. Two additional views, `behavior_by_revenue` and `behavior_by_visitor_type`, compare average on-site behavior (page values, exit rate, bounce rate, product page duration) between converters and non-converters, and across visitor types.

## Executive Summary

Overall conversion rate across the 12,330 sessions is **15.47%** (1,908 converted). Conversion is far from uniform: it more than doubles from a February low to a November peak, new visitors convert nearly twice as well as returning visitors despite browsing less, and weekend sessions slightly outperform weekdays. On-site behavior — especially page values and exit rate — separates converters from non-converters much more sharply than any demographic or traffic-source split. Region, by contrast, barely moves the needle.

![Dashboard: Conversion Rate, Total Sessions, Converted Sessions; Conversion Rate by Month, Conversion Rate by Visitor Type, Conversion Rate by Traffic Source, Conversion Rate by Weekdays vs. Weekend, Behavior by Revenue, Behavior by Visitor Type](exports/conversion_rate_dashboard.png)

## Insights Deep Dive

**Visitor type:**
New visitors convert at 24.91%, well ahead of returning visitors at 13.93% and the small "Other" group at 18.82%. New visitors also average higher page values (10.77 vs. 5.01) despite spending less than half the time on product pages (636 seconds vs. 1,289 seconds) — they browse less but more purposefully, while returning visitors spend longer without converting at the same rate.

**Seasonality:**
Conversion climbs steadily across the year, from a February low of 1.63% up to a November peak of 25.35%, consistent with a Black Friday / holiday shopping surge, before easing back to 12.51% in December.

**Weekend vs. weekday:**
Weekend sessions convert at 17.4% versus 14.89% on weekdays — a modest but consistent lift.

**Traffic source:**
Conversion by traffic type ranges widely, from 0% to 33.33%, but the extremes mostly sit on very small sample sizes (a handful of sessions each). The high-volume traffic types (1, 2, 3) show more stable, moderate rates between 8.77% and 21.65%, which is a more trustworthy read on source quality than the noisy extremes.

**Region:**
Conversion across the 9 regions ranges narrowly from 12.9% to 16.83% — geography is a weak differentiator here compared to visitor type or timing.

**On-site behavior:**
Converters look distinctly different from non-converters: average page values of 27.26 versus 1.98, exit rate of 0.02 versus 0.05, bounce rate of 0.01 versus 0.03, and longer product page duration (1,876 seconds versus 1,070 seconds). These behavioral signals track conversion far more tightly than any of the contextual splits above.

## Recommendations

Concentrate acquisition spend and merchandising pushes around the November holiday window, where conversion is more than double the annual baseline. Because new visitors convert at nearly twice the rate of returning ones, treat top-of-funnel acquisition as at least as valuable as retention — and investigate why returning visitors, who browse the longest, convert the least; this points to a re-engagement or personalization opportunity rather than a traffic-quality problem. Use page values and exit rate as real-time behavioral signals of conversion likelihood, since they outperform demographic and traffic-source splits as predictors. Treat traffic-type conversion rates from small-volume sources as directional only, not a basis for reallocating budget.

## Caveats and Assumptions

`TrafficType` and `Region` are anonymized numeric codes with no documented mapping to real channels or geographies, which limits how actionable those splits are. Several traffic-type segments have very few sessions, making their conversion rates unstable. The dataset covers a single retailer over roughly ten months (missing January), so seasonal patterns may not generalize to other businesses or time periods. The behavioral comparisons are associational, not causal — they describe what converters look like, not what necessarily drives conversion. Finally, the dataset has no revenue or order-value field, so this analysis speaks to conversion likelihood only, not revenue impact.
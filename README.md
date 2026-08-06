# Polypharmacy by pregnancy status in NHANES, August 2021-August 2023

## Overview

This reproducible cross-sectional analysis estimates past-30-day prescription-medication polypharmacy among US women aged 20-44 years, stratified by pregnancy status at the Mobile Examination Center (MEC).

It is inspired by Chang et al. (2023), but it is not a direct replication. This project uses the public NHANES August 2021-August 2023 release and `RIDEXPRG`, whereas the published study pooled earlier cycles and included women aged 15-44 years.

## Research question

What was the survey-weighted prevalence of polypharmacy, defined as use of two or more prescription medications in the past 30 days, among pregnant and non-pregnant women aged 20-44 years?

## Data and definitions

The analysis uses publicly available NHANES files:

- `DEMO_L.xpt`: demographics, pregnancy status at the MEC examination, interview weights, strata, and PSU.
- `RXQ_RX_L.xpt`: past-30-day prescription-medication use and categorized medication count.

Study population:

- female (`RIAGENDR = 2`);
- aged 20-44 years (`RIDAGEYR`);
- `RIDEXPRG = 1` (pregnant) or `RIDEXPRG = 2` (non-pregnant); and
- non-missing polypharmacy status.

`RIDEXPRG` combines self-reported pregnancy information at the examination with urine pregnancy-test information. It is not the same as the reproductive-questionnaire variable `RHD143`.

Polypharmacy is defined as two or more prescription medications in the past 30 days:

- `RXQ033 = 2` (no medication) is coded as `poly = 0`;
- `RXQ033 = 1` and `RXQ050 = 1` is coded as `poly = 0`;
- `RXQ033 = 1` and `RXQ050 = 2-5` is coded as `poly = 1`;
- `RXQ050 = 5` means five or more medications.

## Survey analysis

The analysis accounts for the NHANES complex survey design using:

- interview weight: `WTINT2YR`;
- pseudo-stratum: `SDMVSTRA`;
- pseudo-PSU: `SDMVPSU`.

Prevalence confidence intervals use `survey::svyciprop(..., method = "logit")`.

## Results

| Pregnancy status | Unweighted n | Weighted polypharmacy prevalence (95% CI) |
|---|---:|---:|
| Pregnant | 41 | 20.6% (8.4%-42.1%) |
| Non-pregnant | 1,062 | 34.7% (30.1%-39.7%) |

The pregnant-group estimate is imprecise because it contains 41 respondents and 10 polypharmacy events. This project reports descriptive prevalence estimates; it does not claim that differences between groups are statistically significant or causal.

## Repository files

```text
nhanes.R                         # main reproducible analysis
practice_association.R           # optional learning commands; not reported
docs/codebook.md                 # variable definitions and coding
outputs/table_primary_result.csv
outputs/table_medication_count_weighted.csv
outputs/figure_medication_count_weighted.png
```

Run `nhanes.R` from a folder containing the two NHANES XPT files. It creates the files in `outputs/`. `practice_association.R` is for learning the syntax of Rao-Scott testing and survey logistic regression only; it does not create repository outputs and its results are not reported.

## Limitations

- NHANES is cross-sectional; this analysis describes prevalence and does not establish causality.
- Pregnancy status is measured at the MEC examination and may differ from a reproductive-health questionnaire response at another time.
- The current NHANES medication file contains a categorized count rather than detailed medication names, so medication classes cannot be examined.
- The results should not be interpreted as a formal trend comparison with 1999-2016 estimates because the survey period, age range, and pregnancy definition differ.

## Data access and responsible sharing

Download the public source files directly from CDC:

- [NHANES August 2021-August 2023 data page](https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?BeginYear=2021)
- [Demographics (`DEMO_L`) documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DEMO_L.htm)
- [Prescription Medications (`RXQ_RX_L`) documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/RXQ_RX_L.htm)

## Reference

Chang YC, Huang HY, Shen TH, et al. Prevalence, trends, and characteristics of polypharmacy among US pregnant women aged 15 to 44 years: NHANES 1999 to 2016. *Medicine*. 2023;102(22):e33828. [Full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC10238014/)

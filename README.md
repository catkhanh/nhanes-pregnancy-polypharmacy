# Polypharmacy among pregnant women in NHANES, August 2021–August 2023

## Overview

This reproducible analysis estimates the prevalence of prescription-medication polypharmacy among US pregnant women aged 15–44 years in the National Health and Nutrition Examination Survey (NHANES) August 2021–August 2023 cycle.

The project is inspired by Chang et al. (2023), *Prevalence, trends, and characteristics of polypharmacy among US pregnant women aged 15 to 44 years: NHANES 1999 to 2016*. It is an updated descriptive analysis, not a direct replication: medication data collection differs in the current cycle.

## Research question

What was the survey-weighted prevalence of polypharmacy—defined as use of two or more prescription medications in the past 30 days—among women aged 15–44 years who reported that they were currently pregnant?

## Data sources and access

The analysis uses the NHANES August 2021–August 2023 files:

- `DEMO_L.xpt`: demographic variables, interview weights, strata, and primary sampling units.
- `RXQ_RX_L.xpt`: past-30-day prescription-medication use and number of prescription medications.
- `RHQ_L_R.xpt`: reproductive-health data, including current self-reported pregnancy status (`RHD143`).

## Study population

The primary analytic population is women who meet all of the following criteria:

- female (`RIAGENDR = 2`);
- aged 15–44 years (`RIDAGEYR`);
- reported being currently pregnant (`RHD143 = 1`); and
- had non-missing polypharmacy status.


## Outcome definition

Prescription medication use refers to the **past 30 days**.

- `RXQ033 = 2` (no prescription medication) is coded as no polypharmacy.
- `RXQ050 = 1` is coded as no polypharmacy.
- `RXQ050 = 2`, `3`, `4`, or `5` (where `5` means five or more medications) is coded as polypharmacy.
- Refused, don't know, and other missing responses are coded as missing.

Thus, polypharmacy is defined as use of **at least two prescription medications in the past 30 days**. It should not be interpreted as medication use across the entire pregnancy.

## Survey design and analysis

Because NHANES uses a complex, multistage probability sample, estimates use the interview weight (`WTINT2YR`), masked pseudo-stratum (`SDMVSTRA`), and masked pseudo-PSU (`SDMVPSU`). The `survey` R package is used to define the survey design before subsetting the analytic population.

The primary estimate is obtained with a survey-weighted proportion. A logit confidence interval should be reported for the binary outcome (for example, with `svyciprop(..., method = "logit")`), rather than a Wald interval that can produce an impossible negative lower bound with this small sample.

## Preliminary result

Among 30 unweighted pregnant women aged 15–44 years with complete outcome data, 7 met the definition of polypharmacy. The survey-weighted prevalence was **16.2%**.

This point estimate is imprecise because of the very small number of pregnant participants and polypharmacy events. The confidence interval should be generated and reported using the logit survey method in the final analysis output.

## Interpretation

The 16.2% estimate is numerically higher than the 10.0% prevalence reported for 2015–2016 by Chang et al. However, it should not be interpreted as evidence of an increase over time:

1. The current analysis has only 30 pregnant participants and 7 outcome events.
2. The estimate therefore has a wide confidence interval.
3. The medication data are not fully comparable across NHANES cycles. Earlier cycles recorded detailed medication information, whereas the August 2021–August 2023 prescription-medication file provides self-reported medication use and a categorized count, without detailed drug names or active ingredients.

## Why associations are not modelled

This project does not fit univariable screening models or a multivariable logistic regression model for factors associated with polypharmacy. With only 7 polypharmacy events, such models would be severely underpowered and unstable; null or non-significant findings would not demonstrate the absence of associations.

Descriptive summaries of pre-specified covariates may still be presented with unweighted counts and survey-weighted percentages, but they are exploratory and should not be interpreted as reliable association tests.

## Important comparison caveat

`RHD143 = 2` identifies women who answered that they were not currently pregnant. It does not represent all non-pregnant women aged 15–44 years, because women who were not asked this item may have missing `RHD143`. For this reason, comparison with an overall “non-pregnant women” group is not a primary analysis in this project.

## Suggested repository structure

```text
.
├── README.md
├── R/
│   ├── 01_import_merge.R
│   ├── 02_define_variables.R
│   ├── 03_survey_prevalence.R
│   └── 04_create_figures.R
├── data-raw/
│   └── README.md              # data access instructions; no participant data
├── output/
│   ├── table_primary_result.csv
│   └── figure_medication_count.png
└── renv.lock                  # optional: R package reproducibility
```

## Results

Among women aged 20–44 years, the survey-weighted prevalence of
polypharmacy was:

| Pregnancy status | Unweighted n | Polypharmacy prevalence (95% CI) |
|---|---:|---:|
| Pregnant | 30 | 16.2% (4.1%–46.5%) |
| Non-pregnant | 536 | 31.9% (26.7%–37.6%) |

Confidence intervals were estimated using `svyciprop()` with the logit method.

## References

1. Chang YC, Huang HY, Shen TH, et al. Prevalence, trends, and characteristics of polypharmacy among US pregnant women aged 15 to 44 years: NHANES 1999 to 2016. *Medicine*. 2023;102(22):e33828. [Full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC10238014/)
2. National Center for Health Statistics. [Prescription Medications (RXQ_RX_L) documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/RXQ_RX_L.htm).
3. National Center for Health Statistics. [Reproductive Health (RHQ_L_R) documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/RHQ_L_R.htm).

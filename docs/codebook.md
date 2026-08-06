# Codebook

## Study population and outcome

| Variable | Source file | Coding used in this project | Role / note |
|---|---|---|---|
| `SEQN` | `DEMO_L.xpt` and all component files | Unique participant identifier | Join key; one record per participant is expected in each component file. |
| `RIAGENDR` | `DEMO_L.xpt` | `2 = female` | Eligibility criterion. |
| `RIDAGEYR` | `DEMO_L.xpt` | 15–44 years | Eligibility criterion; also recoded as `<25`, `25–34`, and `≥35`. |
| `RHD143` | `RHQ_L.xpt` / `RHQ_L_R.xpt` | `1 = currently pregnant`; `2 = not currently pregnant`; 7/9 = missing | Defines current self-reported pregnancy. The official 2021–2023 RHD143 file is RDC-only. `RHD143 = 2` is not a complete comparison group of all non-pregnant women. |
| `RXQ033` | `RXQ_RX_L.xpt` | `2 = no` prescription medication → `poly = 0` | Medication use in the past 30 days. |
| `RXQ050` | `RXQ_RX_L.xpt` | `1` → `poly = 0`; `2–5` → `poly = 1`; `5 = 5+`; 7/9 = missing | Number of prescription medications in the past 30 days. |
| `poly` | Derived | `1 = ≥2` prescription medications; `0 = 0–1` medication | Primary outcome. It does not describe medication use across the entire pregnancy. |

## Survey design variables

| Variable | Source file | Use |
|---|---|---|
| `WTINT2YR` | `DEMO_L.xpt` | Full-sample 2-year interview weight. |
| `SDMVSTRA` | `DEMO_L.xpt` | Masked variance pseudo-stratum. |
| `SDMVPSU` | `DEMO_L.xpt` | Masked variance pseudo-PSU. |

These are specified in `survey::svydesign()` before subsetting the analytic population.

## Descriptive health covariates

| Derived variable | Source variable(s) | Project coding |
|---|---|---|
| `blood_pressure` | `BPQ020` in `BPQ_L.xpt` | `1 = yes`, `2 = no`; other responses missing. |
| `diabetes` | `DIQ010` in `DIQ_L.xpt` | `1 = doctor-diagnosed diabetes`; `2 = no` and `3 = borderline` are coded 0; other responses missing. |
| `asthma` | `MCQ010` in `MCQ_L.xpt` | `1 = yes`, `2 = no`; other responses missing. |
| `arthritis` | `MCQ160A` in `MCQ_L.xpt` | `1 = yes`, `2 = no`; other responses missing. |
| `poor_fair_health` | `HUQ010` in `HUQ_L.xpt` | `1 = fair/poor` (`4` or `5`); `0 = excellent/very good/good` (`1–3`). |
| `insurance` | `HIQ011` in `HIQ_L.xpt` | `1 = covered`; `0 = not covered`; other responses missing. |
| `chronic` | `blood_pressure`, `diabetes`, `asthma`, `arthritis` | `1 = at least one` condition; `0 = none`; missing if any component is missing. |

## Other descriptive covariates

| Variable | Source | Project coding / note |
|---|---|---|
| `RIDRETH1` | `DEMO_L.xpt` | Retained using NHANES race/Hispanic-origin categories. |
| `marital` | `DMDMARTZ` in `DEMO_L.xpt` | Married/living with partner vs widowed/divorced/separated or never married. Released for age 20+ only. |
| `pir_cat` | `INDFMPIR` in `DEMO_L.xpt` | `<1.30`, `1.30–3.49`, `≥3.50`. |
| `num_meds` | `RXQ033` + `RXQ050` | 0, 1, 2, 3, 4, or 5+ medications; used only in the unweighted distribution figure. |

## Project limitations

- The preliminary primary analysis contains 30 pregnant participants and 7 polypharmacy events.
- Regression models for associated factors are not estimated because the event count is too small for stable inference.

## Sources

- [NHANES August 2021–August 2023 documentation](https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?BeginYear=2021)
- [Prescription Medications (`RXQ_RX_L`) documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/RXQ_RX_L.htm)
- [Reproductive Health (`RHQ_L_R`) documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/RHQ_L_R.htm)

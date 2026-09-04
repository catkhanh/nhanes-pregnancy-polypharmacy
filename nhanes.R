# NHANES August 2021-August 2023
# Survey-weighted prescription polypharmacy prevalence among U.S. women aged 20-44 years.
# Pregnancy status is based on RIDEXPRG at the MEC examination.

# =============================================================================
# 1. Packages and files
# =============================================================================

library(dplyr)
library(haven)
library(survey)

# Input XPT files are expected in the working directory.
# Derived outputs are written to outputs/.
dir.create("outputs", showWarnings = FALSE)

demo <- read_xpt("DEMO_L.xpt")
med  <- read_xpt("RXQ_RX_L.xpt")

# =============================================================================
# 2. Data preparation
# =============================================================================

nhanes <- demo %>%
  left_join(
    med %>% select(SEQN, RXQ033, RXQ050),
    by = "SEQN"
  ) %>%
  mutate(
    # Recode pregnancy status; 3 = cannot ascertain.
    pregnant = case_when(
      RIDEXPRG == 1 ~ 1L,
      RIDEXPRG == 2 ~ 0L,
      TRUE ~ NA_integer_
    ),

    # Treat non-substantive medication-count codes as missing.
    RXQ050 = if_else(RXQ050 %in% c(7, 9), NA_real_, RXQ050),

    # Define polypharmacy as use of two or more prescription medicines in the past 30 days.
    poly = case_when(
      RXQ033 == 2 ~ 0L,
      RXQ033 == 1 & RXQ050 == 1 ~ 0L,
      RXQ033 == 1 & RXQ050 %in% 2:5 ~ 1L,
      TRUE ~ NA_integer_
    ),

    # Preserve medication-count categories for descriptive estimates.
    num_meds = case_when(
      RXQ033 == 2 ~ 0,
      RXQ033 == 1 ~ RXQ050,
      TRUE ~ NA_real_
    ),

    pregnancy_group = factor(
      pregnant,
      levels = c(1, 0),
      labels = c("Pregnant", "Non-pregnant")
    ),
    num_meds_cat = factor(
      num_meds,
      levels = 0:5,
      labels = c("0", "1", "2", "3", "4", "5+")
    )
  )

# =============================================================================
# 3. Survey design and study population
# =============================================================================

NHANES_all <- svydesign(
  data = nhanes,
  id = ~SDMVPSU,
  strata = ~SDMVSTRA,
  weights = ~WTINT2YR,
  nest = TRUE
)

# Restrict to women aged 20-44 years.
NHANES_women <- subset(
  NHANES_all,
  RIAGENDR == 2 & RIDAGEYR >= 20 & RIDAGEYR <= 44
)

# Retain participants with known pregnancy status and polypharmacy outcome.
NHANES_status <- subset(
  NHANES_women,
  pregnant %in% c(0, 1) & !is.na(poly)
)
NHANES_preg <- subset(NHANES_status, pregnant == 1)
NHANES_nonpreg <- subset(NHANES_status, pregnant == 0)

# =============================================================================
# 4. Survey-weighted prevalence of polypharmacy
# =============================================================================

# Use logit confidence intervals for weighted prevalence estimates.
preg_prev <- svyciprop(~poly, design = NHANES_preg, method = "logit")
nonpreg_prev <- svyciprop(~poly, design = NHANES_nonpreg, method = "logit")

preg_ci <- confint(preg_prev)
nonpreg_ci <- confint(nonpreg_prev)

primary_result_table <- data.frame(
  pregnancy_group = c("Pregnant", "Non-pregnant"),
  unweighted_n = c(nrow(NHANES_preg$variables), nrow(NHANES_nonpreg$variables)),
  weighted_prevalence_pct = round(100 * c(preg_prev, nonpreg_prev), 1),
  ci_lower_pct = round(100 * c(preg_ci[1, 1], nonpreg_ci[1, 1]), 1),
  ci_upper_pct = round(100 * c(preg_ci[1, 2], nonpreg_ci[1, 2]), 1),
  ci_method = "logit"
)

primary_result_table
write.csv(
  primary_result_table,
  "outputs/table_primary_result.csv",
  row.names = FALSE
)

# =============================================================================
# 5. Survey-weighted medication-count distribution
# =============================================================================

NHANES_status_meds <- subset(NHANES_women, pregnant %in% c(0, 1) & !is.na(num_meds))

med_count_wt <- svytable(
  ~pregnancy_group + num_meds_cat,
  design = NHANES_status_meds
)
med_count_wt_pct <- prop.table(med_count_wt, margin = 1) * 100

medication_count_table <- as.data.frame.matrix(round(med_count_wt_pct, 1))
medication_count_table <- cbind(
  pregnancy_group = rownames(medication_count_table),
  medication_count_table
)
rownames(medication_count_table) <- NULL

medication_count_table
write.csv(
  medication_count_table,
  "outputs/table_medication_count_weighted.csv",
  row.names = FALSE
)

# Save the weighted medication-count distribution plot.
png(
  filename = "outputs/figure_medication_count_weighted.png",
  width = 1600,
  height = 1000,
  res = 200
)
bar_positions <- barplot(
  med_count_wt_pct,
  beside = TRUE,
  border = "black",
  ylim = c(0, 70),
  xlab = "Number of prescription medications used in the past 30 days",
  ylab = "Survey-weighted percentage",
  legend.text = rownames(med_count_wt_pct)
)
text(
  x = bar_positions,
  y = med_count_wt_pct + 0.5,
  labels = sprintf("%.1f%%", med_count_wt_pct),
  pos = 3,
  cex = 0.6
)
mtext(
  "Women aged 20-44 years; pregnancy status at the MEC examination.",
  side = 1,
  line = 4,
  cex = 0.7
)
dev.off()


# Practice only: survey association commands
#
# This file is NOT part of the reported analysis. It does not create or save
# association results for the GitHub repository.
# Run the main script first so the survey-design objects are available.

library(survey)

# Rao-Scott test: polypharmacy by pregnancy status.
svychisq(
  ~poly + pregnant,
  design = NHANES_status,
  statistic = "F"
)

# Unadjusted survey-weighted logistic regression.
svyglm(
  poly ~ pregnant,
  design = NHANES_status,
  family = quasibinomial()
)

# Do not fit a multivariable model among pregnant women for this project.
# There are only 41 pregnant respondents and 10 polypharmacy events.
# The following is a syntax template for a future dataset with adequate size:

# svyglm(
#   poly ~ age_cat + chronic + insurance,
#   design = NHANES_preg,
#   family = quasibinomial()
# )

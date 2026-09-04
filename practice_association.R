# Practice : survey association commands
#


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

# I did not fit a multivariable model among pregnant women for this project.
# There are only 41 pregnant respondents and 10 polypharmacy events.
# The following is a syntax template for a future dataset with adequate size:

# svyglm(
#   poly ~ age_cat + chronic + insurance,
#   design = NHANES_preg,
#   family = quasibinomial()
# )

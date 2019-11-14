library(brms)
library(cowplot)
library(dplyr)
library(ggplot2)
library(magrittr)
library(readr)
library(stringr)
library(tibble)
library(tidyr)

phykaainfect <- read_csv(
  "processed-data.csv", 
  col_types = 
    cols(
      DiseaseSeverity = col_double(),
      AMF = col_logical(),
      M_aphidis = col_logical(),
      Population = col_character(),
      Treatment = col_factor(levels = c("Control", "AMF", "M. aphidis", 
                                        "AMF + M. aphidis"))
    )
) %>%
  mutate(perc_infect = 100 * DiseaseSeverity)

fit4 <- read_rds("objects/fit4.rds")
fit5 <- read_rds("objects/fit5.rds")

# Figure of pooled data ----

## Fixed effects
fe <- fixef(fit4) %>%
  as.data.frame() %>%
  rownames_to_column("treatment") %>%
  dplyr::filter(
    treatment %in% c("AMFTRUE", "M_aphidisTRUE", "AMFTRUE:M_aphidisTRUE")
  ) %>%
  mutate(
    Treatment = str_remove_all(treatment, "TRUE"),
    Treatment = str_replace_all(Treatment, "_", ". "),
    Treatment = factor(Treatment, levels = c("AMF:M. aphidis", "M. aphidis", "AMF")),
    label = c("", "*", "")
  )

cols1 <- hcl(h = seq(105, 375, length = 4), l = 65, c = 100)[3:1]
cols2 <- hcl(h = seq(15, 375, length = 5), l = 65, c = 100)[1:4]

pooled_fe <- ggplot(
    data = fe, 
    aes(y = Treatment, x = Estimate, xmin = `Q2.5`, xmax = `Q97.5`,
        fill = Treatment, label = label)
  ) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_errorbarh(height = 0.2, size = 2, color = "black") +
  geom_point(color = "black", size = 6, pch = 21, stroke = 2) +
  geom_text(mapping = aes(y = Treatment, x = `Q97.5`, label = label), inherit.aes = FALSE, nudge_x = 0.15, nudge_y = -0.15, size = 20) +
  scale_fill_manual(values = cols1) +
  scale_x_continuous(limits = c(-1, 1)) +
  xlab(expression(atop("Effect on Disease Severity", "[logit-link]"))) +
  theme(
    axis.line = element_line(colour = "black"),
    axis.text = element_text(colour = "black", size = 15),
    axis.title.y = element_blank(),
    legend.position = "none",
    panel.background = element_blank(),
    panel.border = element_blank(), 
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), 
    text = element_text(colour = "black", size = 20) 
  )

## dot plot

new <- crossing(
  AMF = c(TRUE, FALSE),
  M_aphidis = c(TRUE, FALSE)
)

df_means <- predict(
  object = fit5, 
  newdata = new,
  probs = c(0.025, 0.25, 0.75, 0.975)
) %>%
  as.data.frame() %>%
  bind_cols(new) %>%
  mutate_if(is.numeric, multiply_by, e2 = 100) %>%
  rename(perc_infect = Estimate) %>%
  mutate(Treatment = case_when(
    !AMF & !M_aphidis ~ "Control",
    AMF & !M_aphidis ~ "AMF",
    !AMF & M_aphidis ~ "M. aphidis",
    AMF & M_aphidis ~ "AMF + M. aphidis"
  )) %>%
  mutate(
    Treatment = factor(Treatment, levels = levels(phykaainfect$Treatment))
  )

pooled_dot_plot <- ggplot(
    data = phykaainfect, 
    aes(x = Treatment, y = perc_infect, colour = Treatment)
  ) +
  geom_point(
    pch = 16, size = 3, alpha = 0.5, position = position_jitterdodge()
  ) +
  geom_linerange(
    data = df_means,
    mapping = aes(ymin = `Q2.5`, ymax = `Q97.5`),
    size = 2, color = "black", alpha = 0.5
  ) +
  # geom_linerange(
  #   data = df_means,
  #   mapping = aes(ymin = `Q25`, ymax = `Q75`),
  #   size = 4, color = "black", alpha = 0.5
  # ) +
  geom_point(
    data = df_means,
    mapping = aes(fill=Treatment),
    color = "black", size = 6, pch = 21, stroke = 2
  ) +
  scale_fill_manual(values = cols2) +
  scale_y_continuous(breaks = seq(0, 35, by = 5)) +
  ylab("Disease Severity (%)") +
  theme(
    axis.line = element_line(colour = "black"),
    axis.text.x = element_text(
      angle = 45, hjust = 1, colour = "black", size = 15
    ),
    axis.text.y = element_text(colour = "black", size = 15),
    axis.title.x = element_blank(),
    legend.key.height = unit(1, "cm"),
    legend.key = element_blank(),
    panel.background = element_blank(),
    panel.border = element_blank(), 
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), 
    text = element_text(colour = "black", size = 20) 
  )

l <- get_legend(pooled_dot_plot)
p1 <- pooled_dot_plot + theme(legend.position = "none")
p2 <- plot_grid(pooled_fe, l, ncol = 1)
p <- plot_grid(p1, p2, labels = "auto", rel_widths = c(1, 1))

ggsave("pooled_phykaa_disease_severity_dotplot.tiff", 
       plot = p, width = 10, height = 8)

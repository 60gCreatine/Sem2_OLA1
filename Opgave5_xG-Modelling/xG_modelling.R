#### Opgave 5.1 - Opdeling i trænings- og testdata for skud ####
# Hent alle skud for den polske og hollandske liga og opdel skuddene i trænings- og testdata. 
# Forklar jeres fremgangsmåde. 
# (Hint: det er fx ikke sikkert en tilfældig 70/30 fordeling er den ideelle løsning)

##### TO DO #####
######Mongo call ######
######Clear id for polish and dutch ######
######Clear that it is only shots ######
      # filter by primary shot
######Which season ######
      # Season 2021/2022
######Dead ball situations with or not ######
######Amount of obs and so on ######
######ONLY DESCRIBE X-VARIABLES! ######



unique(allmatches$competitionId)
# May not be relevant, can just filter on label
allmatches <- allmatches %>%
  mutate(
    home_team = trimws(str_extract(label, "^[^-]+")),  # Extract and trim first team name
    away_team = trimws(str_extract(label, "(?<=– ).*?(?=,)")),  # Extract and trim second team name
    home_goals = as.numeric(str_extract(label, "(?<=, )\\d+(?=-)")),  # First digit after comma
    away_goals = as.numeric(str_extract(label, "(?<=-)\\d+"))  # Number after hyphen
  )

## Remove dead ball
# free_kick, corner, penalty
# throw_in gives problems
dead_balls <- c("free_kick","corner","penalty")
nrow(allshot_flat)
# 21069 shots
allshot_xG <- allshot_flat %>%
  filter(
    str_detect(type.secondary, "shot_after_") | 
      !str_detect(possession.types, paste(dead_balls, collapse = "|"))
  )
nrow(allshot_xG)
# 18419

dutch_id <- 635
polish_id <- 692

## only for season 2021/2022 
dutch_matches <- allmatches %>% filter(competitionId == dutch_id)
dutch_matches_2122 <- dutch_matches %>% filter(seasonId == 187502)
dutch_teams <- dutch_matches_2122$home_team
polish_matches <- allmatches %>% filter(competitionId == polish_id)
polish_matches_2122 <- polish_matches %>% filter(seasonId == 186215)
polish_teams <- polish_matches_2122$home_team


dutch_shot <- allshot_xG%>% filter(team.name %in% dutch_teams)
polish_shot <- allshot_xG %>% filter(team.name %in% polish_teams)





#### 5.2 ####








####  Training vs Test Data ####
# Sample size
set.seed(123)
smp_size <- floor(0.7*nrow(allshot_flat))

# set seed
train_ind <- sample(seq_len(nrow(allshot_flat)), size = smp_size)

train <- allshot_flat[train_ind, ]
test <- allshot_flat[-train_ind, ]


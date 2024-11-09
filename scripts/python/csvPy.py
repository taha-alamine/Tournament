import csv
import pandas as pd


#with open('/Users/tboukhalf/Downloads/fifa-world-cup-2022-dataset (2).csv', newline='') as csvfile:
df = pd.read_csv('/Users/tboukhalf/Downloads/fifa-world-cup-2022-dataset (2).csv')


# Extract team-group pairs from both Home Team and Away Team columns
home_teams = df[['Home Team', 'Group']].rename(columns={'Home Team': 'Team'})
away_teams = df[['Away Team', 'Group']].rename(columns={'Away Team': 'Team'})

# Combine both DataFrames and drop duplicates
teams_groups = pd.concat([home_teams, away_teams]).drop_duplicates().dropna(subset=['Group'])

# Sort by team name
teams_groups = teams_groups.sort_values(by='Team').reset_index(drop=True)

# Display the result
#print(teams_groups)
teams_groups.to_csv("out.csv", sep='\t', encoding='utf-8', index=False)
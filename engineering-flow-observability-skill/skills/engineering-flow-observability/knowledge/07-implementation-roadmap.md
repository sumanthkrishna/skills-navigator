# 07 — Implementation Roadmap

## Phase 1 — MVP

- Input: Jira story ID, repo, PR ID, build ID, pipeline ID
- Output: Markdown report
- Use manually supplied IDs
- No dashboard yet

## Phase 2 — Automatic Correlation

- Infer PRs from Jira ID
- Infer build from PR commit SHA
- Infer Spinnaker pipeline from build artifact
- Add confidence score for correlations

## Phase 3 — Sprint Aggregation

- Pull all Jira stories for sprint
- Generate team-level bottleneck report
- Identify repeated delays by category

## Phase 4 — Dashboard

- Store events in PostgreSQL
- Add Grafana / Streamlit / React dashboard
- Trend bottlenecks across sprints

## Phase 5 — Copilot Assistant

- Ask questions such as:
  - Why was PAY-1234 delayed?
  - Which PRs waited longest this sprint?
  - Which Jenkins jobs are slowing the team?
  - Which stories had Sonar rework?

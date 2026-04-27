# 05 – Dashboard Schema

The dashboard should be simple enough for daily engineering standups and detailed enough for lead action.

## Markdown Table Columns

| Column | Description |
|---|---|
| Priority | P0, P1, P2, P3 |
| Source | Jira, Bitbucket PR, Commit, Pipeline |
| Item | Jira key or PR reference |
| Title | Issue or PR title |
| Latest Signal | Plain-English interpretation of latest comment |
| Action Required | Clear next action |
| Owner | Person or team expected to act |
| Due | Today, tomorrow, date, or sprint day |
| Status | Blocked, At Risk, Waiting, Needs Review, Ready to Close |
| Confidence | High, Medium, Low |
| Evidence | Short comment excerpt or link reference |

## JSON Schema

```json
{
  "generated_at": "2026-04-27T08:00:00-04:00",
  "dashboard": [
    {
      "priority": "P1",
      "source": "Jira",
      "item_id": "PAY-1421",
      "title": "Add payment retry support",
      "latest_signal": "API contract is still unclear",
      "action_required": "Schedule API alignment and update acceptance criteria",
      "owner": "Tech Lead / API Owner",
      "due": "Today",
      "status": "Blocked",
      "confidence": "High",
      "evidence": "Latest comment says waiting on API response schema"
    }
  ]
}
```

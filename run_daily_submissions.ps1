# Run daily Arena submissions for all currently open challenges.
# Schedule at 11:30 CET (see README or SCHEDULE.md).
# Put ARENA_API_KEY in local .env (same folder).
# The default baseline source is SMARD; ENTSOE_API_KEY is optional.
# Use --use_global_env only if you want fallback to system/user env vars.
# Pass --data_source entsoe only if you explicitly want ENTSO-E.

Set-Location $PSScriptRoot
& python run_daily_submissions.py @args
exit $LASTEXITCODE

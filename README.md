# Energy Arena — Participate with one script

Submit a day-ahead forecast to the Energy Arena by running one Python script locally.  
Uses ENTSO-E data: d-1 for price, d-2 for load and solar (same logic as BAREF `submit_d1_forecast`).

## What you need

- Python 3.10+ (for `zoneinfo`)
- `ENTSOE_API_KEY` (ENTSO-E Transparency Platform API key)
- Arena API key
- Arena base URL (default: `https://api.energy-arena.org`)

## Quick start

### 1) Clone/download and install dependencies

```bash
git clone <this-repo-url> energy-arena-participate
cd energy-arena-participate
pip install -r requirements.txt
```

### 2) Create local `.env` (recommended)

Copy `.env.example` to `.env` and set your keys:

```bash
cp .env.example .env
```

```env
ENTSOE_API_KEY=your_entsoe_api_key_here
ARENA_API_KEY=your_arena_api_key_here
ARENA_API_BASE_URL=https://api.energy-arena.org
```

Both scripts read `.env` automatically.  
This lets you use different API keys per repo on the same machine.

Optional: allow fallback to global environment variables with `--use_global_env`.

### 3) Submit one forecast

```bash
python submit_forecast.py --target_date 20-02-2026 --challenge_id day_ahead_price --area DE_LU
```

- `target_date`: `DD-MM-YYYY`
- `challenge_id`: `day_ahead_price` | `day_ahead_load` | `day_ahead_solar`
- `area`: `DE_LU` | `AT`

Optional overrides:

```bash
python submit_forecast.py --target_date 20-02-2026 --challenge_id day_ahead_price --area DE_LU --api_key YOUR_KEY --api_base https://api.energy-arena.org
```

Dry run:

```bash
python submit_forecast.py --target_date 20-02-2026 --dry_run
```

### 4) Daily run at 11:30 CET (all 3 challenges × 2 areas)

```bash
python run_daily_submissions.py
```

- Default target date: tomorrow (Europe/Berlin)
- Optional: `--target_date DD-MM-YYYY`
- Optional: `--dry_run`
- Optional: `--use_global_env`

## Scheduling

- Windows (detailed): `WINDOWS_TASK_SCHEDULER.md`
- All platforms (short reference): `SCHEDULE.md`
- Launchers: `run_daily_submissions.bat`, `run_daily_submissions.ps1`

## What the script does

1. Fetches ENTSO-E data:
   - `day_ahead_price`: d-1 day-ahead prices
   - `day_ahead_load`: d-2 actual load
   - `day_ahead_solar`: d-2 actual solar generation
2. Shifts timestamps to target date (`Europe/Berlin`)
3. POSTs to `{ARENA_API_BASE_URL}/api/v1/submissions` with header `X-API-Key`

## Repository layout

- `submit_forecast.py` — single submission
- `run_daily_submissions.py` — daily batch submission (3 challenges × 2 areas)
- `run_daily_submissions.bat` / `run_daily_submissions.ps1` — scheduler-friendly launchers
- `SCHEDULE.md` — scheduling reference (Windows + cron)
- `WINDOWS_TASK_SCHEDULER.md` — step-by-step Windows setup
- `.env.example` — local config template
- `requirements.txt` — dependencies

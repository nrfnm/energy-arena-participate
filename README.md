# Energy Arena Participate

Submit forecasts to Energy Arena with one local Python script.

The built-in baseline is now **SMARD-first**:

- default: `smard` baseline, no extra data key required
- optional: `entsoe` baseline, requires `ENTSOE_API_KEY`

The script resolves the selected challenge from the live Energy Arena API, reads
its accepted forecast format, and then builds the payload automatically for
point, quantile, or ensemble challenges.

## What you need for a first submission

- Python 3.10+
- `ARENA_API_KEY`
- optional `ENTSOE_API_KEY` only if you explicitly want `--data_source entsoe`

## Student path

Use this flow for the shortest route to a first successful submission:

1. Copy `.env.example` to `.env`
2. Fill `ARENA_API_KEY`
3. Run `python submit_forecast.py --check_setup`
4. Run `python submit_forecast.py --list_open_challenges`
5. Do one dry run
6. Submit one real forecast

Minimal commands:

```bash
python submit_forecast.py --check_setup
python submit_forecast.py --list_open_challenges
python submit_forecast.py --target_date 27-03-2026 --challenge_id 1 --dry_run --save_payload test_payload.txt
python submit_forecast.py --target_date 27-03-2026 --challenge_id 1
```

## Quick start

### 1) Clone/download and install dependencies

```bash
git clone <this-repo-url> energy-arena-participate
cd energy-arena-participate
pip install -r requirements.txt
```

Optional conda environment:

```bash
conda create --name energyarena python=3.10
conda activate energyarena
pip install -r requirements.txt
```

### 2) Create local `.env`

```bash
# Windows PowerShell
Copy-Item .env.example .env

# macOS / Linux
cp .env.example .env
```

Example:

```env
ARENA_API_KEY=your_arena_api_key_here
ARENA_API_BASE_URL=https://api.energy-arena.org
BASELINE_DATA_SOURCE=smard

# Optional only for --data_source entsoe
# ENTSOE_API_KEY=your_entsoe_api_key_here
```

Both scripts read `.env` automatically.

### 3) Check your setup

```bash
python submit_forecast.py --check_setup
```

This verifies:

- whether `.env` exists
- whether `ARENA_API_KEY` is available
- whether the open challenge catalog can be reached
- whether a local `custom_model.py` is picked up successfully
- whether your chosen default baseline source is usable

### 4) Inspect open challenges

```bash
python submit_forecast.py --list_open_challenges
```

The table shows:

- `challenge_id`
- target / challenge name
- area
- accepted forecast format
- baseline source (`smard` or `entsoe`)
- next submission deadline
- next target start

Use one of the printed `challenge_id` values in the next step.

### 5) Submit one forecast

```bash
python submit_forecast.py --target_date 27-03-2026 --challenge_id 1
```

Notes:

- `target_date` must be tomorrow's date for day-ahead challenges
- the script resolves the challenge format automatically
- the preferred submission payload is compact: `challenge_id + target_date + values`
- for current single-area challenges, you normally do **not** need `--area`
- the built-in baseline uses `smard` by default

Dry run:

```bash
python submit_forecast.py --target_date 27-03-2026 --challenge_id 1 --dry_run
```

Dry run and save locally:

```bash
python submit_forecast.py --target_date 27-03-2026 --challenge_id 1 --dry_run --save_payload payload.txt
```

Optional ENTSO-E mode:

```bash
python submit_forecast.py --target_date 27-03-2026 --challenge_id 1 --data_source entsoe
```

Use this only if:

- the selected challenge does not expose a confirmed SMARD counterpart, or
- you explicitly want to build the baseline from ENTSO-E data

## Current built-in baseline behavior

Point baseline:

- day-ahead price: previous day price values (`d-1`)
- total load: previous actual load values with the current lookback pattern
- solar generation: previous actual solar values
- wind generation: previous actual wind values

Probabilistic baseline:

- quantile challenges: quantiles are estimated from historical analog values
- ensemble challenges: ensemble members are drawn from historical analog values
- price/load use weekly analog history
- solar/wind use daily submission-aware analog history

The script reads the required quantiles or ensemble size directly from the live
challenge detail endpoint.

## Integrate your own model

If you want to replace the built-in baseline with your own model:

1. Copy `custom_model_template.py` to `custom_model.py`
2. Edit `transform_payload(...)`
3. Validate with `--dry_run --save_payload ...`
4. Submit one manual forecast
5. Only then enable daily automation

Copy commands:

```bash
# Windows PowerShell
Copy-Item custom_model_template.py custom_model.py

# macOS / Linux
cp custom_model_template.py custom_model.py
```

Detailed guide:

- `MODEL_INTEGRATION.md`

## Daily automation

Run all currently open challenges:

```bash
python run_daily_submissions.py
```

Optional:

```bash
python run_daily_submissions.py --dry_run
python run_daily_submissions.py --target_date 27-03-2026
python run_daily_submissions.py --challenge_id 1
python run_daily_submissions.py --data_source entsoe
python run_daily_submissions.py --use_global_env
```

The batch runner now fetches the open challenge list from the API and processes
those challenge ids directly instead of relying on a hardcoded local list.

## Scheduling

- Windows: `WINDOWS_TASK_SCHEDULER.md`
- Cross-platform notes: `SCHEDULE.md`
- Launchers: `run_daily_submissions.bat`, `run_daily_submissions.ps1`

## Repository layout

- `submit_forecast.py` - single submission
- `run_daily_submissions.py` - batch submission for open challenges
- `challenge_catalog.py` - challenge discovery helpers
- `custom_model_template.py` - starter hook for your own model
- `MODEL_INTEGRATION.md` - custom model guide
- `SCHEDULE.md` - scheduling reference
- `WINDOWS_TASK_SCHEDULER.md` - Windows Task Scheduler setup
- `.env.example` - local config template
- `requirements.txt` - dependencies

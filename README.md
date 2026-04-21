# Kap Cyg MESA Models and PAVO Visibilities

This archive contains **MESA inlists and PAVO interferometric visibility data** corresponding to **Chowhan et al. (2026)**, available at 
https://doi.org/10.48550/arXiv.2604.13501 or https://doi.org/10.1093/mnras/stag719.

## Contents

### 1. PAVO Calibrated Visibilities
**File:** `kapCyg_cal_vis.csv`  

- Contains calibrated squared visibilities (V²) for Kap Cyg measured with the PAVO beam combiner at CHARA.  
- Each row corresponds to a single observation at a given wavelength.  
- Key columns:
  - `Star` – target star identifier  
  - `wl` – wavelength of observation (µm)  
  - `sp_freq` – spatial frequency (1/rad)  
  - `cal_v2` – calibrated squared visibility  
  - `cal_v2sig` – uncertainty on `cal_v2`  

---

### 2. MESA Models
**Directory:** `kapCyg_mesa_models`  

Models were computed using:

- **MESA r24.03.1**  
- **GYRE 7.1**  

These files allow reproduction of the stellar model grids. The fitting pipeline and χ² calculations described in the paper are **not included**.

#### Files

**Inlists**

- `inlist_nochange_pm` – configuration for the predictive mixing (PM) grid  
- `inlist_nochange_os` – configuration for the exponential overshoot (OS) grid  

**Parameter sampling**

- `sobol_pm.txt` – Sobol sequence for the PM grid (4096 models)  
- `sobol_os.txt` – Sobol sequence for the OS grid (1024 models)  

**Grid generation scripts**

- `generate_inlist_pm.sh` – generates inlists for the PM grid  
- `generate_inlist_os.sh` – generates inlists for the OS grid  

**Oscillation calculations**

- `gyre.in` – configuration for computing oscillation frequencies with GYRE  

**MESA output configuration**

- `history_columns.list`  
- `profile_columns.list`  

**Custom routines**

- `src/` – contains `run_star_extras` routines used during MESA calculations to call GYRE  

---

#### Reproducing the Models (Single Track)

1. Install **MESA r24.03.1** and set the `$MESA_DIR` environment variable.  
2. Enter the model directory:
```bash
cd path/to/kapCyg_mesa_models
```
3. Compile the custom routines:
```
./mk
```
4. Generate the inlist for a single track (replace <index> with the track number):
- For Predictive mixing:
```
./generate_inlist_pm.sh <index>
```
- For Exponential overshooting:
```
./generate_inlist_os.sh <index>
```
5. Run the model:
```
./rn
```

### Notes
- The Sobol files define the sampling of the stellar parameter space used for the grids described in the paper.

- For physics assumptions and parameter ranges, see section 5.1 of Chowhan et al. (2026).

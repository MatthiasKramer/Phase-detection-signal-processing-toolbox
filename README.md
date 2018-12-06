Adaptive window cross-correlation technique (AWCCT)
===================================================

The AWCCT is a novel processing technique for phase-detection probe signals in high-velocity air-water flows. 
The code was developed by Matthias Kramer (The University of Queensland, [ORCID](https://orcid.org/0000-0001-5673-2751)) and Daniel Valero (IHE Delft, [ORCID](http://orcid.org/0000-0002-7127-7547)). It includes the following features:

- Single-threshold technique to detect air- and water-phases.
- Segmentation of the signal based on a small number of encompassed bubbles/droplets.
- Estimation of pseudo-instantaneous interfacial velocities and turbulence intensities.
- Implemented filtering criteria ensure reliable velocity estimates.

Overall, the uploaded source code allows computation of basic two-phase flow parameters, including void fraction (C), bubble/droplet count rate (F), time series of pseudo-instantaneous interfacial velocities (u) and turbulence intensities (Tu). If using the AWCCT for publishing research, please cite the following reference to credit the authors and to direct your readers to the original  research work:

M. Kramer, D. Valero, H. Chanson and D. Bung (2019). Towards reliable turbulence estimations with phase-detection probes: an adaptive window cross-correlation technique, Experiments in Fluids, 60:2 ([DOI](https://doi.org/10.1007/s00348-018-2650-9))

1 Contents
----------

The code is written in Matlab R2017a. The folder contains source code files and a represetative spillway data set:
- RunAWCCT.m: main code to run the AWCCT.
- windows.m: segmentation of the signal into short time windows.
- velocity.m: computation of pseudo-instantaneous velocities.
- thres.m: single threshold technique.
- ROC.m: robust outlier cutoff.
- GN2002.m: filtering after Goring and Nikora (2002, [DOI](https://doi.org/10.1061/(ASCE)0733-9429(2002)128:1(117))).
- chord.m: evaluation of chord times.
- tightsubplot: customize subplots (from Matlab FileExchange).
- legendflex: customize legends (from Matlab FileExchange).
- setpos: part of the legendflex package.
- getpos: part of the legendflex package. 
- *.dat: phase-detection probe data, measured at the eighth step edge of a large-sized stepped spillway, see Kramer et al. (2019).


2 Processing parameters
------------------------

Important processing paramters of the AWCCT are:
- Np (line 29): number of encompassed particles of the dispersed phase. For example, a window with 
Np = 2 particles contains two water chords and two air chords, compare Fig. 1 in Kramer et al. (2019).
- Rxymaxthres (line 30): threshold of the maximum cross-correlation coefficient. A value between 0.5 to 0.7 is recommended, as indicated in Matos et al. (2002, [DOI](https://doi.org/10.1061/40655(2002)58)) and André et al. (2003, [DOI](https://doi.org/10.1061/(ASCE)0733-9429(2005)131:5(423))). 
- SPRthres (line 31): threshold of the secondary peak ratio, as defined in Kramer et al. (2019). A value of 0.6 is recommended, similar to Keane and Adrian (1990, [DOI](https://doi.org/10.1088/0957-0233/1/11/013)) and Hain and Kähler (2007, [DOI](https://doi.org/10.1007/s00348-007-0266-6)).

3 Contact
----------
Matthias Kramer, School of Civil Engineering, The University of Queensland, Brisbane, Australia. Mail: m.kramer@uq.edu.au

Daniel Valero, IHE Delft Institute for Water Education, Delft, Netherlands.

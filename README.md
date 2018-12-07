Adaptive window cross-correlation technique (AWCCT)
===================================================

The AWCCT is a novel processing technique for **dual-tip phase-detection probe signals** in high-velocity air-water flows, developed by Matthias Kramer (University of Queensland) and Daniel Valero (FH Aachen). The code is subject to further expansion and currently includes the following features:

- Single-threshold filter to detect air- and water-phases.
- Segmentation of the signal based on a small number of encompassed bubbles/droplets.
- Estimation of pseudo-instantaneous interfacial velocities and turbulence intensities.
- Reliable velocity estimates through implementation of filtering criteria.

Overall, the uploaded source code allows computation of basic two-phase flow parameters, including void fraction (*C*), bubble/droplet count rate (*F*), chord times (*ch*), pseudo-instantaneous interfacial velocities (*u*) and turbulence intensities (*Tu*). If using the AWCCT for publishing research, please cite the following reference to credit the authors and to direct your readers to the original  research work:

M. Kramer, D. Valero, H. Chanson and D. Bung (2019). Towards reliable turbulence estimations with phase-detection probes: an adaptive window cross-correlation technique, Experiments in Fluids, 60:2 ([DOI](https://doi.org/10.1007/s00348-018-2650-9))

1 Contents
----------
The code is written in Matlab R2017a. This repository contains source code files and a represetative spillway data set:
- RunAWCCT.m: main code to run the AWCCT.
- chord.m: evaluation of chord times.
- roc.m: robust outlier cutoff. Simplification of Goring and Nikora (2002, [DOI](https://doi.org/10.1061/(ASCE)0733-9429(2002)128:1(117))), as modified by Wahl (2003, [DOI](https://doi.org/10.1061/(ASCE)0733-9429(2003)129:6(484))). ROC only uses instantaneous velocity data (instead of gradients). Note that velocity series are sparse in time, thus gradients correspond to different dt. Further description in Valero (2018, [handle](https://orbi.uliege.be/handle/2268/229191)).
- thres.m: single threshold technique.
- velocity.m: computation of pseudo-instantaneous velocities.
- void.m: void fraction calculation.
- windows.m: segmentation of the signal into short time windows.
- spillway-data: phase-detection probe data, measured at the eighth step edge of a large-sized stepped spillway, see Kramer et al. (2019).


2 Processing parameters
------------------------
Important processing paramters of the AWCCT are:
- **N<sub>P</sub>**: number of encompassed particles of the dispersed phase. For example, a window with 
N<sub>P</sub> = 2 particles contains two water chords and two air chords, compare Fig. 1 in Kramer et al. (2019). A value between N<sub>P</sub>  = 2 and 5 was used for synthetic and real two-phase flow signals. 
- **R<sub>12,max</sub>**: threshold of the maximum cross-correlation coefficient. A value between R<sub>12,max</sub> = 0.5 to 0.7 is recommended, compare Matos et al. (2002, [DOI](https://doi.org/10.1061/40655(2002)58)) and André et al. (2003, [DOI](https://doi.org/10.1061/(ASCE)0733-9429(2005)131:5(423))). 
- **SPR**: threshold of the secondary peak ratio, as defined in Kramer et al. (2019). A value of SPR = 0.6 is proposed, similar to Keane and Adrian (1990, [DOI](https://doi.org/10.1088/0957-0233/1/11/013)) and Hain and Kähler (2007, [DOI](https://doi.org/10.1007/s00348-007-0266-6)).

3 How to run the code?
----------------------
Copy the source code and the *.dat files into the same folder and run "RunAWCCT.m". Instantaneous velocities are accessible through the Matlab workspace and time-averaged results will be saved to an Excel spreadsheet.

4 Comment on measurement accuracy
----------------------------------
Phase-detection probe measurements may overestimate time-averaged velocities and underestimate turbulence intensities, as shown in     Corre and Ishii (2002, [DOI](https://doi.org/10.1016/S0029-5493(02)00130-9)) and Kramer et al. (2019). Possible reasons include:
- Probe tips are not aligned with flow streamlines.
- A greater number of bubbles/droplets impact the tips during periods of high velocities. 

This topic is currently being investigated. It is anticipated that the measurement accuracy decreases in regions with higher velocity fluctuations. 

5 Contact
----------
We are happy to receive **feedback**, **questions** and **recommendations**. Feel free to contact us via Email:

Matthias Kramer, The University of Queensland, Brisbane, Australia. Email: m.kramer@uq.edu.au, [ORCID](https://orcid.org/0000-0001-5673-2751)

Daniel Valero, Aachen University of Applied Sciences, Aachen, Germany. Email: valero@fh-aachen.de, [ORCID](http://orcid.org/0000-0002-7127-7547)

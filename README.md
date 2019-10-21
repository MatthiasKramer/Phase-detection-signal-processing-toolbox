Phase-detection signal processing toolbox
=========================================

This toolbox contains the **adaptive window cross-correlation (AWCC)** technique for processing dual-tip phase-detection probe signals in high-velocity air-water flows, developed by Matthias Kramer (University of Queensland) and Daniel Valero (FH Aachen). The code is subject to further expansion and currently includes the following features:

- Single-threshold filter to detect air- and water-phases.
- Segmentation of the signal based on a small number of encompassed bubbles/droplets.
- Estimation of pseudo-instantaneous interfacial velocities and turbulence intensities.
- Reliable velocity estimates through implementation of filtering criteria.

The uploaded source code allows computation of basic two-phase flow parameters, including void fraction (*C*), particle count rate (*F*), chord times (*t<sub>ch</sub>*), pseudo-instantaneous interfacial velocities (*u*) and turbulence intensities (*Tu*). If using the AWCC technique for publishing research, please cite the following reference to credit the authors and to direct readers to the original research work:

M. Kramer and D. Valero (2019). Phase-detection signal processing toolbox v1.0  [![DOI](https://zenodo.org/badge/160460025.svg)](https://zenodo.org/badge/latestdoi/160460025)

M. Kramer, D. Valero, H. Chanson and D. Bung (2019). Towards reliable turbulence estimations with phase-detection probes: an adaptive window cross-correlation technique, Experiments in Fluids, 60:2 ([DOI](https://doi.org/10.1007/s00348-018-2650-9))

1 Contents
----------
The phase-detection signal processing toolbox is written in Matlab R2017a. This repository contains source code files and a representative spillway data set:
- Batch.m: main code to perform batch-mode processing.
- awcc.m: awcc technique.
- chord.m: evaluation of chord times.
- roc.m: robust outlier cutoff. Simplification of Goring and Nikora (2002, [DOI](https://doi.org/10.1061/(ASCE)0733-9429(2002)128:1(117))), as modified by Wahl (2003, [DOI](https://doi.org/10.1061/(ASCE)0733-9429(2003)129:6(484))). ROC only uses instantaneous velocity data (instead of gradients). Note that velocity series are sparse in time, thus gradients correspond to different dt. Further description in Valero (2018, [handle](https://orbi.uliege.be/handle/2268/229191)).
- thres.m: single threshold technique and void fraction calculation.
- velocity.m: computation of pseudo-instantaneous velocities. 
- windows.m: segmentation of the signal into windows.
- spillway-data: phase-detection probe data, measured at the eighth step edge of a large-sized stepped spillway, see Kramer et al. (2019).


2 Processing parameters
------------------------
Important processing paramters of the AWCCT are:
- **R<sub>12,max</sub>**: threshold of the maximum cross-correlation coefficient. 

- **SPR**: threshold of the secondary peak ratio, as defined in Kramer et al. (2019).

- A combined filtering criteria **R<sub>12,max</sub>**/(**SPR<sub>i</sub><sup>2</sup>** + 1) > **A** is proposed, where the parameter **A** was chosen as **A** = 0.4. 

- **N<sub>P</sub>**: number of encompassed particles of the dispersed phase. For example, a window with 
N<sub>P</sub> = 2 particles contains two water chords and two air chords, compare Fig. 1 in Kramer et al. (2019). A small window size can lead to the inclusion of noise (uncorrelated signals). A number of particles between 5 < **N<sub>P</sub>** < 15  is recommended. The aim is to keep  **N<sub>P</sub>** small while avoiding non-physical velocity information. A sensitivity analysis should lead to  converging mean velocities.

3 How to run the code?
----------------------
Copy the source code and the *.dat files into the same folder and run "Batch.m". Instantaneous velocities are accessible through the Matlab workspace.

4 Comment on measurement accuracy
----------------------------------
Phase-detection probe measurements may overestimate time-averaged velocities and underestimate turbulence intensities, as shown in     Corre and Ishii (2002, [DOI](https://doi.org/10.1016/S0029-5493(02)00130-9)) and Kramer et al. (2019). Possible reasons include:
- Probe tips are not aligned with flow streamlines.
- A greater number of bubbles/droplets impact the tips during periods of high velocities. 

This topic is currently being investigated. It is anticipated that the measurement accuracy of a dual-tip probe decreases in two- or three-dimensional flow situations and in regions with high velocity fluctuations. 

5 Contact
----------
For **feedback**, **questions** and **recommendations**, please use the issue-section or contact the authors via Email:

- Matthias Kramer, UNSW Canberra, School of Engineering and Information Technology (SEIT). Email: m.kramer@adfa.edu.au, [ORCID](https://orcid.org/0000-0001-5673-2751)
- Daniel Valero, IHE Delft Institute for Water Education, Water Science and Engineering Department. Email: d.valero@un-ihe.org, [ORCID](http://orcid.org/0000-0002-7127-7547)

6 Selected References
---------------------
- Neal, L. G. and Bankoff, S. G. (1963). A high resolution resistivity probe for determination of local void properties in gas–liquid flow. American Institue of Chemical Engineers Journal 9(4), pages 490–494.
- Herringe, R. A. and Davis, M. R. (1976). Structural development of gas–liquid mixture flows. Journal of Fluid Mechanics 73, pages 97–123.
- Cartellier, A. and Achard, J. (1991). Local phase detection probes in fluid/fluid two-phase flows. Review of Scientific Instruments 62(2), pages 279–303.
- Chanson, H. and Toombes, L. (2002). Air-water flows down stepped chutes: turbulence and flow structure observations. International Journal of Multiphase Flow 28(11), pages 1737–1761.
- Felder, S. and Chanson, H. (2015). Phase-detection probe measurements in high-velocity free-surface flows including a discussion of key
sampling parameters. Experimental and Thermal Fluid Science 61, pages 66–79.
- Kramer, M., Valero, D., Chanson, H. and Bung, D. B. (2019). Towards reliable turbulence estimations with phase-detection probes: an adaptive window cross-correlation technique, Experiments in Fluids, 60.


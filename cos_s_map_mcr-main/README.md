# cos_s_map_mcr
codes used in "Multivariate Curve Resolution Combined with Estimation by Cosine Similarity Mapping of Analytical Data" published in Analyst

Codes in Analyst paper by Nagai and Katayama

This is the codes used in the paper published in Analyst, ?????, authored by Y. Nagai and K. Katayama. There are three main programs in this repository, which follows the calculation in Scheme 1 and 2 in the paper.

preprocess_cos_s_map.m: preprocessing data, you need to select the necessary preprocessing in each section. 
initial_est_cos_s_map.m: initial estimation of pure spectra. alsOptimization_cos_s_map.m: 
ALS optimization with a constraint of the initial estimation to refine the pure spectra and the concnentrations.

Before running the program, you need to add the path /Program/Main. 
Two sample data are included; mixture of absorption spectra and XRD patterns described in the paper in UV_Vis and XRD folders. 
You may need to install some tool boxes to run the program.

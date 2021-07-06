READ ME
Languages: Matlab and R
Claire Smid, 20 November 2019 
UPDATE: Claire Smid, 24 August 2020 : added more general information 
UPDATE: Claire Smid, 17 September 2020 : added k-fold information
UPDATE: Claire Smid, 8 April 2021 : added parameter recovery information and folders
UPDATE: Claire Smid, 6 July 2021 : we now use gamma, beta and normal priors in the model-fitting, as opposed to using uniform priors previously. In addition, rewards were entered
as their absolute value of points (0-9) rather than scaled down to be between 0 and 1 as was done previously. This was mainly done to improve the reliability of recovering the 
parameters in the model, and to avoid pooling at the bounds as we saw in earlier versions.

This is the main folder to replicate the computational modelling executed in the model-based/model-free developmental publication. Preprint on PsychArxiv: https://psyarxiv.com/ervsb/
by Claire Smid, Wouter Kool, Tobias Hauser and Nikolaus Steinbeis. 

This code is mainly based on the code provided by Wouter Kool, e.g. Kool et al. 2016: https://github.com/wkool/tradeoffs, Kool et al. 2017: https://github.com/wkool/arbitration

Follow the steps below to recreate the analysis as reported. For any questions, please email to: claire.smid.17@ucl.ac.uk or claire.r.smid@gmail.com

	Step 1. Combining data files.
Run the script 'Step1_combine_group_data.m' to create two combined data files for the children and adult data. The resulting data files will be 'adultgroupdata.mat' and
'kidgroupdata.mat' and will be saved in the current folder. The function will also output two log files, named 'kidlog.mat' and 'adultlog.mat'. These
two files will record how many missed trials there were per participant and how many trials available in total, and keep a record of which participants were 
excluded (following the guidelines as specified in the paper. The outputted data files will be used for following analysis but will not be changed by them. The 'mfit-master'
folder contains the optimization functions. The folder named 'data' contains the raw data from all subjects.

	Step 2. Parameter recovery for the 6-parameter and 7-parameter model
In the folder 'Parameter_Recovery' there are scripts to run parameter recovery for both the 6- and 7-parameter model for the task included in this paper. The task
in this paper is different from previous versions (Kool et al 2016, Kool et al 2017), since the trial duration is shorter (original had 200, this one has 140).
The scripts 'Main_Parameter_Recovery_6Params.m' and 'Main_Parameter_Recovery_7Params.m' can be used to run the parameter recovery for 200 agents, for 200, 140 or 100 trials.

Those two main scripts further use the scripts:
- set_simulation_params6.m        # - defines the parameter bounds and Gamma, beta and Normal priors used for the 6 parameter model
- set_simulation_params7.m        # - defines the parameter bounds and Gamma, beta and Normal priors used for the 7 parameter model
- MBMF_generate_sim_6Params.m     # - generates simulated behaviour for the 6 parameter model
- MBMF_generate_sim_7Params.m     # - generates simulated behaviour for the 7 parameter model
- MB_MF_llik_simulation_6Params.m # - estimates the parameters for the 6 parameter model
- MB_MF_llik_simulation_7Params.m # - estimates the parameters for the 7 parameter model

and the model fitting tools included in the 'mfit-master' folder.
The model fitting tools in the mfit-master folder, and especially the 'mfit-optimize.m' script written by Sam Gershmann, have not been edited except for inlcuding
the number of nstarts (random starting locations for optimizer), trials and participant ID in the output (these extra lines are commented in).
the mfit toolbox: https://github.com/sjgershm/mfit

	Step 3. Fitting the 6 parameter RL model (from Kool et al 2016) and creating model-free simulations
The folder 'RL_6ParamsModel_and_Sims' contains the scripts to fit the 6-parameter reinforcement learning model to the behavioural data of the children and the adults.
By running the script 'Main_wrapper_6Params.m', the model will be fitted to both participant groups. The 6-parameter model is agnostic for the stakes, so it can be 
fit to all trials (rather than having two w-parameters split across low and high stake trials). It therefore provides as baseline model-based decision-making measure 
across all trials.

The Model-free simulations can be created by going into the 'model_free_simulations' folder with the 'Main_MF_Sims.m' script. 
In the script, we take the parameters from the children as outputted by the 6-parameter model, add noise to them, set w to 0,
then simulate behaviour with this, and then take the outputted parameters of this to again simulate behaviour, setting the w-parameter to 0. 

We then repeat this for 500 iterations of the total sample of 85 children, giving us a total of 42500 simulations that have been simulated and fitted twice. 
We then take the grand mean of the w-parameter of these 500 means as the true-model-free value of w. 
The 'CLUSTER_Main_MF_Sims.m' script is adapted to be run on a computing cluster. We needed to break the simulations into ~10 sections that were run separately
and later combined. The 'Get_MF_Sims_its_means.m' script combines the files from different iterations.

	Step 4. Running the 7 parameter RL model (from Kool et al 2017) 
The folder 'RL_7ParamsModel_and_Sims' contains the scripts to fit the 7-parameter reinforcement learning model to the behavioural data of the children and the adults.
By running the script 'Main_wrapper_7Params.m', the model will be fitted to both participant groups. The 7-parameter model includes two w-parameters that differ 
across low and high stake trials, allowing investigation of whether the degree of model-based decision-making differs per stake.

	Step 5. Regression-based model-free / model-based measures (based on Kool et al. 2016)
The 'Stay_Probabilities' folder has the scripts that generate choice probabilities on a trial basis, for both children and adults and the 6- and 
7-parameter models that can be used in further regression analysis. In order to have a more 'behavioural' approach, we used the raw data from the participants, e.g.
their actual rewards received, the similarity of starting state and whether they repeated a choice to a planet (staying) or not.

For the article, the regression analysis was conducted in R using the lme4 package. Candidate models were compared via nested model selection with the AICcmodavg 
package in R. 

	Step 6. k-fold Cross Validation
In the 'k-fold_Cross_Validation' folder, scripts are included to check how well both models performed. The script containing 'CLUSTER' in the title is adapted
to be run on a computing cluster.

The final statistical results and the graphs published in the paper have been analysed and created using R. 

References

Kool, W., Cushman, F. A., & Gershman, S. J. (2016). When does model-based control pay off?. PLoS computational biology, 12(8), e1005090.

Kool, W., Gershman, S. J., & Cushman, F. A. (2017). Cost-benefit arbitration between multiple reinforcement-learning systems. Psychological science, 28(9), 1321-1333.

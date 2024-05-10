![mit](https://img.shields.io/badge/License-MIT-blue.svg)

# Counterfactual Visibility
Matan Mazor 🤓, Rani Moran 🥸 & Clare Press 😎

<img src="docs/figures/design_occlusion_noisy_stim.png" alt="Rationale and experimental design for Experiments 1-3. A) occluding more of a target letter decreases its visibility (black markers). Occlusion has no effect on target visibility when the target is absent, but it affects *counterfactual visibility* (white markers): the expected visibility of the target, had it been present. B) example frames from target-present (blue) and target-absent (red) trials. C) trial structure in Exp. 2. D) occlusion conditions in the three experiments. In Exp. 1, on different trials we occluded a random subset of 5% or 15% of the pixels in the stimulus. In Exp. 2 and 3, on different trials we occluded a random subset of 2 or 6 pixel rows. In Exp. 3, the task-relevant stimulus was falnkered by two reference stimuli that, known to the subject, always had the target letter in them. Participants performed two 32-trial blocks in which the target was the letter S and two blocks in which the target was the letter A. The order of the two letters was randomised between participants. *The occluder preview screen only appeared in Exp. 2 and 3. **Confidence ratings were given only in Exp. 2, blocks 3 and 4" width="500"/>

A series of experiments looking at the effects of factual and counterfactual visibility on detection. 
The experiments in this repository are a subset of the [detection in context](https://github.com/matanmazor/detectionInContext) experiments.

## Data
Raw data from all four experiments is available on the project's OSF repository: [osf.io/7v2d6/](https://osf.io/7v2d6/)

## Analysis Scripts
A fully reproducible data-to-paper code (in R and Rmarkdown), as well as reports of all pre-registered analyses, are available in the ['docs'](https://github.com/matanmazor/counterfactualVisibility/blob/main/docs/occlusion.Rmd) subdirectory. Scripts currently use local paths for data files. To read data directly from OSF, replace mentions of `loadAndPreprocessData` with `loadAndPreprocessDataFromOSF`.

## Experiment demos

You can try Experiment 1 (occluded pixels) by clicking [here](https://matanmazor.github.io/counterfactualVisibility/experiments/demos/Exp1pixels)

You can try Experiment 2 (occluded rows) by clicking [here](https://matanmazor.github.io/counterfactualVisibility/experiments/demos/Exp2rows)

You can try Experiment 3 (occluded rows + reference) by clicking [here](https://matanmazor.github.io/counterfactualVisibility/experiments/demos/Exp3reference)

## Pre-registration and pre-registration time-locking 🕝🔒

OSF pre-registrations are available for [Exp. 1](https://osf.io/e6x82) (Exp. 3 in the Detection in Context OSF project), [Exp. 2](https://osf.io/5yr9e) (Exp. 4 in the Detection in Context OSF project) and [Exp. 3](https://osf.io/mfd2w) (Exp. 6 in the Detection in Context OSF project).

To ensure preregistration time-locking (in other words, that preregistration preceded data collection), we employed [randomization-based preregistration](https://medium.com/@mazormatan/cryptographic-preregistration-from-newton-to-fmri-df0968377bb2). We used the SHA256 cryptographic hash function to translate our preregistered protocol folder (including the pre-registration document) to a string of 256 bits. These bits were then combined with the unique identifiers of single subjects, and the resulting string was used as seed for initializing the Mersenne Twister pseudorandom number generator prior to determining all random aspects of the experiment, including the order of trials, occluder positions, and random noise in the stimulus itself. This way, experimental randomization was causally dependent on, and therefore could not have been determined prior to, the specific contents of our preregistration document ([Mazor, Mazor & Mukamel, 2019](https://doi.org/10.1111/ejn.14278)).

### Exp. 1
[protocol folder](https://github.com/matanmazor/counterfactualVisibility/blob/main/experiments/Exp1pixels/version2/protocolFolder.zip)

protocol sum: e420455976659d9a46582ea0f7a64ba9e33810d90786c5157e2a188e8dcdd7c0

[relevant pre-registration lines of code](https://github.com/matanmazor/counterfactualVisibility/blob/ead8cfad719049a3eb9a36ff1e72ed747f4bf820/experiments/Exp1pixels/version2/webpage/index.html#L470-L482)

### Exp. 2
[protocol folder](https://github.com/matanmazor/reverseCorrelation/blob/cbba2d43c2ddfb0c021ee0c15b7d5b03eddd34d8/experiments/Experiment2/protocol_folder.zip)

protocol sum: bf72004d226b7a89a2085b0d6238a8d9b9c638513127a47fd44c6a7d00112b2f

[relevant pre-registration lines of code](https://github.com/matanmazor/counterfactualVisibility/blob/41b46eabd6e3eb9609519be0743b34c137c7231e/experiments/Exp2rows/protocolFolder/webpage/index.html#L513-L525)

⚠️ Notice that the long version of Exp. 2 was not pre-registered. 

### Exp. 3
[protocol folder](https://github.com/matanmazor/counterfactualVisibility/blob/main/experiments/Exp3reference/protocolFolder.zip)

protocol sum: 2be4e2548db0a221a06c936fbba47cecd28894e0400477ac4f580222b77a4a44

[relevant pre-registration lines of code](https://github.com/matanmazor/counterfactualVisibility/blob/41b46eabd6e3eb9609519be0743b34c137c7231e/experiments/Exp3reference/webpage/index.html#L466-L478)

⚠️ Notice that the long version of Exp. 3 was not pre-registered. 

Since randomization in these experiments depends on participants' behaviour (the longer they take to respond, the more random luminance values are sampled, affecting all later trials), setting the seed to the same value is not sufficient to reproduce the same randomization: it is also necessary to reproduce participants' response times. For pre-registration verification purposes, we include "passive" demos ([Exp. 1](https://matanmazor.github.io/counterfactualVisibility/experiments/demos/Exp1pixelsPassive); [Exp. 2](https://matanmazor.github.io/counterfactualVisibility/experiments/demos/Exp2rowsPassive); [Exp. 3](https://matanmazor.github.io/counterfactualVisibility/experiments/demos/Exp3referencePassive)), where specifying a subject identifier initializes the PRNG and reproduces their responses and response times. The resulting randomization should correspond to the randomization observed in the data files. Because of this dependency on RT data, these demos only work for subject identifiers that exist in the data files.







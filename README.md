# Counterfactual Visibility
Matan Mazor 🧱 & Clare Press 🪟

A series of experiments looking at the effects of factual and counterfactual visibility on detection. 
The experiments in this repository are a subset of the [detection in context](https://github.com/matanmazor/detectionInContext) experiments.

## Analysis Scripts
A fully reproducible data-to-paper code (in R and Rmarkdown) is available in the ['docs'](https://github.com/matanmazor/counterfactualVisibility/blob/main/docs/occlusion.Rmd) subdirectory.

## Experiment demos

You can try Experiment 1 (occluded pixels) by clicking [here](https://matanmazor.github.io/counterfactualVisibility/experiments/demos/Exp1pixels)

You can try Experiment 2 (occluded rows) by clicking [here](https://matanmazor.github.io/counterfactualVisibility/experiments/demos/Exp2rows)

You can try Experiment 3 (occluded rows + reference) by clicking [here](https://matanmazor.github.io/counterfactualVisibility/experiments/demos/Exp3reference)

## Pre-registration time-locking 🕝🔒

To ensure preregistration time-locking (in other words, that preregistration preceded data collection), we employed [randomization-based preregistration](https://medium.com/@mazormatan/cryptographic-preregistration-from-newton-to-fmri-df0968377bb2). We used the SHA256 cryptographic hash function to translate our preregistered protocol folder (including the pre-registration document) to a string of 256 bits. These bits were then combined with the unique identifiers of single subjects, and the resulting string was used as seed for initializing the Mersenne Twister pseudorandom number generator prior to determining all random aspects of the experiment, including the order of trials, motion energy in Exp. 1, random luminance values in Exp 2 and 3, and hue values in Exp. 4. This way, experimental randomization was causally dependent on, and therefore could not have been determined prior to, the specific contents of our preregistration document ([Mazor, Mazor & Mukamel, 2019](https://doi.org/10.1111/ejn.14278)).

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





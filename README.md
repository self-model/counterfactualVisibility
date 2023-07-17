# Counterfactual Visibility
Matan Mazor 🧱 & Clare Press 🪟

A series of experiments looking at the effects of factual and counterfactual visibility on detection. 
The experiments in this repository are a subset of the [detection in context](https://github.com/matanmazor/detectionInContext) experiments.

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

protocol sum: f078aa2862041786868ef9f2ad23336df49386eb98fe8259951830bdf7c3dbfd

[relevant pre-registration lines of code](https://github.com/matanmazor/reverseCorrelation/blob/cbba2d43c2ddfb0c021ee0c15b7d5b03eddd34d8/experiments/Experiment2/webpage/ZylbRep.html#L677-L687)

### Exp. 3
[protocol folder](https://github.com/matanmazor/reverseCorrelation/blob/cbba2d43c2ddfb0c021ee0c15b7d5b03eddd34d8/experiments/Experiment3/protocol_folder.zip)

protocol sum: c8c398e9134c072a7c73ea6a24f87079609999df2a40e52c19f94e3d98a58d2c;

[relevant pre-registration lines of code](https://github.com/matanmazor/reverseCorrelation/blob/cbba2d43c2ddfb0c021ee0c15b7d5b03eddd34d8/experiments/Experiment3/webpage/main.js#L682-L692)





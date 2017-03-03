# Data anomalies in ClinicalTrials.gov

__Anyone is free to contribute to this project via pull requests__

__Issues will be used to track to-dos! Head there if you want to contribute__

__If you qualify for contributing to one of the aspects listed in [contributions.csv](./contributions.csv) you will be acknowledged in the paper and you may even want to consider co-authoring the final result__

[ClinicalTrials.gov](https://clinicaltrials.gov) is the US based repository for clinical trials. This database contains almost 20,000 completed clinical trials with results, that can be analyzed for data anomalies in baseline measurements.

Baseline measurements were previously used to detect data anomalies in clinical trials conducted by the now well-known fabricator Fuji ([Retraction Watch's leader with 183 retractions](http://retractionwatch.com/the-retraction-watch-leaderboard/)). Paper's describing the methods used to detect data anomalies are described in the following two papers:

1. [10.1111/j.1365-2044.2012.07128.x](https://doi.org/10.1111/j.1365-2044.2012.07128.x) (paywalled though... [E-mail me](mailto:chjh@protonmail.com) if you want a copy! [I am not allowed to share on here due to copyright]) 

2. [10.1111/anae.13126](https://doi.org/10.1111/anae.13126) (also paywalled; same applies: [e-mail me](mailto:chjh@protonmail.com) for a copy!)

These papers will form the basis of the data analysis. There are pretty much two crucial steps: (1) parsing and identifying randomized clinical trials with baseline measurements and (2) using these baseline measurements to apply the methods from the papers above. A third step will be added after these analysis to inspect how data anomalies relate to study characteristics (e.g., funding).

# Contribution guidelines

1. Make every step reproducible for others
2. If 1 is impossible (manual labor), document
3. Have fun :-)

For 1., don't worry if you're unsure. Pull requests will be evaluated on their reproducibility and anything that remains unclear will be clarified before merging.

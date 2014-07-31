# Ring Rewards

## Citation

Geier, C. F., R. Terwilliger, T. Teslovich, K. Velanova, and B. Luna. “Immaturities in Reward Processing and Its Influence on Inhibitory Control in Adolescence.” Cerebral Cortex 20, no. 7 (July 1, 2010): 1613–29. doi:10.1093/cercor/bhp225.

## Behavdata

example:

    1       182     1       400     7.5     reward108       108     5
    2       185     -1      -1      19.5    reward532       532     11
    3       181     1       400     25.5    reward007       7       13
    4       161     1       467     31.5    neutral007      7       15

columns: 

 1. trial num
 2. XDAT (catch, cue type and dot position)
 3. score (-1:drop, 0: incorrect, 1: correct, 2: error corrected)
 4. latency to first saccade in ms
 5. onset of cue (seconds)
 6. EPrime frame name (cue/condition and dot postion)
 7. dot position
 8. EPrime presentation number (includes fixations and catches)


## Missing Data

| subj   | missing |
| -----  | ------- |
| sub007 |  run 2  |
| sub007 |  run 3  |
| sub007 |  run 4  |
| sub023 |  run 4  |
| sub023 |  run 4  |
| sub028 |  run 3  |
| sub028 |  run 4  |

## Task
coded in EPrime, recorded (XDATS) with ASL eye tracker


    Order:   Cue (1.5s) | Red Centered Cross (1.5s) | Dot (1.5s)  |
    XDATS:            start                      target          stop


Two condition types are distinguished by cue: 
 * Neutral - circle of "#"
 * Reward  - circle of "$"


Each with two catch trial formats:
 * Catch1: cue (1.5) | cross (1.5)
 * Catch2: cue (1.5)


Dot position is given in from left to right, 0 to 600.

Fixations are repeats of 1.5s white centered cross

## Analysis
> Briefly, our model consisted of 6 orthogonal regressors of interest (reward cue, neutral cue, reward preparation, neutral preparation, reward saccade response, neutral saccade response; “correct AS trials only”). We also included regressors for reward and neutral error trials (consisting of the entire trial), regressors for baseline, linear, and nonlinear trends, as well as 6 motion parameters included as “nuisance” regressors. A unique estimated impulse response function (IRF, i.e., hemodynamic response function) for each regressor of interest (reward and neutral cue, preparation, and saccade; “correct AS trials only”) was determined by a weighted linear sum of 5 sine basis functions multiplied by a data determined least squares–estimated beta weight. The estimated IRF reflects the estimated BOLD response to a type of stimulus (e.g., the reward cue) after controlling for variations in the BOLD signal due to other regressors. We specified the duration of the estimated response from stimulus onset (time = 0) to 18-s poststimulus onset (13 TR), a sufficient duration for the estimated BOLD response to return to baseline, for each separate epoch of the trial. We made no assumptions about its specific shape beyond using zero as the start point. Several goodness-of-fit statistics were calculated including partial F-statistics for each regressor and t-scores comparing each of the 5 estimated beta weights with zero. 


## Online info
 * [Paper](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2882823/)
 * [Scripts](https://github.com/LabNeuroCogDevel/openfmri_ring_rew)
 * [ScanSheets](https://docs.google.com/spreadsheets/d/1kzNxuRPnyalaG5K66ADFIavJOYfQl5OXQSmudNwc0Ak/edit#gid=896164689)

## event timing

|v1                      ||v2                      || v3                      | v4                    ||
| -----  | -----          | -----  | -----          | -----  | -----          | -----  | -----         |
| onset  | event          | onset  | event          | onset  | event          | onset  | event         |
| 0      | neutral426     | 0      | neutral532     | 7.5    | reward108      | 4.5    | neutral108    |
| 6      | reward007      | 6      | reward007      | 16.5   | neutralCatch2  | 13.5   | reward532     |
| 12     | neutralCatch1  | 16.5   | reward214      | 19.5   | reward532      | 31.5   | reward007|
| 16.5   | neutral633     | 22.5   | rewardCatch2   | 25.5   | reward007      | 37.5   | neutral532|
| 25.5   | neutralCatch2  | 25.5   | neutral633     | 31.5   | neutral007     | 43.5   | reward532|
| 28.5   | reward633      | 31.5   | neutral214     | 42     | neutralCatch1  | 49.5   | reward007|
| 42     | rewardCatch2   | 43.5   | neutral007     | 46.5   | neutral426     | 55.5   | rewardCatch2|
| 45     | reward426      | 49.5   | neutralCatch1  | 52.5   | reward633      | 63     | neutralCatch1|
| 51     | neutral108     | 54     | rewardCatch2   | 66     | rewardCatch1   | 67.5   | neutral426|
| 61.5   | reward633      | 57     | neutralCatch1  | 70.5   | neutral532     | 73.5   | neutral633|
| 72     | neutral633     | 66     | neutral108     | 76.5   | neutral214     | 79.5   | rewardCatch1|
| 78     | neutral007     | 72     | reward532      | 88.5   | neutral426     | 84     | neutralCatch2|
| 84     | reward532      | 78     | rewardCatch1   | 97.5   | reward426      | 90     | neutral532|
| 90     | reward007      | 90     | reward426      | 103.5  | reward214      | 96     | reward108|
| 96     | reward532      | 96     | neutral007     | 109.5  | reward214      | 106.5  | reward426|
| 114    | neutral214     | 105    | reward633      | 118.5  | reward108      | 112.5  | reward007|
| 123    | reward108      | 114    | neutral108     | 124.5  | neutralCatch2  | 118.5  | neutralCatch1|
| 129    | neutral007     | 120    | neutral426     | 127.5  | rewardCatch1   | 123    | neutral108|
| 135    | neutralCatch2  | 126    | neutralCatch2  | 132    | neutral007     | 136.5  | neutral007|
| 138    | neutral426     | 141    | neutral532     | 138    | neutralCatch2  | 142.5  | neutralCatch2|
| 151.5  | neutral214     | 147    | reward633      | 141    | neutral532     | 148.5  | reward633|
| 157.5  | rewardCatch2   | 153    | reward007      | 150    | neutral108     | 154.5  | rewardCatch2|
| 160.5  | rewardCatch1   | 159    | neutral007     | 156    | rewardCatch1   | 157.5  | neutral633|
| 169.5  | reward426      | 165    | rewardCatch1   | 174    | neutralCatch1  | 163.5  | reward214|
| 175.5  | neutral633     | 172.5  | neutral633     | 178.5  | neutral633     | 175.5  | reward426|
| 181.5  | reward108      | 181.5  | neutral532     | 184.5  | reward532      | 186    | neutral214|
| 187.5  | neutralCatch2  | 187.5  | reward214      | 190.5  | reward426      | 205.5  | neutralCatch1|
| 193.5  | neutral532     | 193.5  | neutral426     | 196.5  | reward633      | 210    | rewardCatch2|
| 199.5  | neutral007     | 199.5  | neutralCatch2  | 202.5  | neutral633     | 213    | neutral007|
| 205.5  | neutral532     | 202.5  | neutral214     | 211.5  | reward633      | 219    | neutral633|
| 211.5  | reward007      | 208.5  | reward426      | 220.5  | rewardCatch2   | 225    | neutralCatch2|
| 222    | reward633      | 214.5  | rewardCatch1   | 223.5  | rewardCatch2   | 228    | reward633|
| 228    | reward214      | 222    | reward108      | 231    | neutral214     | 234    | rewardCatch1|
| 234    | rewardCatch1   | 241.5  | neutral633     | 250.5  | reward007      | 241.5  | reward633|
| 238.5  | neutralCatch1  | 252    | reward108      | 256.5  | neutral007     | 247.5  | neutral214|
| 249    | reward214      | 258    | neutralCatch1  | 262.5  | reward007      | 256.5  | neutral007|
| 259.5  | neutral108     | 262.5  | rewardCatch2   | 268.5  | neutralCatch1  | 265.5  | reward214|
| 276    | rewardCatch2   | 265.5  | reward633      | 273    | neutral108     | 271.5  | reward108|
| 279    | neutralCatch1  | 271.5  | reward007      | 279    | neutral633     | 277.5  | rewardCatch1|
| 283.5  | rewardCatch1   | 277.5  | neutralCatch2  | 285    | rewardCatch2   | 282    | neutral426|



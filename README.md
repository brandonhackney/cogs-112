# cogs-112
In-class demonstrations for Emily Grossman's Intro to fMRI class at UC Irvine. These are MATLAB functions that demonstrate two key ideas for fMRI analysis: **convolution** and **filtering**.

Convolution
-
The 'Convolution' folder has two important functions:
- convolutionExamples is a script that lets you test out various kernels and boxcars, and animates the process of convolution for you.
- predictedSignal is a function applies this concept directly to MR data by generating a predicted brain response based on stimulus timing information

Filtering
-
The 'Signal Filtering' folder really has just one important function:
- RunMe will open a GUI that lets you apply various filters to a signal and see the outcome immediately

Finale
-
The 'finale' script in the root dir puts these two ideas together by generating an MR-like signal, corrupting it with noise, and then applying a filter to try to recover the original signal.

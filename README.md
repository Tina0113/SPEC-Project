# SPEC-Project
> University of Cinicinnati, Introduction to Industrial Big Data Analytics and Applications, SPEC Project.  
> Author:  Chun-Yao Lin, Shin-Ting Wu, Pei-Wen Yang and Po-Han Wu.  
## Project Two
### Background
> A rotor-bearing testbed was built to analyze the health condition of the shaft with unbalance defects.   
### Introdution
> Develop a program assessing the health condition of the shaft based on provided vibration data.  
> The submission should contain: 
> 1. A brief introduction of the analytics process.
> 2. Figures or tables showing the assessment result.
> 3. All the programming codes.  

## Project Three
### Introduction
> Problem Statement 
>> Use SOM, SOM-MQE for health assessment on the data set from the shaft testbed.

## Project Four
### Introduction
> Use SVM for classification on the data set provided by HW3.  

## Final Project-Bearing Fault Diagnosis
### Introduction
>Rolling element bearing is an indispensable component in rotary machinery systems, 
and quite usually a critical one that costs significant expense and time when it fails. 
To monitor bearing health condition, various techniques have been applied including vibration analysis, 
oil debris and acoustic emission. Among these techniques, vibration analysis is currently the most established 
with various signal processing methods employed to analyze the fault signatures in high-resolution vibration waveform. 
An inevitable challenge for bearing monitoring is the multiple possible failure modes and their combinations, 
which requires advanced analytical methods to extract most relevant information and identify failure modes with high accuracy. 
To evaluate analytical methods for bearing fault diagnosis, a test-bed is set up to collect vibration data under different bearing fault conditions. 
A SKF 32208 tapered roller bearing (TRB) is used and an accelerometer is installed on the orthogonal direction of its housing to measure the axial vibration. 
A PCM3178-HG-B DAQ card, embedded in Advantech UNO-2160 box, is used to convert analog waveform to digital data. 
During the tests, seven (7) bearings with induced defects and a new bearing with no defect are used in turn to 
generate data under eight different conditions. The bearing models are the same, thus same specification and
 geometry parameters. The fault conditions are roller defect, inner-race defect, outer-race defect, 
 the three combinations of any two independent faults and the combination of all three.  
### Problem Statement
>The task for this project is to develop a systematic method to assess bearing health 
(good or degraded) and diagnose the specific failure modes when bearing is known degraded.
 Feature extraction is the first module that extracts time domain, frequency domain and other features 
 from raw vibration data. Dimension reduction algorithms can be used to downsize the extracted feature set. 
 With health assessment algorithms, degradation can be assessed with reference to feature set from baseline feature. 
 Eventually classification algorithms are used to learn from labeled training data, 
 and diagnose unknown condition based on testing data.  



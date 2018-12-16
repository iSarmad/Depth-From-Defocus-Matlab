# Depth-From-Defocus-Matlab
This is a Matlab implementation of Depth from Defocus using your mobile phone. In addition I use a number of techniques such as graph cuts and matting laplacian to improve the results

This Repo is the implementation of the following paper:

* [ImageMatting](https://ieeexplore.ieee.org/document/4359322/) A Closed form solution to natural image matting
* [WMF](https://ieeexplore.ieee.org/document/6751115) Constant Time Weighted Median Filtering for Stereo Matching and Beyond


### Prerequisites
1. Download IAT tool box from following link:
```
https://sites.google.com/site/imagealignment/download
```
2. i have provided graph cut library which does not belong to me.Follow instruction on gc-v.30 for any problems:
```
https://github.com/nsubtil/gco-v3.0

```
### Dataset 
Two different datasets have been included in the repository. You can also create your own by getting a whole focal stack from your phones.

## Steps
 The following steps are performed:
 
### Step1 
Sample Image from Focal Stack
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/1.PNG)

### Step2
Sample Image Focus measure
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/2.PNG)
### Step3
Initial Focus Map 
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/3.PNG)
### Step4

![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/4.PNG)
### Step5
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/5.PNG)

### Step6
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/6.PNG)

### Step7
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/7.PNG)
### Step8
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/8.PNG)
### Step9
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/9.PNG)
### Step10
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/10.PNG)

### Step11
![alt text](https://github.com/iSarmad/Depth-From-Defocus-Matlab/blob/master/results/11.PNG)
## License

This project is licensed under the MIT License. 
For specific helper function used in this repository please see the license agreement of the Repo linked in Acknowledgement section

## Acknowledgments
My implementation has been inspired from the following sources.

* [gco-v3.0](https://github.com/nsubtil/gco-v3.0) : I do not own any part of this library included in my code

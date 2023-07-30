# Quantum_Robust_Fitting
This a demonstration program for Quantum Robust Fitting.

Published in ACCV 2020.

[[Paper]](https://openaccess.thecvf.com/content/ACCV2020/papers/Chin_Quantum_Robust_Fitting_ACCV_2020_paper.pdf)

### About ###
This repository contains the demo of a robust fitting approach which is based on "influence" as a measure of outlyingness.


### Getting Started ###
This demo runs in MATLAB, and has been tested on macOS Catalina.

### Demo 1: 2D Line Fitting ###
This demo showcases an example of fitting a 2D line to a set of 100 data points.
1. Run main.m in demo_influence folder.

### Demo 2: Homography Estimation ###
This demo showcases an example of estimating the homography that aligns two 2D images that observe the same plane, given a set of feature correspondences between two images. 
1. Run main.m in demo_homography folder.
   

**Dependencies**
- gurobi (https://www.gurobi.com) (optional)



This demo is free for non-commercial academic use. Any commercial use is strictly prohibited without the authors' consent. Please acknowledge the authors by citing
 
 ```
  @inproceedings{chin2020quantum,
  title={Quantum robust fitting},
  author={Chin, Tat-Jun and Suter, David and Ch'ng, Shin-Fang and Quach, James},
  booktitle={Proceedings of the Asian Conference on Computer Vision},
  year={2020}
  }
````

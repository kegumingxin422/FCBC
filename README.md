# FCBC (Fast Clustering with Balanced Constraint)

Recently, our paper has attracted more and more attention, and there are also many private messages to call for code to be reproduced. So I'd like to open source the code, hoping to help researchers who are interested in this field.

The folder `original-data` is the all the orignial data we used in our paper, and you can run the `RunGetBalanceData.m` to get the balanced dataset in `data`.

Balanced K-means (BKM) and Balanced Clustering with Least Square Regression (BCLS) are two baseline methods we compared. You can run them via `run_BKM.m` and `run_BCLS.m` respectively.

To reproduce ours, please refer to `run_FBKM.m`.

The code is originally designed for research purposes, but adaptable to industrial use. 


## Citation
This code implements a Fast Clustering with Balanced Constraint method proposed in the following paper. (* means equal contribution.)

Hongfu Liu*, Ziming Huang*, Qi Chen, Mingqin Li, Yun Fu, Lintao Zhang 

If you find it useful, please cite the [paper](https://ieeexplore.ieee.org/document/8621917).
```
@article{Liu2018FastCW,
  title={Fast Clustering with Flexible Balance Constraints},
  author={Hongfu Liu and Ziming Huang and Qi Chen and Mingqin Li and Yun Fu and L. Zhang},
  journal={2018 IEEE International Conference on Big Data (Big Data)},
  year={2018},
  pages={743-750}
}
```

## Contact
Please feel free to contact me (Ziming Huang) via hzmyouxiang (AT) gmail.com if you have any questions.



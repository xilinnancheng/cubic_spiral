# Cubic spiral
## Introduction
This is a matlab version to generate the cubic spiral which is illustrated in __Reference One__.  
  
Here, I used the `syms` in matlab to get the expression of the objective function and its gradient. The reason why I use this method to calculate the gradient is that it's difficult to get the correct one by manual computation. Please refer to __gradient.m__ and __gradient.txt__ for details.  
  
Then, I tried to use `L-BFGS-B` to solve this nolinear programming problem. Run __cubic_spiral.m__ to get the example of cubic spiral. The following images show different cubic spirals when they end at different poses.  
![curvature and theta](https://github.com/xilinnancheng/cubic_spiral/blob/master/cubic_spiral_example/spiral%20curvature:k_f%20%3D%200.0%2Ctheta%20%3D%200.5pi.png)  
![image]

## Reference
[Self driving courses in Coursera] https://github.com/qiaoxu123/Self-Driving-Cars/blob/master/Part4-Motion_Planning_for_Self-Driving_Cars/Module7-Putting_it_all_together-Smooth_Local_Planning/Module7-Putting_it_all_together-Smooth_Local_Planning.md

[L-BFGS-B Optimizer] https://github.com/stephenbeckr/L-BFGS-B-C

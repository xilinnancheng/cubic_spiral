# Cubic spiral
## Introduction
This is a matlab version to generate the cubic spiral which is illustrated in __Reference One__.  
  
Here, I used the `syms` in matlab to get the expression of the obejective function and its gradient. The reason why I use this method to calculate the gradient is that it's difficult to get the correct one by manual computation. Please refer to __gradient.m__ and __gradient.txt__.  
  
Then, I tried to use `L-BFGS-B` to solve this nolinear programming problem. Run __cubic_spiral.m__ to get the result.

## Reference
[Self driving courses in Coursera] https://github.com/qiaoxu123/Self-Driving-Cars/blob/master/Part4-Motion_Planning_for_Self-Driving_Cars/Module7-Putting_it_all_together-Smooth_Local_Planning/Module7-Putting_it_all_together-Smooth_Local_Planning.md

[L-BFGS-B Optimizer] https://github.com/stephenbeckr/L-BFGS-B-C

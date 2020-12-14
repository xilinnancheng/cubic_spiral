function p = spiral_optimize(lower_bound,upper_bound,start,target)   
    p0 = [start(4);target(4);norm([target(1)-start(1),target(2)-start(2)])];

    lower_bounds = [lower_bound;lower_bound;p0(3)];
    upper_bounds = [upper_bound;upper_bound;inf];
    min_objective = @(x) cubic_spiral_objective(x,start,target);
    
    opts    = struct( 'factr', 1e7, 'pgtol', 1e-3, 'm', 10);
    opts.printEvery     = 5;
    opts.x0 = [start(4); target(4); p0(3)];
    [p, ~, info] = lbfgsb(min_objective, lower_bounds, upper_bounds, opts );
end
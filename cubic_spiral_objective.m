function [val, gradient] = cubic_spiral_objective(p,start,target)
    x0 = start(1);
    y0 = start(2);
    theta0 = start(3);
    k0 = start(4);
    
    xf = target(1);
    yf = target(2);
    thetaf = target(3);
    kf = target(4);

    p_aug = [k0,p(1),p(2),kf,p(3)];

    weight = [25,25,36];

    val = fbe(p_aug) + weight(1) * fxf(p_aug,theta0,x0,xf) + weight(2) * fyf(p_aug,theta0,y0,yf) ...
        + weight(3) * ftf(p_aug,theta0,thetaf);
    if (nargout > 1)
        gradient = fbe_grad(p_aug) + weight(1) * fxf_grad(p_aug,theta0,x0,xf) + weight(2) * fyf_grad(p_aug,theta0,y0,yf) ...
            + weight(3) * ftf_grad(p_aug,theta0,thetaf);
    end
end
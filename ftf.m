function val = ftf(p,theta_0,theta_f)
    p1 = p(1);
    p2 = p(2);
    p3 = p(3);
    p4 = p(4);
    p5 = p(5);
    
    val = (theta_0 - theta_f + p1*p5 - (p5*((11*p1)/2 - 9*p2 + (9*p3)/2 - p4))/2 - (p5*((9*p1)/2 - (27*p2)/2 + (27*p3)/2 - (9*p4)/2))/4 + (p5*(9*p1 - (45*p2)/2 + 18*p3 - (9*p4)/2))/3)^2;
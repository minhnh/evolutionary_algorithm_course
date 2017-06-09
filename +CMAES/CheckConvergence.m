function converging = CheckConvergence(obj)
%CHECKCONVERGENCE break when covariance condition to high
    converging = false;
    if cond(obj.Constraints.covariance) > 1e14
        converging = true;
    end
end
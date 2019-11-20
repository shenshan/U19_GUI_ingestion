function [rad] = angleMPiPi(rad)
    
  rad   = rad                             ...
        - ceil((rad - pi) / (2*pi))       ...
        * 2*pi                            ...
        ;

end

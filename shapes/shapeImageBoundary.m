classdef shapeImageBoundary < virmenShape
    properties
    end
    methods
        function obj = shapeImageBoundary
            obj.iconLocations = [0 0; 10 10; 50 0; 40 -30];
        end
        function obj = getPoints(obj)
            [x y] = getline(gcf);
            if length(x)==1
                obj.x = [];
                obj.y = [];
            else
                obj.x = x;
                obj.y = y;
            end
        end
        function [x y] = coords2D(obj)
            loc = obj.locations;
            x = loc(:,1);
            y = loc(:,2);
        end
    end
end

function [map] = membershipMap(clusters, height, width)
    
    if(nargin<3)
        width = 512;
    end
    if(nargin<2)
        height = 512;
    end

    map = zeros(height,width);

    for i_cluster = 1:length(clusters)
        map(clusters{i_cluster}) = i_cluster;
    end
end
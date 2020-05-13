function [clusters] = k_corr_clust(Vr2, N, join_threshold, loops, chunk_size, height, width, plotting)

    nFrames2 = size(Vr2,1);

    r = randperm(height*width,N);
    clusters = arrayfun(@(x) x, r, 'UniformOutput', false);

    imagesc(membershipMap(clusters));

    timesVisited = zeros(height*width,1);
    clusterTraces = Vr2(:,cell2mat(clusters));
    nMembers = ones(1,N);
    
    
    N = chunk_size;
    for p = 1:loops
        m = min(timesVisited);
        leastVisited = find(timesVisited==m);
        targetIndices = randi(length(leastVisited),[N 1]);
        iii = leastVisited(targetIndices);
        theseTraces = Vr2(:,iii);
        for zz = 1:N
            ii = leastVisited(targetIndices(zz));
            thisTrace = theseTraces(:,zz);        
            C = thisTrace'*clusterTraces/(nFrames2-1);        
            [y,i] = max(C);
            if(y>join_threshold)
                clusters{i} = [clusters{i} ii];
                clusterTraces(:,i) = (clusterTraces(:,i)*nMembers(i) + thisTrace)/(nMembers(i)+1);
                timesVisited(ii) = timesVisited(ii)+1;
                nMembers(i) = nMembers(i)+1;
            end
        end
        if(plotting==1)
            clf;
            imagesc(membershipMap(clusters));
            pause(eps);
        end
    end        
end
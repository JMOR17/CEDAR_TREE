function [masks] = cleanup_clusters(clusters, height, width, thr1, thr2)

    N_clusters = length(clusters);
    total_cluster_size = zeros(1,N_clusters);
    biggest_cluster_size = zeros(1,N_clusters);
    masks = zeros(height, width, N_clusters);

    for i_cluster = 1:N_clusters
        mask = medfilt2(membershipMap(clusters(i_cluster), height, width));
        mask = bwareafilt(mask==1,[thr2 height*width/4]);
        masks(:,:,i_cluster) = mask;
        total_cluster_size(i_cluster) = sum(mask(:));
%         mask2 = bwareafilt(mask==1,[thr2 height*width/4]);
%         biggest_cluster_size(i_cluster) = sum(mask2(:));
    end

    valid = (total_cluster_size > thr1);% & (biggest_cluster_size > thr2);
    
    masks = masks(:,:,valid);
end
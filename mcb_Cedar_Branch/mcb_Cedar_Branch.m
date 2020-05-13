function [masks] = mcb_Cedar_Branch(filename)

%     filename = 'D:\Jason\MATLAB\SR_Test\885\885D5_MC.tif';

    
    frames = 19999;             %Total frames to be loaded in
    downsample_factor = 10;     %How much to downsample by
    temporal_smoothing = 1;     %How much to smooth in time (after downsampling)
    spatial_smoothing = 3;      %How much to smooth in space

    plotting = 1;               %Do you want to plot as things are clustered?

    initial_points = 500;       %The number of random initial points
    join_threshold = 0.3;       %The minimum correlation needed to join a cluster
    chunk_size = 1000;          %The number of points to process before recomputing means
    loops = 800;                %The number of times to repeat the process

    minimum_segment_size = 20;  %The smallest number of pixels a valid segment can be
    minimum_cluster_size = 50;  %The smallest number of pixels a valid cluster can be
                                %(A cluster is defined as the sum of all of
                                %its segments)

    %% Step 1: Load in the video

    fprintf('\nLoading in video...\n');
    V = j_load_downsample_TiffStack_3(filename,frames,downsample_factor);

    [height, width, ~] = size(V);
    %% Step 2: Smooth in time, smooth in space

    fprintf('\nSmoothing and preparing...\n');
    Vr2 = smooth_and_prepare(V, temporal_smoothing, spatial_smoothing);
    
    %% Step 3: Make initial clusters

    fprintf('\nClustering...\n');
    clusters = k_corr_clust(Vr2, initial_points, join_threshold, loops, chunk_size, height, width, plotting);

    %% Step 4: Clean up clusters

    fprintf('\nCleaning...\n');
    masks = cleanup_clusters(clusters, height, width, minimum_cluster_size, minimum_segment_size);

end
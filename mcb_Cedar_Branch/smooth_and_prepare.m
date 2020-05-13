function [Vr2] = smooth_and_prepare(V, temporal_smoothing, spatial_smoothing)

    [height,width,nFrames2] = size(V);

    %% Step 2: Smooth in time, smooth in space
    fprintf('\nSmoothing in time...\n');
    if(temporal_smoothing>0)
        Vsmooth = NaN(size(V));
        for iA = 1:height    
            for iB = 1:width
                Vsmooth(iA,iB,:) = jmm_smooth_1d_cor(squeeze(V(iA,iB,:)),temporal_smoothing);
            end
        end
    else
        Vsmooth = V;
    end

    fprintf('\nSmoothing in space...\n');
    if(spatial_smoothing>=3)
        for iFrame = 1:nFrames2
            Vsmooth(:,:,iFrame) = medfilt2(squeeze(Vsmooth(:,:,iFrame)),spatial_smoothing*[1 1]);
        end
    end

    a2 = squeeze(mean(Vsmooth,3));
    b2 = squeeze(std(Vsmooth,[],3));

    Vsmooth3 = bsxfun(@rdivide,bsxfun(@minus,Vsmooth,a2),b2);
    Vsmooth3(isnan(Vsmooth3)) = 0;
    Vsmooth3(isinf(Vsmooth3)) = 0;

    Vr = reshape(Vsmooth3,height*width,[]);
    Vr2 = Vr;
    Vr2(Vr2<0) = 0;
    
    Vr2 = Vr2';
end
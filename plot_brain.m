function [plot] = plot_BA_rois(plottype,roi_idx,which_hemisphere,electrodes)
%PLOT_BA_ROIS Summary of this function goes here
    
    %plottype: 
        %'wholebrain': plot whole brain, no highlights
        %'selection': plot only those BA areas specified in roi_idx
        %'highlight': plot whole brain, but highlight specified BA areas in roi_idx
    %roi_idx:
        %array of BA area codes (for details see ATLAS_LABELS.csv)
        
    %which_hemisphere:
        %1 for left
        %2 for right
        %1:2 for both
        
    %electrodes:
        %N x 3 electrode coordinates
        %if none to be plotted, insert empty {}
    
    %% add + load stuff
    disp('load BA atlas')
    rois = readtable('ATLAS_LABELS.csv');
    
    %% determine plotting scheme
    % selection: plot only masks for specified BA according to color scheme
    % highlight: plot all masks, highlight specified according to color
    % scheme, plot rest transparent lightgrey
    
    switch plottype
        case 'wholebrain'
            rois_to_plot = rois.BA;
        case 'selection' %if selection, plot only specified ROIS 
            %rois_to_plot should be a 1d array of BA codes
            rois_to_plot = roi_idx; 
            
        case 'highlight'
            % color only specified rois but plot all others in grey
            highlight = roi_idx;
            others = setdiff(rois.BA,roi_idx)';            
            % set new rois_to_plot by including all others sorted
            rois_to_plot = [highlight, others];
    end
        
    %% load roi masks and plot
    figure;
    for hem = which_hemisphere
        %hem = which_hemisphere(hemi);
        if hem == 1
            hemname = 'lh';
        elseif hem == 2
            hemname = 'rh';
        end
        disp(['plot ' hemname])

        for roii = 1:length(rois_to_plot)
            roi = rois_to_plot(roii);
            if roi ~= 0
                %get the index of the current roi in table
                idx = intersect(find(rois.BA == roi),find(rois.Hemisphere == hem));
                file_name = rois{idx,'Label'}{1};
                %load precomputed mask
                mask = load(['BA\' file_name '.mat']);
                faces = mask.roi.faces;
                vertices = mask.roi.vertices;
                
                %% prepare plotting of current roi
                %determine lobe
                col_idx = rois.ColIdx(idx);
                
                %set color for current lobe
                lobe = rois{idx,'Lobe'};
                if strcmp(lobe,'Temporal')
                    cmap = cbrewer2('seq','Greens',15); 
                elseif strcmp(lobe,'Occipital')
                    cmap = cbrewer2('seq','Blues',15); 
                elseif strcmp(lobe,'Frontal')
                    cmap = cbrewer2('seq','Reds',15); 
                elseif strcmp(lobe,'Parietal')
                    cmap = cbrewer2('seq','Purples',15);
                elseif strcmp(lobe,'Deep')
                    cmap = cbrewer2('seq','Oranges',15); 
                elseif strcmp(lobe,'Cingulum')
                    cmap = cbrewer2('seq','PuBuGn',15);
                end
                
                %normalize colors 
                cmap(cmap>1) = 1; cmap(cmap<0) = 0;
                cmap = flipud(cmap);

                %col = cmap(col_idx,:);
                %reset color if highlight plot and current roi is not
                %highlighted
                if strcmp(plottype,'highlight')
                    %reset color to grey of its no highighted roi
                    if ismember(roi,others)
                        if strcmp(lobe,'Deep')
                            col = [0.55 0.55 0.55];
                        else
                            col = [0.80 0.80 0.80];
                        end
                        face_alpha_level = 0.1; %if non-highlight, plot transparent
                    elseif ismember(roi,highlight)
                        face_alpha_level = 0.3; %if highlight, plot non transparent
                        col = cmap(roii,:);

                    end    
                elseif strcmp(plottype,'selection')
                    col = cmap(col_idx,:);
                    face_alpha_level = 0.3;
                elseif strcmp(plottype, 'wholebrain')
                    col = [0.8 0.8 0.8]; %use this to plot all areas in greyscale
                    %col = cmap(col_idx,:); %use this to color all individual BA
                    
                    if col == [0.8 0.8 0.8]
                        face_alpha_level = 0.1;
                    else
                        face_alpha_level = 0.8;
                    end
                end

                %% plot the mask
                p = patch('faces',faces,'vertices',vertices);
                p.FaceAlpha = face_alpha_level;
                p.FaceColor = col;
                p.EdgeAlpha = 0;
                hold on;

            end
        end
    end
    
    %format plot
    view([-90 0 0])
    set(gcf,'color','white')
    axis off
    axis vis3d
    set(gca,'dataaspectratiomode','manual');
    set(gca,'dataaspectratio',[1 1 1]);
    plot = gcf; %return
    set(gcf,'color','white')
    hold on;
    
    %% plot electrodes
    if ~isempty(electrodes)

        elec_color = [0 0 0]; %black
        gcf;
        scatter3(electrodes(:,1),electrodes(:,2),electrodes(:,3),50,elec_color,'o','filled'); hold on;
    end
end


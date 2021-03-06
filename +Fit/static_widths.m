classdef static_widths < handle
    % phase_space_density fits a 2D gaussian to the data
    %   Detailed explanation goes here
    
    properties
       
        parent_fit
        
    end
    
    properties % Fit results
        
        roi_total_signal
        
        r_center
        c_center
        
        r_width
        c_width
        
    end
    
    methods
        
        function obj = static_widths(fit)
            
            obj = obj@handle;
            
            obj.parent_fit = fit;
            
        end
        
        function fit(obj)
            
            props = obj.parent_fit.pic_props(1);
            
            r_vec = (props.r_roi_ctr-props.roi_wth):(props.r_roi_ctr+props.roi_wth);
            c_vec = (props.c_roi_ctr-props.roi_wth):(props.c_roi_ctr+props.roi_wth);
            
            pic_roi = obj.parent_fit.parent_data.pics.pic_cor(r_vec,c_vec);
            
            obj.roi_total_signal = sum(pic_roi(:));
            
            r_prof = sum(pic_roi,2);
            c_prof = sum(pic_roi,1);
                   
            r_mean = r_vec(:).*r_prof(:);
            c_mean = c_vec(:).*c_prof(:);
            
            obj.r_center = sum(r_mean(:))/sum(r_prof(:));
            obj.c_center = sum(c_mean(:))/sum(c_prof(:));
            
            r_variance = r_vec(:).^2.*r_prof(:);
            c_variance = c_vec(:).^2.*c_prof(:);
            
            obj.r_width = sqrt(sum(r_variance(:))/sum(r_prof(:))-obj.r_center^2);
            obj.c_width = sqrt(sum(c_variance(:))/sum(c_prof(:))-obj.c_center^2);
            
        end
        
    end
    
end


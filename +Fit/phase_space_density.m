classdef phase_space_density < handle
    % phase_space_density fits a 2D gaussian to the data
    %   Detailed explanation goes here
    
    properties
       
        parent_fit
         
    end
    
    properties % Fit results
        
        pic_density
        
        r_center
        c_center
        
        r_width
        c_width
        
        theta
        
        PSD
        
        total_atom_number
        
    end
    
    methods
        
        function obj = phase_space_density(fit)
            
            obj = obj@handle;
            
            obj.parent_fit = fit;
            
        end
        
        function fit(obj)
            
            props = obj.parent_fit.pic_props(1);
            
            r_vec = (props.r_roi_ctr-props.roi_wth):(props.r_roi_ctr+props.roi_wth);
            c_vec = (props.c_roi_ctr-props.roi_wth):(props.c_roi_ctr+props.roi_wth);
            
            [C,R] = meshgrid(c_vec,r_vec);
            
            pic_roi = obj.parent_fit.parent_data.pics.pic_cor(r_vec,c_vec);
           
              
            r_prof = sum(pic_roi,2);
            c_prof = sum(pic_roi,1);
            
                       
            [r_max,r_i_max] = max(r_prof);
            [c_max,c_i_max] = max(c_prof);
            
            r_std = sqrt(sum(r_prof(:).*(r_vec'-sum(r_prof(:).*r_vec')/sum(r_prof)).^2)/sum(r_prof));
            c_std = sqrt(sum(c_prof(:).*(c_vec'-sum(c_prof(:).*c_vec')/sum(c_prof)).^2)/sum(c_prof));
            
            if (sum(pic_roi(:))>5*10^5)&&(abs(r_std>0))&&(abs(c_std>0))
                
                fit_fun = @(p) pic_roi - p(1)*max(pic_roi(:))*exp(-(cos(p(6))*(R-p(2))+sin(p(6))*(C-p(3))).^2/(2*p(4)^2)-(-sin(p(6))*(R-p(2))+cos(p(6))*(C-p(3))).^2/(2*p(5)^2));
                
                fit_results = lsqnonlin(fit_fun,[1,r_i_max+r_vec(1)-1,c_i_max+c_vec(1)-1,...
                    abs(r_std),abs(c_std),pi/4]);
                
                obj.pic_density = fit_results(1)*max(pic_roi(:));
                obj.r_center = fit_results(2);
                obj.c_center = fit_results(3);
                
                obj.theta = mod(fit_results(6),2*pi);
                
                if (obj.theta>=pi/4)&&(obj.theta<3*pi/4)
                    
                    obj.theta = obj.theta - pi/2;
                    obj.r_width = abs(fit_results(5));
                    obj.c_width = abs(fit_results(4));
                    
                elseif (obj.theta>=3*pi/4)&&(obj.theta<5*pi/4)
                    
                    obj.theta = obj.theta - pi;
                    obj.r_width = abs(fit_results(4));
                    obj.c_width = abs(fit_results(5));
                    
                elseif (obj.theta>=5*pi/4)&&(obj.theta<7*pi/4)
                    
                    obj.theta = obj.theta - 3*pi/2;
                    obj.r_width = abs(fit_results(5));
                    obj.c_width = abs(fit_results(4));
                    
                elseif (obj.theta>=7*pi/4)
                    
                    obj.theta = obj.theta - 2*pi;
                    obj.r_width = abs(fit_results(4));
                    obj.c_width = abs(fit_results(5));
                    
                else
                    
                    obj.r_width = abs(fit_results(4));
                    obj.c_width = abs(fit_results(5));
                    
                end
                
                obj.PSD = real(fit_results(1)*max(pic_roi(:))/(fit_results(4)*fit_results(5)));
                
                obj.total_atom_number = fit_results(1)*max(pic_roi(:))*2*pi*fit_results(4)*fit_results(5);
                
            else
                
                obj.pic_density = 0;
                obj.r_center = 0;
                obj.c_center = 0;
                obj.theta = 0;
                obj.r_width = 0;
                obj.c_width = 0;
                obj.PSD = 0;
                obj.total_atom_number = 0;
                
            end
            
        end
        
        function show(obj)
            
            props = obj.parent_fit.pic_props(1);
            
            r_vec = (props.r_roi_ctr-props.roi_wth):(props.r_roi_ctr+props.roi_wth);
            c_vec = (props.c_roi_ctr-props.roi_wth):(props.c_roi_ctr+props.roi_wth);
            
            [C,R] = meshgrid(c_vec,r_vec);
            
            pic_roi = obj.parent_fit.parent_data.pics.pic_cor(r_vec,c_vec);
            
            r_prof = sum(pic_roi,2);
            c_prof = sum(pic_roi,1);
            
            pic_density = obj.pic_density;
            theta = obj.theta;
            r_center = obj.r_center;
            c_center = obj.c_center;
            r_width = obj.r_width;
            c_width = obj.c_width;
            
            fit_function = @(R,C) pic_density*exp(-(cos(theta)*(R-r_center)+sin(theta)*(C-c_center)).^2/(2*r_width^2)-(-sin(theta)*(R-r_center)+cos(theta)*(C-c_center)).^2/(2*c_width^2));
            
            fit_pic_roi = fit_function(R,C);
            
            fit_r_prof = sum(fit_pic_roi,2);
            fit_c_prof = sum(fit_pic_roi,1);
            
            figure;
            
            imagesc(fit_pic_roi)
            
            axis image
            
            set(gca,'Box','on','Tickdir','out','YDir','normal','XTickLabel',[],'YTickLabel',[]);
            
            figure;
            
            hold on
            
            plot(r_prof,'k+')
            plot(fit_r_prof,'r-')
            
            hold off
            
            figure;
            
            hold on
            
            plot(c_prof,'k+')
            plot(fit_c_prof,'r-')
            
            hold off
            
        end
        
    end
    
end



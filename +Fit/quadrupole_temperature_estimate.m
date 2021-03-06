classdef quadrupole_temperature_estimate < handle
    % quadrupole_temperature_estimate estimates mean and variance of the
    % horizontal and vertical density profiles and calculates temperature
    % and magnetic field gradient.
    %   Detailed explanation goes here
    
    properties
       
        parent_fit
         
    end
    
    properties % Output properties
        
        r_mean
        c_mean
        
        r_std
        c_std
        
        T
        bp
        
    end
    
    properties % Fit results
       
        r_left_results
        r_right_results
        
        c_left_results
        c_right_results
        
    end
    
    methods
        
        function obj = quadrupole_temperature_estimate(fit)
            
            obj = obj@handle;
            
            obj.parent_fit = fit;
            
        end
        
        function fit(obj)
            
            % Get horizontal and vertical density profiles
            
            props = obj.parent_fit.pic_props(1);
            
            r_vec = (props.r_roi_ctr-props.roi_wth):(props.r_roi_ctr+props.roi_wth);
            c_vec = (props.c_roi_ctr-props.roi_wth):(props.c_roi_ctr+props.roi_wth);
            
            pic_roi = obj.parent_fit.parent_data.pics.pic_cor(r_vec,c_vec);
            
            if (sum(pic_roi(:))>5*10^6)
            
            r_prof = sum(pic_roi,2)'; % vertical
            c_prof = sum(pic_roi,1); % horizontal
            
            [r_max,r_i_max] = max(r_prof);
            [c_max,c_i_max] = max(c_prof);
            
            r_wth = min(floor(r_vec(end)-r_vec(1)-r_i_max),floor(r_i_max-1))/2;
            
            % Estimate the mean of each profile using a moving average method
            
            r_mean_fun = @(y) abs(sum(((ceil(y-r_wth):floor(y+r_wth))-y).*r_prof((ceil(y-r_wth):floor(y+r_wth))))...
                +(1-(ceil(y+r_wth)-(y+r_wth)))*(ceil(y+r_wth)-y)*r_prof(ceil(y+r_wth))*((y+r_wth)<ceil(y+r_wth))...
                +(1-((y-r_wth)-floor(y-r_wth)))*(floor(y-r_wth)-y)*r_prof(floor(y-r_wth))*((y-r_wth)>floor(y-r_wth)))/sum(r_prof);
            
            c_wth = min(floor(c_vec(end)-c_vec(1)-c_i_max),floor(c_i_max-1))/2;
            
            c_mean_fun = @(y) abs(sum(((ceil(y-c_wth):floor(y+c_wth))-y).*c_prof((ceil(y-c_wth):floor(y+c_wth))))...
                +(1-(ceil(y+c_wth)-(y+c_wth)))*(ceil(y+c_wth)-y)*c_prof(ceil(y+c_wth))*((y+c_wth)<ceil(y+c_wth))...
                +(1-((y-c_wth)-floor(y-c_wth)))*(floor(y-c_wth)-y)*c_prof(floor(y-c_wth))*((y-c_wth)>floor(y-c_wth)))/sum(c_prof);
            
            r_mean = fminsearch(r_mean_fun,r_i_max);
            
            c_mean = fminsearch(c_mean_fun,c_i_max);
            
            % Estimate the variance of each profile through a fit of the
            % cdf
            
            r_var_fun = @(z) (sum(((ceil(r_mean-z):floor(r_mean+z))-r_mean).^2.*r_prof((ceil(r_mean-z):floor(r_mean+z))))...
                +(1-(ceil(r_mean+z)-(r_mean+z)))*(ceil(r_mean+z)-r_mean)^2*r_prof(ceil(r_mean+z))*((r_mean+z)<ceil(r_mean+z))...
                +(1-((r_mean-z)-floor(r_mean-z)))*(floor(r_mean-z)-r_mean)^2*r_prof(floor(r_mean-z))*((r_mean-z)>floor(r_mean-z)))/sum(r_prof);
            
            r_var_i_vec = 1:min(floor(r_vec(end)-r_vec(1)+1-r_mean),floor(r_mean-1));
            
            r_var_vec = zeros(size(r_var_i_vec));
            
            for i=r_var_i_vec
                
                r_var_vec(i)=r_var_fun(i);
                
            end
            
            var_fun = @(x,xdata) -sqrt(2/pi)*x*xdata.*exp(-xdata.^2/(2*x^2))+x^2*erf(xdata/(sqrt(2)*x));
            
            r_std = lsqcurvefit(var_fun,sqrt(r_var_vec(end)),r_var_i_vec,r_var_vec);
            
            c_var_fun = @(z) (sum(((ceil(c_mean-z):floor(c_mean+z))-c_mean).^2.*c_prof((ceil(c_mean-z):floor(c_mean+z))))...
                +(1-(ceil(c_mean+z)-(c_mean+z)))*(ceil(c_mean+z)-c_mean)^2*c_prof(ceil(c_mean+z))*((c_mean+z)<ceil(c_mean+z))...
                +(1-((c_mean-z)-floor(c_mean-z)))*(floor(c_mean-z)-c_mean)^2*c_prof(floor(c_mean-z))*((c_mean-z)>floor(c_mean-z)))/sum(c_prof);
            
            c_var_i_vec = 1:min(floor(c_vec(end)-c_vec(1)+1-c_mean),floor(c_mean-1));
            
            c_var_vec = zeros(size(c_var_i_vec));
            
            for i=c_var_i_vec
                
                c_var_vec(i)=c_var_fun(i);
                
            end
            
            var_fun = @(x,xdata) -sqrt(2/pi)*x*xdata.*exp(-xdata.^2/(2*x^2))+x^2*erf(xdata/(sqrt(2)*x));
            
            c_std = lsqcurvefit(var_fun,sqrt(c_var_vec(end)),c_var_i_vec,c_var_vec);
            
            % Estimate the variance on each side of the distribution
            
            % r_left
            
            r_var_left_fun = @(z) (sum(((ceil(r_mean-z):floor(r_mean))-r_mean).^2.*r_prof((ceil(r_mean-z):floor(r_mean))))...
                +(1-(ceil(r_mean)-(r_mean)))*(ceil(r_mean)-r_mean)^2*r_prof(ceil(r_mean))*((r_mean)<ceil(r_mean))...
                +(1-((r_mean-z)-floor(r_mean-z)))*(floor(r_mean-z)-r_mean)^2*r_prof(floor(r_mean-z))*((r_mean-z)>floor(r_mean-z)))/sum(r_prof(1:floor(r_mean)));
            
            r_var_left_i_vec = 1:floor(r_mean-1);
            
            r_var_left_vec = zeros(size(r_var_left_i_vec));
            
            for i=r_var_left_i_vec
                
                r_var_left_vec(i)=r_var_left_fun(i);
                
            end
            
            var_left_fun = @(x,xdata) x(1)*(-sqrt(2/pi)*x(2)*xdata.*exp(-xdata.^2/(2*x(2)^2))+x(2)^2*erf(xdata/(sqrt(2)*x(2))));
            
            obj.r_left_results = lsqcurvefit(var_left_fun,[1,sqrt(r_var_left_vec(end))],r_var_left_i_vec,r_var_left_vec);
            
            % r_right
            
            r_var_right_fun = @(z) (sum(((ceil(r_mean):floor(r_mean+z))-r_mean).^2.*r_prof((ceil(r_mean):floor(r_mean+z))))...
                +(1-(ceil(r_mean+z)-(r_mean+z)))*(ceil(r_mean+z)-r_mean)^2*r_prof(ceil(r_mean+z))*((r_mean+z)<ceil(r_mean+z))...
                +(1-((r_mean)-floor(r_mean)))*(floor(r_mean)-r_mean)^2*r_prof(floor(r_mean))*((r_mean)>floor(r_mean)))/sum(r_prof(ceil(r_mean):(r_vec(end)-r_vec(1)+1)));
            
            r_var_right_i_vec = 1:floor(r_vec(end)-r_vec(1)+1-r_mean);
            
            r_var_right_vec = zeros(size(r_var_right_i_vec));
            
            for i=r_var_right_i_vec
                
                r_var_right_vec(i)=r_var_right_fun(i);
                
            end
            
            var_right_fun = @(x,xdata) x(1)*(-sqrt(2/pi)*x(2)*xdata.*exp(-xdata.^2/(2*x(2)^2))+x(2)^2*erf(xdata/(sqrt(2)*x(2))));
            
            obj.r_right_results = lsqcurvefit(var_right_fun,[1,sqrt(r_var_right_vec(end))],r_var_right_i_vec,r_var_right_vec);
            
            % c_left
            
            c_var_left_fun = @(z) (sum(((ceil(c_mean-z):floor(c_mean))-c_mean).^2.*c_prof((ceil(c_mean-z):floor(c_mean))))...
                +(1-(ceil(c_mean)-(c_mean)))*(ceil(c_mean)-c_mean)^2*c_prof(ceil(c_mean))*((c_mean)<ceil(c_mean))...
                +(1-((c_mean-z)-floor(c_mean-z)))*(floor(c_mean-z)-c_mean)^2*c_prof(floor(c_mean-z))*((c_mean-z)>floor(c_mean-z)))/sum(c_prof(1:floor(c_mean)));
            
            c_var_left_i_vec = 1:floor(c_mean-1);
            
            c_var_left_vec = zeros(size(c_var_left_i_vec));
            
            for i=c_var_left_i_vec
                
                c_var_left_vec(i)=c_var_left_fun(i);
                
            end
            
            var_left_fun = @(x,xdata) x(1)*(-sqrt(2/pi)*x(2)*xdata.*exp(-xdata.^2/(2*x(2)^2))+x(2)^2*erf(xdata/(sqrt(2)*x(2))));
            
            obj.c_left_results = lsqcurvefit(var_left_fun,[1,sqrt(c_var_left_vec(end))],c_var_left_i_vec,c_var_left_vec);
            
            % c_right
            
            c_var_right_fun = @(z) (sum(((ceil(c_mean):floor(c_mean+z))-c_mean).^2.*c_prof((ceil(c_mean):floor(c_mean+z))))...
                +(1-(ceil(c_mean+z)-(c_mean+z)))*(ceil(c_mean+z)-c_mean)^2*c_prof(ceil(c_mean+z))*((c_mean+z)<ceil(c_mean+z))...
                +(1-((c_mean)-floor(c_mean)))*(floor(c_mean)-c_mean)^2*c_prof(floor(c_mean))*((c_mean)>floor(c_mean)))/sum(c_prof(ceil(c_mean):(c_vec(end)-c_vec(1)+1)));
            
            c_var_right_i_vec = 1:floor(c_vec(end)-c_vec(1)+1-c_mean);
            
            c_var_right_vec = zeros(size(c_var_right_i_vec));
            
            for i=c_var_right_i_vec
                
                c_var_right_vec(i)=c_var_right_fun(i);
                
            end
            
            var_right_fun = @(x,xdata) x(1)*(-sqrt(2/pi)*x(2)*xdata.*exp(-xdata.^2/(2*x(2)^2))+x(2)^2*erf(xdata/(sqrt(2)*x(2))));
            
            obj.c_right_results = lsqcurvefit(var_right_fun,[1,sqrt(c_var_right_vec(end))],c_var_right_i_vec,c_var_right_vec);
            
            % Set the value of the output properties
            
            obj.r_mean = r_mean;
            obj.c_mean = c_mean;
            
            if floor(r_mean-1)>floor(r_vec(end)-r_vec(1)+1-r_mean)
                
                obj.r_std = obj.r_left_results(2);
                
            else
                
                obj.r_std = obj.r_right_results(2);
                
            end
            
            if floor(c_mean-1)>floor(c_vec(end)-c_vec(1)+1-c_mean)
                
                obj.c_std = obj.c_left_results(2);
                
            else
                
                obj.c_std = obj.c_right_results(2);
                
            end
                        
            magnification = 0.23;
            pixel_size = 6.45e-6;
            
            alpha = sqrt(3/((c_std*pixel_size/magnification)^2-(r_std*pixel_size/magnification)^2));
            
            kb = 1.38064852*10^(-23); % [J/K]
            m = 3.817540*10^(-26); % [kg]
            
            ttof = obj.parent_fit.parent_data.static_params(strcmp({obj.parent_fit.parent_data.static_params.name},'TOF_time')).value*1e-3;
            
            T = m/(kb*ttof^2)*((c_std*pixel_size/magnification)^2-4/alpha^2);
            
            gF = -1/2;
            mF = -1;
            muB = 9.274009994e-24; % [J/T]
            
            bp = kb*T*alpha/(gF*mF*muB);
            
            obj.T = T*1e6;
            obj.bp = bp*100;
            
            else
                
                obj.r_mean = 0;
                obj.c_mean = 0;
                
                obj.r_std = 0;
                obj.c_std = 0;
                
                obj.T = 0;
                obj.bp = 0;
                
            end
            
        end
        
        function show_var_estimate(obj)
            
            props = obj.parent_fit.pic_props(1);
            
            r_vec = (props.r_roi_ctr-props.roi_wth):(props.r_roi_ctr+props.roi_wth);
            c_vec = (props.c_roi_ctr-props.roi_wth):(props.c_roi_ctr+props.roi_wth);
            
            pic_roi = obj.parent_fit.parent_data.pics.pic_cor(r_vec,c_vec);
            
            r_prof = sum(pic_roi,2)'; % vertical
            c_prof = sum(pic_roi,1); % horizontal
            
            r_mean = obj.r_mean;
            
            c_mean = obj.c_mean;
            
            r_var_fun = @(z) (sum(((ceil(r_mean-z):floor(r_mean+z))-r_mean).^2.*r_prof((ceil(r_mean-z):floor(r_mean+z))))...
                +(1-(ceil(r_mean+z)-(r_mean+z)))*(ceil(r_mean+z)-r_mean)^2*r_prof(ceil(r_mean+z))*((r_mean+z)<ceil(r_mean+z))...
                +(1-((r_mean-z)-floor(r_mean-z)))*(floor(r_mean-z)-r_mean)^2*r_prof(floor(r_mean-z))*((r_mean-z)>floor(r_mean-z)))/sum(r_prof);
            
            r_var_i_vec = 1:min(floor(r_vec(end)-r_vec(1)-r_mean),floor(r_mean-1));
            
            r_var_vec = zeros(size(r_var_i_vec));
            
            for i=r_var_i_vec
                
                r_var_vec(i)=r_var_fun(i);
                
            end
            
            c_var_fun = @(z) (sum(((ceil(c_mean-z):floor(c_mean+z))-c_mean).^2.*c_prof((ceil(c_mean-z):floor(c_mean+z))))...
                +(1-(ceil(c_mean+z)-(c_mean+z)))*(ceil(c_mean+z)-c_mean)^2*c_prof(ceil(c_mean+z))*((c_mean+z)<ceil(c_mean+z))...
                +(1-((c_mean-z)-floor(c_mean-z)))*(floor(c_mean-z)-c_mean)^2*c_prof(floor(c_mean-z))*((c_mean-z)>floor(c_mean-z)))/sum(c_prof);
            
            c_var_i_vec = 1:min(floor(c_vec(end)-c_vec(1)-c_mean),floor(c_mean-1));
            
            c_var_vec = zeros(size(c_var_i_vec));
            
            for i=c_var_i_vec
                
                c_var_vec(i)=c_var_fun(i);
                
            end
            
            var_fun = @(x,xdata) -sqrt(2/pi)*x*xdata.*exp(-xdata.^2/(2*x^2))+x^2*erf(xdata/(sqrt(2)*x));
            
            r_var_long_vec = linspace(0,1.1*r_var_i_vec(end),201);
            
            figure
            
            hold on
            
            plot(r_var_i_vec,r_var_vec,'+k')
            
            plot(r_var_long_vec,var_fun(obj.r_std,r_var_long_vec),'-r')
            
            hold off
            
            xlabel('pixel')
            ylabel('r_var')
            
            c_var_long_vec = linspace(0,1.1*c_var_i_vec(end),201);
            
            figure
            
            hold on
            
            plot(c_var_i_vec,c_var_vec,'+k')
            
            plot(c_var_long_vec,var_fun(obj.c_std,c_var_long_vec),'-r')
            
            hold off
            
            xlabel('pixel')
            ylabel('c_var')
            
            % r_left
            
            r_var_left_fun = @(z) (sum(((ceil(r_mean-z):floor(r_mean))-r_mean).^2.*r_prof((ceil(r_mean-z):floor(r_mean))))...
                +(1-(ceil(r_mean)-(r_mean)))*(ceil(r_mean)-r_mean)^2*r_prof(ceil(r_mean))*((r_mean)<ceil(r_mean))...
                +(1-((r_mean-z)-floor(r_mean-z)))*(floor(r_mean-z)-r_mean)^2*r_prof(floor(r_mean-z))*((r_mean-z)>floor(r_mean-z)))/sum(r_prof(1:floor(r_mean)));
            
            r_var_left_i_vec = 1:floor(r_mean-1);
            
            r_var_left_vec = zeros(size(r_var_left_i_vec));
            
            for i=r_var_left_i_vec
                
                r_var_left_vec(i)=r_var_left_fun(i);
                
            end
            
            var_left_fun = @(x,xdata) x(1)*(-sqrt(2/pi)*x(2)*xdata.*exp(-xdata.^2/(2*x(2)^2))+x(2)^2*erf(xdata/(sqrt(2)*x(2))));
            
            r_var_left_long_vec = linspace(0,1.1*r_var_left_i_vec(end),201);
            
            figure
            
            hold on
            
            plot(r_var_left_i_vec,r_var_left_vec,'+k')
            
            plot(r_var_left_long_vec,var_left_fun(obj.r_left_results,r_var_left_long_vec),'-r')
            
            hold off
            
            xlabel('pixel')
            ylabel('r_left_var')
            
            % r_right
            
            r_var_right_fun = @(z) (sum(((ceil(r_mean):floor(r_mean+z))-r_mean).^2.*r_prof((ceil(r_mean):floor(r_mean+z))))...
                +(1-(ceil(r_mean+z)-(r_mean+z)))*(ceil(r_mean+z)-r_mean)^2*r_prof(ceil(r_mean+z))*((r_mean+z)<ceil(r_mean+z))...
                +(1-((r_mean)-floor(r_mean)))*(floor(r_mean)-r_mean)^2*r_prof(floor(r_mean))*((r_mean)>floor(r_mean)))/sum(r_prof(ceil(r_mean):(r_vec(end)-r_vec(1)+1)));
            
            r_var_right_i_vec = 1:floor(r_vec(end)-r_vec(1)+1-r_mean);
            
            r_var_right_vec = zeros(size(r_var_right_i_vec));
            
            for i=r_var_right_i_vec
                
                r_var_right_vec(i)=r_var_right_fun(i);
                
            end
            
            var_right_fun = @(x,xdata) x(1)*(-sqrt(2/pi)*x(2)*xdata.*exp(-xdata.^2/(2*x(2)^2))+x(2)^2*erf(xdata/(sqrt(2)*x(2))));
            
            r_var_right_long_vec = linspace(0,1.1*r_var_right_i_vec(end),201);
            
            figure
            
            hold on
            
            plot(r_var_right_i_vec,r_var_right_vec,'+k')
            
            plot(r_var_right_long_vec,var_right_fun(obj.r_right_results,r_var_right_long_vec),'-r')
            
            hold off
            
            xlabel('pixel')
            ylabel('r_right_var')
            
            % c_left
            
            c_var_left_fun = @(z) (sum(((ceil(c_mean-z):floor(c_mean))-c_mean).^2.*c_prof((ceil(c_mean-z):floor(c_mean))))...
                +(1-(ceil(c_mean)-(c_mean)))*(ceil(c_mean)-c_mean)^2*c_prof(ceil(c_mean))*((c_mean)<ceil(c_mean))...
                +(1-((c_mean-z)-floor(c_mean-z)))*(floor(c_mean-z)-c_mean)^2*c_prof(floor(c_mean-z))*((c_mean-z)>floor(c_mean-z)))/sum(c_prof(1:floor(c_mean)));
            
            c_var_left_i_vec = 1:floor(c_mean-1);
            
            c_var_left_vec = zeros(size(c_var_left_i_vec));
            
            for i=c_var_left_i_vec
                
                c_var_left_vec(i)=c_var_left_fun(i);
                
            end
            
            var_left_fun = @(x,xdata) x(1)*(-sqrt(2/pi)*x(2)*xdata.*exp(-xdata.^2/(2*x(2)^2))+x(2)^2*erf(xdata/(sqrt(2)*x(2))));
            
            c_var_left_long_vec = linspace(0,1.1*c_var_left_i_vec(end),201);
            
            figure
            
            hold on
            
            plot(c_var_left_i_vec,c_var_left_vec,'+k')
            
            plot(c_var_left_long_vec,var_left_fun(obj.c_left_results,c_var_left_long_vec),'-r')
            
            hold off
            
            xlabel('pixel')
            ylabel('c_left_var')
            
            % c_right
            
            c_var_right_fun = @(z) (sum(((ceil(c_mean):floor(c_mean+z))-c_mean).^2.*c_prof((ceil(c_mean):floor(c_mean+z))))...
                +(1-(ceil(c_mean+z)-(c_mean+z)))*(ceil(c_mean+z)-c_mean)^2*c_prof(ceil(c_mean+z))*((c_mean+z)<ceil(c_mean+z))...
                +(1-((c_mean)-floor(c_mean)))*(floor(c_mean)-c_mean)^2*c_prof(floor(c_mean))*((c_mean)>floor(c_mean)))/sum(c_prof(ceil(c_mean):(c_vec(end)-c_vec(1)+1)));
            
            c_var_right_i_vec = 1:floor(c_vec(end)-c_vec(1)+1-c_mean);
            
            c_var_right_vec = zeros(size(c_var_right_i_vec));
            
            for i=c_var_right_i_vec
                
                c_var_right_vec(i)=c_var_right_fun(i);
                
            end
            
            var_right_fun = @(x,xdata) x(1)*(-sqrt(2/pi)*x(2)*xdata.*exp(-xdata.^2/(2*x(2)^2))+x(2)^2*erf(xdata/(sqrt(2)*x(2))));
            
            c_var_right_long_vec = linspace(0,1.1*c_var_right_i_vec(end),201);
            
            figure
            
            hold on
            
            plot(c_var_right_i_vec,c_var_right_vec,'+k')
            
            plot(c_var_right_long_vec,var_right_fun(obj.c_right_results,c_var_right_long_vec),'-r')
            
            hold off
            
            xlabel('pixel')
            ylabel('c_right_var')

        end
        
    end
    
end


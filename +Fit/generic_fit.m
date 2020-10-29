classdef generic_fit < handle
    % generic_fit is the generic fit class
    %   Detailed explanation goes here
    
    properties % handle to the parent data
        
        parent_data
        
    end
    
    properties % Picture properties
        
        pic_props
        
        static_pic_props
        
    end
    
    properties % Fit properties
        
        fit
        
        fit_name
        
    end
    
    methods
        
        function obj = generic_fit(data,fit_name)
            
            obj = obj@handle;
            
            obj.parent_data = data;
            
            obj.pic_props = obj.parent_data.pics.pic_props;
            
            obj.static_pic_props = obj.parent_data.pics.static_pic_props;
            
            obj.fit_name=fit_name;
            
            eval(['obj.fit = Fit.',fit_name,'(obj);']);
            
            % Fit the data
            
            obj.fit.fit;
            
        end
        
    end
    
end


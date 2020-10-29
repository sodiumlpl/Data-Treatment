classdef Data < handle
    % Generic Data class
    
    
    properties % Camera & Treatment
        
        camera_type
        
        treatment_type
        
    end
    
    properties % Pics class
        
        pics
        
        pics_path
        
    end
    
    properties
       
        static_params
        
        dep_params
        
    end
    
    properties (SetObservable = true)
        
        scan_obs_x_axis
        
        scan_obs_fit_type
        scan_obs_y_axis
        
        glob_obs_fit_type
        glob_obs_y_axis
        
    end
    
    properties % observed values
        
        scan_obs_x_axis_value
        scan_obs_y_axis_value
        
        glob_obs_y_axis_value
        
    end
    
    properties
        
        fit_array % array containing the different fits of the data
        
    end
    
    methods
        
        function obj = Data(camera_type,treatment_type,pics_path)
            
            obj = obj@handle;
            
            obj.camera_type = camera_type;
            obj.treatment_type = treatment_type;
            
            obj.pics_path = pics_path;

            obj.get_pics(pics_path);
            
            addlistener(obj,'scan_obs_x_axis','PostSet',@obj.postset_scan_obs_x_axis);
            addlistener(obj,'scan_obs_fit_type','PostSet',@obj.postset_scan_obs_fit_type);
            addlistener(obj,'scan_obs_y_axis','PostSet',@obj.postset_scan_obs_y_axis);
            
            addlistener(obj,'glob_obs_fit_type','PostSet',@obj.postset_glob_obs_fit_type);
            addlistener(obj,'glob_obs_y_axis','PostSet',@obj.postset_glob_obs_y_axis);
            
            if exist([obj.pics_path,'\params.mat'],'file')
                
                load([obj.pics_path,'\params.mat'])
                
                obj.static_params = static_params;
                
                obj.dep_params = dep_params;
                
            end
            
        end
        
        function get_pics(obj,pics_path)
            
            switch obj.camera_type
                
                case 'pixelfly'
                    
                    switch obj.treatment_type
                        
                        case 'fluo_tof'
                            
                            obj.pics = Pixelfly.Fluo_tof(pics_path);
                            
                            obj.pics.parent = obj;
                            
                        case 'fluo_1pix'
                            
                            obj.pics = Pixelfly.Fluo_1pix(pics_path);
                            
                            obj.pics.parent = obj;
                            
                        case 'absorption'
                            
                            obj.pics = Pixelfly.Absorption(pics_path);
                            
                            obj.pics.parent = obj;
                            
                        case 'clean_abs'
                            
                            obj.pics = Pixelfly.Clean_abs(pics_path);
                            
                            obj.pics.parent = obj;

                    end
                    
                case 'imagsource'
                    
                    switch obj.treatment_type
                        
                        case 'fluo_tof'
                            
                            obj.pics = ImagSource.Fluo_tof(pics_path);
                            
                            obj.pics.parent = obj;
                            
                        case 'fluo_1pix'
                            
                            obj.pics = ImagSource.Fluo_1pix(pics_path);
                            
                            obj.pics.parent = obj;
                            
                        case 'absorption'
                            
                            obj.pics = ImagSource.Absorption(pics_path);
                            
                            obj.pics.parent = obj;
                            
                        case 'clean_abs'
                            
                            obj.pics = ImagSource.Clean_abs(pics_path);
                            
                            obj.pics.parent = obj;

                    end
                  
                    
            end
            
        end
        
        function save(obj)
            
            data = obj;
            
            save([obj.pics_path,'\data.mat'],'data');
            
        end
        
        function postset_scan_obs_x_axis(obj,~,~)
            
            if ~strcmp(obj.scan_obs_x_axis,'none')
                
                if any(strcmp({obj.static_params.name},obj.scan_obs_x_axis))
                    
                    obj.scan_obs_x_axis_value = obj.static_params(strcmp({obj.static_params.name},obj.scan_obs_x_axis)).value;
                    
                else
                    
                    obj.scan_obs_x_axis_value = obj.dep_params(strcmp({obj.dep_params.name},obj.scan_obs_x_axis)).value;
                    
                end
                
            end
            
        end
        
        function postset_scan_obs_fit_type(obj,~,~)
            
            if ~isempty(obj.fit_array)
                
                ind = find(strcmp({obj.fit_array.fit_name},obj.scan_obs_fit_type));
                
                if ~isempty(ind)
                    
                    if ~(isequal(obj.fit_array(ind).pic_props,obj.pics.pic_props)&&...
                             isequal(obj.fit_array(ind).static_pic_props,obj.pics.static_pic_props))
                        
                        eval(['obj.fit_array(ind) = Fit.generic_fit(obj,''',obj.scan_obs_fit_type,''');']);
                         
                    end
                    
                else
                    
                    eval(['obj.fit_array(end+1) = Fit.generic_fit(obj,''',obj.scan_obs_fit_type,''');']);
                    
                end
                
            else
                
                eval(['obj.fit_array = Fit.generic_fit(obj,''',obj.scan_obs_fit_type,''');']);
                
            end
            
        end
        
        function postset_scan_obs_y_axis(obj,~,~)
            
            eval(['obj.scan_obs_y_axis_value = obj.fit_array(strcmp({obj.fit_array.fit_name},obj.scan_obs_fit_type)).fit.',...
                obj.scan_obs_y_axis,';']);
            
        end
        
        function postset_glob_obs_fit_type(obj,~,~)
            
            if ~isempty(obj.fit_array)
                
                ind = find(strcmp({obj.fit_array.fit_name},obj.glob_obs_fit_type));
                
                if ~isempty(ind)
                    
                    if ~(isequal(obj.fit_array(ind).pic_props,obj.pics.pic_props)&&...
                             isequal(obj.fit_array(ind).static_pic_props,obj.pics.static_pic_props))
                        
                        eval(['obj.fit_array(ind) = Fit.generic_fit(obj,',obj.glob_obs_fit_type,');']);
                         
                    end
                    
                else
                    
                    eval(['obj.fit_array(end+1) = Fit.generic_fit(obj,',obj.glob_obs_fit_type,');']);
                    
                end
                
            else
                
                eval(['obj.fit_array = Fit.generic_fit(obj,''',obj.glob_obs_fit_type,''');']);
                
            end
            
        end
        
        function postset_glob_obs_y_axis(obj,~,~)
            
            eval(['obj.glob_obs_y_axis_value = obj.fit_array(strcmp({obj.fit_array.fit_name},obj.glob_obs_fit_type)).fit.',...
                obj.glob_obs_y_axis,';']);
            
        end
        
        function data = saveobj(obj)
            
            data = obj;
            
            data.static_params = [];
            data.dep_params = [];

        end
        
        function delete(obj)
           
            delete(obj.pics)
            
        end
        
    end
    
    methods (Static = true)
        
        function obj = loadobj(data)
            
            if exist([data.pics_path,'\params.mat'],'file')
                
                load([data.pics_path,'\params.mat'])
                
                data.static_params = static_params;
                
                data.dep_params = dep_params;
                
            end
            
            addlistener(data,'scan_obs_x_axis','PostSet',@data.postset_scan_obs_x_axis);
            addlistener(data,'scan_obs_fit_type','PostSet',@data.postset_scan_obs_fit_type);
            addlistener(data,'scan_obs_y_axis','PostSet',@data.postset_scan_obs_y_axis);
            
            addlistener(data,'glob_obs_y_axis','PostSet',@data.postset_glob_obs_y_axis);
            addlistener(data,'glob_obs_fit_type','PostSet',@data.postset_glob_obs_fit_type);
            
            obj = data;
            
        end
        
    end
    
end
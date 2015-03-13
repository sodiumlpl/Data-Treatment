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
        scan_obs_y_axis
        
        glob_obs_y_axis
        
    end
    
    properties % observed values
        
        scan_obs_x_axis_value
        scan_obs_y_axis_value
        
        glob_obs_y_axis_value
        
    end
    
    properties
        
        treat_struct % structure containing treated value 
        
    end
    
    methods
        
        function obj = Data(camera_type,treatment_type,pics_path)
            
            obj = obj@handle;
            
            obj.camera_type = camera_type;
            obj.treatment_type = treatment_type;
            
            obj.pics_path = pics_path;

            obj.get_pics(pics_path);
            
            addlistener(obj,'scan_obs_x_axis','PostSet',@obj.postset_scan_obs_x_axis);
            addlistener(obj,'scan_obs_y_axis','PostSet',@obj.postset_scan_obs_y_axis);
            
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
        
        function postset_scan_obs_y_axis(obj,~,~)
            
            addpath([Treatment.Default_parameters.treatment_script_path,'\', ...
                obj.camera_type,'\',obj.treatment_type]);
            
            if ~isempty(obj.treat_struct)
                
                ind = find(strcmp({obj.treat_struct.name},obj.scan_obs_y_axis));
                
                if ~isempty(ind)
                    
                    if isequal(obj.treat_struct(ind).props,obj.pics.pic_props)&&...
                            isequal(obj.treat_struct(ind).static_props,obj.pics.static_pic_props)
                        
                        obj.scan_obs_y_axis_value = obj.treat_struct(ind).value;
                        
                    else
                        
                        obj.scan_obs_y_axis_value = eval([obj.scan_obs_y_axis,'(obj);']);
                        
                        obj.treat_struct(ind).value = obj.scan_obs_y_axis_value;
                        
                        obj.treat_struct(ind).props = obj.pics.pic_props;
                        
                        obj.treat_struct(ind).static_props = obj.pics.static_pic_props;
                        
                    end
                    
                else
                    
                    obj.scan_obs_y_axis_value = eval([obj.scan_obs_y_axis,'(obj);']);
                    
                    obj.treat_struct(end+1).name = obj.scan_obs_y_axis;
                    
                    obj.treat_struct(end+1).value = obj.scan_obs_y_axis_value;
                    
                    obj.treat_struct(end+1).props = obj.pics.pic_props;
                    
                    obj.treat_struct(end+1).static_props = obj.pics.static_pic_props;
                    
                end
                
            else
                
                obj.scan_obs_y_axis_value = eval([obj.scan_obs_y_axis,'(obj);']);
                
                obj.treat_struct = struct('name',obj.scan_obs_y_axis,'value',obj.scan_obs_y_axis_value,...
                    'props',obj.pics.pic_props,'static_props',obj.pics.static_pic_props);

            end
            
        end
        
        function postset_glob_obs_y_axis(obj,~,~)
            
            if strcmp(obj.glob_obs_y_axis,obj.scan_obs_y_axis)
                
                obj.glob_obs_y_axis_value = obj.scan_obs_y_axis_value;
                
            else
                
                addpath([Treatment.Default_parameters.treatment_script_path,'\', ...
                    obj.camera_type,'\',obj.treatment_type]);
                
                obj.glob_obs_y_axis_value =eval([obj.glob_obs_y_axis,'(obj);']);
                
            end
            
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
            addlistener(data,'scan_obs_y_axis','PostSet',@data.postset_scan_obs_y_axis);
            
            addlistener(data,'glob_obs_y_axis','PostSet',@data.postset_glob_obs_y_axis);
            
            obj = data;
            
        end
        
    end
    
end
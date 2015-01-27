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
    
    methods
        
        function obj = Data(camera_type,treatment_type,pics_path)
            
            obj = obj@handle;
            
            obj.camera_type = camera_type;
            obj.treatment_type = treatment_type;
            
            obj.pics_path = pics_path;

            obj.get_pics(pics_path);
            
        end
        
        function get_pics(obj,pics_path)
            
            switch obj.camera_type
                
                case 'pixelfly'
                    
                    switch obj.treatment_type
                        
                        case 'fluo_tof'
                            
                            obj.pics = Pixelfly.Fluorescence(pics_path);
                            
                            obj.pics.parent = obj;
                            
                            % Show pictures
                            
                            obj.pics.show();
                            
                        case 'fluo_1pix'
                            
                            obj.pics = Pixelfly.Fluo_1pix(pics_path);
                            
                            obj.pics.parent = obj;
                            
                            % Show pictures
                            
                            obj.pics.show();

                    end
                    
            end
            
        end
        
        function save(obj)
            
            data = obj;
            
            save([obj.pics_path,'\data.m'],'data');
            
        end
        
    end
    
end
classdef Default_parameters
    % Default_parameters class contains the value of every Adwin GUI
    % parameters
    
    properties (Constant) % Defaults Panel properties
        
        Panel_BackgroundColor = [0.929 0.929 0.929];
        Panel_ForegroundColor = [0. 0. 0.];
        Panel_HighlightColor = [0.5 0.5 0.5];
        Panel_ShadowColor = [0.7 0.7 0.7];
        
        Panel_Units = 'normalized';
        
        Panel_FontName = 'Helvetica';
        Panel_FontSize = 12;
        Panel_FontUnits = 'points';
        Panel_FontWeight = 'bold';
        
        Panel_SelectionHighlight = 'off';
        
        
    end
    
    properties (Constant) % Defaults Text properties
        
        Text_Units = 'normalized';
        
        Text_FontName = 'Helvetica';
        Text_FontSize =8;
        Text_FontUnits = 'points';
        Text_FontWeight = 'bold';

        Text_HorizontalAlignment = 'center';

    end
    
    properties (Constant) % Defaults Edit properties
                
        Edit_Units = 'normalized';
        
        Edit_FontName = 'Helvetica';
        Edit_FontSize = 8;
        Edit_FontUnits = 'points';
        Edit_FontWeight = 'bold';
        
        Edit_HorizontalAlignment = 'center';
        
    end
    
    properties (Constant) % Defaults Popup properties
        
        Popup_Units = 'normalized';
        
        Popup_FontName = 'Helvetica';
        Popup_FontSize = 8;
        Popup_FontUnits = 'points';
        Popup_FontWeight = 'bold';
        
    end
    
    properties (Constant) % Defaults Pushbutton properties
        
        Pushbutton_FontName = 'Helvetica';
        Pushbutton_FontSize = 9;
        Pushbutton_FontUnits = 'points';
        Pushbutton_FontWeight = 'bold';
        
        Pushbutton_Units = 'normalized';

    end
    
    properties (Constant) % Defaults Radiobutton properties
        
        Radiobutton_FontName = 'Helvetica';
        Radiobutton_FontSize = 9;
        Radiobutton_FontUnits = 'points';
        Radiobutton_FontWeight = 'bold';
        
        Radiobutton_Units = 'normalized';

    end
    
    properties (Constant) % Defaults Listbox properties
        
        Listbox_Units = 'normalized';

    end
    
    properties (Constant) % Defaults Checkbox properties
        
        Checkbox_Units = 'normalized';

    end
    
    properties (Constant) % Defaults Axes properties
        
        Axes_Units = 'normalized';
        
        Axes_FontName = 'Helvetica';
        Axes_FontSize = 8;
        Axes_FontUnits = 'points';
        Axes_FontWeight = 'normal';
        
    end
    
    properties (Constant) % Default Camera & Treatment properties
        
        camera_struct = struct('type', ...
            {'pixelfly' ...
            ; 'imagsource'...
            },...
            'data_path', ...
            {'D:\Data\Tmp\Pixelfly' ... %'\\BEC009-T3600\Users\BEC\Documents\data\pixelfly' ...
            ;'D:\Data\Tmp\ImagSource' ...  %'\\BEC009-T3600\Users\BEC\Documents\data\imagsource' ...
            });
        
        camera_type = 'pixelfly';
        
        treatment_struct = struct('type', ...
            {'fluo_tof' ...
            ;'fluo_1pix' ...
            },...
            'pics_nbr', ...
            {4 ...
            ;2 ...
            });
        
        treatment_type = 'fluo_1pix';
        
    end
    
    properties (Constant) % Data
        
        data_path = 'D:\Data';
        
    end
    
    properties (Constant) % Observe
        
        treatment_script_path = 'D:\Data\Treatment_Scripts';
        
    end
    
    methods
        
    end
    
end
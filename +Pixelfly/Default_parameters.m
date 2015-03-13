classdef Default_parameters
    % Default_parameters class contains the value of every Pixelfly
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
    
    properties (Constant) % Camera
       
        pixel_size = 6.45e-6; %[m]
        magnification = 0.23;
        
    end
    
    properties (Constant) % Sodium Atoms
       
        sigma0 = 1.6573163925e-9*(1e-2)^2; % [m^2] Resonant Cross Section cycling transition
        
    end
    
    properties (Constant) % Defaults Absorption properties
        
        Absorption_Corrected_r_roi_ctr = 730;
        Absorption_Corrected_c_roi_ctr = 420;
        Absorption_Corrected_roi_wth = 100;
        
        Absorption_Corrected_r_rbc_ctr = 690;
        Absorption_Corrected_c_rbc_ctr = 570;
        Absorption_Corrected_rbc_wth = 50;
        
        Absorption_Corrected_use_rbc = 1;
        
        Absorption_Corrected_pic_min = 0;
        Absorption_Corrected_pic_max = 3000;
        
        Absorption_Signal_r_roi_ctr = 696;
        Absorption_Signal_c_roi_ctr = 520;
        Absorption_Signal_roi_wth = 519;
        
        Absorption_Signal_pic_min = -10;
        Absorption_Signal_pic_max = 15000;
        
        Absorption_Background_r_roi_ctr = 696;
        Absorption_Background_c_roi_ctr = 520;
        Absorption_Background_roi_wth = 519;
        
        Absorption_Background_pic_min = -10;
        Absorption_Background_pic_max = 15000;
        
        Absorption_pic_at_r_roi_ctr = 696;
        Absorption_pic_at_c_roi_ctr = 520;
        Absorption_pic_at_roi_wth = 519;
        
        Absorption_pic_at_pic_min = 0;
        Absorption_pic_at_pic_max = 15000;
        
        Absorption_pic_at_bg_r_roi_ctr = 696;
        Absorption_pic_at_bg_c_roi_ctr = 520;
        Absorption_pic_at_bg_roi_wth = 519;
        
        Absorption_pic_at_bg_pic_min = 200;
        Absorption_pic_at_bg_pic_max = 1000;
        
        Absorption_pic_wat_r_roi_ctr = 696;
        Absorption_pic_wat_c_roi_ctr = 520;
        Absorption_pic_wat_roi_wth = 519;
        
        Absorption_pic_wat_pic_min = 0;
        Absorption_pic_wat_pic_max = 15000;
        
        Absorption_pic_wat_bg_r_roi_ctr = 696;
        Absorption_pic_wat_bg_c_roi_ctr = 520;
        Absorption_pic_wat_bg_roi_wth = 519;
        
        Absorption_pic_wat_bg_pic_min = 200;
        Absorption_pic_wat_bg_pic_max = 1000;
        
    end
    
    properties (Constant) % Defaults Fluo_1pix properties
        
        Fluo_1pix_Corrected_r_roi_ctr = 696;
        Fluo_1pix_Corrected_c_roi_ctr = 520;
        Fluo_1pix_Corrected_roi_wth = 519;
        
        Fluo_1pix_Corrected_pic_min = -10;
        Fluo_1pix_Corrected_pic_max = 100;
        
        Fluo_1pix_Signal_r_roi_ctr = 696;
        Fluo_1pix_Signal_c_roi_ctr = 520;
        Fluo_1pix_Signal_roi_wth = 519;
        
        Fluo_1pix_Signal_pic_min = 0;
        Fluo_1pix_Signal_pic_max = 1000;
        
        Fluo_1pix_Background_r_roi_ctr = 696;
        Fluo_1pix_Background_c_roi_ctr = 520;
        Fluo_1pix_Background_roi_wth = 519;
        
        Fluo_1pix_Background_pic_min = 0;
        Fluo_1pix_Background_pic_max = 1000;
        
    end
    
    properties (Constant) % Defaults Absorption properties
        
        Fluo_tof_Corrected_r_roi_ctr = 696;
        Fluo_tof_Corrected_c_roi_ctr = 520;
        Fluo_tof_Corrected_roi_wth = 519;
        
        Fluo_tof_Corrected_pic_min = -10;
        Fluo_tof_Corrected_pic_max = 100;
        
        Fluo_tof_Signal_r_roi_ctr = 696;
        Fluo_tof_Signal_c_roi_ctr = 520;
        Fluo_tof_Signal_roi_wth = 519;
        
        Fluo_tof_Signal_pic_min = -10;
        Fluo_tof_Signal_pic_max = 100;
        
        Fluo_tof_Background_r_roi_ctr = 696;
        Fluo_tof_Background_c_roi_ctr = 520;
        Fluo_tof_Background_roi_wth = 519;
        
        Fluo_tof_Background_pic_min = -10;
        Fluo_tof_Background_pic_max = 100;
        
        Fluo_tof_pic_at_r_roi_ctr = 696;
        Fluo_tof_pic_at_c_roi_ctr = 520;
        Fluo_tof_pic_at_roi_wth = 519;
        
        Fluo_tof_pic_at_pic_min = 0;
        Fluo_tof_pic_at_pic_max = 1000;
        
        Fluo_tof_pic_at_bg_r_roi_ctr = 696;
        Fluo_tof_pic_at_bg_c_roi_ctr = 520;
        Fluo_tof_pic_at_bg_roi_wth = 519;
        
        Fluo_tof_pic_at_bg_pic_min = 0;
        Fluo_tof_pic_at_bg_pic_max = 1000;
        
        Fluo_tof_pic_wat_r_roi_ctr = 696;
        Fluo_tof_pic_wat_c_roi_ctr = 520;
        Fluo_tof_pic_wat_roi_wth = 519;
        
        Fluo_tof_pic_wat_pic_min = 0;
        Fluo_tof_pic_wat_pic_max = 1000;
        
        Fluo_tof_pic_wat_bg_r_roi_ctr = 696;
        Fluo_tof_pic_wat_bg_c_roi_ctr = 520;
        Fluo_tof_pic_wat_bg_roi_wth = 519;
        
        Fluo_tof_pic_wat_bg_pic_min = 0;
        Fluo_tof_pic_wat_bg_pic_max = 1000;
        
    end
    
    methods
        
    end
    
end
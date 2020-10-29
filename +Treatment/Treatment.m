classdef Treatment < handle
    % Treatment class
    
    properties % GUI
        
        tmg % treatment main GUI
        
        gog % global observe GUI
        
        osg % observe scan GUI
        
    end
    
    properties (SetObservable = true) % general
        
        data_path
        
        day
        
        month
        
        year
        
        current_data_dir
        
        camera_type
        treatment_type
        
    end
    
    properties
        
        tmp_dir_path
        
    end
    
    properties
        
        data_array
        
    end
    
    properties (SetObservable = true)
        
        glob_obs
        
        scan_obs
        
        current_data
        
    end
    
    properties
       
        net
        
    end
    
    methods
        
        function obj = Treatment()
            
            obj = obj@handle;
            
            % create Network class
            
            obj.net = Network.Network(obj);
            
            % set date and create date folder
            
            cur_date = clock;
            
            obj.year = num2str(cur_date(1));
            
            if (cur_date(2)<10)
                
                obj.month = ['0',num2str(cur_date(2))];
                
            else
                
                obj.month = num2str(cur_date(2));
                
            end
            
            if (cur_date(3)<10)
                
                obj.day = ['0',num2str(cur_date(3))];
                
            else
                
                obj.day = num2str(cur_date(3));
                
            end
            
            addlistener(obj,'day','PostSet',@obj.postset_day);
            addlistener(obj,'month','PostSet',@obj.postset_month);
            addlistener(obj,'year','PostSet',@obj.postset_year);
            
            % set Data path
            
            obj.data_path = Treatment.Default_parameters.data_path;
            
            if ~exist([obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day],'dir')
                
                mkdir([obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day]);
                
            end
            
            addlistener(obj,'data_path','PostSet',@obj.postset_data_path);
            
            addlistener(obj,'current_data_dir','PreSet',@obj.preset_current_data_dir);
            addlistener(obj,'current_data_dir','PostSet',@obj.postset_current_data_dir);
            
            addlistener(obj,'current_data','PostSet',@obj.post_set_current_data);
            
            % set default camera and treatment
            
            addlistener(obj,'camera_type','PostSet',@obj.postset_camera_type);
            addlistener(obj,'treatment_type','PostSet',@obj.postset_treatment_type);
            
            % create observers listeners
            
            addlistener(obj,'glob_obs','PostSet',@obj.post_set_glob_obs);
            addlistener(obj,'scan_obs','PostSet',@obj.post_set_scan_obs);
            
        end
        
        function treatment_main_gui(obj)
            
            % initialize Vision GUI
            
            obj.tmg.h = figure(...
                'Name'                ,'Treatment Main' ...
                ,'NumberTitle'        ,'off' ...
                ,'Position'           ,[8 48 300 1068] ... %,'MenuBar'     ,'none'...
                );
            
            %%% Camera & Treatment type panel %%%
            
            c_ofs = 0.0025;
            r_ofs = 0.84;
            c_wth = 0.995;
            r_wth = 0.15;
            
            obj.tmg.hsp1 = uipanel(...
                'Parent'              ,obj.tmg.h ...
                ,'Title'              ,'Camera & Treatment type' ...
                ,'TitlePosition'      ,'lefttop' ...
                ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                ,'FontSize'           ,Treatment.Default_parameters.Panel_FontSize ...
                ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                ,'SelectionHighlight' ,Treatment.Default_parameters.Panel_SelectionHighlight ...
                ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % Text
            
            c_ofs = 0.035;
            r_ofs = 0.85;
            c_wth = 0.175;
            r_wth = 0.1;
            
            obj.tmg.txt1_1 = uicontrol(...
                'Parent'               ,obj.tmg.hsp1 ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Camera :' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % listbox
            
            % set value
            
            cell_tmp = Treatment.Default_parameters.camera_struct;
            
            c_ofs = 0.065;
            r_ofs = 0.115;
            c_wth = 0.35;
            r_wth = 0.65;
            
            obj.tmg.lsb1_1 = uicontrol(...
                'Parent'               ,obj.tmg.hsp1 ...
                ,'Style'               ,'listbox' ...
                ,'Units'               , Treatment.Default_parameters.Listbox_Units ...
                ,'String'              , {cell_tmp.type} ...
                ,'Position'            ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Enable'              ,'off' ...
                );
            
            % Text
            
            c_ofs = 0.5;
            r_ofs = 0.85;
            c_wth = 0.35;
            r_wth = 0.1;
            
            obj.tmg.txt1_2 = uicontrol(...
                'Parent'               ,obj.tmg.hsp1 ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Treatment type :' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % listbox
            
            c_ofs = 0.53;
            r_ofs = 0.115;
            c_wth = 0.35;
            r_wth = 0.65;
            
            % set value
            
            cell_tmp = Treatment.Default_parameters.treatment_struct;
            
            obj.tmg.lsb1_2 = uicontrol(...
                'Parent'               ,obj.tmg.hsp1 ...
                ,'Style'               ,'listbox' ...
                ,'Units'               , Treatment.Default_parameters.Listbox_Units ...
                ,'String'              , {cell_tmp.type} ...
                ,'Position'            ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Enable'              ,'off' ...
                );
            
            %%% Data path panel %%%
            
            c_ofs = 0.0025;
            r_ofs = 0.68;
            c_wth = 0.995;
            r_wth = 0.15;
            
            obj.tmg.hsp2 = uipanel(...
                'Parent'              ,obj.tmg.h ...
                ,'Title'              ,'Data path' ...
                ,'TitlePosition'      ,'lefttop' ...
                ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                ,'FontSize'           ,Treatment.Default_parameters.Panel_FontSize ...
                ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                ,'SelectionHighlight' ,Treatment.Default_parameters.Panel_SelectionHighlight ...
                ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % Text
            
            c_ofs = 0.025;
            r_ofs = 0.505;
            c_wth = 0.14;
            r_wth = 0.1;
            
            obj.tmg.txt2_1 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Day' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % Edit
            
            c_ofs = 0.185;
            r_ofs = 0.5;
            c_wth = 0.12;
            r_wth = 0.13;
            
            obj.tmg.edt2_1 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'edit' ...
                ,'String'               ,obj.day ...
                ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                ,'FontWeight'           ,'normal' ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                ,'Callback'             ,@obj.tmg_edt2_1_clb ...
                );
            
            % Text
            
            c_ofs = 0.025;
            r_ofs = 0.315;
            c_wth = 0.14;
            r_wth = 0.1;
            
            obj.tmg.txt2_2 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Month' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % Edit
            
            c_ofs = 0.185;
            r_ofs = 0.295;
            c_wth = 0.12;
            r_wth = 0.13;
            
            obj.tmg.edt2_2 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'edit' ...
                ,'String'               ,obj.month ...
                ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                ,'FontWeight'           ,'normal' ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                ,'Callback'             ,@obj.tmg_edt2_2_clb ...
                );
            
            % Text
            
            c_ofs = 0.025;
            r_ofs = 0.1;
            c_wth = 0.14;
            r_wth = 0.1;
            
            obj.tmg.txt2_3 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Year' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % Edit
            
            c_ofs = 0.185;
            r_ofs = 0.085;
            c_wth = 0.12;
            r_wth = 0.13;
            
            obj.tmg.edt2_3 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'edit' ...
                ,'String'               ,obj.year ...
                ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                ,'FontWeight'           ,'normal' ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                ,'Callback'             ,@obj.tmg_edt2_3_clb ...
                );
            
            % Text
            
            c_ofs = 0.025;
            r_ofs = 0.855;
            c_wth = 0.2;
            r_wth = 0.1;
            
            obj.tmg.txt2_4 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Data path' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % Text
            
            c_ofs = 0.05;
            r_ofs = 0.685;
            c_wth = 0.3;
            r_wth = 0.1;
            
            obj.tmg.txt2_5 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'text' ...
                ,'String'               ,obj.data_path ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,'normal' ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % pushbutton 2_1 geometry
            
            c_ofs = 0.25;
            r_ofs = 0.85;
            c_wth = 0.1;
            r_wth = 0.1;
            
            obj.tmg.but2_1 = uicontrol(...
                'Parent'                ,obj.tmg.hsp2 ...
                ,'Style'                ,'pushbutton' ...
                ,'String'               ,'...' ...
                ,'FontName'             ,Treatment.Default_parameters.Pushbutton_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Pushbutton_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Pushbutton_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Pushbutton_FontWeight ...
                ,'Units'                ,Treatment.Default_parameters.Pushbutton_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.tmg_but2_1_clb ...
                );
            
            % Text
            
            c_ofs = 0.515;
            r_ofs = 0.855;
            c_wth = 0.25;
            r_wth = 0.1;
            
            obj.tmg.txt2_6 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Data Folder :' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % listbox
            
            c_ofs = 0.555;
            r_ofs = 0.125;
            c_wth = 0.35;
            r_wth = 0.65;
            
            obj.tmg.lsb2_1 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'listbox' ...
                ,'Units'                , Treatment.Default_parameters.Listbox_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.tmg_lsb2_1_clb ...
                );
            
            % pushbutton 2_2 geometry
            
            c_ofs = 0.85;
            r_ofs = 0.85;
            c_wth = 0.1;
            r_wth = 0.1;
            
            obj.tmg.but2_2 = uicontrol(...
                'Parent'                ,obj.tmg.hsp2 ...
                ,'Style'                ,'pushbutton' ...
                ,'String'               ,'...' ...
                ,'FontName'             ,Treatment.Default_parameters.Pushbutton_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Pushbutton_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Pushbutton_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Pushbutton_FontWeight ...
                ,'Units'                ,Treatment.Default_parameters.Pushbutton_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.tmg_but2_2_clb ...
                );
            
            %%% Data path panel %%%
            
            c_ofs = 0.0025;
            r_ofs = 0.0025;
            c_wth = 0.995;
            r_wth = 0.66;
            
            obj.tmg.hsp2 = uipanel(...
                'Parent'              ,obj.tmg.h ...
                ,'Title'              ,'Data' ...
                ,'TitlePosition'      ,'lefttop' ...
                ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                ,'FontSize'           ,Treatment.Default_parameters.Panel_FontSize ...
                ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                ,'SelectionHighlight' ,Treatment.Default_parameters.Panel_SelectionHighlight ...
                ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % Text
            
            c_ofs = 0.05;
            r_ofs = 0.965;
            c_wth = 0.12;
            r_wth = 0.02;
            
            obj.tmg.txt3_1 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Data List :' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % listbox
            
            c_ofs = 0.075;
            r_ofs = 0.025;
            c_wth = 0.35;
            r_wth = 0.92;
            
            obj.tmg.lsb3_1 = uicontrol(...
                'Parent'               ,obj.tmg.hsp2 ...
                ,'Style'                ,'listbox' ...
                ,'Units'                , Treatment.Default_parameters.Listbox_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.tmg_lsb3_1_clb ...
                );
            
            % initialize Global Observe GUI
            
            obj.gog.h = figure(...
                'Name'                ,'Global observe' ...
                ,'NumberTitle'        ,'off' ...
                ,'Position'           ,[1340 50 570 450] ... %,'MenuBar'     ,'none'...
                );
            
            %%% main panel %%%
            
            c_ofs = 0.0025;
            r_ofs = 0.0025;
            c_wth = 0.995;
            r_wth = 0.995;
            
            obj.gog.hsp = uipanel(...
                'Parent'              ,obj.gog.h ...
                ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                ,'FontSize'           ,Treatment.Default_parameters.Panel_FontSize ...
                ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                ,'SelectionHighlight' ,Treatment.Default_parameters.Panel_SelectionHighlight ...
                ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            c_ofs = 0.1;
            r_ofs = 0.28;
            c_wth = 0.825;
            r_wth = 0.66;
            
            obj.gog.ax = axes(...
                'Parent'             ,obj.gog.hsp ...
                ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                ,'Box'                ,'on' ...
                ,'Tickdir'            ,'out' ...
                ,'NextPlot'           ,'replace'...
                ,'FontSize'           ,8 ...
                ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % Text
            
            c_ofs = 0.105;
            r_ofs = 0.155;
            c_wth = 0.08;
            r_wth = 0.03;
            
            obj.gog.txt1 = uicontrol(...
                'Parent'               ,obj.gog.hsp ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Fit type :' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % pop-up
            
            c_ofs = 0.10;
            r_ofs = 0.08;
            c_wth = 0.2;
            r_wth = 0.05;
            
            obj.gog.pum1 = uicontrol(...
                'Parent'               ,obj.gog.hsp ...
                ,'Style'                ,'popupmenu' ...
                ,'Units'                ,Treatment.Default_parameters.Popup_Units ...
                ,'FontName'             ,Treatment.Default_parameters.Popup_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Popup_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Popup_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Popup_FontWeight ...
                ,'String'               ,'static_widths' ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.gog_pum1_clb ...
                ,'Enable'               ,'off' ...
                );
            
            % Text
            
            c_ofs = 0.405;
            r_ofs = 0.155;
            c_wth = 0.08;
            r_wth = 0.03;
            
            obj.gog.txt2 = uicontrol(...
                'Parent'               ,obj.gog.hsp ...
                ,'Style'                ,'text' ...
                ,'String'               ,'y axis :' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % pop-up
            
            c_ofs = 0.40;
            r_ofs = 0.08;
            c_wth = 0.2;
            r_wth = 0.05;
            
            obj.gog.pum2 = uicontrol(...
                'Parent'               ,obj.gog.hsp ...
                ,'Style'                ,'popupmenu' ...
                ,'Units'                ,Treatment.Default_parameters.Popup_Units ...
                ,'FontName'             ,Treatment.Default_parameters.Popup_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Popup_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Popup_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Popup_FontWeight ...
                ,'String'               ,'roi_total_signal' ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.gog_pum2_clb ...
                ,'Enable'               ,'off' ...
                );
            
            % pushbutton 2_1 geometry
            
            c_ofs = 0.75;
            r_ofs = 0.08;
            c_wth = 0.2;
            r_wth = 0.05;
            
            obj.gog.but1 = uicontrol(...
                'Parent'                ,obj.gog.hsp ...
                ,'Style'                ,'pushbutton' ...
                ,'String'               ,'Reset' ...
                ,'FontName'             ,Treatment.Default_parameters.Pushbutton_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Pushbutton_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Pushbutton_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Pushbutton_FontWeight ...
                ,'Units'                ,Treatment.Default_parameters.Pushbutton_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.gog_but1_clb ...
                );
            
            
            % update path directory
                        
            obj.update_dir_path;
            
        end
        
        function gog_pum1_clb(obj,~,~)
            
            list_y_axis = get(obj.gog.pum1,'String');
            
            fit_type = list_y_axis{get(obj.gog.pum1,'Value')};
            
            list_fit_type = {Fit.Default_parameters.fit_struct.type};
            
            list_y_axis_params = Fit.Default_parameters.fit_struct(strcmp(fit_type,list_fit_type)).parameters;
            
            set(obj.gog.pum2,'String',list_y_axis_params,'Value',1); 
                
            obj.glob_obs = struct('fit_type',fit_type,...
                    'y_axis',list_y_axis_params{1});

        end
        
        function gog_pum2_clb(obj,~,~)
            
            list_y_axis = get(obj.gog.pum2,'String');
            
            obj.glob_obs.y_axis = list_y_axis{get(obj.gog.pum2,'Value')};
            
        end
        
        function gog_but1_clb(obj,~,~)
            
            obj.glob_obs.values = [];
            
        end
        
        function tmg_edt2_1_clb(obj,~,~)
            
            obj.day = get(obj.tmg.edt2_1,'String');
            
            obj.update_dir_path;
            
        end
        
        function tmg_edt2_2_clb(obj,~,~)
            
            obj.month = get(obj.tmg.edt2_2,'String');
            
            obj.update_dir_path;
            
        end
        
        function tmg_edt2_3_clb(obj,~,~)
            
            obj.year = get(obj.tmg.edt2_3,'String');
            
            obj.update_dir_path;
            
        end
        
        function tmg_but2_1_clb(obj,~,~)
            
            path = uigetdir(obj.data_path);
            
            if ~isequal(path,0)
                
                obj.data_path = path;
                
            end
            
        end
        
        function tmg_lsb2_1_clb(obj,~,~)
            
            dir_names = get(obj.tmg.lsb2_1,'String');
            
            obj.current_data_dir = dir_names{get(obj.tmg.lsb2_1,'Value')};
            
        end
        
        function tmg_but2_2_clb(obj,~,~)
            
            path = uigetdir([obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day]);
            
            if ~isequal(path,0)
                
                words = strsplit(path,'\');
                                
                obj.data_path = path(1:end-length(char(strcat('\',words{end-3},'\',words{end-2},'\',words{end-1},'\',words{end}))));
                
                obj.year = words{end-3};
                
                obj.month = words{end-2};
                
                obj.day = words{end-1};
                
                obj.current_data_dir = words{end};
                
            end
            
        end
        
        function tmg_lsb3_1_clb(obj,~,~)
            
            ind = get(obj.tmg.lsb3_1,'Value');
            
            if ~isempty(obj.current_data)
                
                if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                    
                    if isequal(obj.current_data.camera_type,obj.data_array(ind).camera_type)&&isequal(obj.current_data.treatment_type,obj.data_array(ind).treatment_type)
                        
                        obj.data_array(ind).pics.dpg = obj.current_data.pics.dpg;
                        
                        if ~isequal(obj.data_array(ind).pics.pic_props,obj.current_data.pics.pic_props)
                            
                            obj.data_array(ind).pics.pic_props = obj.current_data.pics.pic_props;
                            
                        end
                        
                        obj.data_array(ind).pics.reset_clb;
                        
                    else
                        
                        close(obj.current_data.pics.dpg.h)
                        
                    end
                    
                end
                
            end
            
            obj.data_array(ind).pics.show;
          
            obj.current_data = obj.data_array(ind);
            
            obj.camera_type = obj.data_array(ind).camera_type;
            
            obj.treatment_type = obj.data_array(ind).treatment_type;
            
        end
        
        function update_dir_path(obj)
            
            path = [obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day];
            
            if isempty(obj.tmp_dir_path)||~strcmp(obj.tmp_dir_path,path)
                
                obj.tmp_dir_path = path;
                
                dir_struct = dir(path);
                
                dir_names = {dir_struct.name};
                
                if length(dir_names)>2
                    
                    if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                        
                        tmp_names = dir_names(cellfun(@(x) ~isempty(x),regexp(dir_names,'Scan')));
                        
                        list_tmp = cellfun( @(x) obj.split_names(x),tmp_names);
                        
                        list_tmp = sort(list_tmp);
                        
                        if ~isempty(dir_names(cellfun(@(x) ~isempty(x),regexp(dir_names,'Saved'))))
                            
                            sorted_list = cell(1,length(list_tmp)+1);
                            
                            sorted_list{1} = 'Saved';
                            
                            for i = 2:length(sorted_list)
                                
                                sorted_list{i} = ['Scan',num2str(list_tmp(i-1))];
                                
                            end
                            
                        else
                            
                            sorted_list = cell(1,length(list_tmp));
                            
                            for i = 1:length(sorted_list)
                                
                                sorted_list{i} = ['Scan',num2str(list_tmp(i))];
                                
                            end
                            
                        end
                        
                        set(obj.tmg.lsb2_1,'String',sorted_list,'Value',1);
                        
                    end
                    
                    obj.current_data_dir = sorted_list{1};
                    
                else
                    
                    if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                        
                        set(obj.tmg.lsb2_1,'String','');
                        
                    end
                    
                    obj.current_data_dir = [];
                    
                end
                
            end
            
        end
        
        function observe_scans_gui(obj)
            
            % initialize Observe GUI
            
            obj.osg.h = figure(...
                'Name'                ,'Observe scans' ...
                ,'NumberTitle'        ,'off' ...
                ,'Position'           ,[1340 670 570 450] ... %,'MenuBar'     ,'none'...
                );
            
            %%% main panel %%%
            
            c_ofs = 0.0025;
            r_ofs = 0.0025;
            c_wth = 0.995;
            r_wth = 0.995;
            
            obj.osg.hsp = uipanel(...
                'Parent'              ,obj.osg.h ...
                ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                ,'FontSize'           ,Treatment.Default_parameters.Panel_FontSize ...
                ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                ,'SelectionHighlight' ,Treatment.Default_parameters.Panel_SelectionHighlight ...
                ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            c_ofs = 0.1;
            r_ofs = 0.28;
            c_wth = 0.825;
            r_wth = 0.66;
            
            obj.osg.ax = axes(...
                'Parent'             ,obj.osg.hsp ...
                ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                ,'Box'                ,'on' ...
                ,'Tickdir'            ,'out' ...
                ,'NextPlot'           ,'replace'...
                ,'FontSize'           ,8 ...
                ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % Text
            
            c_ofs = 0.03;
            r_ofs = 0.1;
            c_wth = 0.08;
            r_wth = 0.03;
            
            obj.osg.txt1 = uicontrol(...
                'Parent'               ,obj.osg.hsp ...
                ,'Style'                ,'text' ...
                ,'String'               ,'x axis :' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % pop-up
            
            c_ofs = 0.03;
            r_ofs = 0.04;
            c_wth = 0.2;
            r_wth = 0.05;
            
            obj.osg.pum1 = uicontrol(...
                'Parent'               ,obj.osg.hsp ...
                ,'Style'                ,'popupmenu' ...
                ,'Units'                ,Treatment.Default_parameters.Popup_Units ...
                ,'FontName'             ,Treatment.Default_parameters.Popup_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Popup_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Popup_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Popup_FontWeight ...
                ,'String'               ,'none' ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.osg_pum1_clb ...
                ,'Enable'               ,'off' ...
                );
            
            % Text
            
            c_ofs = 0.27;
            r_ofs = 0.1;
            c_wth = 0.08;
            r_wth = 0.03;
            
            obj.osg.txt2 = uicontrol(...
                'Parent'               ,obj.osg.hsp ...
                ,'Style'                ,'text' ...
                ,'String'               ,'Fit type :' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % pop-up
            
            c_ofs = 0.27;
            r_ofs = 0.04;
            c_wth = 0.2;
            r_wth = 0.05;
            
            obj.osg.pum2 = uicontrol(...
                'Parent'               ,obj.osg.hsp ...
                ,'Style'                ,'popupmenu' ...
                ,'Units'                ,Treatment.Default_parameters.Popup_Units ...
                ,'FontName'             ,Treatment.Default_parameters.Popup_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Popup_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Popup_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Popup_FontWeight ...
                ,'String'               ,'static_widths' ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.osg_pum2_clb ...
                ,'Enable'               ,'off' ...
                );
            
            % Text
            
            c_ofs = 0.49;
            r_ofs = 0.1;
            c_wth = 0.08;
            r_wth = 0.03;
            
            obj.osg.txt3 = uicontrol(...
                'Parent'               ,obj.osg.hsp ...
                ,'Style'                ,'text' ...
                ,'String'               ,'y axis :' ...
                ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                ,'HorizontalAlignment'  ,'left' ...
                ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                );
            
            % pop-up
            
            c_ofs = 0.49;
            r_ofs = 0.04;
            c_wth = 0.2;
            r_wth = 0.05;
            
            obj.osg.pum3 = uicontrol(...
                'Parent'               ,obj.osg.hsp ...
                ,'Style'                ,'popupmenu' ...
                ,'Units'                ,Treatment.Default_parameters.Popup_Units ...
                ,'FontName'             ,Treatment.Default_parameters.Popup_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Popup_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Popup_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Popup_FontWeight ...
                ,'String'               ,'roi_total_signal' ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.osg_pum3_clb ...
                ,'Enable'               ,'off' ...
                );
            
            % pushbutton geometry
            
            c_ofs = 0.7;
            r_ofs = 0.12;
            c_wth = 0.25;
            r_wth = 0.0625;
            
            obj.osg.but1 = uicontrol(...
                'Parent'                ,obj.osg.hsp ...
                ,'Style'                ,'pushbutton' ...
                ,'String'               ,'Update parameters' ...
                ,'FontName'             ,Treatment.Default_parameters.Pushbutton_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Pushbutton_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Pushbutton_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Pushbutton_FontWeight ...
                ,'Units'                ,Treatment.Default_parameters.Pushbutton_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.set_obs_params_lists ...
                ,'Enable'               ,'off' ...
                );
            
            % pushbutton geometry
            
            c_ofs = 0.7;
            r_ofs = 0.04;
            c_wth = 0.25;
            r_wth = 0.0625;
            
            obj.osg.but2 = uicontrol(...
                'Parent'                ,obj.osg.hsp ...
                ,'Style'                ,'pushbutton' ...
                ,'String'               ,'Print figure' ...
                ,'FontName'             ,Treatment.Default_parameters.Pushbutton_FontName ...
                ,'FontSize'             ,Treatment.Default_parameters.Pushbutton_FontSize ...
                ,'FontUnits'            ,Treatment.Default_parameters.Pushbutton_FontUnits ...
                ,'FontWeight'           ,Treatment.Default_parameters.Pushbutton_FontWeight ...
                ,'Units'                ,Treatment.Default_parameters.Pushbutton_Units ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.osg_but2_clb ...
                ,'Enable'               ,'off' ...
                );
            
        end
        
        function osg_pum1_clb(obj,~,~)
            
            list_x_axis = get(obj.osg.pum1,'String');
            
            obj.scan_obs.x_axis = list_x_axis{get(obj.osg.pum1,'Value')};
            
        end
        
        function osg_pum2_clb(obj,~,~)
            
            list_y_axis = get(obj.osg.pum2,'String');
                
            fit_type = list_y_axis{get(obj.osg.pum2,'Value')};
            
            list_fit_type = {Fit.Default_parameters.fit_struct.type};
            
            ind = find(strcmp(fit_type,list_fit_type));
            
            list_y_axis_params = Fit.Default_parameters.fit_struct(ind).parameters;
            
            set(obj.osg.pum3,'String',list_y_axis_params,'Value',1);
            
            obj.scan_obs = struct('fit_type',list_fit_type{ind},...
                'y_axis',list_y_axis_params{1},'x_axis',obj.scan_obs.x_axis);
            
        end
        
        function osg_pum3_clb(obj,~,~)
            
            list_y_axis = get(obj.osg.pum3,'String');
                
            obj.scan_obs.y_axis = list_y_axis{get(obj.osg.pum3,'Value')};

        end
        
        function osg_but2_clb(obj,~,~)
            
            figure;
            
            x_axis_values = [obj.data_array.scan_obs_x_axis_value];
            
            y_axis_values = [obj.data_array.scan_obs_y_axis_value];
            
            uniq_x_axis_values = unique(x_axis_values);
            
            % plot errorbars if possible
            
            if length(uniq_x_axis_values)<length(x_axis_values)
                
                mean_y_axis_values = zeros(size(uniq_x_axis_values));
                
                std_y_axis_values = zeros(size(uniq_x_axis_values));
                
                for i = 1:length(uniq_x_axis_values)
                    
                    ind_array = find(x_axis_values==uniq_x_axis_values(i));
                    
                    mean_y_axis_values(i) = mean(y_axis_values(ind_array));
                    
                    std_y_axis_values(i) = std(y_axis_values(ind_array));
                    
                end
                
                plot(x_axis_values,y_axis_values,'Parent',gca,'Marker','o',...
                    'MarkerEdgeColor','k','LineStyle','none')
                
                hold(gca,'on')
                
                errorbar(uniq_x_axis_values,mean_y_axis_values,std_y_axis_values/2,'Parent',gca,'LineStyle','-','Color','r')
                
                hold(gca,'off')
                
            else
                
                plot(x_axis_values,y_axis_values,'Parent',gca,'Marker','o',...
                    'MarkerEdgeColor','k','LineStyle','-','Color','r')
                
            end
            
            xlabel(gca,obj.scan_obs.x_axis,'interpreter','none')
            
            ylabel(gca,obj.scan_obs.y_axis,'interpreter','none')
            
            set(gca,'Box','on','Tickdir','out','NextPlot','replace','FontSize',8);

        end
        
        function postset_data_path(obj,~,~)
            
            if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                
                set(obj.tmg.txt2_5,'String',obj.data_path);
                
            end
            
            obj.update_dir_path;
            
        end
        
        function postset_day(obj,~,~)
            
            if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                
                set(obj.tmg.edt2_1,'String',obj.day);
                
            end
            
            obj.update_dir_path;
            
        end
        
        function postset_month(obj,~,~)
            
            if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                
                set(obj.tmg.edt2_2,'String',obj.month);
                
            end
            
            obj.update_dir_path;
            
        end
        
        function postset_year(obj,~,~)
            
            if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                
                set(obj.tmg.edt2_3,'String',obj.year);
                
            end
            
            obj.update_dir_path;
        end
        
        function preset_current_data_dir(obj,~,~)
            
            if ~isempty(obj.current_data)
                
                tmp_dpg = obj.current_data.pics.dpg;
                
            end
            
            % Before changing the current data directory, save the data in
            % the data array if it is not empty
            
            if ~isempty(obj.data_array)
                
                for i = 1:length(obj.data_array)
                    
                    obj.data_array(i).save;
                    
                    disp(['Pic number ',num2str(i),' saved !'])
                    
                end
                
            end
            
            if ~isempty(obj.current_data)
                
                obj.current_data.pics.dpg = tmp_dpg;
                
                obj.current_data.pics.reset_clb;
                
            end
            
        end
        
        function postset_current_data_dir(obj,~,~)
            
            if ~isempty(obj.current_data_dir)
                
                % If the current data directory is not empty...
                
                if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                    
                    % Check if the Treatment main GUI exists and set the listbox to the current data directory 
                    
                    set(obj.tmg.lsb2_1,'Value',find(strcmp(get(obj.tmg.lsb2_1,'String'),obj.current_data_dir)));
                    
                end
                
                % Get the name of the files in the current data directory
                
                path = strcat(obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day,'\',obj.current_data_dir);
                
                dir_struct = dir(path);
                
                dir_names = {dir_struct.name};
                
                if length(dir_names)>2
                    
                    % If the current data directory is not empty load the
                    % data in the data array
                    
                    if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                        
                        set(obj.tmg.lsb3_1,'String',cellfun(@(x) num2str(x),num2cell(sort(str2double(dir_names(3:end)))),'UniformOutput',0),'Value',1);
                        
                    end
                    
                    % fill data_array
                    
                    try
                        
                        load([path,'\1\data.mat']);

                    catch
                        
                        load([path,'\1\data.m'],'-mat');
                        
                        save([path,'\1\data.mat'],'data')
                        delete([path,'\1\data.m'])
                        
                    end
                    
                    % change the data dir path if needed
                    
                    if strcmp(data.pics_path(1:3),'D:\')
                        
                        data.pics_path(1:3)='E:\';
                        
                    end
                    
                    if strcmp(data.pics.pics_path(1:3),'D:\')
                        
                        data.pics.pics_path(1:3)='E:\';
                        
                    end
                    
                    % set observe properties if empty
                    
                    if isempty(data.scan_obs_fit_type)
                        
                        data.scan_obs_fit_type = 'static_widths';
                        data.glob_obs_fit_type = 'static_widths';
                        data.scan_obs_y_axis = 'roi_total_signal';
                        data.glob_obs_y_axis = 'roi_total_signal';
                        
                    end
                    
                    obj.data_array = data;
                    
                    disp('Pic 1 reloaded !')
                    
                    for i=2:length(get(obj.tmg.lsb3_1,'String'))
                        
                        try
                            
                            load([path,'\',num2str(i),'\data.mat']);

                        catch
                            
                            load([path,'\',num2str(i),'\data.m'],'-mat');
                            
                            save([path,'\',num2str(i),'\data.mat'],'data');
                            delete([path,'\',num2str(i),'\data.m']);
                            
                        end
                        
                        % change the data dir path if needed
                        
                        if strcmp(data.pics_path(1:3),'D:\')
                            
                            data.pics_path(1:3)='E:\';
                            
                        end
                        
                        if strcmp(data.pics.pics_path(1:3),'D:\')
                            
                            data.pics.pics_path(1:3)='E:\';
                            
                        end
                        
                        % set observe properties if empty
                        
                        if isempty(data.scan_obs_fit_type)
                            
                            data.scan_obs_fit_type = 'static_widths';
                            data.glob_obs_fit_type = 'static_widths';
                            data.scan_obs_y_axis = 'roi_total_signal';
                            data.glob_obs_y_axis = 'roi_total_signal';
                            
                        end
                        
                        obj.data_array(i) = data;
                        
                        disp(['Pic ',num2str(i),' reloaded !'])
                        
                    end
                    
                    % Show the scan GUI if it is closed
                                        
                    if isempty(obj.osg)||~ishandle(obj.osg.h)
                        
                        obj.observe_scans_gui;
                        
                    end
                    
                    if ~isempty(obj.current_data)
                        
                        if isequal(obj.current_data.camera_type,obj.data_array(1).camera_type)&&isequal(obj.current_data.treatment_type,obj.data_array(1).treatment_type)
                            
                            if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                
                                obj.data_array(1).pics.dpg = obj.current_data.pics.dpg;
                                
                                obj.data_array(1).pics.reset_clb;
                                
                            end
                            
                            obj.current_data = obj.data_array(1);
                            
                            %obj.update_scan_obs_plot;
                            
                        else
                            
                            if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                
                                close(obj.current_data.pics.dpg.h)
                                
                            end
                            
                            obj.current_data = obj.data_array(1);
                            
                            %obj.set_obs_params_lists;
                            
                        end
                        
                    else
                        
                        obj.current_data = obj.data_array(1);
                        
                        %obj.set_obs_params_lists;
                        
                    end
                    
                    % update scan observe GUI
                    
                    obj.set_obs_params_lists;
                    %obj.update_scan_obs_plot;
                    
                    % enable global observe pop-up menu
                    
                    set(obj.gog.pum1,'Enable','on')
                    set(obj.gog.pum2,'Enable','on')
             
                    if strcmp(obj.current_data_dir(1:4),'Scan')
                        
                        % enable scan observe buttons
                        
                        set(obj.osg.but1,'Enable','on')
                        set(obj.osg.but2,'Enable','on')
                        
                        % re-enable scan observe pop-up menu
                        
                        set(obj.osg.pum1,'Enable','on')
                        set(obj.osg.pum2,'Enable','on')
                        set(obj.osg.pum3,'Enable','on')
                        
                    end
                    
                else
                    
                    % If the current data directory is empty...
                    
                    if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                        
                        set(obj.tmg.lsb3_1,'String','');
                        
                    end
                    
                    obj.data_array = [];
                    
                end
                
            end
            
        end
                
        function postset_camera_type(obj,~,~)
            
            if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                
                tmp_struct = Treatment.Default_parameters.camera_struct;
                
                ind = find(strcmp(obj.camera_type,{tmp_struct.type}));
                
                set(obj.tmg.lsb1_1,'Value',ind);
                
            end
            
        end
        
        function postset_treatment_type(obj,~,~)
            
            if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                
                tmp_struct = Treatment.Default_parameters.treatment_struct;
                
                ind = find(strcmp(obj.treatment_type,{tmp_struct.type}));
                
                set(obj.tmg.lsb1_2,'Value',ind);
                
            end
            
        end
        
        function execute(obj,name,message)
            
            switch name
                
                case 'BEC009'
                    
                    str_cell = strsplit(message,'-');
                    
                    obj.camera_type = str_cell{1};
                    
                    obj.treatment_type = str_cell{2};
                    
                    tmp_struct = Treatment.Default_parameters.camera_struct;
                    
                    raw_data_dir_path = Treatment.Default_parameters.camera_struct(strcmp({tmp_struct.type},obj.camera_type)).data_path;
                    
                    % check if the date is the current one, if not set it
                    
                    cur_date = clock;
                    
                    tmp_year = num2str(cur_date(1));
                    
                    if ~strcmp(obj.year,tmp_year)
                    
                    obj.year = tmp_year;
                    
                    end
                    
                    if (cur_date(2)<10)
                        
                        tmp_month = ['0',num2str(cur_date(2))];
                        
                    else
                        
                        tmp_month = num2str(cur_date(2));
                        
                    end
                    
                    if ~strcmp(obj.month,tmp_month)
                    
                    obj.month = tmp_month;
                    
                    end
                    
                    if (cur_date(3)<10)
                        
                        tmp_day = ['0',num2str(cur_date(3))];
                        
                    else
                        
                        tmp_day = num2str(cur_date(3));
                        
                    end
                    
                    if ~strcmp(obj.day,tmp_day)
                    
                    obj.day = tmp_day;
                    
                    end
                    
                    switch str_cell{3}
                        
                        case 'scan'
                            
                            if isempty(obj.osg)||~ishandle(obj.osg.h)
                                
                                obj.observe_scans_gui;
                                
                            end
                            
                            scan_nbr = str2double(str_cell{4});
                            
                            pic_num = str2double(str_cell{6});
                            
                            scan_data_dir_path = [obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day,'\Scan',num2str(scan_nbr)];
                            
                            new_data_dir_path = [obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day,'\Scan',num2str(scan_nbr),'\',num2str(pic_num)];
                            
                            if isequal(pic_num,1)
                                
                                % update list of folders
                                
                                tmp_str_cell = get(obj.tmg.lsb2_1,'String');
                                
                                if ~isempty(tmp_str_cell)
                                    
                                    tmp_str_cell{end+1} = ['Scan',num2str(scan_nbr)];
                                    
                                else
                                    
                                    tmp_str_cell = {['Scan',num2str(scan_nbr)]};
                                    
                                end
                                
                                set(obj.tmg.lsb2_1,'String',tmp_str_cell)
                                
                                % create current scan folder
                                
                                mkdir(scan_data_dir_path);
                                
                                obj.current_data_dir = ['Scan',num2str(scan_nbr)];

                                % move data files
                                
                                mkdir(new_data_dir_path);
                                
                                movefile([raw_data_dir_path,'\*'],new_data_dir_path);
                                
                                if exist([obj.data_path,'\Tmp\params.mat'],'file')
                                    
                                    disp('Found params file !')
                                    
                                    movefile([obj.data_path,'\Tmp\params.mat'],new_data_dir_path);
                                    
                                else
                                    
                                    disp('Params file not found !')
                                    
                                    while ~exist([obj.data_path,'\Tmp\params.mat'],'file')
                                        
                                        pause(1)
                                        
                                        disp('Waiting for file !')
                                        
                                    end
                                    
                                    disp('Found params file !')
                                    
                                    movefile([obj.data_path,'\Tmp\params.mat'],new_data_dir_path);
                                end
                                
                                % update listbox data
                                
                                tmp = get(obj.tmg.lsb3_1,'String');
                                
                                tmp{end+1} = num2str(pic_num);
                                
                                set(obj.tmg.lsb3_1,'String',tmp,'Value',pic_num);
                                
                                % initialize data array
                                
                                obj.data_array = Data.Data(obj.camera_type,obj.treatment_type,new_data_dir_path);
                                
                                if ~isempty(obj.current_data)
                                    
                                    if isequal(obj.current_data.camera_type,obj.data_array.camera_type)&&isequal(obj.current_data.treatment_type,obj.data_array.treatment_type)

                                        if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                            
                                            obj.data_array.pics.dpg = obj.current_data.pics.dpg;
                                            
                                            obj.data_array.pics.reset_clb;
                                            
                                        end
                                            
                                        obj.data_array.pics.pic_props = obj.current_data.pics.pic_props;
                                        
                                        obj.data_array.pics.static_pic_props = obj.current_data.pics.static_pic_props;
                                        
                                        obj.current_data = obj.data_array;

                                    else
                                        
                                        if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                            
                                            close(obj.current_data.pics.dpg.h)
                                            
                                        end
                                        
                                        obj.current_data = obj.data_array;
                                        
                                        obj.set_obs_params_lists;
                                        
                                    end
                                    
                                else
                                    
                                    obj.current_data = obj.data_array;
                                    
                                    obj.set_obs_params_lists;
                                    
                                    % enable global observe pop-up menu
                                    
                                    set(obj.gog.pum1,'Enable','on')
                                    
                                    % enable scan observe buttons
                                    
                                    set(obj.osg.but1,'Enable','on')
                                    set(obj.osg.but2,'Enable','on')
                                    
                                end
                                
                                % re-enable pop-up menu
                                
                                set(obj.osg.pum1,'Enable','on')
                                set(obj.osg.pum2,'Enable','on')
                                set(obj.osg.pum3,'Enable','on')
                                
                            else
                                
                                % move data files
                                
                                mkdir(new_data_dir_path);
                                
                                movefile([raw_data_dir_path,'\*'],new_data_dir_path);
                                
                                if exist([obj.data_path,'\Tmp\params.mat'],'file')
                                    
                                    disp('Found params file !')
                                    
                                    movefile([obj.data_path,'\Tmp\params.mat'],new_data_dir_path);
                                    
                                else
                                    
                                    disp('Params file not found !')
                                    
                                    while ~exist([obj.data_path,'\Tmp\params.mat'],'file')
                                        
                                        pause(1)
                                        
                                        disp('Waiting for file !')
                                        
                                    end
                                    
                                    disp('Found params file !')
                                    
                                    movefile([obj.data_path,'\Tmp\params.mat'],new_data_dir_path);
                                    
                                end
                                
                                % update listbox data
                                
                                tmp = get(obj.tmg.lsb3_1,'String');
                                
                                tmp{end+1} = num2str(pic_num);
                                
                                set(obj.tmg.lsb3_1,'String',tmp,'Value',pic_num);
                                
                                % fill the data array
                                
                                obj.data_array(end+1) = Data.Data(obj.camera_type,obj.treatment_type,new_data_dir_path);
                                
                                if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                    
                                    obj.data_array(end).pics.dpg = obj.current_data.pics.dpg;
                                    
                                    obj.data_array(end).pics.reset_clb;
                                    
                                end
                                    
                                obj.data_array(end).pics.pic_props = obj.current_data.pics.pic_props;
                                
                                obj.data_array(end).pics.static_pic_props = obj.current_data.pics.static_pic_props;
                                
                                obj.current_data = obj.data_array(end);

                            end

                            % update scan observe
                                                        
                            obj.data_array(end).scan_obs_x_axis = obj.scan_obs.x_axis;
                            
                            if strcmp(obj.scan_obs.x_axis,'none')
                                
                                obj.data_array(end).scan_obs_x_axis_value = length(obj.data_array);
                                
                            end
                            
                            obj.data_array(end).scan_obs_fit_type = obj.scan_obs.fit_type;
                            
                            obj.data_array(end).scan_obs_y_axis = obj.scan_obs.y_axis;
                            
                            obj.update_scan_obs_plot;
                            
                            % update global observe
                            
                            obj.data_array(end).glob_obs_fit_type = obj.glob_obs.fit_type;
                            
                            obj.data_array(end).glob_obs_y_axis = obj.glob_obs.y_axis;
                            
                            if isfield(obj.glob_obs,'values')
                                
                                obj.glob_obs.values(end+1) = obj.data_array(end).glob_obs_y_axis_value;
                                
                            else
                                
                                obj.glob_obs.values = obj.data_array(end).glob_obs_y_axis_value;
                                
                            end
                            
                        case 'seq'
                            
                            %%% disable scan obs
                            
                            if ~isempty(obj.osg)&&ishandle(obj.osg.h)
                                
                                % disable scan observe pop-up menu
                                
                                set(obj.osg.pum1,'Enable','off')
                                set(obj.osg.pum2,'Enable','off')
                                set(obj.osg.pum2,'Enable','off')
                                
                            else
                                
                                obj.observe_scans_gui;
                                
                            end
                            
                            %%%
                            
                            seq_nbr = str2double(str_cell{4});
                            
                            if isequal(seq_nbr,0)
                                
                                tmp_data_dir_path = [obj.data_path,'\Tmp'];
                                
                                movefile([raw_data_dir_path,'\*'],tmp_data_dir_path);
                                
                                tmp_data_new = Data.Data(obj.camera_type,obj.treatment_type,tmp_data_dir_path);
                                
                                if ~isempty(obj.current_data)
                                    
                                    if isequal(obj.current_data.camera_type,tmp_data_new.camera_type)&&isequal(obj.current_data.treatment_type,tmp_data_new.treatment_type)
                                        
                                        if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                            
                                            tmp_data_new.pics.dpg = obj.current_data.pics.dpg;
                                            
                                            tmp_data_new.pics.reset_clb;
                                            
                                        end
                                        
                                        tmp_data_new.pics.pic_props = obj.current_data.pics.pic_props;
                                        
                                        tmp_data_new.pics.static_pic_props = obj.current_data.pics.static_pic_props;
                                        
                                        obj.current_data = tmp_data_new;
                                        
                                    else
                                        
                                        if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                            
                                            close(obj.current_data.pics.dpg.h)
                                            
                                        end
                                        
                                        obj.current_data = tmp_data_new;
                                        
                                        obj.set_obs_params_lists;
                                        
                                    end
                                    
                                else
                                    
                                    obj.current_data = tmp_data_new;
                                        
                                    obj.set_obs_params_lists;
                                    
                                    % enable scan observe buttons
                                        
                                    set(obj.osg.but1,'Enable','on')
                                    set(obj.osg.but2,'Enable','on')
                                    
                                    % enable global observe pop-up menu
                                    
                                    set(obj.gog.pum1,'Enable','on')
                                    set(obj.gog.pum2,'Enable','on')
                                    
                                end
                                
                                % update global observe
                                
                                obj.current_data.glob_obs_fit_type = obj.glob_obs.fit_type;
                                
                                obj.current_data.glob_obs_y_axis = obj.glob_obs.y_axis;
                                
                                if isfield(obj.glob_obs,'values')
                                    
                                    obj.glob_obs.values(end+1) = obj.current_data.glob_obs_y_axis_value;
                                    
                                else
                                    
                                    obj.glob_obs.values = obj.current_data.glob_obs_y_axis_value;
                                    
                                end
                                
                            else
                                
                                seq_data_dir_path = [obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day,'\Saved'];
                                
                                if ~exist(seq_data_dir_path,'file')
                                    
                                    % update list of folders
                                    
                                    tmp_str_cell = get(obj.tmg.lsb2_1,'String');
                                    
                                    if ~isempty(tmp_str_cell)
                                        
                                        tmp_str_cellbis = cell(1,length(tmp_str_cell)+1);
                                        
                                        tmp_str_cellbis{1} = 'Saved';
                                        
                                        tmp_str_cellbis(2:end) = tmp_str_cell;
                                        
                                        tmp_str_cell = tmp_str_cellbis;
                                        
                                    else
                                        
                                        tmp_str_cell = {'Saved'};
                                        
                                    end
                                    
                                    set(obj.tmg.lsb2_1,'String',tmp_str_cell)
                                    
                                    mkdir(seq_data_dir_path);
                                    
                                end
                                
                                if ~strcmp(obj.current_data_dir,'Saved')
                                    
                                    obj.current_data_dir = 'Saved';
                                    
                                end
                                
                                mkdir([seq_data_dir_path,'\',num2str(seq_nbr)]);
                                
                                movefile([raw_data_dir_path,'\*'],[seq_data_dir_path,'\',num2str(seq_nbr)]);
                                
                                movefile([obj.data_path,'\Tmp\params.mat'],[seq_data_dir_path,'\',num2str(seq_nbr)]);
                                
                                % update listbox data
                                
                                tmp = get(obj.tmg.lsb3_1,'String');
                                
                                tmp{end+1} = num2str(seq_nbr);
                                
                                set(obj.tmg.lsb3_1,'String',tmp,'Value',seq_nbr);
                                
                                % fill data array
                                
                                if isempty(obj.data_array)
                                    
                                    obj.data_array = Data.Data(obj.camera_type,obj.treatment_type,[seq_data_dir_path,'\',num2str(seq_nbr)]);
                                    
                                    if ~isempty(obj.current_data)
                                        
                                        if isequal(obj.current_data.camera_type,obj.data_array.camera_type)&&isequal(obj.current_data.treatment_type,obj.data_array.treatment_type)
                                            
                                            if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                                
                                                obj.data_array.pics.dpg = obj.current_data.pics.dpg;
                                                
                                                obj.data_array.pics.reset_clb;
                                                
                                            end
                                            
                                            obj.data_array.pics.pic_props = obj.current_data.pics.pic_props;
                                            
                                            obj.data_array.pics.static_pic_props = obj.current_data.pics.static_pic_props;
                                            
                                            obj.current_data = obj.data_array;
                                            
                                        else
                                            
                                            if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                                
                                                close(obj.current_data.pics.dpg.h)
                                                
                                            end
                                            
                                            obj.current_data = obj.data_array;
                                            
                                            obj.set_obs_params_lists;
                                            
                                        end
                                        
                                    else
                                        
                                        obj.current_data = obj.data_array;
                                        
                                        obj.set_obs_params_lists;
                                        
                                        % enable scan observe buttons
                                        
                                        set(obj.osg.but1,'Enable','on')
                                        set(obj.osg.but2,'Enable','on')
                                        
                                        % enable global observe pop-up menu
                                        
                                        set(obj.gog.pum1,'Enable','on')
                                        set(obj.gog.pum2,'Enable','on')
                                        
                                    end
                                    
                                else
                                    
                                    obj.data_array(end+1) = Data.Data(obj.camera_type,obj.treatment_type,[seq_data_dir_path,'\',num2str(seq_nbr)]);
                                    
                                    if ~isempty(obj.current_data)
                                        
                                        if isequal(obj.current_data.camera_type,obj.data_array(end).camera_type)&&isequal(obj.current_data.treatment_type,obj.data_array(end).treatment_type)
                                            
                                            if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                                
                                                obj.data_array(end).pics.dpg = obj.current_data.pics.dpg;
                                                
                                                obj.data_array(end).pics.reset_clb;
                                                
                                            end
                                            
                                            obj.data_array(end).pics.pic_props = obj.current_data.pics.pic_props;
                                            
                                            obj.data_array(end).pics.static_pic_props = obj.current_data.pics.static_pic_props;
                                            
                                            obj.current_data = obj.data_array(end);
                                            
                                        else
                                            
                                            if ~isempty(obj.current_data.pics.dpg)&&ishandle(obj.current_data.pics.dpg.h)
                                                
                                                close(obj.current_data.pics.dpg.h)
                                                
                                            end
                                            
                                            obj.current_data = obj.data_array;
                                            
                                            obj.set_obs_params_lists;
                                            
                                        end
                                        
                                    else
                                        
                                        obj.current_data = obj.data_array;
                                        
                                        obj.set_obs_params_lists;
                                        
                                        % enable scan observe buttons
                                        
                                        set(obj.osg.but1,'Enable','on')
                                        set(obj.osg.but2,'Enable','on')
                                        
                                        % enable global observe pop-up menu
                                        
                                        set(obj.gog.pum1,'Enable','on')
                                        set(obj.gog.pum2,'Enable','on')
                                        
                                    end
                                    
                                end
                                
                                % update global observe
                                
                                obj.data_array(end).glob_obs_fit_type = obj.glob_obs.fit_type;
                                
                                obj.data_array(end).glob_obs_y_axis = obj.glob_obs.y_axis;
                                
                                if isfield(obj.glob_obs,'values')
                                    
                                    obj.glob_obs.values(end+1) = obj.data_array(end).glob_obs_y_axis_value;
                                    
                                else
                                    
                                    obj.glob_obs.values = obj.data_array(end).glob_obs_y_axis_value;
                                    
                                end
                                
                                
                            end
                            
                    end
                    
            end
            
        end
        
        function set_obs_params_lists(obj,~,~)
            
            % update fit-type list
            
            list_fit_type = {Fit.Default_parameters.fit_struct.type};
            
            ind1 = find(strcmp(obj.current_data.glob_obs_fit_type,list_fit_type));
            
            if isempty(ind1)
                
                ind1=1;
                
            end
            
            set(obj.gog.pum1,'String',list_fit_type,'Value',ind1);
            
            ind2 = find(strcmp(obj.current_data.scan_obs_fit_type,list_fit_type));
            
            if isempty(ind2)
                
                ind2=1;
                
            end
            
            set(obj.osg.pum2,'String',list_fit_type,'Value',ind2);
            
            % update y-axis parameters list
            
            list_y_axis_1 = Fit.Default_parameters.fit_struct(ind1).parameters;
            
            ind3 = find(strcmp(obj.current_data.glob_obs_y_axis,list_y_axis_1));
            
            if isempty(ind3)
                
                ind3=1;
                
            end
            
            set(obj.gog.pum2,'String',list_y_axis_1,'Value',ind3);
            
            list_y_axis_2 = Fit.Default_parameters.fit_struct(ind2).parameters;
            
            ind4 = find(strcmp(obj.current_data.scan_obs_y_axis,list_y_axis_2));
            
            if isempty(ind4)
                
                ind4=1;
                
            end
            
            set(obj.osg.pum3,'String',list_y_axis_2,'Value',ind4);
            
            % update x-axis parameters list
            
            if ~isempty(obj.current_data.static_params)||~isempty(obj.current_data.dep_params)
                
                list_x_axis = ['none',{obj.current_data.static_params.name},{obj.current_data.dep_params.name}];
                
            else
                
                list_x_axis = {'none'};
                
            end
            
            ind = find(strcmp(obj.current_data.scan_obs_x_axis,list_x_axis));
            
            if isempty(ind)
                
                ind=1;
                
            end
            
            set(obj.osg.pum1,'String',list_x_axis,'Value',ind);
            
            % update global scan_obs
            
            if isfield(obj.glob_obs,'values')
                
                obj.glob_obs = struct('fit_type',list_fit_type{ind1},...
                    'y_axis',list_y_axis_1{ind3},'values',obj.glob_obs.values);
                
            else
                
                obj.glob_obs = struct('fit_type',list_fit_type{ind1},...
                    'y_axis',list_y_axis_1{ind3});
                
            end

            obj.scan_obs = struct('fit_type',list_fit_type{ind2},...
                'y_axis',list_y_axis_2{ind4},'x_axis',list_x_axis{ind});

        end
        
        function update_glob_obs_plot(obj)
            
            plot(1:length(obj.glob_obs.values),obj.glob_obs.values,'Parent',obj.gog.ax)
            
            if ~isequal(length(obj.glob_obs.values),1)
                
                xlim(obj.gog.ax,[1 length(obj.glob_obs.values)])
                
            end
            
            xlabel(obj.gog.ax,'# run')
            
            ylabel(obj.gog.ax,obj.glob_obs.y_axis)
            
            set(obj.gog.ax,'Box','on','Tickdir','out','NextPlot','replace','FontSize',8);
            
        end
        
        function post_set_glob_obs(obj,~,~)
            
            if isfield(obj.glob_obs,'values')&&~isempty(obj.glob_obs.values)
                
                if ~strcmp(obj.glob_obs.fit_type,obj.current_data.glob_obs_fit_type)||...
                        ~strcmp(obj.glob_obs.y_axis,obj.current_data.glob_obs_y_axis)
                    
                    obj.current_data.glob_obs_fit_type = obj.glob_obs.fit_type;
                    obj.current_data.glob_obs_y_axis = obj.glob_obs.y_axis;
                    
                    obj.glob_obs.values = obj.current_data.glob_obs_y_axis_value;
                    
                end
                
                obj.update_glob_obs_plot;
                
            else
                
                plot([],[],'Parent',obj.gog.ax)
                
                xlabel(obj.gog.ax,[])
                
                ylabel(obj.gog.ax,[])
                
                set(obj.gog.ax,'Box','on','Tickdir','out','NextPlot','replace','FontSize',8);
                
            end

        end
        
        function update_scan_obs_plot(obj)
            
            x_axis_values = [obj.data_array.scan_obs_x_axis_value];
            
            y_axis_values = [obj.data_array.scan_obs_y_axis_value];
            
            uniq_x_axis_values = unique(x_axis_values);
            
            % plot errorbars if possible
            
            if length(uniq_x_axis_values)<length(x_axis_values)
                
                mean_y_axis_values = zeros(size(uniq_x_axis_values));
                
                std_y_axis_values = zeros(size(uniq_x_axis_values));
                
                for i = 1:length(uniq_x_axis_values)
                    
                    ind_array = find(x_axis_values==uniq_x_axis_values(i));
                    
                    mean_y_axis_values(i) = mean(y_axis_values(ind_array));
                    
                    std_y_axis_values(i) = std(y_axis_values(ind_array));
                    
                end
                
                plot(x_axis_values,y_axis_values,'Parent',obj.osg.ax,'Marker','o',...
                    'MarkerEdgeColor','k','LineStyle','none')
                
                hold(obj.osg.ax,'on')
                
                errorbar(uniq_x_axis_values,mean_y_axis_values,std_y_axis_values/2,'Parent',obj.osg.ax,'LineStyle','-','Color','r')
                
                hold(obj.osg.ax,'off')
                
            else
                
                plot(x_axis_values,y_axis_values,'Parent',obj.osg.ax,'Marker','o',...
                    'MarkerEdgeColor','k','LineStyle','-','Color','r')
                
            end
            
            xlabel(obj.osg.ax,obj.scan_obs.x_axis,'interpreter','none')
            
            ylabel(obj.osg.ax,obj.scan_obs.y_axis,'interpreter','none')
            
            set(obj.osg.ax,'Box','on','Tickdir','out','NextPlot','replace','FontSize',8);
            
        end
        
        function post_set_scan_obs(obj,~,~)
            
            if ~isempty(obj.data_array)
                
                if isfield(obj.scan_obs,'x_axis')&&isfield(obj.scan_obs,'fit_type')&&isfield(obj.scan_obs,'y_axis')
                    
                    if ~isempty(obj.scan_obs.x_axis)&&~isempty(obj.scan_obs.fit_type)&&~isempty(obj.scan_obs.y_axis)
                        
                        if ~strcmp(obj.scan_obs.x_axis,obj.data_array(1).scan_obs_x_axis)||...
                                ~strcmp(obj.scan_obs.fit_type,obj.data_array(1).scan_obs_fit_type)||...
                                ~strcmp(obj.scan_obs.y_axis,obj.data_array(1).scan_obs_y_axis)
                            
                            for i=1:length(obj.data_array)
                                
                                disp(['Treat picture ',num2str(i),' !'])
                                
                                obj.data_array(i).pics.pic_props = obj.data_array(1).pics.pic_props;
                                obj.data_array(i).pics.static_pic_props = obj.data_array(1).pics.static_pic_props;
                                
                                obj.data_array(i).scan_obs_x_axis = obj.scan_obs.x_axis;
                                
                                if strcmp(obj.scan_obs.x_axis,'none')
                                    
                                    obj.data_array(i).scan_obs_x_axis_value = i;
                                    
                                end
                                
                                obj.data_array(i).scan_obs_fit_type = obj.scan_obs.fit_type;
                                obj.data_array(i).scan_obs_y_axis = obj.scan_obs.y_axis;
                                
                            end
                            
                        end
                        
                        obj.update_scan_obs_plot;
                        
                    end
                    
                end
                
            end
            
%             if ~isempty(obj.data_array)
%                 
%                 if isfield(obj.scan_obs,'x_axis')&&isfield(obj.scan_obs,'y_axis')
%                     
%                     if ~isempty(obj.scan_obs.x_axis)&&~isempty(obj.scan_obs.y_axis)
%                         
%                         if ~strcmp(obj.scan_obs.x_axis,obj.data_array(1).scan_obs_x_axis)
%                             
%                             for i=1:length(obj.data_array)
%                                 
%                                 obj.data_array(i).pics.pic_props = obj.data_array(1).pics.pic_props;
%                                 obj.data_array(i).pics.static_pic_props = obj.data_array(1).pics.static_pic_props;
%                                 
%                                 obj.data_array(i).pics.tmp_pic_bg = [];
%                                 obj.data_array(i).pics.tmp_pic_sig = [];
%                                 obj.data_array(i).pics.tmp_pic_cor = [];
%                                 
%                                 obj.data_array(i).scan_obs_x_axis = obj.scan_obs.x_axis;
%                                 
%                                 if strcmp(obj.scan_obs.x_axis,'none')
%                                     
%                                     obj.data_array(i).scan_obs_x_axis_value = i;
%                                     
%                                 end
%                                 
%                             end
%                             
%                         end
%                         
%                         if ~strcmp(obj.scan_obs.y_axis,obj.data_array(1).scan_obs_y_axis)
%                             
%                             for i=1:length(obj.data_array)
%                                 
%                                 obj.data_array(i).pics.pic_props = obj.data_array(1).pics.pic_props;
%                                 obj.data_array(i).pics.static_pic_props = obj.data_array(1).pics.static_pic_props;
%                                 
%                                 obj.data_array(i).pics.tmp_pic_bg = [];
%                                 obj.data_array(i).pics.tmp_pic_sig = [];
%                                 obj.data_array(i).pics.tmp_pic_cor = [];
%                                 
%                                 obj.data_array(i).scan_obs_y_axis = obj.scan_obs.y_axis;
%                                 
%                             end
%                             
%                         end
%                         
%                         obj.update_scan_obs_plot;
%                         
%                     end
%                     
%                 end
%                 
%             end
            
        end
        
        function post_set_current_data(obj,~,~)
           
            obj.current_data.pics.show;
            
        end
        
        function delete(obj)
            
            obj.preset_current_data_dir;
            
            delete(obj.net);
            
            for i=1:length(obj.data_array)
               
                delete(obj.data_array(i));
                
            end
            
        end
        
    end
    
    methods (Static = true)
        
        function num = split_names(str)
            
            if strcmp(str(1:4),'Scan')
                
                num = str2double(str(5:end));
                
            else
                
                num = 0;
                
            end
            
        end
        
    end
    
end
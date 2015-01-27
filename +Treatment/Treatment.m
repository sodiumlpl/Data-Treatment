classdef Treatment < handle
    % Treatment class
    
    properties % GUI
        
        tmg % treatment main GUI
        
    end
    
    properties (SetObservable = true) % general
        
        data_path
        
        day
        
        month
        
        year
        
        current_data_dir
        
    end
    
    properties
        
        running
        
        chk_pix_timer
        
    end
    
    properties % camera & treatment
        
        camera_type
        
        treatment_type
        
    end
    
    properties
        
        data_array
        
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
            
            addlistener(obj,'current_data_dir','PostSet',@obj.postset_current_data_dir);
            
            obj.running = 0;
            
            % set default camera and treatment
            
            obj.camera_type = Treatment.Default_parameters.camera_type;
            
            obj.treatment_type = Treatment.Default_parameters.treatment_type;
            
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
                ,'Style'                ,'listbox' ...
                ,'Units'                , Treatment.Default_parameters.Listbox_Units ...
                ,'String'               , {cell_tmp.type} ...
                ,'Value'                , find(strcmp({cell_tmp.type},Treatment.Default_parameters.camera_type)) ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.tmg_lsb1_1_clb ...
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
                ,'Style'                ,'listbox' ...
                ,'Units'                , Treatment.Default_parameters.Listbox_Units ...
                ,'String'               , {cell_tmp.type} ...
                ,'Value'                ,find(strcmp({cell_tmp.type},Treatment.Default_parameters.treatment_type)) ...
                ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                ,'Callback'             ,@obj.tmg_lsb1_2_clb ...
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
            
            obj.update_dir_path;
            
        end
        
        function tmg_lsb1_1_clb(obj,~,~)
            
            ind = get(obj.tmg.lsb1_1,'Value');
            
            list = {Treatment.Default_parameters.camera_struct.type};
            
            obj.camera_type = list{ind};

        end
        
        function tmg_lsb1_2_clb(obj,~,~)
            
            ind = get(obj.tmg.lsb1_2,'Value');
            
            tmp_struct = Treatment.Default_parameters.treatment_struct;
            
            list = {tmp_struct.type};
            
            obj.treatment_type = list{ind};
            
        end
        
        function check_new_pics(obj,~,~)
            
            switch obj.running
                
                case 0
                    
                    % initialize and start sequence
                    
                    %start(obj.chk_pix_timer);
                    
                    set(obj.tmg.but1_1,'BackgroundColor',[1.0,0.0,0.0]);
                    
                    obj.running = 1;
                    
                case 1
                    
                    % stop sequence
                    
                    %stop(obj.chk_pix_timer);
                    
                    set(obj.tmg.but1_1,'BackgroundColor',[0.0,1.0,0.0]);
                    
                    obj.running = 0;
                    
            end
            
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
            
            obj.data_array(ind).pics.show;
            
        end
        
        function update_dir_path(obj)
            
            path = [obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day];
            
            dir_struct = dir(path);
            
            dir_names = {dir_struct.name};
            
            if length(dir_names)>2
                
                if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                    
                    list_tmp = cellfun( @(x) obj.split_names(x),dir_names(3:end));
                    
                    list_tmp = sort(list_tmp);
                    
                    list_tmp = list_tmp(list_tmp>0);
                    
                    sorted_list = cell(1,length(list_tmp));
                    
                    if isequal(list_tmp(1),0)
                       
                        sorted_list{1} = 'Saved';
                        
                        for i = 2:length(sorted_list)
                            
                            sorted_list{i} = ['Scan',num2str(list_tmp(i))];
                            
                        end
                        
                    else
                        
                        for i = 1:length(sorted_list)
                            
                            sorted_list{i} = ['Scan',num2str(list_tmp(i))];
                            
                        end
                        
                    end
                    
                    set(obj.tmg.lsb2_1,'String',sorted_list,'Value',1);
                    
                end
                
                obj.current_data_dir = dir_names{3};
                
            else
                
                if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                    
                    set(obj.tmg.lsb2_1,'String','');
                    
                end
                
                obj.current_data_dir = [];
                
            end
            
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
        
        function postset_current_data_dir(obj,~,~)
            
            if ~isempty(obj.current_data_dir)
                
                if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                    
                    set(obj.tmg.lsb2_1,'Value',find(strcmp(get(obj.tmg.lsb2_1,'String'),obj.current_data_dir)));
                    
                end
                
                path = strcat(obj.data_path,'\',obj.year,'\',obj.month,'\',obj.day,'\',obj.current_data_dir);
                
                dir_struct = dir(path);
                
                dir_names = {dir_struct.name};
                
                if length(dir_names)>2
                    
                    if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                        
                        set(obj.tmg.lsb3_1,'String',cellfun(@(x) num2str(x),num2cell(sort(str2double(dir_names(3:end)))),'UniformOutput',0),'Value',1);
                        
                    end
                    
                    % fill data_array
                    
                    load([path,'\1\data.m'],'-mat');
                    
                    obj.data_array = data;
                    
                    for i=2:length(get(obj.tmg.lsb3_1,'String'))
                        
                        load([path,'\',num2str(i),'\data.m'],'-mat');
                        
                        obj.data_array(i) = data;
                        
                    end
                    
                else
                    
                    if ~isempty(obj.tmg)&&ishandle(obj.tmg.h)
                        
                        set(obj.tmg.lsb3_1,'String','');
                        
                    end
                    
                    obj.data_array = [];
                    
                end
                
            end
            
        end
        
        function execute(obj,name,message)
            
            switch name
                
                case 'BEC009'
                    
                    disp(['Received message : ',message])
                    
                    str_cell = strsplit(message,'_');
                    
                    raw_data_dir_path = Treatment.Default_parameters.camera_struct(strcmp({Treatment.Default_parameters.camera_struct.type},obj.camera_type)).data_path;
                    
                    switch str_cell{1}
                        
                        case 'scan'
                            
                            scan_nbr = str2double(str_cell{2});
                            
                            pic_num = str2double(str_cell{4});
                            
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
                                
                            end
                            
                            mkdir(new_data_dir_path);
                            
                            movefile([raw_data_dir_path,'\*'],new_data_dir_path);
                            
                            % update listbox data
                            
                            tmp = get(obj.tmg.lsb3_1,'String');
                            
                            tmp{end+1} = num2str(pic_num);
                            
                            set(obj.tmg.lsb3_1,'String',tmp,'Value',pic_num);
                            
                            % fill data array
                            
                            if isempty(obj.data_array)
                                
                                obj.data_array = Data.Data(obj.camera_type,obj.treatment_type,new_data_dir_path);
                                
                                obj.data_array.save;
                                
                            else
                                
                                obj.data_array(end+1) = Data.Data(obj.camera_type,obj.treatment_type,new_data_dir_path);
                                
                                obj.data_array(end).save;
                                
                            end
                            
                            
                        case 'seq'
                            
                            seq_nbr = str2double(str_cell{2});
                            
                            if isequal(seq_nbr,0)
                                
                                tmp_data_dir_path = [obj.data_path,'\Tmp'];
                                
                                movefile([raw_data_dir_path,'\*'],tmp_data_dir_path);
                                
                                tmp_data = Data.Data(obj.camera_type,obj.treatment_type,tmp_data_dir_path);
                                
                                tmp_data.pics.show;
                                
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
                                
                                % update listbox data
                                
                                tmp = get(obj.tmg.lsb3_1,'String');
                                
                                tmp{end+1} = num2str(seq_nbr);
                                
                                set(obj.tmg.lsb3_1,'String',tmp,'Value',seq_nbr);
                                
                                % fill data array
                                
                                if isempty(obj.data_array)
                                    
                                    obj.data_array = Data.Data(obj.camera_type,obj.treatment_type,[seq_data_dir_path,'\',num2str(seq_nbr)]);
                                    
                                    obj.data_array.save;
                                    
                                else
                                    
                                    obj.data_array(end+1) = Data.Data(obj.camera_type,obj.treatment_type,[seq_data_dir_path,'\',num2str(seq_nbr)]);
                                    
                                    obj.data_array(end).save;
                                    
                                end
                                
                                
                            end
                            
                    end
                    
            end
            
        end
        
        function delete(obj)
            
            delete(obj.net);
            
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
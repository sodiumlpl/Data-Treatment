classdef Fluo_1pix < handle
    % Generic Pixelfly class
    
    properties
        
        pics_path
        
    end
    
    properties (Dependent = true)
        
        pic_at
        
        pic_at_bg
        
        pic_cor
        
    end
    
    properties
        
        tmp_pic_cor
        
    end
    
    properties (SetObservable = true)
        
        pic_type
        
        pic_props % pictures properties
        
    end
    
    properties % listeners
       
        lst_pic_type
        
        lst_pic_props
        
    end
    
    properties % pics size
        
        r_size = [1 1392];
        c_size = [1 1040];
        
    end
    
    properties % GUI
        
        dpg
        
    end
    
    properties % parent Data class
        
        parent
        
    end
    
    methods
        
        function obj = Fluo_1pix(pics_path)
            
            obj = obj@handle;
            
            obj.pics_path=pics_path;
            
            % set default picture properties
            
            obj.pic_props(1).r_roi_ctr = 696;
            obj.pic_props(1).c_roi_ctr = 520;
            obj.pic_props(1).roi_wth = 519;
            
            obj.pic_props(1).pic_min = -10 ;
            obj.pic_props(1).pic_max = 500 ;
            
            obj.pic_props(2).r_roi_ctr = 696;
            obj.pic_props(2).c_roi_ctr = 520;
            obj.pic_props(2).roi_wth = 519;
            
            obj.pic_props(2).pic_min = 200 ;
            obj.pic_props(2).pic_max = 700 ;
            
            obj.pic_props(3).r_roi_ctr = 696;
            obj.pic_props(3).c_roi_ctr = 520;
            obj.pic_props(3).roi_wth = 519;
            
            obj.pic_props(3).pic_min = 2 ;
            obj.pic_props(3).pic_max = 700 ;
            
            
            % initialize listeners
            
            obj.lst_pic_type = addlistener(obj,'pic_type','PostSet',@obj.postset_pic_type);
            
            obj.lst_pic_props = addlistener(obj,'pic_props','PostSet',@obj.postset_pic_props);
            
        end
        
        function show(obj)
            
            if isempty(obj.dpg)||~ishandle(obj.dpg.h)
                
                % initialize Show GUI
                
                obj.dpg.h = figure(...
                    'Name'                ,'Show pic Main' ...
                    ,'NumberTitle'        ,'off' ...
                    ,'Position'           ,[322 116 1000 1000] ... %,'MenuBar'     ,'none'...
                    );
                
                %%% Camera & Treatment type panel %%%
                
                c_ofs = 0.02;
                r_ofs = 0.02;
                c_wth = 0.20;
                r_wth = 0.96;
                
                obj.dpg.hsp1 = uipanel(...
                    'Parent'              ,obj.dpg.h ...
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
                
                c_ofs = 0.01;
                r_ofs = 0.67;
                c_wth = 0.98;
                r_wth = 0.32;
                
                obj.dpg.hsp1_1 = uipanel(...
                    'Parent'              ,obj.dpg.hsp1 ...
                    ,'Title'              ,'Corrected' ...
                    ,'TitlePosition'      ,'centertop' ...
                    ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                    ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                    ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                    ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                    ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                    ,'FontSize'           ,Treatment.Default_parameters.Panel_FontSize ...
                    ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                    ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                    ,'SelectionHighlight' ,'on' ...
                    ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                    ,'Selected'           ,'on' ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    ,'ButtonDownFcn'      , @obj.dpg_hsp1_1_clb ...
                    );
                
                c_ofs = 0.01;
                r_ofs = 0.01;
                c_wth = 0.98;
                r_wth = 0.98;
                
                obj.dpg.ax1_1 = axes(...
                    'Parent'             ,obj.dpg.hsp1_1 ...
                    ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                
                c_ofs = 0.01;
                r_ofs = 0.34;
                c_wth = 0.98;
                r_wth = 0.32;
                
                obj.dpg.hsp1_2 = uipanel(...
                    'Parent'             ,obj.dpg.hsp1 ...
                    ,'Title'              ,'Signal' ...
                    ,'TitlePosition'      ,'centertop' ...
                    ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                    ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                    ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                    ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                    ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                    ,'FontSize'           ,Treatment.Default_parameters.Panel_FontSize ...
                    ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                    ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                    ,'SelectionHighlight' ,'on' ...
                    ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                    ,'Selected'           ,'off' ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    ,'ButtonDownFcn'      , @obj.dpg_hsp1_2_clb ...
                    );
                
                c_ofs = 0.01;
                r_ofs = 0.01;
                c_wth = 0.98;
                r_wth = 0.98;
                
                obj.dpg.ax1_2 = axes(...
                    'Parent'             ,obj.dpg.hsp1_2 ...
                    ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                
                c_ofs = 0.01;
                r_ofs = 0.01;
                c_wth = 0.98;
                r_wth = 0.32;
                
                obj.dpg.hsp1_3 = uipanel(...
                    'Parent'             ,obj.dpg.hsp1 ...
                    ,'Title'              ,'Background' ...
                    ,'TitlePosition'      ,'centertop' ...
                    ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                    ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                    ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                    ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                    ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                    ,'FontSize'           ,Treatment.Default_parameters.Panel_FontSize ...
                    ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                    ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                    ,'SelectionHighlight' ,'on' ...
                    ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                    ,'Selected'           ,'off' ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    ,'ButtonDownFcn'      , @obj.dpg_hsp1_3_clb ...
                    );
                
                c_ofs = 0.01;
                r_ofs = 0.01;
                c_wth = 0.98;
                r_wth = 0.98;
                
                obj.dpg.ax1_3 = axes(...
                    'Parent'             ,obj.dpg.hsp1_3 ...
                    ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                
                %%%
                
                c_ofs = 0.235;
                r_ofs = 0.235;
                c_wth = 0.75;
                r_wth = 0.75;
                
                obj.dpg.hsp2 = uipanel(...
                    'Parent'             ,obj.dpg.h ...
                    ,'Title'              ,'Detailed View' ...
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
                
                
                c_ofs = 0.075;
                r_ofs = 0.07+0.321+0.07;
                c_wth = 0.519;
                r_wth = 0.519;
                
                obj.dpg.ax2_1 = axes(...
                    'Parent'             ,obj.dpg.hsp2 ...
                    ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                
                c_ofs = 0.075;
                r_ofs = 0.07;
                c_wth = 0.519;
                r_wth = 0.321;
                
                obj.dpg.ax2_2 = axes(...
                    'Parent'              ,obj.dpg.hsp2 ...
                    ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                c_ofs = 0.075+0.519+0.065;
                r_ofs = 0.07+0.321+0.07;
                c_wth = 0.321;
                r_wth = 0.519;
                
                obj.dpg.ax2_3 = axes(...
                    'Parent'              ,obj.dpg.hsp2 ...
                    ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                %%% set Min-Max
                
                % Text
                
                c_ofs = 0.7;
                r_ofs = 0.36;
                c_wth = 0.095;
                r_wth = 0.02;
                
                obj.dpg.txt2_0 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Set Min-Max' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Text
                
                c_ofs = 0.7;
                r_ofs = 0.32;
                c_wth = 0.04;
                r_wth = 0.02;
                
                obj.dpg.txt2_1 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Min' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Edit
                
                c_ofs = 0.765;
                r_ofs = 0.315;
                c_wth = 0.06;
                r_wth = 0.03;
                
                obj.dpg.edt2_1 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'edit' ...
                    ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                    ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                    ,'Callback'             ,@obj.dpg_edt2_1_clb ...
                    );
                
                % Text
                
                c_ofs = 0.7;
                r_ofs = 0.27;
                c_wth = 0.04;
                r_wth = 0.02;
                
                obj.dpg.txt2_2 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Max' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Edit
                
                c_ofs = 0.765;
                r_ofs = 0.265;
                c_wth = 0.06;
                r_wth = 0.03;
                
                obj.dpg.edt2_2 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'edit' ...
                    ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                    ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                    ,'Callback'             ,@obj.dpg_edt2_2_clb ...
                    );
                
                %%% set region of interest
                
                % Text
                
                c_ofs = 0.7;
                r_ofs = 0.215;
                c_wth = 0.14;
                r_wth = 0.02;
                
                obj.dpg.txt2_3 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Region of interest' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Text
                
                c_ofs = 0.7;
                r_ofs = 0.17;
                c_wth = 0.08;
                r_wth = 0.02;
                
                obj.dpg.txt2_4 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Row center' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Edit
                
                c_ofs = 0.79;
                r_ofs = 0.166;
                c_wth = 0.06;
                r_wth = 0.03;
                
                obj.dpg.edt2_3 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'edit' ...
                    ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                    ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                    ,'Callback'             ,@obj.dpg_edt2_3_clb ...
                    );
                
                % Text
                
                c_ofs = 0.7;
                r_ofs = 0.12;
                c_wth = 0.08;
                r_wth = 0.02;
                
                obj.dpg.txt2_5 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Column center' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Edit
                
                c_ofs = 0.79;
                r_ofs = 0.116;
                c_wth = 0.06;
                r_wth = 0.03;
                
                obj.dpg.edt2_4 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'edit' ...
                    ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                    ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                    ,'Callback'             ,@obj.dpg_edt2_4_clb ...
                    );
                
                % Text
                
                c_ofs = 0.7;
                r_ofs = 0.07;
                c_wth = 0.08;
                r_wth = 0.02;
                
                obj.dpg.txt2_6 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Width' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Edit
                
                c_ofs = 0.79;
                r_ofs = 0.070;
                c_wth = 0.06;
                r_wth = 0.03;
                
                obj.dpg.edt2_5 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'edit' ...
                    ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                    ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                    ,'Callback'             ,@obj.dpg_edt2_5_clb ...
                    );
                
                %%% Display panel %%%
                
                c_ofs = 0.235;
                r_ofs = 0.02;
                c_wth = 0.75;
                r_wth = 0.21;
                
                obj.dpg.hsp3 = uipanel(...
                    'Parent'              ,obj.dpg.h ...
                    ,'Title'              ,'Display' ...
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
                
                c_ofs = 0.185;
                r_ofs = 0.425;
                c_wth = 0.26;
                r_wth = 0.235;
                
                obj.dpg.txt3_1 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp3 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Total signal :' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,24 ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Text
                
                c_ofs = 0.455;
                r_ofs = 0.425;
                c_wth = 0.18;
                r_wth = 0.235;
                
                obj.dpg.txt3_2 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp3 ...
                    ,'Style'                ,'text' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,24 ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
            end
            
            
            %%% disp pictures
            
            obj.disp_pic_cor;
            
            obj.disp_pic_at;
            
            obj.disp_pic_at_bg;
            
            obj.pic_type = 'Corrected';
            
        end
        
        function reset_clb(obj)
            
            set(obj.dpg.hsp1_1,'ButtonDownFcn',@obj.dpg_hsp1_1_clb)
            
            set(obj.dpg.hsp1_2,'ButtonDownFcn',@obj.dpg_hsp1_2_clb)
            
            set(obj.dpg.hsp1_3,'ButtonDownFcn',@obj.dpg_hsp1_3_clb)
            
            set(obj.dpg.edt2_1,'Callback',@obj.dpg_edt2_1_clb)
            set(obj.dpg.edt2_2,'Callback',@obj.dpg_edt2_2_clb)
            set(obj.dpg.edt2_3,'Callback',@obj.dpg_edt2_3_clb)
            set(obj.dpg.edt2_4,'Callback',@obj.dpg_edt2_4_clb)
            set(obj.dpg.edt2_5,'Callback',@obj.dpg_edt2_5_clb)
            
        end
        
        function dpg_hsp1_1_clb(obj,~,~)
            
            obj.pic_type = 'Corrected';
            
        end
        
        function dpg_hsp1_2_clb(obj,~,~)
            
            obj.pic_type = 'Signal';
            
        end
        
        function dpg_hsp1_3_clb(obj,~,~)
            
            obj.pic_type = 'Background';
            
        end
        
        function dpg_edt2_1_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
            end
            
        end
        
        function dpg_edt2_2_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
            end
            
        end
        
        function dpg_edt2_3_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
            end
            
        end
        
        function dpg_edt2_4_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
            end
            
        end
        
        function dpg_edt2_5_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
            end
            
        end
        
        function disp_pic_cor(obj)
            
            %%% disp picture
            
            imagesc(obj.c_size(1):obj.c_size(2),obj.r_size(1):obj.r_size(2),obj.pic_cor,'Parent',obj.dpg.ax1_1);
            
            set(obj.dpg.ax1_1,'NextPlot','add');
            
            rectangle('Position',[obj.pic_props(1).c_roi_ctr-obj.pic_props(1).roi_wth,obj.pic_props(1).r_roi_ctr-obj.pic_props(1).roi_wth,2*obj.pic_props(1).roi_wth+1,2*obj.pic_props(1).roi_wth+1],'EdgeColor','w','Parent',obj.dpg.ax1_1)
            
            plot(obj.pic_props(1).c_roi_ctr,obj.pic_props(1).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax1_1)
            
            caxis(obj.dpg.ax1_1,[obj.pic_props(1).pic_min,obj.pic_props(1).pic_max])
            
            axis(obj.dpg.ax1_1,'image')
            
            set(obj.dpg.ax1_1,'Box','on','Tickdir','out','YDir','normal','XTickLabel',[],'YTickLabel',[],'NextPlot','replace');
            
        end
        
        function disp_pic_at(obj)
            
            %%% disp picture
            
            imagesc(obj.c_size(1):obj.c_size(2),obj.r_size(1):obj.r_size(2),obj.pic_at,'Parent',obj.dpg.ax1_2);
            
            set(obj.dpg.ax1_2,'NextPlot','add');
            
            rectangle('Position',[obj.pic_props(2).c_roi_ctr-obj.pic_props(2).roi_wth,obj.pic_props(2).r_roi_ctr-obj.pic_props(2).roi_wth,2*obj.pic_props(2).roi_wth+1,2*obj.pic_props(2).roi_wth+1],'EdgeColor','w','Parent',obj.dpg.ax1_2)
            
            plot(obj.pic_props(2).c_roi_ctr,obj.pic_props(2).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax1_2)
            
            caxis(obj.dpg.ax1_2,[obj.pic_props(2).pic_min,obj.pic_props(2).pic_max])
            
            axis(obj.dpg.ax1_2,'image')
            
            set(obj.dpg.ax1_2,'Box','on','Tickdir','out','YDir','normal','XTickLabel',[],'YTickLabel',[],'NextPlot','replace');
            
            
        end
        
        function disp_pic_at_bg(obj)
            
            %%% disp picture
            
            imagesc(obj.c_size(1):obj.c_size(2),obj.r_size(1):obj.r_size(2),obj.pic_at_bg,'Parent',obj.dpg.ax1_3);
            
            set(obj.dpg.ax1_3,'NextPlot','add');
            
            rectangle('Position',[obj.pic_props(3).c_roi_ctr-obj.pic_props(3).roi_wth,obj.pic_props(3).r_roi_ctr-obj.pic_props(3).roi_wth,2*obj.pic_props(3).roi_wth+1,2*obj.pic_props(3).roi_wth+1],'EdgeColor','w','Parent',obj.dpg.ax1_3)
            
            plot(obj.pic_props(3).c_roi_ctr,obj.pic_props(3).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax1_3)
            
            caxis(obj.dpg.ax1_3,[obj.pic_props(3).pic_min,obj.pic_props(3).pic_max])
            
            axis(obj.dpg.ax1_3,'image')
            
            set(obj.dpg.ax1_3,'Box','on','Tickdir','out','YDir','normal','XTickLabel',[],'YTickLabel',[],'NextPlot','replace');
            
        end
        
        function postset_pic_type(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    %%% set picture properties values
                    
                    set(obj.dpg.edt2_1,'String',num2str(obj.pic_props(1).pic_min));
                    set(obj.dpg.edt2_2,'String',num2str(obj.pic_props(1).pic_max));
                    set(obj.dpg.edt2_3,'String',num2str(obj.pic_props(1).r_roi_ctr));
                    set(obj.dpg.edt2_4,'String',num2str(obj.pic_props(1).c_roi_ctr));
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(1).roi_wth));
                    
                    %%% 2D profile
                    
                    cur_pic_roi = obj.pic_cor((obj.pic_props(1).r_roi_ctr-obj.pic_props(1).roi_wth):(obj.pic_props(1).r_roi_ctr+obj.pic_props(1).roi_wth),...
                        (obj.pic_props(1).c_roi_ctr-obj.pic_props(1).roi_wth):(obj.pic_props(1).c_roi_ctr+obj.pic_props(1).roi_wth));
                    
                    imagesc((obj.pic_props(1).c_roi_ctr-obj.pic_props(1).roi_wth):(obj.pic_props(1).c_roi_ctr+obj.pic_props(1).roi_wth),...
                        (obj.pic_props(1).r_roi_ctr-obj.pic_props(1).roi_wth):(obj.pic_props(1).r_roi_ctr+obj.pic_props(1).roi_wth),cur_pic_roi,'Parent',obj.dpg.ax2_1);
                    
                    set(obj.dpg.ax2_1,'NextPlot','add');
                    
                    plot(obj.pic_props(1).c_roi_ctr,obj.pic_props(1).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax2_1)
                    
                    xlabel(obj.dpg.ax2_1,'[pixels]')
                    
                    ylabel(obj.dpg.ax2_1,'[pixels]')
                    
                    caxis(obj.dpg.ax2_1,[obj.pic_props(1).pic_min,obj.pic_props(1).pic_max])
                    
                    colorbar('peer',obj.dpg.ax2_1,'location','WestOutside','Position',[0.04,0.461,0.027,0.519])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    set(obj.dpg.ax2_1,'Box','on','YAxisLocation','right','Tickdir','out','YDir','normal','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(1).c_roi_ctr-obj.pic_props(1).roi_wth):(obj.pic_props(1).c_roi_ctr+obj.pic_props(1).roi_wth),sum(cur_pic_roi,1),'Parent',obj.dpg.ax2_2)
                    
                    xlim(obj.dpg.ax2_2,[(obj.pic_props(1).c_roi_ctr-obj.pic_props(1).roi_wth) (obj.pic_props(1).c_roi_ctr+obj.pic_props(1).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_2,'[counts]')
                    
                    set(obj.dpg.ax2_2,'Box','on','XTickLabel',[],'Tickdir','out','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(1).r_roi_ctr-obj.pic_props(1).roi_wth):(obj.pic_props(1).r_roi_ctr+obj.pic_props(1).roi_wth),sum(cur_pic_roi,2),'Parent',obj.dpg.ax2_3)
                    
                    xlim(obj.dpg.ax2_3,[(obj.pic_props(1).r_roi_ctr-obj.pic_props(1).roi_wth) (obj.pic_props(1).r_roi_ctr+obj.pic_props(1).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_3,'[counts]')
                    
                    set(obj.dpg.ax2_3,'Box','on','XTickLabel',[],'Tickdir','out','View',[270 90],'YDir','reverse','NextPlot','replace','FontSize',8);
                    
                    tot_sig = sum(cur_pic_roi(:));
                    
                    set(obj.dpg.txt3_2,'String',num2str(tot_sig));
                    
                case 'Signal'
                    
                    %%% set picture properties values
                    
                    set(obj.dpg.edt2_1,'String',num2str(obj.pic_props(2).pic_min));
                    set(obj.dpg.edt2_2,'String',num2str(obj.pic_props(2).pic_max));
                    set(obj.dpg.edt2_3,'String',num2str(obj.pic_props(2).r_roi_ctr));
                    set(obj.dpg.edt2_4,'String',num2str(obj.pic_props(2).c_roi_ctr));
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(2).roi_wth));
                    
                    %%% 2D profile
                    
                    cur_pic_roi = obj.pic_at((obj.pic_props(2).r_roi_ctr-obj.pic_props(2).roi_wth):(obj.pic_props(2).r_roi_ctr+obj.pic_props(2).roi_wth),...
                        (obj.pic_props(2).c_roi_ctr-obj.pic_props(2).roi_wth):(obj.pic_props(2).c_roi_ctr+obj.pic_props(2).roi_wth));
                    
                    imagesc((obj.pic_props(2).c_roi_ctr-obj.pic_props(2).roi_wth):(obj.pic_props(2).c_roi_ctr+obj.pic_props(2).roi_wth),...
                        (obj.pic_props(2).r_roi_ctr-obj.pic_props(2).roi_wth):(obj.pic_props(2).r_roi_ctr+obj.pic_props(2).roi_wth),cur_pic_roi,'Parent',obj.dpg.ax2_1);
                    
                    set(obj.dpg.ax2_1,'NextPlot','add');
                    
                    plot(obj.pic_props(2).c_roi_ctr,obj.pic_props(2).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax2_1)
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    caxis(obj.dpg.ax2_1,[obj.pic_props(2).pic_min,obj.pic_props(2).pic_max])
                    
                    colorbar('peer',obj.dpg.ax2_1,'location','WestOutside','Position',[0.04,0.461,0.027,0.519])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    set(obj.dpg.ax2_1,'Box','on','YAxisLocation','right','Tickdir','out','YDir','normal','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(2).c_roi_ctr-obj.pic_props(2).roi_wth):(obj.pic_props(2).c_roi_ctr+obj.pic_props(2).roi_wth),sum(cur_pic_roi,1),'Parent',obj.dpg.ax2_2)
                    
                    xlim(obj.dpg.ax2_2,[(obj.pic_props(2).c_roi_ctr-obj.pic_props(2).roi_wth) (obj.pic_props(2).c_roi_ctr+obj.pic_props(2).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_2,'[counts]')
                    
                    set(obj.dpg.ax2_2,'Box','on','XTickLabel',[],'Tickdir','out','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(2).r_roi_ctr-obj.pic_props(2).roi_wth):(obj.pic_props(2).r_roi_ctr+obj.pic_props(2).roi_wth),sum(cur_pic_roi,2),'Parent',obj.dpg.ax2_3)
                    
                    xlim(obj.dpg.ax2_3,[(obj.pic_props(2).r_roi_ctr-obj.pic_props(2).roi_wth) (obj.pic_props(2).r_roi_ctr+obj.pic_props(2).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_3,'[counts]')
                    
                    set(obj.dpg.ax2_3,'Box','on','XTickLabel',[],'Tickdir','out','View',[270 90],'YDir','reverse','NextPlot','replace','FontSize',8);
                    
                case 'Background'
                    
                    %%% set picture properties values
                    
                    set(obj.dpg.edt2_1,'String',num2str(obj.pic_props(3).pic_min));
                    set(obj.dpg.edt2_2,'String',num2str(obj.pic_props(3).pic_max));
                    set(obj.dpg.edt2_3,'String',num2str(obj.pic_props(3).r_roi_ctr));
                    set(obj.dpg.edt2_4,'String',num2str(obj.pic_props(3).c_roi_ctr));
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(3).roi_wth));
                    
                    %%% 2D profile
                    
                    cur_pic_roi = obj.pic_at_bg((obj.pic_props(3).r_roi_ctr-obj.pic_props(3).roi_wth):(obj.pic_props(3).r_roi_ctr+obj.pic_props(3).roi_wth),...
                        (obj.pic_props(3).c_roi_ctr-obj.pic_props(3).roi_wth):(obj.pic_props(3).c_roi_ctr+obj.pic_props(3).roi_wth));
                    
                    imagesc((obj.pic_props(3).c_roi_ctr-obj.pic_props(3).roi_wth):(obj.pic_props(3).c_roi_ctr+obj.pic_props(3).roi_wth),...
                        (obj.pic_props(3).r_roi_ctr-obj.pic_props(3).roi_wth):(obj.pic_props(3).r_roi_ctr+obj.pic_props(3).roi_wth),cur_pic_roi,'Parent',obj.dpg.ax2_1);
                    
                    set(obj.dpg.ax2_1,'NextPlot','add');
                    
                    plot(obj.pic_props(3).c_roi_ctr,obj.pic_props(3).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax2_1)
                    
                    caxis(obj.dpg.ax2_1,[obj.pic_props(3).pic_min,obj.pic_props(3).pic_max])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    colorbar('peer',obj.dpg.ax2_1,'location','WestOutside','Position',[0.04,0.461,0.027,0.519])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    set(obj.dpg.ax2_1,'Box','on','YAxisLocation','right','Tickdir','out','YDir','normal','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(3).c_roi_ctr-obj.pic_props(3).roi_wth):(obj.pic_props(3).c_roi_ctr+obj.pic_props(3).roi_wth),sum(cur_pic_roi,1),'Parent',obj.dpg.ax2_2)
                    
                    xlim(obj.dpg.ax2_2,[(obj.pic_props(3).c_roi_ctr-obj.pic_props(3).roi_wth) (obj.pic_props(3).c_roi_ctr+obj.pic_props(3).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_2,'[counts]')
                    
                    set(obj.dpg.ax2_2,'Box','on','XTickLabel',[],'Tickdir','out','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(3).r_roi_ctr-obj.pic_props(3).roi_wth):(obj.pic_props(3).r_roi_ctr+obj.pic_props(3).roi_wth),sum(cur_pic_roi,2),'Parent',obj.dpg.ax2_3)
                    
                    xlim(obj.dpg.ax2_3,[(obj.pic_props(3).r_roi_ctr-obj.pic_props(3).roi_wth) (obj.pic_props(3).r_roi_ctr+obj.pic_props(3).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_3,'[counts]')
                    
                    set(obj.dpg.ax2_3,'Box','on','XTickLabel',[],'Tickdir','out','View',[270 90],'YDir','reverse','NextPlot','replace','FontSize',8);
                    
            end
            
        end
        
        function postset_pic_props(obj,~,~)
            
            if ~isempty(obj.pic_type)
                
                switch obj.pic_type
                    
                    case 'Corrected'
                        
                        obj.disp_pic_cor;
                        
                    case 'Signal'
                        
                        obj.disp_pic_at;
                        
                    case 'Background'
                        
                        obj.disp_pic_at_bg;
                        
                end
                
                obj.postset_pic_type;
                
            end
            
        end
        
        
        function pic_at = get.pic_at(obj)
            
            path = [obj.pics_path,'\pic_at.mat'];
            
            load(path);
            
        end
        
        function pic_at_bg = get.pic_at_bg(obj)
            
            path = [obj.pics_path,'\pic_at_bg.mat'];
            
            load(path);
            
        end
        
        function pic_cor = get.pic_cor(obj)
            
            if isempty(obj.tmp_pic_cor)
                
                obj.tmp_pic_cor = (double(obj.pic_at) - double(obj.pic_at_bg));
                
            end
            
            pic_cor = obj.tmp_pic_cor;
            
        end
        
        function pic = saveobj(obj)
            
            pic = obj;
            
            pic.lst_pic_type = [];
            
            pic.lst_pic_props = [];
            
            pic.dpg = [];
            
            pic.tmp_pic_cor = [];
            
        end
        
    end
    
    methods (Static = true)
        
        function obj = loadobj(pic)
            
            pic.lst_pic_type = addlistener(pic,'pic_type','PostSet',@pic.postset_pic_type);
            
            pic.lst_pic_props = addlistener(pic,'pic_props','PostSet',@pic.postset_pic_props);
            
            obj = pic;  % return the updated object
            
        end
        
    end
    
end
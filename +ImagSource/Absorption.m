classdef Absorption < handle
    % Generic Imaging source class
    
    properties
        
        pics_path
        
    end
    
    properties (Dependent = true)
        
        pic_at
        pic_wat
        
        pic_at_bg
        pic_wat_bg
        
        pic_cor
        
        pic_sig
        
        pic_bg
        
    end
    
    properties
        
        tmp_pic_cor
        
        tmp_pic_sig
        tmp_pic_bg
        
    end
    
    properties (SetObservable = true)
        
        pic_type
        
        pic_props % picture properties
        
        static_pic_props  % static picture properties
        
    end
    
    properties % listeners
        
        lst_pic_type
        
        lst_pic_props
        
        lst_static_pic_props
        
    end
    
    properties % pics size
        
        r_size = [1 960];
        c_size = [1 1280];
        
    end
    
    properties % GUI
        
        dpg
        
    end
    
    properties % parent Data class
        
        parent
        
    end
    
    methods
        
        function obj = Absorption(pics_path)
            
            obj = obj@handle;
            
            obj.pics_path=pics_path;
            
            % set default picture static properties
            
            obj.static_pic_props.magnification = ImagSource.Default_parameters.magnification;
            
            obj.static_pic_props.r_rbc_ctr = ImagSource.Default_parameters.Absorption_Corrected_r_rbc_ctr;
            obj.static_pic_props.c_rbc_ctr = ImagSource.Default_parameters.Absorption_Corrected_c_rbc_ctr;
            obj.static_pic_props.rbc_wth = ImagSource.Default_parameters.Absorption_Corrected_rbc_wth;
            
            obj.static_pic_props.use_rbc = ImagSource.Default_parameters.Absorption_Corrected_use_rbc;
            
            % set default picture properties
            
            obj.pic_props(1).r_roi_ctr = ImagSource.Default_parameters.Absorption_Corrected_r_roi_ctr;
            obj.pic_props(1).c_roi_ctr = ImagSource.Default_parameters.Absorption_Corrected_c_roi_ctr;
            obj.pic_props(1).roi_wth = ImagSource.Default_parameters.Absorption_Corrected_roi_wth;
            
            obj.pic_props(1).pic_min = ImagSource.Default_parameters.Absorption_Corrected_pic_min ;
            obj.pic_props(1).pic_max = ImagSource.Default_parameters.Absorption_Corrected_pic_max ;
            
            obj.pic_props(2).r_roi_ctr = ImagSource.Default_parameters.Absorption_Signal_r_roi_ctr;
            obj.pic_props(2).c_roi_ctr = ImagSource.Default_parameters.Absorption_Signal_c_roi_ctr;
            obj.pic_props(2).roi_wth = ImagSource.Default_parameters.Absorption_Signal_roi_wth;
            
            obj.pic_props(2).pic_min = ImagSource.Default_parameters.Absorption_Signal_pic_min;
            obj.pic_props(2).pic_max = ImagSource.Default_parameters.Absorption_Signal_pic_max;
            
            obj.pic_props(3).r_roi_ctr = ImagSource.Default_parameters.Absorption_Background_r_roi_ctr;
            obj.pic_props(3).c_roi_ctr = ImagSource.Default_parameters.Absorption_Background_c_roi_ctr;
            obj.pic_props(3).roi_wth = ImagSource.Default_parameters.Absorption_Background_roi_wth;
            
            obj.pic_props(3).pic_min = ImagSource.Default_parameters.Absorption_Background_pic_min ;
            obj.pic_props(3).pic_max = ImagSource.Default_parameters.Absorption_Background_pic_max ;
            
            obj.pic_props(4).r_roi_ctr = ImagSource.Default_parameters.Absorption_pic_at_r_roi_ctr;
            obj.pic_props(4).c_roi_ctr = ImagSource.Default_parameters.Absorption_pic_at_c_roi_ctr;
            obj.pic_props(4).roi_wth = ImagSource.Default_parameters.Absorption_pic_at_roi_wth;
            
            obj.pic_props(4).pic_min = ImagSource.Default_parameters.Absorption_pic_at_pic_min ;
            obj.pic_props(4).pic_max = ImagSource.Default_parameters.Absorption_pic_at_pic_max ;
            
            obj.pic_props(5).r_roi_ctr = ImagSource.Default_parameters.Absorption_pic_at_bg_r_roi_ctr;
            obj.pic_props(5).c_roi_ctr = ImagSource.Default_parameters.Absorption_pic_at_bg_c_roi_ctr;
            obj.pic_props(5).roi_wth = ImagSource.Default_parameters.Absorption_pic_at_bg_roi_wth;
            
            obj.pic_props(5).pic_min = ImagSource.Default_parameters.Absorption_pic_at_bg_pic_min ;
            obj.pic_props(5).pic_max = ImagSource.Default_parameters.Absorption_pic_at_bg_pic_max ;
            
            obj.pic_props(6).r_roi_ctr = ImagSource.Default_parameters.Absorption_pic_wat_r_roi_ctr;
            obj.pic_props(6).c_roi_ctr = ImagSource.Default_parameters.Absorption_pic_wat_c_roi_ctr;
            obj.pic_props(6).roi_wth = ImagSource.Default_parameters.Absorption_pic_wat_roi_wth;
            
            obj.pic_props(6).pic_min = ImagSource.Default_parameters.Absorption_pic_wat_pic_min ;
            obj.pic_props(6).pic_max = ImagSource.Default_parameters.Absorption_pic_wat_pic_max ;
            
            obj.pic_props(7).r_roi_ctr = ImagSource.Default_parameters.Absorption_pic_wat_bg_r_roi_ctr;
            obj.pic_props(7).c_roi_ctr = ImagSource.Default_parameters.Absorption_pic_wat_bg_c_roi_ctr;
            obj.pic_props(7).roi_wth = ImagSource.Default_parameters.Absorption_pic_wat_bg_roi_wth;
            
            obj.pic_props(7).pic_min = ImagSource.Default_parameters.Absorption_pic_wat_bg_pic_min ;
            obj.pic_props(7).pic_max = ImagSource.Default_parameters.Absorption_pic_wat_bg_pic_max ;
            
            
            % initialize listeners
            
            obj.lst_pic_type = addlistener(obj,'pic_type','PostSet',@obj.postset_pic_type);
            
            obj.lst_pic_props = addlistener(obj,'pic_props','PostSet',@obj.postset_pic_props);
            
            obj.lst_static_pic_props = addlistener(obj,'static_pic_props','PostSet',@obj.postset_static_pic_props);
            
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
                r_ofs = 0.03;
                c_wth = 0.98;
                r_wth = 0.98;
                
                obj.dpg.ax1_2 = axes(...
                    'Parent'             ,obj.dpg.hsp1_2 ...
                    ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                c_ofs = 0.005;
                r_ofs = 0.005;
                c_wth = 0.49;
                r_wth = 0.07;
                
                obj.dpg.hsp1_2_1 = uipanel(...
                    'Parent'             ,obj.dpg.hsp1_2 ...
                    ,'Title'              ,'signal' ...
                    ,'TitlePosition'      ,'centertop' ...
                    ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                    ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                    ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                    ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                    ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                    ,'FontSize'           ,10 ...
                    ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                    ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                    ,'SelectionHighlight' ,'on' ...
                    ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                    ,'Selected'           ,'off' ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    ,'ButtonDownFcn'      , @obj.dpg_hsp1_2_1_clb ...
                    );
                
                c_ofs = 0.505;
                r_ofs = 0.005;
                c_wth = 0.49;
                r_wth = 0.07;
                
                obj.dpg.hsp1_2_2 = uipanel(...
                    'Parent'             ,obj.dpg.hsp1_2 ...
                    ,'Title'              ,'background' ...
                    ,'TitlePosition'      ,'centertop' ...
                    ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                    ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                    ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                    ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                    ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                    ,'FontSize'           ,10 ...
                    ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                    ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                    ,'SelectionHighlight' ,'on' ...
                    ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                    ,'Selected'           ,'off' ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    ,'ButtonDownFcn'      , @obj.dpg_hsp1_2_2_clb ...
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
                r_ofs = 0.03;
                c_wth = 0.98;
                r_wth = 0.98;
                
                obj.dpg.ax1_3 = axes(...
                    'Parent'             ,obj.dpg.hsp1_3 ...
                    ,'Units'              ,Treatment.Default_parameters.Axes_Units ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                c_ofs = 0.005;
                r_ofs = 0.005;
                c_wth = 0.49;
                r_wth = 0.07;
                
                obj.dpg.hsp1_3_1 = uipanel(...
                    'Parent'             ,obj.dpg.hsp1_3 ...
                    ,'Title'              ,'signal' ...
                    ,'TitlePosition'      ,'centertop' ...
                    ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                    ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                    ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                    ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                    ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                    ,'FontSize'           ,10 ...
                    ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                    ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                    ,'SelectionHighlight' ,'on' ...
                    ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                    ,'Selected'           ,'off' ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    ,'ButtonDownFcn'      , @obj.dpg_hsp1_3_1_clb ...
                    );
                
                c_ofs = 0.505;
                r_ofs = 0.005;
                c_wth = 0.49;
                r_wth = 0.07;
                
                obj.dpg.hsp1_3_2 = uipanel(...
                    'Parent'             ,obj.dpg.hsp1_3 ...
                    ,'Title'              ,'background' ...
                    ,'TitlePosition'      ,'centertop' ...
                    ,'BackgroundColor'    ,Treatment.Default_parameters.Panel_BackgroundColor ...
                    ,'ForegroundColor'    ,Treatment.Default_parameters.Panel_ForegroundColor ...
                    ,'HighlightColor'     ,Treatment.Default_parameters.Panel_HighlightColor ...
                    ,'ShadowColor'        ,Treatment.Default_parameters.Panel_ShadowColor ...
                    ,'FontName'           ,Treatment.Default_parameters.Panel_FontName ...
                    ,'FontSize'           ,10 ...
                    ,'FontUnits'          ,Treatment.Default_parameters.Panel_FontUnits ...
                    ,'FontWeight'         ,Treatment.Default_parameters.Panel_FontWeight ...
                    ,'SelectionHighlight' ,'on' ...
                    ,'Units'              ,Treatment.Default_parameters.Panel_Units ...
                    ,'Selected'           ,'off' ...
                    ,'Position'           ,[c_ofs r_ofs c_wth r_wth] ...
                    ,'ButtonDownFcn'      , @obj.dpg_hsp1_3_2_clb ...
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
                
                c_ofs = 0.62;
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
                
                c_ofs = 0.62;
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
                
                c_ofs = 0.685;
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
                
                c_ofs = 0.62;
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
                
                c_ofs = 0.685;
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
                
                c_ofs = 0.62;
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
                
                c_ofs = 0.62;
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
                
                c_ofs = 0.71;
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
                
                c_ofs = 0.62;
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
                
                c_ofs = 0.71;
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
                
                c_ofs = 0.62;
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
                
                c_ofs = 0.71;
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
                
                %%% set background correction
                
                % Text
                
                c_ofs = 0.82;
                r_ofs = 0.215;
                c_wth = 0.14;
                r_wth = 0.02;
                
                obj.dpg.txt2_7 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Background corr.' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Checkbox
                
                c_ofs = 0.97;
                r_ofs = 0.215;
                c_wth = 0.02;
                r_wth = 0.02;
                
                obj.dpg.ckb2_1 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'checkbox' ...
                    ,'Units'                ,Treatment.Default_parameters.Checkbox_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    ,'Callback'             ,@obj.dpg_ckb2_1_clb ...
                    );
                
                % Text
                
                c_ofs = 0.82;
                r_ofs = 0.17;
                c_wth = 0.08;
                r_wth = 0.02;
                
                obj.dpg.txt2_8 = uicontrol(...
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
                
                c_ofs = 0.91;
                r_ofs = 0.166;
                c_wth = 0.06;
                r_wth = 0.03;
                
                obj.dpg.edt2_6 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'edit' ...
                    ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                    ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                    ,'Callback'             ,@obj.dpg_edt2_6_clb ...
                    );
                
                % Text
                
                c_ofs = 0.82;
                r_ofs = 0.12;
                c_wth = 0.08;
                r_wth = 0.02;
                
                obj.dpg.txt2_9 = uicontrol(...
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
                
                c_ofs = 0.91;
                r_ofs = 0.116;
                c_wth = 0.06;
                r_wth = 0.03;
                
                obj.dpg.edt2_7 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'edit' ...
                    ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                    ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                    ,'Callback'             ,@obj.dpg_edt2_7_clb ...
                    );
                
                % Text
                
                c_ofs = 0.82;
                r_ofs = 0.07;
                c_wth = 0.08;
                r_wth = 0.02;
                
                obj.dpg.txt2_10 = uicontrol(...
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
                
                c_ofs = 0.91;
                r_ofs = 0.070;
                c_wth = 0.06;
                r_wth = 0.03;
                
                obj.dpg.edt2_8 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'edit' ...
                    ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                    ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                    ,'Callback'             ,@obj.dpg_edt2_8_clb ...
                    );
                
                % Text
                
                c_ofs = 0.79;
                r_ofs = 0.27;
                c_wth = 0.1;
                r_wth = 0.02;
                
                obj.dpg.txt2_11 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'text' ...
                    ,'String'               ,'Magnification' ...
                    ,'FontName'             ,Treatment.Default_parameters.Text_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Text_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Text_FontUnits ...
                    ,'FontWeight'           ,Treatment.Default_parameters.Text_FontWeight ...
                    ,'HorizontalAlignment'  ,'left' ...
                    ,'Units'                ,Treatment.Default_parameters.Text_Units ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth] ...
                    );
                
                % Edit
                
                c_ofs = 0.91;
                r_ofs = 0.265;
                c_wth = 0.06;
                r_wth = 0.03;
                
                obj.dpg.edt2_9 = uicontrol(...
                    'Parent'               ,obj.dpg.hsp2 ...
                    ,'Style'                ,'edit' ...
                    ,'Units'                ,Treatment.Default_parameters.Edit_Units ...
                    ,'FontName'             ,Treatment.Default_parameters.Edit_FontName ...
                    ,'FontSize'             ,Treatment.Default_parameters.Edit_FontSize ...
                    ,'FontUnits'            ,Treatment.Default_parameters.Edit_FontUnits ...
                    ,'FontWeight'           ,'normal' ...
                    ,'Position'             ,[c_ofs r_ofs c_wth r_wth]...
                    ,'Callback'             ,@obj.dpg_edt2_9_clb ...
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
                c_wth = 0.3;
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
            
            obj.disp_pic_sig;
            
            obj.disp_pic_bg;
            
            obj.pic_type = 'Corrected';
            
        end
        
        function reset_clb(obj)
            
            set(obj.dpg.hsp1_1,'ButtonDownFcn',@obj.dpg_hsp1_1_clb)
            
            set(obj.dpg.hsp1_2,'ButtonDownFcn',@obj.dpg_hsp1_2_clb)
            
            set(obj.dpg.hsp1_2_1,'ButtonDownFcn',@obj.dpg_hsp1_2_1_clb)
            set(obj.dpg.hsp1_2_2,'ButtonDownFcn',@obj.dpg_hsp1_2_2_clb)
            
            set(obj.dpg.hsp1_3,'ButtonDownFcn',@obj.dpg_hsp1_3_clb)
            
            set(obj.dpg.hsp1_3_1,'ButtonDownFcn',@obj.dpg_hsp1_3_1_clb)
            set(obj.dpg.hsp1_3_2,'ButtonDownFcn',@obj.dpg_hsp1_3_2_clb)
            
            set(obj.dpg.edt2_1,'Callback',@obj.dpg_edt2_1_clb)
            set(obj.dpg.edt2_2,'Callback',@obj.dpg_edt2_2_clb)
            set(obj.dpg.edt2_3,'Callback',@obj.dpg_edt2_3_clb)
            set(obj.dpg.edt2_4,'Callback',@obj.dpg_edt2_4_clb)
            set(obj.dpg.edt2_5,'Callback',@obj.dpg_edt2_5_clb)
            set(obj.dpg.edt2_6,'Callback',@obj.dpg_edt2_6_clb)
            set(obj.dpg.edt2_7,'Callback',@obj.dpg_edt2_7_clb)
            set(obj.dpg.edt2_8,'Callback',@obj.dpg_edt2_8_clb)
            set(obj.dpg.edt2_9,'Callback',@obj.dpg_edt2_9_clb)
            
            set(obj.dpg.ckb2_1,'Callback',@obj.dpg_ckb2_1_clb)
            
        end
        
        function dpg_hsp1_1_clb(obj,~,~)
            
            obj.pic_type = 'Corrected';
            
        end
        
        function dpg_hsp1_2_clb(obj,~,~)
            
            obj.pic_type = 'Signal';
            
        end
        
        function dpg_hsp1_2_1_clb(obj,~,~)
            
            obj.pic_type = 'pic_at';
            
        end
        
        function dpg_hsp1_2_2_clb(obj,~,~)
            
            obj.pic_type = 'pic_at_bg';
            
        end
        
        function dpg_hsp1_3_clb(obj,~,~)
            
            obj.pic_type = 'Background';
            
        end
        
        function dpg_hsp1_3_1_clb(obj,~,~)
            
            obj.pic_type = 'pic_wat';
            
        end
        
        function dpg_hsp1_3_2_clb(obj,~,~)
            
            obj.pic_type = 'pic_wat_bg';
            
        end
        
        function dpg_edt2_1_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
                case 'pic_at'
                    
                    obj.pic_props(4).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
                case 'pic_at_bg'
                    
                    obj.pic_props(5).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
                case 'pic_wat'
                    
                    obj.pic_props(6).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
                case 'pic_wat_bg'
                    
                    obj.pic_props(7).pic_min = str2double(get(obj.dpg.edt2_1,'String'));
                    
            end
            
        end
        
        function dpg_edt2_2_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
                case 'pic_at'
                    
                    obj.pic_props(4).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
                case 'pic_at_bg'
                    
                    obj.pic_props(5).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
                case 'pic_wat'
                    
                    obj.pic_props(6).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
                case 'pic_wat_bg'
                    
                    obj.pic_props(7).pic_max = str2double(get(obj.dpg.edt2_2,'String'));
                    
            end
            
        end
        
        function dpg_edt2_3_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
                case 'pic_at'
                    
                    obj.pic_props(4).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
                case 'pic_at_bg'
                    
                    obj.pic_props(5).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
                case 'pic_wat'
                    
                    obj.pic_props(6).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
                case 'pic_wat_bg'
                    
                    obj.pic_props(7).r_roi_ctr = str2double(get(obj.dpg.edt2_3,'String'));
                    
            end
            
        end
        
        function dpg_edt2_4_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
                case 'pic_at'
                    
                    obj.pic_props(4).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
                case 'pic_at_bg'
                    
                    obj.pic_props(5).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
                case 'pic_wat'
                    
                    obj.pic_props(6).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
                case 'pic_wat_bg'
                    
                    obj.pic_props(7).c_roi_ctr = str2double(get(obj.dpg.edt2_4,'String'));
                    
            end
            
        end
        
        function dpg_edt2_5_clb(obj,~,~)
            
            switch obj.pic_type
                
                case 'Corrected'
                    
                    obj.pic_props(1).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
                case 'Signal'
                    
                    obj.pic_props(2).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
                case 'pic_at'
                    
                    obj.pic_props(4).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
                case 'pic_at_bg'
                    
                    obj.pic_props(5).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
                case 'Background'
                    
                    obj.pic_props(3).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
                case 'pic_wat'
                    
                    obj.pic_props(6).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
                case 'pic_wat_bg'
                    
                    obj.pic_props(7).roi_wth = str2double(get(obj.dpg.edt2_5,'String'));
                    
            end
            
        end
        
        function dpg_edt2_6_clb(obj,~,~)
            
            obj.static_pic_props.r_rbc_ctr = str2double(get(obj.dpg.edt2_6,'String'));
            
        end
        
        function dpg_edt2_7_clb(obj,~,~)
            
            obj.static_pic_props.c_rbc_ctr = str2double(get(obj.dpg.edt2_7,'String'));
            
        end
        
        function dpg_edt2_8_clb(obj,~,~)
            
            obj.static_pic_props.rbc_wth = str2double(get(obj.dpg.edt2_8,'String'));
            
        end
        
        function dpg_edt2_9_clb(obj,~,~)
            
            obj.static_pic_props.magnification = str2double(get(obj.dpg.edt2_9,'String'));
            
        end
        
        function dpg_ckb2_1_clb(obj,~,~)
            
            obj.static_pic_props.use_rbc = get(obj.dpg.ckb2_1,'Value');
            
        end

        function disp_pic_cor(obj)
            
            %%% disp picture
            
            imagesc(obj.c_size(1):obj.c_size(2),obj.r_size(1):obj.r_size(2),obj.pic_cor,'Parent',obj.dpg.ax1_1);
            
            set(obj.dpg.ax1_1,'NextPlot','add');
            
            rectangle('Position',[obj.pic_props(1).c_roi_ctr-obj.pic_props(1).roi_wth,obj.pic_props(1).r_roi_ctr-obj.pic_props(1).roi_wth,2*obj.pic_props(1).roi_wth+1,2*obj.pic_props(1).roi_wth+1],'EdgeColor','w','Parent',obj.dpg.ax1_1)
            
            rectangle('Position',[obj.static_pic_props.c_rbc_ctr-obj.static_pic_props.rbc_wth,obj.static_pic_props.r_rbc_ctr-obj.static_pic_props.rbc_wth,2*obj.static_pic_props.rbc_wth+1,2*obj.static_pic_props.rbc_wth+1],'EdgeColor','r','Parent',obj.dpg.ax1_1)
            
            plot(obj.pic_props(1).c_roi_ctr,obj.pic_props(1).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax1_1)
            
            plot(obj.static_pic_props.c_rbc_ctr,obj.static_pic_props.r_rbc_ctr,'r+','LineWidth',1,'MarkerSize',8,'Parent',obj.dpg.ax1_1)
            
            caxis(obj.dpg.ax1_1,[obj.pic_props(1).pic_min,obj.pic_props(1).pic_max])
            
            axis(obj.dpg.ax1_1,'image')
            
            set(obj.dpg.ax1_1,'Box','on','Tickdir','out','YDir','normal','XTickLabel',[],'YTickLabel',[],'NextPlot','replace');
            
        end
        
        function disp_pic_sig(obj)
            
            %%% disp picture
            
            imagesc(obj.c_size(1):obj.c_size(2),obj.r_size(1):obj.r_size(2),obj.pic_sig,'Parent',obj.dpg.ax1_2);
            
            set(obj.dpg.ax1_2,'NextPlot','add');
            
            rectangle('Position',[obj.pic_props(2).c_roi_ctr-obj.pic_props(2).roi_wth,obj.pic_props(2).r_roi_ctr-obj.pic_props(2).roi_wth,2*obj.pic_props(2).roi_wth+1,2*obj.pic_props(2).roi_wth+1],'EdgeColor','w','Parent',obj.dpg.ax1_2)
            
            plot(obj.pic_props(2).c_roi_ctr,obj.pic_props(2).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax1_2)
            
            caxis(obj.dpg.ax1_2,[obj.pic_props(2).pic_min,obj.pic_props(2).pic_max])
            
            axis(obj.dpg.ax1_2,'image')
            
            set(obj.dpg.ax1_2,'Box','on','Tickdir','out','YDir','normal','XTickLabel',[],'YTickLabel',[],'NextPlot','replace');
            
            
        end
        
        function disp_pic_bg(obj)
            
            %%% disp picture
            
            imagesc(obj.c_size(1):obj.c_size(2),obj.r_size(1):obj.r_size(2),obj.pic_bg,'Parent',obj.dpg.ax1_3);
            
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
                    set(obj.dpg.ckb2_1,'Value',obj.static_pic_props.use_rbc);
                    set(obj.dpg.edt2_6,'String',num2str(obj.static_pic_props.r_rbc_ctr));
                    set(obj.dpg.edt2_7,'String',num2str(obj.static_pic_props.c_rbc_ctr));
                    set(obj.dpg.edt2_8,'String',num2str(obj.static_pic_props.rbc_wth));
                    
                    set(obj.dpg.edt2_9,'Enable','on');
                    set(obj.dpg.edt2_9,'String',num2str(obj.static_pic_props.magnification));
                    
                    if obj.static_pic_props.use_rbc
                        
                        set(obj.dpg.edt2_6,'Enable','on');
                        set(obj.dpg.edt2_7,'Enable','on');
                        set(obj.dpg.edt2_8,'Enable','on');
                        
                    else
                        
                        set(obj.dpg.edt2_6,'Enable','off');
                        set(obj.dpg.edt2_7,'Enable','off');
                        set(obj.dpg.edt2_8,'Enable','off');
                        
                    end
                    
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
                    
                    set(obj.dpg.txt3_2,'String',sprintf('%0.5e',tot_sig));
                    
                case 'Signal'
                    
                    %%% set picture properties values
                    
                    set(obj.dpg.edt2_1,'String',num2str(obj.pic_props(2).pic_min));
                    set(obj.dpg.edt2_2,'String',num2str(obj.pic_props(2).pic_max));
                    set(obj.dpg.edt2_3,'String',num2str(obj.pic_props(2).r_roi_ctr));
                    set(obj.dpg.edt2_4,'String',num2str(obj.pic_props(2).c_roi_ctr));
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(2).roi_wth));
                    set(obj.dpg.edt2_6,'Enable','off');
                    set(obj.dpg.edt2_7,'Enable','off');
                    set(obj.dpg.edt2_8,'Enable','off');
                    set(obj.dpg.edt2_9,'Enable','off');
                    
                    %%% 2D profile
                    
                    cur_pic_roi = obj.pic_sig((obj.pic_props(2).r_roi_ctr-obj.pic_props(2).roi_wth):(obj.pic_props(2).r_roi_ctr+obj.pic_props(2).roi_wth),...
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
                    
                case 'pic_at'
                    
                    %%% set picture properties values
                    
                    set(obj.dpg.edt2_1,'String',num2str(obj.pic_props(4).pic_min));
                    set(obj.dpg.edt2_2,'String',num2str(obj.pic_props(4).pic_max));
                    set(obj.dpg.edt2_3,'String',num2str(obj.pic_props(4).r_roi_ctr));
                    set(obj.dpg.edt2_4,'String',num2str(obj.pic_props(4).c_roi_ctr));
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(4).roi_wth));
                    set(obj.dpg.edt2_6,'Enable','off');
                    set(obj.dpg.edt2_7,'Enable','off');
                    set(obj.dpg.edt2_8,'Enable','off');
                    set(obj.dpg.edt2_9,'Enable','off');
                    
                    %%% 2D profile
                    
                    cur_pic_roi = obj.pic_at((obj.pic_props(4).r_roi_ctr-obj.pic_props(4).roi_wth):(obj.pic_props(4).r_roi_ctr+obj.pic_props(4).roi_wth),...
                        (obj.pic_props(4).c_roi_ctr-obj.pic_props(4).roi_wth):(obj.pic_props(4).c_roi_ctr+obj.pic_props(4).roi_wth));
                    
                    imagesc((obj.pic_props(4).c_roi_ctr-obj.pic_props(4).roi_wth):(obj.pic_props(4).c_roi_ctr+obj.pic_props(4).roi_wth),...
                        (obj.pic_props(4).r_roi_ctr-obj.pic_props(4).roi_wth):(obj.pic_props(4).r_roi_ctr+obj.pic_props(4).roi_wth),cur_pic_roi,'Parent',obj.dpg.ax2_1);
                    
                    set(obj.dpg.ax2_1,'NextPlot','add');
                    
                    plot(obj.pic_props(4).c_roi_ctr,obj.pic_props(4).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax2_1)
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    caxis(obj.dpg.ax2_1,[obj.pic_props(4).pic_min,obj.pic_props(4).pic_max])
                    
                    colorbar('peer',obj.dpg.ax2_1,'location','WestOutside','Position',[0.04,0.461,0.027,0.519])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    set(obj.dpg.ax2_1,'Box','on','YAxisLocation','right','Tickdir','out','YDir','normal','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(4).c_roi_ctr-obj.pic_props(4).roi_wth):(obj.pic_props(4).c_roi_ctr+obj.pic_props(4).roi_wth),sum(cur_pic_roi,1),'Parent',obj.dpg.ax2_2)
                    
                    xlim(obj.dpg.ax2_2,[(obj.pic_props(4).c_roi_ctr-obj.pic_props(4).roi_wth) (obj.pic_props(4).c_roi_ctr+obj.pic_props(4).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_2,'[counts]')
                    
                    set(obj.dpg.ax2_2,'Box','on','XTickLabel',[],'Tickdir','out','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(4).r_roi_ctr-obj.pic_props(4).roi_wth):(obj.pic_props(4).r_roi_ctr+obj.pic_props(4).roi_wth),sum(cur_pic_roi,2),'Parent',obj.dpg.ax2_3)
                    
                    xlim(obj.dpg.ax2_3,[(obj.pic_props(4).r_roi_ctr-obj.pic_props(4).roi_wth) (obj.pic_props(4).r_roi_ctr+obj.pic_props(4).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_3,'[counts]')
                    
                    set(obj.dpg.ax2_3,'Box','on','XTickLabel',[],'Tickdir','out','View',[270 90],'YDir','reverse','NextPlot','replace','FontSize',8);
                    
                case 'pic_at_bg'
                    
                    %%% set picture properties values
                    
                    set(obj.dpg.edt2_1,'String',num2str(obj.pic_props(5).pic_min));
                    set(obj.dpg.edt2_2,'String',num2str(obj.pic_props(5).pic_max));
                    set(obj.dpg.edt2_3,'String',num2str(obj.pic_props(5).r_roi_ctr));
                    set(obj.dpg.edt2_4,'String',num2str(obj.pic_props(5).c_roi_ctr));
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(5).roi_wth));
                    set(obj.dpg.edt2_6,'Enable','off');
                    set(obj.dpg.edt2_7,'Enable','off');
                    set(obj.dpg.edt2_8,'Enable','off');
                    set(obj.dpg.edt2_9,'Enable','off');
                    
                    %%% 2D profile
                    
                    cur_pic_roi = obj.pic_at_bg((obj.pic_props(5).r_roi_ctr-obj.pic_props(5).roi_wth):(obj.pic_props(5).r_roi_ctr+obj.pic_props(5).roi_wth),...
                        (obj.pic_props(5).c_roi_ctr-obj.pic_props(5).roi_wth):(obj.pic_props(5).c_roi_ctr+obj.pic_props(5).roi_wth));
                    
                    imagesc((obj.pic_props(5).c_roi_ctr-obj.pic_props(5).roi_wth):(obj.pic_props(5).c_roi_ctr+obj.pic_props(5).roi_wth),...
                        (obj.pic_props(5).r_roi_ctr-obj.pic_props(5).roi_wth):(obj.pic_props(5).r_roi_ctr+obj.pic_props(5).roi_wth),cur_pic_roi,'Parent',obj.dpg.ax2_1);
                    
                    set(obj.dpg.ax2_1,'NextPlot','add');
                    
                    plot(obj.pic_props(5).c_roi_ctr,obj.pic_props(5).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax2_1)
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    caxis(obj.dpg.ax2_1,[obj.pic_props(5).pic_min,obj.pic_props(5).pic_max])
                    
                    colorbar('peer',obj.dpg.ax2_1,'location','WestOutside','Position',[0.04,0.461,0.027,0.519])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    set(obj.dpg.ax2_1,'Box','on','YAxisLocation','right','Tickdir','out','YDir','normal','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(5).c_roi_ctr-obj.pic_props(5).roi_wth):(obj.pic_props(5).c_roi_ctr+obj.pic_props(5).roi_wth),sum(cur_pic_roi,1),'Parent',obj.dpg.ax2_2)
                    
                    xlim(obj.dpg.ax2_2,[(obj.pic_props(5).c_roi_ctr-obj.pic_props(5).roi_wth) (obj.pic_props(5).c_roi_ctr+obj.pic_props(5).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_2,'[counts]')
                    
                    set(obj.dpg.ax2_2,'Box','on','XTickLabel',[],'Tickdir','out','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(5).r_roi_ctr-obj.pic_props(5).roi_wth):(obj.pic_props(5).r_roi_ctr+obj.pic_props(5).roi_wth),sum(cur_pic_roi,2),'Parent',obj.dpg.ax2_3)
                    
                    xlim(obj.dpg.ax2_3,[(obj.pic_props(5).r_roi_ctr-obj.pic_props(5).roi_wth) (obj.pic_props(5).r_roi_ctr+obj.pic_props(5).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_3,'[counts]')
                    
                    set(obj.dpg.ax2_3,'Box','on','XTickLabel',[],'Tickdir','out','View',[270 90],'YDir','reverse','NextPlot','replace','FontSize',8);
                    
                case 'Background'
                    
                    %%% set picture properties values
                    
                    set(obj.dpg.edt2_1,'String',num2str(obj.pic_props(3).pic_min));
                    set(obj.dpg.edt2_2,'String',num2str(obj.pic_props(3).pic_max));
                    set(obj.dpg.edt2_3,'String',num2str(obj.pic_props(3).r_roi_ctr));
                    set(obj.dpg.edt2_4,'String',num2str(obj.pic_props(3).c_roi_ctr));
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(3).roi_wth));
                    set(obj.dpg.edt2_6,'Enable','off');
                    set(obj.dpg.edt2_7,'Enable','off');
                    set(obj.dpg.edt2_8,'Enable','off');
                    set(obj.dpg.edt2_9,'Enable','off');
                    
                    %%% 2D profile
                    
                    cur_pic_roi = obj.pic_bg((obj.pic_props(3).r_roi_ctr-obj.pic_props(3).roi_wth):(obj.pic_props(3).r_roi_ctr+obj.pic_props(3).roi_wth),...
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
                    
                case 'pic_wat'
                    
                    %%% set picture properties values
                    
                    set(obj.dpg.edt2_1,'String',num2str(obj.pic_props(6).pic_min));
                    set(obj.dpg.edt2_2,'String',num2str(obj.pic_props(6).pic_max));
                    set(obj.dpg.edt2_3,'String',num2str(obj.pic_props(6).r_roi_ctr));
                    set(obj.dpg.edt2_4,'String',num2str(obj.pic_props(6).c_roi_ctr));
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(6).roi_wth));
                    set(obj.dpg.edt2_6,'Enable','off');
                    set(obj.dpg.edt2_7,'Enable','off');
                    set(obj.dpg.edt2_8,'Enable','off');
                    set(obj.dpg.edt2_9,'Enable','off');
                    
                    %%% 2D profile
                    
                    cur_pic_roi = obj.pic_wat((obj.pic_props(6).r_roi_ctr-obj.pic_props(6).roi_wth):(obj.pic_props(6).r_roi_ctr+obj.pic_props(6).roi_wth),...
                        (obj.pic_props(6).c_roi_ctr-obj.pic_props(6).roi_wth):(obj.pic_props(6).c_roi_ctr+obj.pic_props(6).roi_wth));
                    
                    imagesc((obj.pic_props(6).c_roi_ctr-obj.pic_props(6).roi_wth):(obj.pic_props(6).c_roi_ctr+obj.pic_props(6).roi_wth),...
                        (obj.pic_props(6).r_roi_ctr-obj.pic_props(6).roi_wth):(obj.pic_props(6).r_roi_ctr+obj.pic_props(6).roi_wth),cur_pic_roi,'Parent',obj.dpg.ax2_1);
                    
                    set(obj.dpg.ax2_1,'NextPlot','add');
                    
                    plot(obj.pic_props(6).c_roi_ctr,obj.pic_props(6).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax2_1)
                    
                    caxis(obj.dpg.ax2_1,[obj.pic_props(6).pic_min,obj.pic_props(6).pic_max])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    colorbar('peer',obj.dpg.ax2_1,'location','WestOutside','Position',[0.04,0.461,0.027,0.519])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    set(obj.dpg.ax2_1,'Box','on','YAxisLocation','right','Tickdir','out','YDir','normal','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(6).c_roi_ctr-obj.pic_props(6).roi_wth):(obj.pic_props(6).c_roi_ctr+obj.pic_props(6).roi_wth),sum(cur_pic_roi,1),'Parent',obj.dpg.ax2_2)
                    
                    xlim(obj.dpg.ax2_2,[(obj.pic_props(6).c_roi_ctr-obj.pic_props(6).roi_wth) (obj.pic_props(6).c_roi_ctr+obj.pic_props(6).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_2,'[counts]')
                    
                    set(obj.dpg.ax2_2,'Box','on','XTickLabel',[],'Tickdir','out','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(6).r_roi_ctr-obj.pic_props(6).roi_wth):(obj.pic_props(6).r_roi_ctr+obj.pic_props(6).roi_wth),sum(cur_pic_roi,2),'Parent',obj.dpg.ax2_3)
                    
                    xlim(obj.dpg.ax2_3,[(obj.pic_props(6).r_roi_ctr-obj.pic_props(6).roi_wth) (obj.pic_props(6).r_roi_ctr+obj.pic_props(6).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_3,'[counts]')
                    
                    set(obj.dpg.ax2_3,'Box','on','XTickLabel',[],'Tickdir','out','View',[270 90],'YDir','reverse','NextPlot','replace','FontSize',8);
                    
                case 'pic_wat_bg'
                    
                    %%% set picture properties values
                    
                    set(obj.dpg.edt2_1,'String',num2str(obj.pic_props(7).pic_min));
                    set(obj.dpg.edt2_2,'String',num2str(obj.pic_props(7).pic_max));
                    set(obj.dpg.edt2_3,'String',num2str(obj.pic_props(7).r_roi_ctr));
                    set(obj.dpg.edt2_4,'String',num2str(obj.pic_props(7).c_roi_ctr));
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(7).roi_wth));
                    set(obj.dpg.edt2_6,'Enable','off');
                    set(obj.dpg.edt2_7,'Enable','off');
                    set(obj.dpg.edt2_8,'Enable','off');
                    set(obj.dpg.edt2_9,'Enable','off');
                    
                    %%% 2D profile
                    
                    cur_pic_roi = obj.pic_wat_bg((obj.pic_props(7).r_roi_ctr-obj.pic_props(7).roi_wth):(obj.pic_props(7).r_roi_ctr+obj.pic_props(7).roi_wth),...
                        (obj.pic_props(7).c_roi_ctr-obj.pic_props(7).roi_wth):(obj.pic_props(7).c_roi_ctr+obj.pic_props(7).roi_wth));
                    
                    imagesc((obj.pic_props(7).c_roi_ctr-obj.pic_props(7).roi_wth):(obj.pic_props(7).c_roi_ctr+obj.pic_props(7).roi_wth),...
                        (obj.pic_props(7).r_roi_ctr-obj.pic_props(7).roi_wth):(obj.pic_props(7).r_roi_ctr+obj.pic_props(7).roi_wth),cur_pic_roi,'Parent',obj.dpg.ax2_1);
                    
                    set(obj.dpg.ax2_1,'NextPlot','add');
                    
                    plot(obj.pic_props(7).c_roi_ctr,obj.pic_props(7).r_roi_ctr,'w+','LineWidth',1,'MarkerSize',10,'Parent',obj.dpg.ax2_1)
                    
                    caxis(obj.dpg.ax2_1,[obj.pic_props(7).pic_min,obj.pic_props(7).pic_max])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    colorbar('peer',obj.dpg.ax2_1,'location','WestOutside','Position',[0.04,0.461,0.027,0.519])
                    
                    axis(obj.dpg.ax2_1,'image')
                    
                    set(obj.dpg.ax2_1,'Box','on','YAxisLocation','right','Tickdir','out','YDir','normal','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(7).c_roi_ctr-obj.pic_props(7).roi_wth):(obj.pic_props(7).c_roi_ctr+obj.pic_props(7).roi_wth),sum(cur_pic_roi,1),'Parent',obj.dpg.ax2_2)
                    
                    xlim(obj.dpg.ax2_2,[(obj.pic_props(7).c_roi_ctr-obj.pic_props(7).roi_wth) (obj.pic_props(7).c_roi_ctr+obj.pic_props(7).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_2,'[counts]')
                    
                    set(obj.dpg.ax2_2,'Box','on','XTickLabel',[],'Tickdir','out','NextPlot','replace','FontSize',8);
                    
                    %%% disp picture
                    
                    plot((obj.pic_props(7).r_roi_ctr-obj.pic_props(7).roi_wth):(obj.pic_props(7).r_roi_ctr+obj.pic_props(7).roi_wth),sum(cur_pic_roi,2),'Parent',obj.dpg.ax2_3)
                    
                    xlim(obj.dpg.ax2_3,[(obj.pic_props(7).r_roi_ctr-obj.pic_props(7).roi_wth) (obj.pic_props(7).r_roi_ctr+obj.pic_props(7).roi_wth)])
                    
                    ylabel(obj.dpg.ax2_3,'[counts]')
                    
                    set(obj.dpg.ax2_3,'Box','on','XTickLabel',[],'Tickdir','out','View',[270 90],'YDir','reverse','NextPlot','replace','FontSize',8);
                    
            end
            
        end
        
        function postset_pic_props(obj,~,~)

            if ~isempty(obj.pic_type)
                
                % check properties boundaries and correct if needed
                
                switch obj.pic_type
                    
                    case 'Corrected'
                        
                        ind = 1;
                        
                    case 'Signal'
                        
                        ind = 2;
                        
                    case 'Background'
                        
                        ind = 3;
                        
                    case 'pic_at'
                        
                        ind = 4;
                        
                    case 'pic_at_bg'
                        
                        ind = 5;
                        
                    case 'pic_wat'
                        
                        ind = 6;
                        
                    case 'pic_wat_bg'
                        
                        ind = 7;
                        
                end
                
                if ((obj.pic_props(ind).c_roi_ctr+obj.pic_props(ind).roi_wth)>obj.c_size(2) )|| ...
                        ((obj.pic_props(ind).c_roi_ctr-obj.pic_props(ind).roi_wth)<obj.c_size(1) )
                    
                    obj.pic_props(ind).roi_wth = min(obj.c_size(2)-obj.pic_props(ind).c_roi_ctr, ...
                        obj.pic_props(ind).c_roi_ctr-obj.c_size(1));
                    
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(ind).roi_wth));
                    
                end
                
                if ((obj.pic_props(ind).r_roi_ctr+obj.pic_props(ind).roi_wth)>obj.r_size(2) )|| ...
                        ((obj.pic_props(ind).r_roi_ctr-obj.pic_props(ind).roi_wth)<obj.r_size(1) )
                    
                    obj.pic_props(ind).roi_wth = min(obj.r_size(2)-obj.pic_props(ind).r_roi_ctr, ...
                        obj.pic_props(ind).r_roi_ctr-obj.r_size(1));
                    
                    set(obj.dpg.edt2_5,'String',num2str(obj.pic_props(ind).roi_wth));
                    
                end
                
                % display pictures
                
                if ~isempty(obj.dpg)&&ishandle(obj.dpg.h)
                    
                    switch obj.pic_type
                        
                        case 'Corrected'
                            
                            obj.disp_pic_cor;
                            
                        case 'Signal'
                            
                            obj.disp_pic_sig;
                            
                        case 'Background'
                            
                            obj.disp_pic_bg;
                            
                    end
                    
                    obj.postset_pic_type;
                    
                end
                
            end
            
        end
        
        function postset_static_pic_props(obj,~,~)
            
            if ~isempty(obj.pic_type)

                % reset corrected picture
                
                obj.tmp_pic_cor = [];
                
                % reset display
                
                if ~isempty(obj.dpg)&&ishandle(obj.dpg.h)
                    
                    if ((obj.static_pic_props.c_rbc_ctr+obj.static_pic_props.rbc_wth)>obj.c_size(2) )|| ...
                            ((obj.static_pic_props.c_rbc_ctr-obj.static_pic_props.rbc_wth)<obj.c_size(1) )
                        
                        obj.static_pic_props.rbc_wth = min(obj.c_size(2)-obj.static_pic_props.c_rbc_ctr, ...
                            obj.static_pic_props.c_rbc_ctr-obj.c_size(1));
                        
                        set(obj.dpg.edt2_8,'String',num2str(obj.static_pic_props.rbc_wth));
                        
                    end
                    
                    if ((obj.static_pic_props.r_rbc_ctr+obj.static_pic_props.rbc_wth)>obj.r_size(2) )|| ...
                            ((obj.static_pic_props.r_rbc_ctr-obj.static_pic_props.rbc_wth)<obj.r_size(1) )
                        
                        obj.static_pic_props.rbc_wth = min(obj.r_size(2)-obj.static_pic_props.r_rbc_ctr, ...
                            obj.static_pic_props.r_rbc_ctr-obj.r_size(1));
                        
                        set(obj.dpg.edt2_8,'String',num2str(obj.static_pic_props.rbc_wth));
                        
                    end
                    
                    obj.disp_pic_cor;
                    
                    obj.postset_pic_type;
                    
                end
                
            end
            
        end
        
        
        function pic_at = get.pic_at(obj)
            
            path = [obj.pics_path,'/pic_at.mat'];
            
            load(path);
            
        end
        
        function pic_wat = get.pic_wat(obj)
            
            path = [obj.pics_path,'/pic_wat.mat'];
            
            load(path);
            
        end
        
        function pic_at_bg = get.pic_at_bg(obj)
            
            path = [obj.pics_path,'/pic_at_bg.mat'];
            
            load(path);
            
        end
        
        function pic_wat_bg = get.pic_wat_bg(obj)
            
            path = [obj.pics_path,'/pic_wat_bg.mat'];
            
            load(path);
            
            
        end
        
        function pic_cor = get.pic_cor(obj)
            
            if isempty(obj.tmp_pic_cor)
                
                if obj.static_pic_props.use_rbc
                    
                    pic_sig_rbc = obj.pic_sig((obj.static_pic_props.r_rbc_ctr-obj.static_pic_props.rbc_wth):(obj.static_pic_props.r_rbc_ctr+obj.static_pic_props.rbc_wth),...
                        (obj.static_pic_props.c_rbc_ctr-obj.static_pic_props.rbc_wth):(obj.static_pic_props.c_rbc_ctr+obj.static_pic_props.rbc_wth));
                    
                    pic_bg_rbc = obj.pic_bg((obj.static_pic_props.r_rbc_ctr-obj.static_pic_props.rbc_wth):(obj.static_pic_props.r_rbc_ctr+obj.static_pic_props.rbc_wth),...
                        (obj.static_pic_props.c_rbc_ctr-obj.static_pic_props.rbc_wth):(obj.static_pic_props.c_rbc_ctr+obj.static_pic_props.rbc_wth));
                    
                    rbc_crt = sum(pic_sig_rbc(:))/sum(pic_bg_rbc(:));
                    
                else
                    
                    rbc_crt = 1;
                    
                end
                
                mask_sig = obj.pic_sig>0;
                mask_bg = obj.pic_bg>0;
                
                tmp = (obj.pic_sig.*mask_sig+~mask_sig)./(rbc_crt*obj.pic_bg.*mask_bg+~mask_bg);
                
                obj.tmp_pic_cor = -(ImagSource.Default_parameters.pixel_size/obj.static_pic_props.magnification)^2/...
                    ImagSource.Default_parameters.sigma0* ...
                    log(tmp);
                
            end
            
            pic_cor = obj.tmp_pic_cor;
            
        end
        
        function pic_sig = get.pic_sig(obj)
            
            if isempty(obj.tmp_pic_sig)
                
                obj.tmp_pic_sig = (double(obj.pic_at) - double(obj.pic_at_bg));
                
            end
            
            pic_sig = obj.tmp_pic_sig;
            
        end
        
        function pic_bg = get.pic_bg(obj)
            
            if isempty(obj.tmp_pic_bg)
                
                obj.tmp_pic_bg = (double(obj.pic_wat) - double(obj.pic_wat_bg));
                
            end
            
            pic_bg = obj.tmp_pic_bg;
            
        end
        
        function pic = saveobj(obj)
            
            pic = obj;
            
            pic.lst_pic_type = [];
            
            pic.lst_pic_props = [];
            
            pic.lst_static_pic_props = [];
            
            pic.dpg = [];
            
            pic.tmp_pic_cor = [];
            
            pic.tmp_pic_sig = [];
            pic.tmp_pic_bg = [];
            
        end
        
    end
    
    methods (Static = true)
        
        function obj = loadobj(pic)
            
            pic.lst_pic_type = addlistener(pic,'pic_type','PostSet',@pic.postset_pic_type);
            
            pic.lst_pic_props = addlistener(pic,'pic_props','PostSet',@pic.postset_pic_props);
            
            pic.lst_static_pic_props = addlistener(pic,'static_pic_props','PostSet',@pic.postset_static_pic_props);
            
            % retrocompatibility 11/03/2015 update
            
            if isempty(pic.static_pic_props)
                
                pic.static_pic_props.magnification = ImagSource.Default_parameters.magnification;
                
                pic.static_pic_props.use_rbc = 0;
                
                pic.static_pic_props.r_rbc_ctr = ImagSource.Default_parameters.Absorption_Corrected_r_rbc_ctr;
                pic.static_pic_props.c_rbc_ctr = ImagSource.Default_parameters.Absorption_Corrected_c_rbc_ctr;
                pic.static_pic_props.rbc_wth = ImagSource.Default_parameters.Absorption_Corrected_rbc_wth;
                
                pic.parent.treat_struct = [];
                
            end
            
            obj = pic;  % return the updated object
            
        end
        
    end
    
end
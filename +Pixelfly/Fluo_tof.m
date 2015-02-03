classdef Fluo_tof < handle
    % Generic Pixelfly class
    
    properties
        
        pics_path
        
    end
    
    properties (Dependent = true)
       
        pic_at
        pic_wat
        
        pic_at_bg
        pic_wat_bg
        
        pic_cor
        
    end
    
    properties % GUI
        
        dpg
        
    end
    
    properties
        
        pic_props % pictures properties
        
    end
    
    properties
       
        parent % parent Data class
        
    end
    
    methods
        
        function obj = Fluo_tof(pics_path)
            
            obj = obj@handle;
            
            obj.pics_path=pics_path;
            
            obj.pic_cor = obj.get_pic_cor;
            
        end
        
        function show(obj)
            
            % Show Pics
            
            h_fluo_img_at=findobj('Name','Fluorescence Image - Atoms');
            
            if isempty(h_fluo_img_at)
                
                h_fluo_img_at  = figure('Name','Fluorescence Image - Atoms','Position',[8,694,560,420],'NumberTitle','off');
                ax_fluo_img_at = axes('Parent',h_fluo_img_at);
                
            else
                
                tmp = get(h_fluo_img_at,'Children');
                ax_fluo_img_at = tmp(2);
                
            end
            
            h_fluo_img_wat=findobj('Name','Fluorescence Image - No Atoms');
            
            if isempty(h_fluo_img_wat)
                
                h_fluo_img_wat  = figure('Name','Fluorescence Image - No Atoms','Position',[583,695,560,420],'NumberTitle','off');
                ax_fluo_img_wat = axes('Parent',h_fluo_img_wat);
                
            else
                
                tmp = get(h_fluo_img_wat,'Children');
                ax_fluo_img_wat = tmp(2);
                
            end
            
            h_fluo_img_at_bg=findobj('Name','Fluorescence Image - Atoms Background');
            
            if isempty(h_fluo_img_at_bg)
                
                h_fluo_img_at_bg  = figure('Name','Fluorescence Image - Atoms Background','Position',[8,182,560,420],'NumberTitle','off');
                ax_fluo_img_at_bg = axes('Parent',h_fluo_img_at_bg);
                
            else
                
                tmp = get(h_fluo_img_at_bg,'Children');
                ax_fluo_img_at_bg = tmp(2);
                
            end
            
            h_fluo_img_wat_bg=findobj('Name','Fluorescence Image - No Atoms Background');
            
            if isempty(h_fluo_img_wat_bg)
                
                h_fluo_img_wat_bg  = figure('Name','Fluorescence Image - No Atoms Background','Position',[583,182,560,420],'NumberTitle','off');
                ax_fluo_img_wat_bg = axes('Parent',h_fluo_img_wat_bg);
                
            else
                
                tmp = get(h_fluo_img_wat_bg,'Children');
                ax_fluo_img_wat_bg = tmp(2);
                
            end
            
            h_fluo_img_cor=findobj('Name','Fluorescence Image - Corrected');
            
            if isempty(h_fluo_img_cor)
                
                h_fluo_img_cor  = figure('Name','Fluorescence Image - Corrected','Position',[1349,695,560,420],'NumberTitle','off');
                ax_fluo_img_cor = axes('Parent',h_fluo_img_cor);
                
            else
                
                tmp = get(h_fluo_img_cor,'Children');
                ax_fluo_img_cor = tmp(2);
                
            end

            imagesc(obj.pic_at,'Parent',ax_fluo_img_at);
            caxis(ax_fluo_img_at,[200 600]);
            colorbar('peer',ax_fluo_img_at);
            axis(ax_fluo_img_at,'image')
            set(ax_fluo_img_at,'YDir','normal');
            
            imagesc(obj.pic_wat,'Parent',ax_fluo_img_wat);
            caxis(ax_fluo_img_wat,[200 600]);
            colorbar('peer',ax_fluo_img_wat);
            axis(ax_fluo_img_wat,'image')
            set(ax_fluo_img_wat,'YDir','normal');
            
            imagesc(obj.pic_at_bg,'Parent',ax_fluo_img_at_bg);
            caxis(ax_fluo_img_at_bg,[200 600]);
            colorbar('peer',ax_fluo_img_at_bg);
            axis(ax_fluo_img_at_bg,'image')
            set(ax_fluo_img_at_bg,'YDir','normal');
            
            imagesc(obj.pic_wat_bg,'Parent',ax_fluo_img_wat_bg);
            caxis(ax_fluo_img_wat_bg,[200 600]);
            colorbar('peer',ax_fluo_img_wat_bg);
            axis(ax_fluo_img_wat_bg,'image')
            set(ax_fluo_img_wat_bg,'YDir','normal');
            
            imagesc(obj.pic_cor,'Parent',ax_fluo_img_cor);
            caxis(ax_fluo_img_cor,[0 400]);
            colorbar('peer',ax_fluo_img_cor);
            axis(ax_fluo_img_cor,'image')
            set(ax_fluo_img_cor,'YDir','normal');
            
            
            set(h_fluo_img_at,'Visible','off')
            set(h_fluo_img_wat,'Visible','off')
            set(h_fluo_img_at_bg,'Visible','off')
            set(h_fluo_img_wat_bg,'Visible','off')
            set(h_fluo_img_cor,'Visible','off')
            
            set(h_fluo_img_at,'Visible','on')
            set(h_fluo_img_wat,'Visible','on')
            set(h_fluo_img_at_bg,'Visible','on')
            set(h_fluo_img_wat_bg,'Visible','on')
            set(h_fluo_img_cor,'Visible','on')
            
        end
        
        function fpic_cor = get_pic_cor(obj)
            
            fpic_cor = (obj.pic_at - obj.pic_at_bg) - (obj.pic_wat - obj.pic_wat_bg);
            
        end
        
        function pic_at = get.pic_at(obj)
            
            path = [obj.pics_path,'\pic_at.mat'];
            
            load(path);
            
        end
        
        function pic_wat = get.pic_wat(obj)
            
            path = [obj.pics_path,'\pic_wat.mat'];
            
            load(path);
            
        end
        
        function pic_at_bg = get.pic_at_bg(obj)
            
            path = [obj.pics_path,'\pic_at_bg.mat'];
            
            load(path);
            
        end
        
        function pic_wat_bg = get.pic_wat_bg(obj)
            
            path = [obj.pics_path,'\pic_wat_bg.mat'];
            
            load(path);

            
        end
        
        function pic_cor = get.pic_cor(obj)
            
            path = [obj.pics_path,'\pic_cor.mat'];
            
            load(path);
        
        end
        
        function set.pic_cor(obj,pic_cor)
            
            path = [obj.pics_path,'\pic_cor.mat'];
            
            save(path,'pic_cor');
            
        end
        
    end

end
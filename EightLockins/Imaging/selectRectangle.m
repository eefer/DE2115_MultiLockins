function selectRectangle(pos,obj)
    lockin_amp_mat = getappdata(obj,'lockin_amp_mat'); 
    lockin_phase_mat = getappdata(obj,'lockin_phase_mat'); 
   
    hLine1 = findobj(obj, 'Tag', 'ampLine');
    hLine2 = findobj(obj, 'Tag', 'phaseLine');
    
    % calculate mean of roi
    miny = round(pos(1,2));
    maxy = round(pos(1,2)+pos(1,4));
    minx = round(pos(1,1));
    maxx = round(pos(1,1)+pos(1,3)) ;
    area = (maxx - minx) * (maxy - miny);
    
    roi_mean_amp = squeeze(sum(sum(lockin_amp_mat(miny:maxy-1,minx:maxx-1,:),1),2))./area;
    roi_mean_phase = squeeze(sum(sum(lockin_phase_mat(miny:maxy-1,minx:maxx-1,:),1),2))./area;
    
    % update 
    set(hLine1,'YData', roi_mean_amp);
    set(hLine2,'YData', roi_mean_phase);
    drawnow;
end
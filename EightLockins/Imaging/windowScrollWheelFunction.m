function windowScrollWheelFunction(obj, evt)
    currentFrame = getappdata(obj, 'currentFrame');
    lockin_amp_mat = getappdata(obj,'lockin_amp_mat');
    lockin_phase = getappdata(obj,'lockin_phase');
    
    h_amp = findobj(obj, 'Tag', 'ampImage');
    h_phase = findobj(obj, 'Tag', 'phaseImage');
    
    if evt.VerticalScrollCount == 1
       % go to next frame 
       if currentFrame <= 7
       currentFrame = currentFrame + 1;
       end
    else
        % go to prev frame
        if currentFrame >= 2
        currentFrame = currentFrame - 1;
        end
    end
    
    % replace image with current frame
    set(h_amp,'CData',lockin_amp_mat(:,:,currentFrame));
    title(h_amp.Parent,sprintf('Lockin %d Amplitude', currentFrame));
    set(h_phase,'CData',lockin_phase{currentFrame});
    title(h_phase.Parent,sprintf('Lockin %d Phase', currentFrame));
    setappdata(obj, 'currentFrame', currentFrame);
end
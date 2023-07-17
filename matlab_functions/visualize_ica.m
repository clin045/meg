function vizualize_ica(ica)
    % Inspect topoplots
    cfg = [];
    cfg.component = 1:20;
    cfg.marker = 'off'; % may be easier to read if markers off
    cfg.comment = 'no'; % may be easier to read if comments off
    cfg.style = 'straight'; % may be easier to read if contour lines off
    cfg.layout      = 'CTF275.lay';
    ft_topoplotIC(cfg, ica);
end

function vizualize_ica(ica)
    % Inspect topoplots
    cfg = [];
    cfg.component = 1:20;
    cfg.layout      = 'CTF275.lay';
    cfg.viewmode = 'component';
    ft_databrowser(cfg, ica);
end

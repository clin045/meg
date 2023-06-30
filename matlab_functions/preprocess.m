function preprocess(in_path, trl)
    ft_defaults();
    cfg = [];
    cfg.trl = trl;
    cfg.dataset = in_path;
    data_meg = ft_preprocessing(cfg);

    cfg.metric = 'zvalue';  % use by default zvalue method
    cfg.method = 'summary'; % use by default summary method
    ft_rejectvisual(cfg,data_meg);
    
end
function preprocess(in_path, out_path, trl)
    ft_defaults();
    cfg = [];
    cfg.trl = trl;
    cfg.dataset = in_path;
    cfg.channel = 'MEG';

    cfg.hpfilter       = 'yes';           % enable high-pass filtering
    cfg.lpfilter       = 'yes';           % enable low-pass filtering
    cfg.hpfreq         = 5;              % set up the frequency for high-pass filter
    cfg.lpfreq         = 100;             % set up the frequency for low-pass filter

    
    data_meg = ft_preprocessing(cfg);
    save(out_path,"data_meg");
end
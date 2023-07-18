function preprocess_a(in_path, out_path, trl)
    ft_defaults();
    cfg = [];
    cfg.dataset = in_path;
    cfg.channel = 'MEG';
    cfg.bpfilter = 'yes';
    cfg.bpfreq = [1, 100];
    cfg.continuous  = 'yes';

    preprocessed = ft_preprocessing(cfg);
    save(out_path,"preprocessed",'-v7.3');
end
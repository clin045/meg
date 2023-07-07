function ica(in_path, out_path)
    ft_defaults();
    load(in_path, 'preprocessed');
    resampled = ft_resampledata(struct('resamplefs',300,'detrend','no'), preprocessed);
    comp = ft_componentanalysis(struct('method','runica','numcomponent',20), resampled);
    save(out_path, 'comp')
end
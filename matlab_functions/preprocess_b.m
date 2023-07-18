function preprocess_b(preproc_path, comp_path, timelock_path, trl, reject_components)
    load(preproc_path, "preprocessed");
    load(comp_path, "comp");
    ft_defaults();
    disp(cell2mat(reject_components));
    ica_cleaned = ft_rejectcomponent(struct('component', cell2mat(reject_components)), comp, preprocessed);

    % Bandpass to just the beta band
    cfg = [];
    cfg.channel = 'MEG';
    cfg.bpfilter = 'yes';
    cfg.bpfreq = [15, 30];
    bandpassed = ft_preprocessing(cfg, ica_cleaned);
    epoched = ft_redefinetrial(struct('trl', trl), bandpassed);
    timelock = ft_timelockanalysis(struct('covariance','yes'), ...
                                        epoched);
    save(timelock_path,"timelock",'-v7.3');
end
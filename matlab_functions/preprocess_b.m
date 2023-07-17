function preprocess_b(preproc_path, comp_path, out_path, timelock_path, trl, reject_components)
    load(preproc_path, "preprocessed");
    load(comp_path, "comp");
    ft_defaults();
    disp(cell2mat(reject_components));
    ica_cleaned = ft_rejectcomponent(struct('component', cell2mat(reject_components)), comp, preprocessed);
    timelock = ft_timelockanalysis(struct('covariance','yes'), ...
                                        ica_cleaned);
    save(timelock_path,"timelock",'-v7.3');
    preprocessed_b = ft_redefinetrial(struct('trl', trl), timelock);
    save(out_path,"preprocessed_b",'-v7.3');
end
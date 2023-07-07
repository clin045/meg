function preprocess_b(preproc_path, comp_path, out_path, trl, reject_components)
    load(preproc_path, "preprocessed");
    load(comp_path, "comp");
    ft_defaults();
    disp(cell2mat(reject_components));
    ica_cleaned = ft_rejectcomponent(struct('component', cell2mat(reject_components)), comp, preprocessed);
    preprocessed_b = ft_redefinetrial(struct('trl', trl), ica_cleaned);
    save(out_path,"preprocessed_b",'-v7.3');
end
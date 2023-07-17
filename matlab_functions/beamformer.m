function beamformer(sourcemodel_path, headmodel_path, timelock_path, anat_path, out_path)
    ft_defaults();
    % load("data/preprocessing/558CTL0505M_R-vannest-SRT_20190730_01/preprocessed_b.mat",'preprocessed_b');
    load(sourcemodel_path,"sourcemodel_singleshell");
    load(headmodel_path,"vol");
    load(timelock_path,"timelock");
    % Build lead field
    cfg = [];
    cfg.grad = timelock.grad;
    cfg.headmodel = vol;
    cfg.sourcemodel = sourcemodel_singleshell;
    cfg.channel =  {'MEG'};
    cfg.singleshell.batchsize = 2000;
    lf = ft_prepare_leadfield(cfg);

    % Create lcmv beamformer
    cfg = [];
    cfg.method = 'lcmv';
    cfg.sourcemodel = lf;
    cfg.headmodel = vol;
    cfg.lcmv.keepfilter = 'yes';
    cfg.lcmv.fixedori = 'yes';
    source = ft_sourceanalysis(cfg, timelock);
    
    % Interpolate source data to anatomical MRI. We don't save the original source var
    % for now, since it takes up a lot of memory.
    mri = ft_volumereslice([], ft_read_mri(anat_path));
    cfg = [];
    cfg.downsample = 2;
    cfg.parameter = 'pow';
    sourceInt = ft_sourceinterpolate(cfg, source, mri);
    save(out_path, "sourceInt");
end
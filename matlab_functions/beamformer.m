function beamformer(sourcemodel_path, headmodel_path, timelock_path, anat_path, out_path, figure_path, nifti_path, resliced_path)
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
    cfg.lcmv.projectnoise = 'yes';
    source = ft_sourceanalysis(cfg, timelock);
    
    % Interpolate source data to anatomical MRI. We don't save the original source var
    % for now, since it takes up a lot of memory.
    mri = ft_volumereslice([], ft_read_mri(anat_path));

    % Export resliced MRI
    cfg = [];
    cfg.parameter = 'anatomy';
    cfg.filename = resliced_path;
    cfg.filetype = 'nifti_gz';
    ft_volumewrite(cfg, mri);

    sourceNAI = source;
    sourceNAI.avg.pow = source.avg.pow ./ source.avg.noise;

    cfg = [];
    cfg.downsample = 2;
    cfg.parameter = 'pow';
    sourceInt = ft_sourceinterpolate(cfg, sourceNAI, mri);
    save(out_path, "sourceInt");

    % Construct figure
    maxval = max(sourceInt.pow);
    cfg = [];
    cfg.method        = 'slice';
    cfg.funparameter  = 'pow';
    cfg.maskparameter = cfg.funparameter;
    cfg.funcolorlim   = [4.0 maxval];
    cfg.opacitylim    = [4.0 maxval];
    cfg.opacitymap    = 'rampup';
    ft_sourceplot(cfg, sourceInt);
    saveas(gcf, figure_path)

    % Export nifti
    cfg = [];
    cfg.filename = nifti_path;
    cfg.parameter = 'pow';
    cfg.filetype = 'nifti';
    ft_sourcewrite(cfg, sourceInt);
end
function forward(dataset)
    load("/Users/clin/research/fieldtrip/template/sourcemodel/standard_sourcemodel3d4mm.mat")
    load Subject01_headmodel

    cfg         = [];
    cfg.grad    = dataset.grad;   % sensor information
    cfg.channel = dataset.label;  % the used channels
    cfg.grid    = sourcemodel;   % source points
    cfg.headmodel = headmodel;   % volume conduction model
    cfg.singleshell.batchsize = 5000; % speeds up the computation
    leadfield   = ft_prepare_leadfield(cfg);
end

function extract_audio(in_path, out_path)
    ft_defaults;
    dat = ft_read_data(in_path,'chanindx',312);
    dat_mono = dat(:);
    sample_rate = 2400;
    audiowrite(out_path, dat_mono, sample_rate);
end
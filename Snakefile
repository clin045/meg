from matlab import engine
import lib

eng = engine.connect_matlab()
eng.addpath('./matlab_functions')
eng.addpath('~/fieldtrip')

rule extract_audio:
    input:
        "data/raw/{sub}_R-vannest-SRT_{date}_{ses}.ds"
    output:
        "data/audio/{sub}_R-vannest-SRT_{date}_{ses}.wav"
    run:
        eng.extract_audio(input[0],output[0],nargout=0)
        

rule extract_syllables:
    input:
        "data/audio/{sub}_R-vannest-SRT_{date}_{ses}.wav"
    output:
        "data/labels/{sub}_R-vannest-SRT_{date}_{ses}.txt"
    run:
        res = lib.extract_syllables(input[0])
        for idx, r in enumerate(res):
            label = lib.format_label(r[0], r[1], idx)
            with open(output[0], "a+") as f:
                f.write(f"{label}\n")

rule preprocess_a:
    # Pre-ICA preprocessing steps (bandpass)
    input:
        "data/raw/{sub}_R-vannest-SRT_{date}_{ses}.ds",
        "data/manual_labels/{sub}_R-vannest-SRT_{date}_{ses}.txt"
    output:
        "data/preprocessing/{sub}_R-vannest-SRT_{date}_{ses}/ica_cleaned.mat"
    run:
        trl = lib.create_trl(input[1])
        eng.preprocess_a(input[0],output[0],nargout=0)

# rule preprocess_trials:
    

rule ica:
    input:
        "data/preprocessing/{sub}_R-vannest-SRT_{date}_{ses}/preprocessed_a.mat"
    output:
        "data/preprocessing/{sub}_R-vannest-SRT_{date}_{ses}/ica.mat"
    run:
        eng.ica(input[0],output[0],nargout=0)

rule preprocess_b:
    # ICA component removal, epoching, covariance calculation
    # ica_rejected_components.txt must be created manually
    input:
        "data/preprocessing/{sub}_R-vannest-SRT_{date}_{ses}/preprocessed_a.mat",
        "data/preprocessing/{sub}_R-vannest-SRT_{date}_{ses}/ica.mat",
        "data/preprocessing/{sub}_R-vannest-SRT_{date}_{ses}/ica_rejected_components.txt",
        "data/manual_labels/{sub}_R-vannest-SRT_{date}_{ses}.txt"
    output:
        "data/preprocessing/{sub}_R-vannest-SRT_{date}_{ses}/preprocessed_b.mat",
        "data/preprocessing/{sub}_R-vannest-SRT_{date}_{ses}/timelock.mat"
    run:
        reject = []
        with open(input[2]) as f:
            for l in f.readlines():
                reject.append(int(l.strip()))
        print(f"Rejecting components {reject}")
        trl = lib.create_trl(input[3])
        eng.preprocess_b(input[0],input[1],output[0],output[1],trl,reject,nargout=0)

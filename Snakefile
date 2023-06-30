from matlab import engine
import lib

eng = engine.connect_matlab()
eng.addpath('./matlab_functions')
eng.addpath('/Users/clin/research/fieldtrip')

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

rule preprocess:
    input:
        "data/raw/{sub}_R-vannest-SRT_{date}_{ses}.ds",
        "data/manual_labels/{sub}_R-vannest-SRT_{date}_{ses}.txt"
    output:
        "{sub}_R-vannest-SRT_{date}_{ses}.test"
    run:
        trl = lib.create_trl(input[1])
        eng.preprocess(input[0],trl,nargout=0)

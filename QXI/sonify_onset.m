function [out] = sonify_onset(onset_time ,onset_amp, f_audio,parameter)
%SONIFY_NOVELTYCURVE Sonifies a novelty curve.
%   [out] = sonify_noveltyCurve(novelty,f_audio,parameter) sonifies the novelty curve
%   novelty and returns a stereo waveform vector out with the original f_audio 
%   in the left channel and the novelty peaks sonifiesd as beep in the
%   right channel
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% sonify onsets
%
%
% Input:
%       onset_time : timevec of onsets in secs
%       onset_amp  : amp of onsets.
%       f_audio : original audio waveform, used to create a stereo annotation 
%       parameter (optional): parameter struct with fields
%               .feature_fs : feature rate of the novelty curve
%               .audio_fs : sampling rate of the audio
%               
%
% Output:
%       out : stereo signal, music in Left, click in right.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin < 3
    parameter = [];
end

if isfield(parameter,'outpath')==0
    parameter.outpath = 'sonifiy_out';
end

if isfield(parameter,'audio_fs')==0
    parameter.audio_fs = 22050;
end
if isfield(parameter,'feature_fs')==0
    warning('parameter.feature_fs not set! Assuming 100!')
    parameter.feature_fs = 100;
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


peaks = onset_time;
click_amp = onset_amp ./ max(onset_amp) * 0.8 + 0.1; % normalize to 0.1-0.9




click =  [0.0000; 0.0000; -0.0001; 0.0002; -0.0001; 0.0001; -0.0000; -0.0001; 0.0001; 0.0938; 0.1861; 0.2755; 0.3606; 0.4400; 0.5125; 0.5769; 0.6324; 0.6778; 0.7127; 0.7362; 0.7484; 0.7487; 0.7373; 0.7143; 0.6800; 0.6352; 0.5803; 0.5164; 0.4442; 0.3654; 0.2803; 0.1915; 0.0989; 0.0054; -0.0885; -0.1810; -0.2704; -0.3560; -0.4356; -0.5086; -0.5734; -0.6295; -0.6755; -0.7108; -0.7354; -0.7479; -0.7491; -0.7382; -0.7159; -0.6823; -0.6380; -0.5837; -0.5202; -0.4485; -0.3700; -0.2853; -0.1965; -0.1043; -0.0107; 0.0832; 0.1758; 0.2655; 0.3511; 0.4314; 0.5045; 0.5702; 0.6264; 0.6733; 0.7091; 0.7343; 0.7475; 0.7493; 0.7392; 0.7174; 0.6845; 0.6408; 0.5871; 0.5240; 0.4529; 0.3744; 0.2905; 0.2014; 0.1098; 0.0159; -0.0779; -0.1704; -0.2606; -0.3464; -0.4269; -0.5007; -0.5665; -0.6235; -0.6709; -0.7073; -0.7332; -0.7469; -0.7497; -0.7399; -0.7191; -0.6867; -0.6434; -0.5905; -0.5278; -0.4571; -0.3792; -0.2952; -0.2068; -0.1148; -0.0215; 0.0726; 0.1653; 0.2556; 0.3416; 0.4225; 0.4966; 0.5631; 0.6206; 0.6683; 0.7058; 0.7318; 0.7467; 0.7497; 0.7408; 0.7206; 0.6888; 0.6463; 0.5937; 0.5316; 0.4613; 0.3838; 0.3002; 0.2119; 0.1202; 0.0268; -0.0673; -0.1600; -0.2506; -0.3368; -0.4182; -0.4926; -0.5595; -0.6176; -0.6658; -0.7039; -0.7307; -0.7461; -0.7499; -0.7416; -0.7220; -0.6909; -0.6488; -0.5971; -0.5352; -0.4656; -0.3883; -0.3051; -0.2171; -0.1254; -0.0322; 0.0620; 0.1548; 0.2454; 0.3322; 0.4135; 0.4887; 0.5558; 0.6147; 0.6633; 0.7021; 0.7294; 0.7456; 0.7499; 0.7425; 0.7234; 0.6929; 0.6517; 0.6000; 0.5392; 0.4696; 0.3930; 0.3099; 0.2220; 0.1308; 0.0374; -0.0566; -0.1497; -0.2403; -0.3275; -0.4090; -0.4846; -0.5523; -0.6114; -0.6610; -0.7001; -0.7283; -0.7449; -0.7499; -0.7432; -0.7248; -0.6949; -0.6544; -0.6032; -0.5429; -0.4739; -0.3974; -0.3149; -0.2271; -0.1362; -0.0426; 0.0513; 0.1443; 0.2355; 0.3224; 0.4048; 0.4804; 0.5486; 0.6084; 0.6583; 0.6982; 0.7269; 0.7444; 0.7500; 0.7439; 0.7261; 0.6970; 0.6569; 0.6064; 0.5466; 0.4778; 0.4022; 0.3194; 0.2324; 0.1413; 0.0479; -0.0457; -0.1393; -0.2302; -0.3177; -0.4002; -0.4762; -0.5451; -0.6051; -0.6559; -0.6962; -0.7256; -0.7437; -0.7500; -0.7445; -0.7276; -0.6988; -0.6595; -0.6095; -0.5501; -0.4822; -0.4064; -0.3244; -0.2374; -0.1464; -0.0536; 0.0407; 0.1338; 0.2252; 0.3128; 0.3957; 0.4722; 0.5413; 0.6021; 0.6532; 0.6942; 0.7242; 0.7430; 0.7499; 0.7452; 0.7287; 0.7009; 0.6619; 0.6128; 0.5537; 0.4862; 0.4109; 0.3292; 0.2424; 0.1517; 0.0587; -0.0353; -0.1286; -0.2201; -0.3079; -0.3911; -0.4680; -0.5377; -0.5988; -0.6506; -0.6921; -0.7229; -0.7421; -0.7499; -0.7457; -0.7300; -0.7027; -0.6645; -0.6157; -0.5574; -0.4902; -0.4155; -0.3340; -0.2475; -0.1570; -0.0640; 0.0298; 0.1235; 0.2148; 0.3031; 0.3865; 0.4639; 0.5338; 0.5957; 0.6477; 0.6902; 0.7213; 0.7414; 0.7498; 0.7462; 0.7313; 0.7045; 0.6670; 0.6187; 0.5609; 0.4943; 0.4198; 0.3389; 0.2525; 0.1622; 0.0693; -0.0245; -0.1181; -0.2098; -0.2982; -0.3820; -0.4597; -0.5301; -0.5923; -0.6452; -0.6879; -0.7199; -0.7405; -0.7496; -0.7469; -0.7323; -0.7065; -0.6693; -0.6218; -0.5644; -0.4984; -0.4241; -0.3438; -0.2574; -0.1675; -0.0747; 0.0194; 0.1126; 0.2049; 0.2932; 0.3773; 0.4554; 0.5263; 0.5891; 0.6424; 0.6859; 0.7184; 0.7397; 0.7495; 0.7472; 0.7336; 0.7081; 0.6717; 0.6249; 0.5677; 0.5025; 0.4284; 0.3485; 0.2624; 0.1727; 0.0800; -0.0139; -0.1076; -0.1995; -0.2884; -0.3727; -0.4511; -0.5226; -0.5857; -0.6397; -0.6836; -0.7168; -0.7389; -0.7490; -0.7478; -0.7346; -0.7099; -0.6742; -0.6276; -0.5716; -0.5061; -0.4331; -0.3530; -0.2676; -0.1778; -0.0853; 0.0086; 0.1022; 0.1945; 0.2834; 0.3681; 0.4469; 0.5187; 0.5824; 0.6369; 0.6814; 0.7152; 0.7379; 0.7487; 0.7483; 0.7355; 0.7117; 0.6764; 0.6306; 0.5749; 0.5101; 0.4155; 0.3219; 0.2317; 0.1463; 0.0680; -0.0022; -0.0631; -0.1134; -0.1532; -0.1817; -0.1991; -0.2060; -0.2026; -0.1902; -0.1699; -0.1427; -0.1106; -0.0748; -0.0375; 0.0000; -0.0001; 0.0000; 0.0001; -0.0001; 0.0002; -0.0002; 0.0001; 0];
click = click.*(1:-1/length(click):1/length(click))'.^2;
click = resample(click, parameter.audio_fs, 2*44100);
click_len = length(click);

out = zeros(size(f_audio));


for idx = 1:length(peaks)
    start = floor(peaks(idx) * parameter.audio_fs)+1;
    stop = start + click_len - 1;
    if stop <= length(out)
        out(start:stop) = out(start:stop) + click .* click_amp(idx);
    end
end



out = [f_audio, out(:)];
audiowrite(parameter.outpath, out, parameter.audio_fs);






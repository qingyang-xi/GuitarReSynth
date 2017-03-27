import pretty_midi
import scipy.io.wavfile

midi_file = 'midi_output'
fs = 44100

midi = pretty_midi.PrettyMIDI('./midi/' + midi_file + '.mid')
soundfonts = { \
	'acoustic': './soundfonts/Acoustic_Guitar.sf2', \
	'energized': './soundfonts/Energized.sf2', \
	'les_paul': './soundfonts/Gibson_Les_Paul.sf2' \
}

for sf in soundfonts:
	synthesized = midi.fluidsynth(fs, soundfonts[sf])
	output_path = './wave_out/'+sf+'_'+midi_file+'.wav'
	scipy.io.wavfile.write(output_path, fs, synthesized)





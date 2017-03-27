
import math
import pretty_midi
import scipy.io as sio
import numpy as np
import matplotlib.pyplot as plt



onset_time = sio.loadmat('./saved_mats/onset_time.mat')['onset_time']
chunked_roll = sio.loadmat('./saved_mats/chunked_roll.mat')['chunked_roll']
length_of_piece = 26;

# add the ending time of the last note into the roll.
onset_time = np.append(onset_time,length_of_piece)
chunked_roll = np.append(chunked_roll, np.zeros((chunked_roll.shape[0],1)), axis = 1)


def get_pitch_velocity(salience):
    # get from salience number to velocity number
    return int(math.floor(salience ** 0.5 * 127))

def get_pitch_dict(onset_idx, chunked_roll):
    # get the non-zero entries of a column of chunked_roll, with salience being the value
    col = chunked_roll[:,onset_idx]
    pitch_list = np.nonzero(col)[0]
    output = {}
    for pitch in pitch_list:
        output[pitch] = col[pitch]
    return output

def get_end_time(onset_idx, pitch, chunked_roll, onset_time):
    # get the end time for each note. Trying to gt rid of repeated onset
    current_salience = chunked_roll[pitch, onset_idx]
    
    '''
    only end the note if the salience of the next instance of note is 0 OR more salient. 
    Otherwise it should be treated as a tied-over note. 
    If it's tied-over, get rid of the following salience so the next onset wouldn't pick it up as NoteOn
    '''
    noteOff_idx = onset_idx + 1
    while True:
        if chunked_roll[pitch, noteOff_idx] == 0:
            end_time = onset_time[noteOff_idx]
            break
        elif chunked_roll[pitch, noteOff_idx] < chunked_roll[pitch, onset_idx]: 
            # it's a tied over note!
            chunked_roll[pitch, noteOff_idx] = 0
            noteOff_idx += 1
        else: # it's a new onset of the same note
            end_time = onset_time[noteOff_idx]
            break
    return end_time

def get_midi_note_from_pitch(pitch):
    # get pitch which is in piano roll format to be MIDI
    return pitch + 21;

# Initialize
midi_output = pretty_midi.PrettyMIDI()
guitar = pretty_midi.Instrument(program=0) # using soundfonts that has 0:0 as the guitar sound

#read chunked roll and synthesis!
#first iterate through all onsets
for idx in np.arange(0,onset_time.shape[0]):
    # get the non-zero pitches and their salience from chunked_roll
    current_pitch_dict = get_pitch_dict(idx, chunked_roll)
    # then for each onset, iterate through each note
    for pitch in current_pitch_dict:
        salience = current_pitch_dict[pitch]
        midi_number = get_midi_note_from_pitch(pitch)
        velocity = get_pitch_velocity(salience)
        start_time = onset_time[idx]
        end_time = get_end_time(idx, pitch, chunked_roll, onset_time)
        note = pretty_midi.Note(velocity=velocity, pitch=midi_number, start=start_time, end=end_time)
        guitar.notes.append(note)
        
# Add the guitar instrument to the PrettyMIDI object
midi_output.instruments.append(guitar)
# Write out the MIDI data
midi_output.write('./midi/midi_output.mid')




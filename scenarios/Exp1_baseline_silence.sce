scenario = "PART 1";
default_monitor_sounds = false; 
write_codes = true;	
active_buttons = 1; 
pulse_width = 20;

begin;

picture {} default;

picture {
text {
caption="+";
font_size=1000;
};
x=0; y=0;
} fixation;


$att_value = 0.0;
sound { wavefile { filename="control.wav";   preload=true;}; description = "1"; attenuation='$att_value'; default_code="Control";} 	 sound_1;
sound { wavefile { filename="left.wav";      preload=true;}; description = "2"; attenuation='$att_value'; default_code="Left";} 		 sound_2;
sound { wavefile { filename="right.wav";     preload=true;}; description = "3"; attenuation='$att_value'; default_code="Right";}     sound_3;

array {
	sound sound_1; 
	sound sound_2; 
	sound sound_3; 
} array_sounds;



# trial definition for variable ISI
trial { 
    trial_duration = 1000; 
    picture default;
    code = "isi";
} isi_trial;


#### trial def for main sound presentation trial
trial {
	trial_duration = stimuli_length; 
	monitor_sounds = true;
	stimulus_event {
		sound sound_1; 
		time=0;
	} event;	
} trial_main;



#---------------------------------------


begin_pcl;

# Condition shuffling
array<int>condition_order[0];
loop int i = 1 until i > (3 * 30)
begin
    condition_order.add( 1 );
    condition_order.add( 2 );
    condition_order.add( 3 );
    i = i + 3;
end;
condition_order.shuffle();

# short blank stimulus to avoid sending a port code immeditely after scenario start
isi_trial.present();

output_port port = output_port_manager.get_port( 1 );

# send a start/stop code (1)
port.send_code(15);   

begin;
	loop int i=1;
	until i > condition_order.count()	
	begin; 

	# Present silence
	int isi = random( 20000, 35000 );
	isi_trial.set_duration(isi);
	isi_trial.present();

	# Present stimulus
	int current_trial_index = condition_order[i]; 	
	event.set_stimulus( array_sounds[current_trial_index] );	
	int port_code = int( array_sounds[current_trial_index].description());
	event.set_event_code(array_sounds[current_trial_index].description());
	port.send_code(port_code);
	trial_main.present(); 

	i=i+1;
end;

isi_trial.present();
port.send_code(15);

end;


#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/
# "Evo"
# Uses a Akai LPD8 Mk2 Laptop Pad Controller and Game Controller
# as part of a collection of instruments that performs within an ensemble.

use_debug false
use_cue_logging false

live = 1
setup_test_1 = 0
setup_test_2 = 0
live_test = 0

define :rfiles do
  run_file "/Users/jevi/GitHub/EOA/Code/Version 11/replicator.rb"
  run_file "/Users/jevi/GitHub/EOA/Code/Version 11/o1_player.rb"
  run_file "/Users/jevi/GitHub/EOA/Code/Version 11/o2_player.rb"
  run_file "/Users/jevi/GitHub/EOA/Code/Version 11/o3_player.rb"
end

define :test_o1 do
  set :env_ready, 1
  set :o1_ready, 1
  set :o1_on, 1
  sleep 1

  osc "/play/button1", 1
  sleep 4
  osc "/play/button3", 1
  sleep 4
  osc "/play/button4", 1
  sleep 4
  osc "/play/button2", 1
  sleep 4

  osc "play/bumper-l-up", 1
  sleep 5
  osc "play/bumper-l-down", 1
  sleep 5  
  osc "play/bumper-r-up", 1
  sleep 5
  osc "play/bumper-r-down", 1
  sleep 4
end

define :test_o2_m1 do
  set :env_ready, 1
  set :o1_ready, 1
  set :o2_ready, 1
  set :o2_on, 1
  set :mut_o2, 0
  sleep 1

  osc "/play/button1", 1
  sleep 4
  osc "/play/button3", 1
  sleep 4
  osc "/play/button4", 1
  sleep 4
  osc "/play/button2", 1
  sleep 4

  osc "/play/improv_burst", 1
  sleep 0.1
  osc "/play/improv_burst", 1
  sleep 0.1  
  osc "/play/improv_burst", 1
  sleep 0.1
  osc "/play/improv_burst", 1
  sleep 0.1
  sleep 4
end

define :test_o2_m2 do
  set :env_ready, 1
  set :o1_ready, 1
  set :o2_ready, 1
  set :o2_on, 1
  set :mut_o2, 1
  sleep 1

  osc "/play/button1", 1
  sleep 4
  osc "/play/button3", 1
  sleep 4
  osc "/play/button4", 1
  sleep 4
  osc "/play/button2", 1
  sleep 4
end

define :test_o3 do
  set :env_ready, 1
  set :o1_ready, 1
  set :o2_ready, 1
  set :o3_ready, 1
  set :mut_o2, 1
  set :o1_on, 1
  set :o2_on, 1
  sleep 1

  osc "/play/button1", 1
  sleep 4
  osc "/play/button3", 1
  sleep 4
  osc "/play/button4", 1
  sleep 4
  osc "/play/button2", 1
  sleep 4

  osc "/modes/8", 8, "chaos2", 1
  sleep 4
  osc "/modes/8", 8, "chaos2", 0

end


# Run Test Setup 1
if setup_test_1 == 1 then
  loop do
    use_synth :pnoise
    play :c4, pan: -1
    sleep 1
    use_synth :pnoise
    play :d4, pan: 1
    sleep 1
  end
end

# Run Test Setup 2
if setup_test_2 == 1 then
  cmal2 =  "/Users/jevi/GitHub/EOA/Code/Version\ 10/samples/Mountain_Audio_-_Computer_Malfunction_-_Sound_\(2\).wav"
  loop do
    sample cmal2, amp: 1, pan: -1, finish: 1
    use_synth :pnoise
    play :c4, pan: -1
    sleep 1
    sample cmal2, amp: 1, pan: 1, finish: 1
    use_synth :pnoise
    play :d4, pan: 1
    sleep 1
  end
end


# Run Live
if live == 1 then
  rfiles
end


# Run Live Test - Use right channel to get isolated sound
if live_test == 1 then
  rfiles
  sleep 4
  use_osc "localhost", 4560
  set :o1_pos, 1  #testing in right channel
  test_o1
  set :o1_pos, -1 #send sound to left channel after testing

  set :o2_pos, 1  #testing in right channel
  test_o2_m1
  test_o2_m2

  set :o2_pos, -1 #send sound to left channel after testing
  test_o3 
end

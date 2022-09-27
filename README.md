# Boron_Encryption
Hardware implementation of ultraligth-weight Boron Encryption and decryption algorithms


This encryption algorithm has been invented to run on low-size and low-power computation systems. The inputs of this design are 64-bit Plain text and 80-bit key. There are two main processes going on in this algorithm one is to iterate encryption of the key which is called Key Update and the other is updating the text state with using updated key.  The process of updating the key and the text happens twenty-five times. The reason behind this is to build more hard to break encryption message. 

![Modules](Images/RTL_Schematic.png?raw=true "RLT_Schematic")

Steps involved in updating the key can be elaborated as like this round shift, S-box, Xor Layer. Round shit is binary rotational operation, S-box is nonlinear shuffle and Xor layer is generic binary xor operation with 5-bit counter which is updated every positive edge. After fallowing those steps we acquired the updated key. 
The other process besides updating the key is updating the text-state. In this process first operation is to do generic xor operation with updated keys least significant 64-bits. Then the resulting 64-bit data is given as input to round function. In the rounding function couple operations are applied those are S-box, Block Shuffle, Round Permutation.

![Test](Images/Simulation_Results.png?raw=true "Simulation Results")
### Inhouse encoders and decoders 

This folder provides in-house versions for:

1. Crc encoding/decoding 
2. Convolutional tail-biting codes encoding/decoding 
3. Turbo codes encoding/decoding

The implementation of the above encoders and decoders is mainly targeted to provide Octave support or Matlab support when MATLAB Communication Toolbox System Objects are not available. 

The implementation can be inefficient in terms of performance. 

#### How to enable?
The in-house implementation is automatically enabled by testing if Communication_Toolbox is not presented in the current system. The following method is used:
```
license('test','Communication_Toolbox')
```

Octave always returns 0

#### How to test

Matlab-way
```
runtests("lib/inhouse");
```

Octave-way
```
pkg load communications
runtests("lib/inhouse");
```



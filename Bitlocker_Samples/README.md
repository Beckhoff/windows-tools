# Bitlocker Configuration

To use Bitlocker some mandatory settings must be respected:
- Operating system is Windows 10 with 64 Bit architecture
- Bitlocker is supported starting with Windows 10 IoT Enterprise 2019 LTSC
- fTPM is enabled in the BIOS
- BIOS Boot mode is UEFI

The sample checks the following settings:
- TwinCAT state is in CONFIG mode
- TwinCAT powershell module AdsApi is available
- Boot mode is UEFI or LEGACY
- OS architecture is 32 Bit or 64 Bit
- OS release id is supported (below 1809 is not supported)
- fTPM or FTPM is present
- fTPM or FTPM is ready
- Recovery partitions exist
- Bitlocker status state  
_FullyDecrypted_ 
The script goes on  
_EncryptionInProgress_ 
The script stops here because the encryption is in progress  
_DecryptionInProgress_ 
The script stops here because the decryption is in progress  
_FullyEncrypted_ 
The script stops here because the volume is already encrypted  
- Add Bitlocker Protectors: TpmProtector, RecoveryPasswordProtector
- Initialize TPM, add recovery partition if needed and enable Bitlocker
- Save Bitlocker KeyProtectors to defined target location $KeyProtectorLocation  
In the sample it is "C:\Users\Administrator\Desktop\KeyProtector.txt"


Error Code Description:  
- _$Error_Success_ = 0  
The script runs successfully  
- _$Error_OsLegacy_ = 10  
OS is LEGACY which is not supported  
- _$Error_Os32Bit_ = 11  
OS is 32Bit which is not supported  
- _$Error_OsReleaseId_ = 12  
OS ReleaseID is lower than 1809 which is not supported  
- _$Error_TpmNotPreent_ = 20  
TPM is not present  
- _$Error_TpmNotReady_ = 21  
TPM is not ready  
- _$Error_BLDriveNotReady_ = 30  
Bitlocker mountpoint does not exist  
- _$Error_BLEncryptionInProgress_ = 31  
Bitlocker Encryption is in progress  
- _$Error_BLDecryptionInProgress_ = 32  
Bitlocker Decryption is in progress  
- _$Error_BLFullyEncrypted_ = 32  
Bitlocker is already encrypted  
- _$Error_TcSysPsExtensionMissing_ = 40  
TwinCAT powershell module AdsApi is missing
- _$Error_TcSysStateRunning_ = 41  
TwinCAT state is running

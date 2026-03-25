# Beckhoff Service Tool – Sample Scripts

A collection of Windows batch scripts for backing up and restoring TwinCAT boot directories, disabling TwinCAT System Service or set TwinCAT StartupType to Config/Run.

These scripts are intended to run from within the **Beckhoff Service Tool (BST)** environmentwhere a separate BST Images partition and a Windows partition are both accessible.
Backup and Restore of TwinCAT Boot Directory, disabling of TwinCAT System Service in Offline Image or set TwinCAT Startup Type to Config/Run.

## Prerequisites

- Run on Beckhoff Service Tool (BST)
- `diskpart` and `reg` must be available (standard on BST)

---

## Folder Structure

```
BeckhoffServiceTool_Sample/
├── BackupTwinCATBoot.cmd            # Backs up TwinCAT Boot directory to BST Images partition
├── GetWindowsLogs.cmd               # Collects key Windows logs to BST Images partition
├── RestoreTwinCATBoot.cmd           # Restores TwinCAT Boot directory from BST Images partition
├── SetTcStartupTypeConfig.cmd       # Sets TwinCAT startup type to Config
├── SetTcStartupTypeRun.cmd          # Sets TwinCAT startup type to Run
├── SetTcSysSrvToDisabled.cmd        # Disables TwinCAT System Service (run before restore)
└── Helper/
    ├── GetBstImagesPartition.cmd    # Detects BST Images partition drive letter → BstImagesPartition
    ├── GetWindowsPartition.cmd      # Detects Windows partition drive letter → WindowsPartition
    ├── GetWindowsComputerName.cmd   # Reads computer name from registry → ComputerName
    ├── GetProcessorArchitecture.cmd # Reads CPU architecture from registry → ARCH
    ├── GetTcBootDir.cmd             # Reads TwinCAT 3 boot directory from registry → TwinCATBootDir
    ├── SetTcSysSrvTo.cmd            # Sets TwinCAT System Service start type
    └── SetTcSysStartupState.cmd     # Sets TwinCAT startup state (Config/Run)
```
---
## Usage

### 1. Backup TwinCAT Boot Directory

Copies the TwinCAT boot directory from the Windows partition to the BST Images partition.

```cmd
BackupTwinCATBoot.cmd
```

Also use via Linked Button.
Navigate to Settings, Linked Buttons Tab and assign BackupTwinCATBoot.cmd via Select.

Copies files from:
```
<WindowsPartition>:\<TwinCATBootDir>
```

Backup is written to:
```
<BstImagesPartition>:\Backup\<ComputerName>\Boot\
```

>Note: The copy operation will override files already exist in `<BstImagesPartition>:\Backup\<ComputerName>\Boot\`.

### 2. Restore TwinCAT Boot Directory

Restores the previously backed-up TwinCAT boot directory back to the Windows partition.

```cmd
RestoreTwinCATBoot.cmd
```

Also use via Linked Button.
Navigate to Settings, Linked Buttons Tab and assign RestoreTwinCATBoot.cmd via Select.

Restores from:
```
<BstImagesPartition>:\Backup\<ComputerName>\Boot\
```

Writes files to:
```
<WindowsPartition>:\<TwinCATBootDir>
```

>Note: The copy operation will override files already exist in `<WindowsPartition>:\<TwinCATBootDir>`.

### 3. Set TwinCAT Startup Type to Config

Sets the TwinCAT startup type to **Config**.

```cmd
SetTcStartupTypeConfig.cmd
```

Also use via Linked Button.
Navigate to Settings, Linked Buttons Tab and assign SetTcStartupTypeConfig.cmd via Select.

### 4. Set TwinCAT Startup Type to Run

Sets the TwinCAT startup type to **Run**.

```cmd
SetTcStartupTypeRun.cmd
```

Also use via Linked Button.
Navigate to Settings, Linked Buttons Tab and assign SetTcStartupTypeRun.cmd via Select.

### 5. Disable TwinCAT System Service

Disables the TwinCAT System Service (`TcSysSrv`). Run this before restoring to prevent the service from starting automatically on next boot.

```cmd
SetTcSysSrvToDisabled.cmd
```

Also use via Linked Button.
Navigate to Settings, Linked Buttons Tab and assign SetTcSysSrvToDisabled.cmd via Select.

### 6. Get Windows Logs

Collects common Windows diagnostic logs from the offline Windows partition and stores them on the BST Images partition for analysis.

```cmd
GetWindowsLogs.cmd
```

Also use via Linked Button.
Navigate to Settings, Linked Buttons Tab and assign GetWindowsLogs.cmd via Select.

Collected logs include:
- `%WindowsPartition%\Windows\System32\winevt\Logs\Application.evtx`
- `%WindowsPartition%\Windows\System32\winevt\Logs\System.evtx`
- `%WindowsPartition%\Windows\Logs\CBS\CBS.log`
- `%WindowsPartition%\Windows\Panther\*`

Logs are written to:
```
<BstImagesPartition>:\Logs\<ComputerName>\
```

---

## Helper Scripts

These scripts are called internally by the main scripts and set variables in the caller's environment. They can also be called standalone for diagnostics.

| Script | Argument | Output variable | Description |
|---|---|---|---|
| `GetBstImagesPartition.cmd` | — | `BstImagesPartition` | Detects BST Images partition drive letter |
| `GetWindowsPartition.cmd` | — | `WindowsPartition` | Detects Windows partition drive letter |
| `GetWindowsComputerName.cmd` | `<WindowsPartition>` | `ComputerName` | Reads computer name from offline SYSTEM hive |
| `GetProcessorArchitecture.cmd` | `<WindowsPartition>` | `ARCH` | Reads `PROCESSOR_ARCHITECTURE` (`AMD64`, `x86`) |
| `GetTcBootDir.cmd` | `<WindowsPartition>` | `TwinCATBootDir` | Reads TwinCAT 3 `BootDir` from offline SOFTWARE hive |
| `SetTcSysSrvTo.cmd` | `<StartType> <WindowsPartition>` | — | Sets `TcSysSrv` start type (2=Auto, 3=Manual, 4=Disabled) |
| `SetTcSysStartupState.cmd` | `<StartupState> <WindowsPartition>` | — | Sets TwinCAT startup state (`Config`, `Run`) |

---

## Error Handling

All scripts exit with a non-zero return code on failure and print a descriptive error message. The main scripts validate all required variables before performing any file operations.


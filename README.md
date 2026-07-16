# Robonix ALSA Audio Primitive

This package exposes a Linux host's ALSA microphone and speaker through the
standard Robonix audio contracts. It is a reusable hardware primitive and does
not depend on Webots.

## Requirements

- Linux with `arecord` and `aplay` from `alsa-utils`
- Robonix installed and initialized with `rbnx setup`
- `uv` available on `PATH`
- at least one ALSA capture or playback device

On Debian or Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y alsa-utils
```

## Deployment

Reference the package from a robot deployment manifest:

```yaml
primitive:
  - name: audio_driver
    url: https://github.com/syswonder/primitive-audio-driver-rbnx
    branch: main
    config:
      mic_device: null
      speaker_device: null
```

When a device is `null`, the primitive scans ALSA and selects a suitable
device. Use `arecord -l` and `aplay -l` to find explicit device identifiers
such as `hw:1,0`. The complete configuration surface and defaults are in
[`config.spec`](config.spec).

Build and start it through the robot deployment:

```bash
rbnx build
rbnx boot
```

`rbnx build` generates the contract bindings and creates a package-owned Python
environment. During `Driver(CMD_INIT)`, the primitive scans ALSA and initializes
the selected capture and playback devices.

## Capabilities

| Contract | Purpose |
| --- | --- |
| `robonix/primitive/audio/mic` | Streams raw microphone PCM to a caller. |
| `robonix/primitive/audio/speaker` | Plays caller-provided raw PCM. |
| `robonix/primitive/audio/list_devices` | Lists ALSA devices and the current route. |
| `robonix/primitive/audio/select_device` | Changes the input or output device. |
| `robonix/primitive/audio/driver` | Provides the standard lifecycle interface. |

The microphone path defaults to mono, 16-bit PCM and probes a supported sample
rate, preferring 16 kHz. The speaker path defaults to mono, 16-bit PCM at
24 kHz. Consumers must send PCM matching the configured format.

## Development checks

```bash
python3 -m unittest -v test_speaker_driver.py
rbnx build
```

The package uses `arecord` and `aplay` only at runtime; the unit test does not
access an audio device.

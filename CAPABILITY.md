---
name: ALSA audio
description: Capture microphone PCM and play speaker PCM through Linux ALSA devices.
---

# ALSA audio primitive

Use this provider when microphone and speaker devices are attached directly to
the Linux robot host. It exposes the standard Robonix microphone, speaker,
device-list, device-selection, and lifecycle contracts.

Device routing is configured by the deployment or changed through the standard
audio device contracts. Do not assume a fixed ALSA card number; enumerate the
available devices first when an explicit route is required.

/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Constants, { AudioVolumeType, AudioDeviceType } from './Constants';

interface VolumeLayout {
  id: number;
  icon: string | Resource;
  label: string | Resource;
  iconDisable?: string | Resource;
}

interface VolumeConfig {
  volumeLayoutGroups: VolumeLayout[];
};

export const soundPanelConfig: VolumeConfig = {
  volumeLayoutGroups: [
    {
      id: AudioVolumeType.RINGTONE,
      icon: $r('app.media.ic_public_sound'),
      label: $r('app.string.sound_main'),
      iconDisable: $r('app.media.ic_public_sound_off'),
    },
    {
      id: AudioVolumeType.MEDIA,
      icon: $r('app.media.ic_public_ring'),
      label: $r('app.string.sound_media'),
      iconDisable: $r('app.media.ic_public_ring_off'),
    },
    {
      id: AudioVolumeType.VOICE_CALL,
      icon: $r('app.media.ic_public_phone'),
      label: $r('app.string.sound_calls'),
      iconDisable: $r('app.media.ic_public_phone'),
    },
  ],
};

interface DeviceLayout {
  id: number;
  icon: string | Resource;
  label: string | Resource;
};

interface DeviceConfig {
  deviceLayoutGroups: DeviceLayout[];
};

export const soundDeviceConfig: DeviceConfig = {
  deviceLayoutGroups: [
    {
      id: AudioDeviceType.BLUETOOTH_SCO,
      icon: $r('app.media.ic_device_soundx'),
      label: $r('app.string.sound_output_device_soundx'),
    },
    {
      id: AudioDeviceType.BLUETOOTH_SCO,
      icon: $r('app.media.ic_device_earphone'),
      label: $r('app.string.sound_output_device_earphone'),
    },
  ],
};

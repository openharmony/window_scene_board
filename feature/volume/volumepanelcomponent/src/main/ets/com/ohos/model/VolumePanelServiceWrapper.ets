/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import audio from '@ohos.multimedia.audio';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Constants from '../common/Constants';
import { BusinessError } from '@kit.BasicServicesKit';
import { SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICommonUtil';
import ViewModel from '../viewmodel/VolumePanelVM';
import { forceVolumeKeyControlType } from './StubAudioVolumeManager';

const TAG = 'VolumePanelServiceWrapper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class VolumePanelServiceWrapper {
  private static activeVolume: number | null = null;
  private static activeVolumeType: audio.AudioVolumeType | null = null;
  private static throttleSetVolume =
    SystemUICommonUtil.throttle(VolumePanelServiceWrapper.setVolume, Constants.SET_VOLUME_DELAY_TIME);

  static setVolumeByTypeAsync(volumeType: audio.AudioVolumeType, volume: number): void {
    VolumePanelServiceWrapper.activeVolumeType = volumeType;
    VolumePanelServiceWrapper.activeVolume = volume;
    VolumePanelServiceWrapper.throttleSetVolume(VolumePanelServiceWrapper.activeVolumeType,
      VolumePanelServiceWrapper.activeVolume);
  }

  private static setVolume(volumeType: Object, volume: Object): void {
    log.showWarn(`Set volume start, ${volumeType} ${volume}`);
    if (volume === Constants.DEFAULT_MIN_VOLUME) {
      ViewModel.updateVolumeWhenTouchToZero(volumeType as audio.AudioVolumeType, Constants.DEFAULT_MIN_VOLUME);
    }
    const mAudioManager = audio.getAudioManager();
    mAudioManager?.setVolume(volumeType as audio.AudioVolumeType, volume as number, (error: BusinessError) => {
      if (error) {
        log.showError(`Set volume failed, code: ${error?.code}, message: ${error?.message}`);
      }
      log.showWarn(`Set volume end, ${volumeType} ${volume}`);
    });
  }

  static generateThrottleSetVolume(): void {
    VolumePanelServiceWrapper.throttleSetVolume = SystemUICommonUtil.throttle(VolumePanelServiceWrapper.setVolume,
      Constants.SET_VOLUME_DELAY_TIME);
  }

  static async forceVolumeKeyControlType(volumeChannelType: audio.AudioVolumeType, duration: number): Promise<void> {
    try {
      await forceVolumeKeyControlType(volumeChannelType, duration);
    } catch (e) {
      log.error(`forceVolumeKeyControlType error,code: ${e?.code}, msg:${e?.message}`);
    }
  }
}
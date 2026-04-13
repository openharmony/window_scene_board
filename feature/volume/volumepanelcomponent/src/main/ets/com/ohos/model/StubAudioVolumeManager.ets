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

interface VolumeManager extends audio.AudioVolumeManager {
  forceVolumeKeyControlType(volumeType: audio.AudioVolumeType, duration: number): Promise<void>;
}

// 该文件中接口在API20可用，SceneBoard仓升级到API20后删除该文件并使用系统提供的接口
export function forceVolumeKeyControlType(volumeType: audio.AudioVolumeType, duration: number): Promise<void> {
  const manager = audio.getAudioManager().getVolumeManager() as VolumeManager;
  return manager.forceVolumeKeyControlType(volumeType, duration);
}
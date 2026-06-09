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

export interface VolumeWindowStateListener {
  onVolumeWindowStateChanged: Function,
  onVolumeWindowSizeChanged: Function,
  beforeVolumeWindowShow: Function,
  onOoberStateChanged: Function,
  onVolumeDisplayChanged: Function,
  onTouchVolumeOutSide: Function,
  onDeviceConfigChanged: Function,
  onRingerModeChanged?: Function;
}

export interface VolumeChangedListener {
  onVolumeChanged: Function,
  onVolumeActiveTypeChanged: Function,
  onActiveTypeChanged: Function,
  onVolumeTypeChanged: Function,
  volumeIndex: number,
}

export interface VolumeKeyPressedListener {
  onVolumeKeyPressed: Function,
  // 包含未拉出音量条时的keyPressed
  onKeyPressed?: Function,
  // 音量键抬手事件
  onKeyUp?: Function,
}

export interface VolumeListener { updateVolumeInfo: Function };

export interface PreviousVolumeCallback { getPreviousVolume: Function };

export interface OutputDeviceListener { updateOutputDevice: Function };
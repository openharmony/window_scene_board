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
/* instrument ignore file */
import type audio from '@ohos.multimedia.audio';

enum AudioIoType {
  INPUT_AUDIO_DEVICE_TYPE,
  OUTPUT_AUDIO_DEVICE_TYPE
}

/**
 * PC Audio Settings Audio Device POJO
 */
class PcAudioDevice {
  private deviceName: string;
  private description: string;
  private ioType: AudioIoType;
  private deviceType: audio.DeviceType;
  private deviceIndex: number;
  private audioDeviceDescriptor: audio.AudioDeviceDescriptor;
  private viewIndex?: number;

  public constructor(
    id: number,
    title: string,
    desc: string,
    kind: AudioIoType,
    dt: audio.DeviceType,
    add: audio.AudioDeviceDescriptor
  ) {
    this.deviceName = title;
    this.description = desc;
    this.ioType = kind;
    this.deviceIndex = id;
    this.deviceType = dt;
    this.audioDeviceDescriptor = add;
  }

  public getDeviceName(): string {
    return this.deviceName;
  }

  public setDeviceName(name: string): void {
    this.deviceName = name;
  }

  public getDescription(): string {
    return this.description;
  }

  public setDescription(desc: string): void {
    this.description = desc;
  }

  public getIoType(): AudioIoType {
    return this.ioType;
  }

  public setIoType(kind: AudioIoType): void {
    this.ioType = kind;
  }

  public getDeviceIndex(): number {
    return this.deviceIndex;
  }

  public getDeviceType(): audio.DeviceType {
    return this.deviceType;
  }

  public getAudioDeviceDescriptor(): audio.AudioDeviceDescriptor {
    return this.audioDeviceDescriptor;
  }

  public setViewIndex(value: number): void {
    this.viewIndex = value;
  }

  public getViewIndex(): number | undefined {
    return this.viewIndex;
  }
}

// 导出类型定义
export { AudioIoType, PcAudioDevice };

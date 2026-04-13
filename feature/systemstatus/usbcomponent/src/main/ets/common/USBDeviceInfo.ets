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
import fileExtensionInfo from '@ohos.file.fileExtensionInfo';


export class USBDeviceInfo {
  public diskId: string;
  public volumeId: string;
  public uuid: string;
  public description: string;
  public flags?: number;
  public fsType?: number;
  public uri?: string = '';
  public deviceType?: number = fileExtensionInfo.DeviceType.DEVICE_EXTERNAL_USB;
  public displayName?: string = '';
  public path?: string;
  public relativePath?: string;

  constructor(diskId: string, volumeId: string, uuid: string, description: string, flags?: number, fsType?: number,
    uri?: string, deviceType?: number, displayName?: string, path?: string, relativePath?: string) {
    this.diskId = diskId;
    this.volumeId = volumeId;
    this.uuid = uuid;
    this.description = description;
    this.flags = flags;
    this.fsType = fsType;
    this.uri = uri;
    this.deviceType = deviceType;
    this.displayName = displayName;
    this.path = path;
    this.relativePath = relativePath;
  }
}
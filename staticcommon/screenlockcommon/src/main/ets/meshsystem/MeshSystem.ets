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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'MeshSystem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class MeshRange {
  public rangeStart: number;
  public rangeEnd: number;

  constructor(rangeStart: number = 0, rangeEnd: number = 0) {
    this.rangeStart = rangeStart;
    this.rangeEnd = rangeEnd;
  }

  public getRangeStart(): number {
    return this.rangeStart;
  }

  public getRangeEnd(): number {
    return this.rangeEnd;
  }
}

export class MeshRangeInfo {
  private clockMeshRange: MeshRange = new MeshRange();
  private panelMeshRange: MeshRange = new MeshRange();
  private notificationMeshRange: MeshRange = new MeshRange();

  constructor() {
  }

  public setClockMeshRangeInfo(meshRange: MeshRange): void {
    this.clockMeshRange = meshRange;
  }

  public setPanelMeshRangeInfo(meshRange: MeshRange): void {
    this.panelMeshRange = meshRange;
  }

  public setNotificationMeshRangeInfo(meshRange: MeshRange): void {
    this.notificationMeshRange = meshRange;
  }

  public setMeshRangeInfo(clockMeshRange: MeshRange, panelMeshRange: MeshRange,
    notificationMeshRange: MeshRange): void {
    this.clockMeshRange = clockMeshRange;
    this.panelMeshRange = panelMeshRange;
    this.notificationMeshRange = notificationMeshRange;
  }

  public getClockMeshRangeInfo(): MeshRange {
    return this.clockMeshRange;
  }

  public getPanelMeshRangeInfo(): MeshRange {
    return this.panelMeshRange;
  }

  public getNotificationMeshRangeInfo(): MeshRange {
    return this.notificationMeshRange;
  }
}

export class MeshConfig {
  private static instance: MeshConfig;

  public meshHeight: number = 0;
  public maxScreenLockMesh: number = 0;

  public static getInstance(): MeshConfig {
    if (!MeshConfig.instance) {
      MeshConfig.instance = new MeshConfig();
    }
    return MeshConfig.instance;
  }
}

let meshConfig: MeshConfig = MeshConfig.getInstance();

export default meshConfig as MeshConfig;
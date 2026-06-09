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

const TAG = 'ScreenLockFormPanelMeshConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const DIMENSION_2_2_GRID_AMOUNT_X: number = 2;
const DIMENSION_2_2_GRID_AMOUNT_Y: number = 2;
const DIMENSION_1_4_GRID_AMOUNT_X: number = 4;
const DIMENSION_1_4_GRID_AMOUNT_Y: number = 1;

export type OnPanelMeshYChange = () => void; // 卡片栅格高度监听

@Observed
export class ScreenLockFormPanelMeshConfig {
  private static instance: ScreenLockFormPanelMeshConfig;

  public panelBeginMeshX: number = 0;
  public panelBeginMeshY: number = DIMENSION_1_4_GRID_AMOUNT_X;
  public panelMeshX: number = 0;
  private panelMeshY: number = 0;
  @Track public isPanelVisible: boolean = true;
  private meshYListener?: OnPanelMeshYChange;

  public static getInstance(): ScreenLockFormPanelMeshConfig {
    if (!ScreenLockFormPanelMeshConfig.instance) {
      ScreenLockFormPanelMeshConfig.instance = new ScreenLockFormPanelMeshConfig();
    }
    return ScreenLockFormPanelMeshConfig.instance;
  }

  setPanelBeginMesh(panelBeginMesh: number) {
    log.showInfo(`setPanelBeginMesh is ${panelBeginMesh}`);
    this.panelBeginMeshY = panelBeginMesh;
  }

  setPanelHeight(panelHeight: number): void {
    log.showInfo(`setPanelHeight is ${panelHeight}`);
    if (panelHeight === DIMENSION_1_4_GRID_AMOUNT_Y) {
      this.panelMeshX = DIMENSION_1_4_GRID_AMOUNT_X;
      this.updatePanelMeshY(DIMENSION_1_4_GRID_AMOUNT_Y);
      this.panelBeginMeshX = 0;
    } else if (panelHeight === DIMENSION_2_2_GRID_AMOUNT_Y) {
      this.panelMeshX = DIMENSION_2_2_GRID_AMOUNT_X;
      this.updatePanelMeshY(DIMENSION_2_2_GRID_AMOUNT_Y);
      this.panelBeginMeshX = 1;
    } else {
      this.updatePanelMeshY(0);
    }
  }

  public setPanelMeshYChangeListener(listener: OnPanelMeshYChange): void { // 监听卡片栅格高度变化
    this.meshYListener = listener;
  }

  public getPanelMeshY(): number { // 卡片面板栅格高度
    return this.panelMeshY;
  }

  private updatePanelMeshY(meshY: number): void {
    if (this.panelMeshY !== meshY) {
      this.panelMeshY = meshY;
      this.meshYListener?.();
    }
  }
}

let screenLockFormPanelMeshConfig: ScreenLockFormPanelMeshConfig = ScreenLockFormPanelMeshConfig.getInstance();

export default screenLockFormPanelMeshConfig as ScreenLockFormPanelMeshConfig
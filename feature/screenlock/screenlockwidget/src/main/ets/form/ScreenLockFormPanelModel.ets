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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sEventManager, obtainLocalEvent } from '@ohos/frameworkwrapper';
import { ComponentType, ComponentCallback, KeyguardStatusService } from '@ohos/screenlockcommon';
import { ScreenLockHeadManager } from '@ohos/screenlockcommon/Index';
import { MeshRange } from '@ohos/screenlockcommon';
import ScreenLockFormPanelMeshConfig, { OnPanelMeshYChange } from './ScreenLockFormPanelMeshConfig';

const TAG = 'ScreenLockFormPanelModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 卡片变化类型
 */
export enum FormPanelChange {
  PANEL_VISIBLE = 'panelVisible',
  PANEL_MOVE = 'panelMove',
}

/**
 * form panel view model
 *
 * @since 2024-03-12
 */
export class ScreenLockFormPanelModel {
  private static instance: ScreenLockFormPanelModel;
  private panelMeshRange: MeshRange = new MeshRange();
  private isNtfListCollapsed: boolean = true;
  private outMeshRange?: MeshRange; // 外部栅格占用
  private onMeshYChange: OnPanelMeshYChange = (): void => { // 卡片栅格高度切换
    if (this.outMeshRange) { // 刷新卡片可见性
      this.onMeshUsageChange(this.outMeshRange);
    }
  };

  public init(): void {
    log.showInfo('ScreenLockFormPanelModel init');
    this.panelMeshRange = new MeshRange(ScreenLockFormPanelMeshConfig.panelBeginMeshY,
      ScreenLockFormPanelMeshConfig.panelBeginMeshY + ScreenLockFormPanelMeshConfig.getPanelMeshY());
    ScreenLockHeadManager.initHeadMeshRange(ComponentType.FORM_PANEL, this.panelMeshRange);
    ScreenLockHeadManager.registerComponentCallback(ComponentType.FORM_PANEL, this.panelChangeCallback);
    ScreenLockFormPanelMeshConfig.setPanelMeshYChangeListener(this.onMeshYChange);
  }

  public destroy(): void {
    log.showInfo('ScreenLockFormPanelModel Destroy');
    ScreenLockHeadManager.unRegisterComponentCallback(ComponentType.FORM_PANEL, this.panelChangeCallback);
  }

  public static getInstance(): ScreenLockFormPanelModel {
    if (!ScreenLockFormPanelModel.instance) {
      ScreenLockFormPanelModel.instance = new ScreenLockFormPanelModel();
    }
    return ScreenLockFormPanelModel.instance;
  }

  private panelChangeCallback: ComponentCallback = {
    onRangeChange: (meshRange: MeshRange): void => {
      this.onMeshUsageChange(meshRange, (result) => {
        log.showInfo('onMeshUsageChange set panel MeshRange');
        ScreenLockHeadManager.setPanelMeshRange(result);
      });
    }
  }

  public updateFormPanelVisible(): void {
    // 通知展开或者问候语显示都会隐藏卡片
    if (!this.isNtfListCollapsed || KeyguardStatusService.isSlGreetMode()) {
      sEventManager.publish(obtainLocalEvent(FormPanelChange.PANEL_VISIBLE, false));
      ScreenLockFormPanelMeshConfig.isPanelVisible = false;
    } else {
      sEventManager.publish(obtainLocalEvent(FormPanelChange.PANEL_VISIBLE, true));
      ScreenLockFormPanelMeshConfig.isPanelVisible = true;
    }
  }

  private printRangeInfo(meshRange: MeshRange) {
    log.showInfo(`onMeshUsageChange meshRange start is ${meshRange.rangeStart}, end is ${meshRange.rangeEnd}， ${ScreenLockFormPanelMeshConfig.getPanelMeshY()}`);
  }

  private async onMeshUsageChange(meshRange: MeshRange, onResultCallback?: (result: MeshRange) => void): Promise<void> {
    this.outMeshRange = meshRange;
    this.printRangeInfo(meshRange);
    // 起始位置不相同，做move
    if (this.panelMeshRange.rangeStart !== meshRange.rangeStart) {
      let moveDistance: number = this.panelMeshRange.rangeStart - meshRange.rangeStart;
      sEventManager.publish(obtainLocalEvent(FormPanelChange.PANEL_MOVE, moveDistance));
    }
    let panelHeight = ScreenLockFormPanelMeshConfig.getPanelMeshY(); // 无卡片保持不可见
    if (meshRange.rangeEnd - meshRange.rangeStart > 0 && meshRange.rangeEnd - meshRange.rangeStart >= panelHeight) {
      this.isNtfListCollapsed = true;
      this.updateFormPanelVisible();
      this.panelMeshRange = new MeshRange(meshRange.rangeStart,
        meshRange.rangeStart + panelHeight);
    } else {
      this.isNtfListCollapsed = false;
      this.updateFormPanelVisible();
      this.panelMeshRange = new MeshRange(meshRange.rangeStart, meshRange.rangeStart);
    }
    this.printRangeInfo(this.panelMeshRange);
    onResultCallback?.(this.panelMeshRange);
  }
}

let screenLockFormPanelModel: ScreenLockFormPanelModel = ScreenLockFormPanelModel.getInstance();

export default screenLockFormPanelModel as ScreenLockFormPanelModel
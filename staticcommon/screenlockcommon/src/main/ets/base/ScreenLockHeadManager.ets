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
import { MeshRange } from '../meshsystem/MeshSystem';
import { screenLockInnerStateManager } from './ScreenLockInnerStateManager';
import { BaseMeshViewModel, ComponentType, ComponentCallback } from './BaseMeshViewModel';

const TAG = 'ScreenLockHeadManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

class TopHeadMeshRange {
  public clockMesh?: MeshRange;
  public panelMesh?: MeshRange;
}

/**
 * 锁屏上方head区域网格管理
 *
 * @since 2024-03-22
 */
export class ScreenLockHeadManager extends BaseMeshViewModel {
  private static instance: ScreenLockHeadManager;
  private topHeadMeshRange: TopHeadMeshRange = new TopHeadMeshRange();
  private headBeginMesh: number = 0;
  private headTopHeight: number = 0;
  protected headMeshHeight: number = 0;
  private initPanelMesh: number = 0;

  /**
   * head区域网格管理instance初始化
   */
  public static getInstance(): ScreenLockHeadManager {
    if (!ScreenLockHeadManager.instance) {
      ScreenLockHeadManager.instance = new ScreenLockHeadManager();
    }
    return ScreenLockHeadManager.instance;
  }

  /**
   * head区域网格管理init
   */
  public init(): void {
    screenLockInnerStateManager.registerComponentCallback(ComponentType.TOP_HEAD, this.rangeChangeCallback);
  }

  /**
   * head区域网格管理destroy
   */
  public destroy(): void {
    screenLockInnerStateManager.unRegisterComponentCallback(ComponentType.TOP_HEAD, this.rangeChangeCallback);
  }

  /**
   * 初始化Head网格信息
   *
   * @param componentType 组件类型
   * @param meshRange 网格信息
   */
  public async initHeadMeshRange(componentType: string, meshRange: MeshRange): Promise<void> {
    log.showInfo(`componentType: ${componentType}, initHeadMeshRange meshRange: ${meshRange.rangeStart}, ${meshRange.rangeEnd}`);
    switch (componentType) {
      case ComponentType.CLOCK:
        this.topHeadMeshRange.clockMesh = meshRange;
        this.headTopHeight = meshRange.rangeEnd - meshRange.rangeStart;
        this.headBeginMesh = meshRange.rangeStart;
        break;
      case ComponentType.FORM_PANEL:
        this.topHeadMeshRange.panelMesh = meshRange;
        this.initPanelMesh = meshRange.rangeEnd - meshRange.rangeStart;
        break;
      default:
        break;
    }
    this.updateHeadRange();
  }

  private updateHeadRange(): void {
    if (!this.topHeadMeshRange.clockMesh) {
      this.topHeadMeshRange.clockMesh = new MeshRange(0, this.topHeadMeshRange?.panelMesh?.rangeStart);
    }
    this.headMeshHeight = this.headTopHeight + this.initPanelMesh;
    screenLockInnerStateManager.requestUseMesh(ComponentType.TOP_HEAD,
      new MeshRange(this.topHeadMeshRange.clockMesh.rangeStart,
        this.topHeadMeshRange.clockMesh.rangeStart + this.headMeshHeight));
  }

  /**
   * 设置组件网格范围
   *
   * @param meshRange 网格范围
   */
  public setClockMeshRange(meshRange: MeshRange): void {
    if (meshRange.rangeEnd > ((this.topHeadMeshRange?.clockMesh?.rangeEnd ?? 0) as number) ||
      meshRange.rangeEnd - meshRange.rangeStart < this.headTopHeight) {
      this.topHeadMeshRange.panelMesh = new MeshRange(meshRange.rangeEnd, meshRange.rangeEnd);
    } else {
      log.showInfo(`topHeadMeshRange panelMeshRange rangeEnd is ${this.topHeadMeshRange?.panelMesh?.rangeEnd}`);
      this.topHeadMeshRange.panelMesh = new MeshRange(meshRange.rangeEnd, this.topHeadMeshRange?.panelMesh?.rangeEnd);
    }
    this.topHeadMeshRange.clockMesh = meshRange;
    this.handleComponentCallback(ComponentType.FORM_PANEL, this.topHeadMeshRange.panelMesh);
  }

  /**
   * 设置组件网格范围
   *
   * @param meshRange 网格范围
   */
  public setPanelMeshRange(meshRange: MeshRange): void {
    this.topHeadMeshRange.panelMesh = meshRange;
  }

  private rangeChangeCallback: ComponentCallback = {
    onRangeChange: (meshRange: MeshRange): void => {
      this.onMeshUsageChange(meshRange, (result) => {
        log.showDebug('onRangeChange set topHead meshRangeInfo');
        screenLockInnerStateManager.requestUseMesh(ComponentType.TOP_HEAD, result);
      });
    }
  };

  private async onMeshUsageChange(meshRange: MeshRange, onResultCallback: (result: MeshRange) => void): Promise<void> {
    log.showInfo(`headBeginMesh is ${this.headBeginMesh}`);
    if ((this.topHeadMeshRange?.panelMesh?.rangeEnd ?? 0) as number > meshRange.rangeEnd) {
      // 通知区域和上方区域有重叠
      this.handleRangeOverlay(meshRange);
    } else {
      // 通知区域和上方区域无重叠
      this.handleRangeNotOverlay(meshRange);
    }
    this.handleComponentCallback(ComponentType.CLOCK, this.topHeadMeshRange.clockMesh);
    onResultCallback(new MeshRange(this.topHeadMeshRange?.clockMesh?.rangeStart,
      this.topHeadMeshRange?.panelMesh?.rangeEnd));
  }

  protected handleRangeOverlay(meshRange: MeshRange): void {
    log.showInfo('handleRangeOverlay');
    if (meshRange.rangeEnd >= this.headMeshHeight) {
      // 通知开始位置高于上方区域的高度，只做位移
      let moveDistance: number = (this.topHeadMeshRange?.panelMesh?.rangeEnd ?? 0) as number - meshRange.rangeEnd;
      this.topHeadMeshRange.clockMesh =
        new MeshRange((this.topHeadMeshRange?.clockMesh?.rangeStart ?? 0) as number - moveDistance,
          (this.topHeadMeshRange?.clockMesh?.rangeEnd ?? 0) as number - moveDistance);
      this.topHeadMeshRange.panelMesh =
        new MeshRange((this.topHeadMeshRange?.panelMesh?.rangeStart ?? 0) as number - moveDistance,
          (this.topHeadMeshRange?.panelMesh?.rangeEnd ?? 0) as number - moveDistance);
    } else {
      // 通知开始位置低于上方区域的高度，重新刷新时钟和卡片range
      this.topHeadMeshRange.clockMesh = new MeshRange(0, meshRange.rangeEnd);
      this.topHeadMeshRange.panelMesh = new MeshRange(meshRange.rangeEnd, meshRange.rangeEnd);
    }
  }

  private handleRangeNotOverlay(meshRange: MeshRange): void {
    log.showInfo('handleRangeNotOverlay');
    if (meshRange.rangeEnd >= this.headMeshHeight &&
      this.topHeadMeshRange?.clockMesh?.rangeStart !== this.headBeginMesh) {
      // 通知开始位置高于上方区域的高度
      let beginMesh: number = meshRange.rangeEnd - this.headMeshHeight;
      beginMesh = beginMesh > this.headBeginMesh ? this.headBeginMesh : beginMesh;
      this.topHeadMeshRange.clockMesh = new MeshRange(beginMesh, meshRange.rangeEnd);
      this.topHeadMeshRange.panelMesh = new MeshRange(meshRange.rangeEnd, meshRange.rangeEnd);
    } else {
      // 通知开始位置低于上方区域的高度或者在初始位置
      this.topHeadMeshRange.clockMesh = new MeshRange(0, meshRange.rangeEnd);
      this.topHeadMeshRange.panelMesh = new MeshRange(meshRange.rangeEnd, meshRange.rangeEnd);
    }
  }
}

let screenLockHeadManager: ScreenLockHeadManager = ScreenLockHeadManager.getInstance();

export default screenLockHeadManager as ScreenLockHeadManager;
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
import { AnyClock } from '../../editsheet/models/AnyClock';
import { clockWidgetConfigManager } from '../common/ClockWidgetConfigManager';

const TAG = 'Screenlock-ClockWidgeMeshConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const CLOCK_TOP_MESH = 0;
const DEFAULT_CLOCK_LAYOUT_AMOUNT_X: number = 4;
const DEFAULT_CLOCK_LAYOUT_AMOUNT_Y: number = 4;
const NORMAL_CLOCK_LAYOUT_AMOUNT_X: number = 4;
const NORMAL_CLOCK_LAYOUT_AMOUNT_Y: number = 2;

// 时钟网格参数切换回调
export type OnClockMeshChange = () => void;

/**
 * 时钟网格Config
 */
export class ClockWidgetMeshConfig {
  private static instance: ClockWidgetMeshConfig;

  // 监听器
  private readonly meshListeners: Set<OnClockMeshChange> = new Set();
  public clockTopMesh: number = CLOCK_TOP_MESH;
  public maxClockMeshX: number = DEFAULT_CLOCK_LAYOUT_AMOUNT_X;
  public maxClockMeshY: number = DEFAULT_CLOCK_LAYOUT_AMOUNT_Y;
  public minClockMeshX: number = NORMAL_CLOCK_LAYOUT_AMOUNT_X;
  public minClockMeshY: number = NORMAL_CLOCK_LAYOUT_AMOUNT_Y;
  public clockBeginMeshX: number = CLOCK_TOP_MESH;
  public clockBeginMeshY: number = CLOCK_TOP_MESH;

  /**
   * 时钟网格config信息instance
   */
  public static getInstance(): ClockWidgetMeshConfig {
    if (!ClockWidgetMeshConfig.instance) {
      ClockWidgetMeshConfig.instance = new ClockWidgetMeshConfig();
    }
    return ClockWidgetMeshConfig.instance;
  }

  /**
   * 注册栅格切换监听
   *
   * @param li 监听器
   */
  public registerMeshChangeListener(li: OnClockMeshChange): void {
    this.meshListeners.add(li);
  }

  /**
   * 注销栅格切换监听
   *
   * @param li 监听器
   */
  public unregisterMeshChangeListener(li: OnClockMeshChange): void {
    this.meshListeners.delete(li);
  }

  /**
   * 设置时钟网格config信息
   *
   * @param clockStyle 时钟类型
   */
  public setClockMesh(clockStyle: AnyClock) {
    let expandGrid = clockWidgetConfigManager.getExpandClockGridType(clockStyle.layout);
    this.maxClockMeshX = expandGrid?.gridWidthAmount ?? DEFAULT_CLOCK_LAYOUT_AMOUNT_X;
    this.maxClockMeshY = expandGrid?.gridHeightAmount ?? DEFAULT_CLOCK_LAYOUT_AMOUNT_Y;
    let collapseGrid = clockWidgetConfigManager.getCollapseClockGridType(clockStyle.layout);
    this.minClockMeshX = collapseGrid?.gridWidthAmount ?? NORMAL_CLOCK_LAYOUT_AMOUNT_X;
    this.minClockMeshY = collapseGrid?.gridHeightAmount ?? NORMAL_CLOCK_LAYOUT_AMOUNT_Y;

    this.clockBeginMeshX = clockStyle.x;
    this.clockBeginMeshY = clockStyle.y;
    this.clockTopMesh = CLOCK_TOP_MESH;

    // 栅格变化回调
    this.meshListeners.forEach((li) => li?.());
  }
}

let clockWidgetMeshConfig: ClockWidgetMeshConfig = ClockWidgetMeshConfig.getInstance();

export default clockWidgetMeshConfig as ClockWidgetMeshConfig
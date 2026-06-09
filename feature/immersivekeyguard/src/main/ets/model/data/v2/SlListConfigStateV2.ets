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

import { SlListConfigStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ColumnGutter, SlConfigBaseState } from '@ohos/screenlockcommon/Index';

/**
 * 沉浸列表配置状态管理器
 */
export class SlListConfigStateV2 extends SlConfigBaseState<SlListConfigStPt, SlListConfigStateV2> {
  // 顶部时钟占用高度，配置高度
  private _topClockHeight: number = 0;

  // 底部小工具占用高度，配置高度
  private _bottomToolsHeight: number = 0;

  // 栅格计算配置，赋值则按栅格计算宽度
  private _gutterConfig?: ColumnGutter;

  protected constructor() {
    super(SlStateId.SL_LIST_STATE);
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlListConfigStPt.PT_TOP_CLOCK_HEIGHT, this.setTopClockHeight);
    this.addSetMethod(SlListConfigStPt.PT_BOTTOM_TOOLS_HEIGHT, this.setBottomToolsHeight);
    this.addSetMethod(SlListConfigStPt.PT_GUTTER_CONFIG, this.setGutterConfig);
  }

  protected getTarInstance(): SlListConfigStateV2 {
    return this;
  }

  /**
   * 赋值顶部时钟配置高度
   *
   * @param height 高度
   * @returns 链式
   */
  public setTopClockHeight(height: number): SlListConfigStateV2 {
    let result = height ?? 0;
    if (this._topClockHeight !== result) {
      this._topClockHeight = result;
      this.notifyStateChange(SlListConfigStPt.PT_TOP_CLOCK_HEIGHT);
    }
    return this;
  }

  /**
   * 取值顶部时钟配置高度
   *
   * @returns 高度
   */
  public getTopClockHeight(): number {
    return this._topClockHeight;
  }

  /**
   * 赋值底部小工具配置高度
   *
   * @param height 高度
   * @returns 链式
   */
  public setBottomToolsHeight(height: number): SlListConfigStateV2 {
    let result = height ?? 0;
    if (this._bottomToolsHeight !== result) {
      this._bottomToolsHeight = result;
      this.notifyStateChange(SlListConfigStPt.PT_BOTTOM_TOOLS_HEIGHT);
    }
    return this;
  }

  /**
   * 取值底部小工具配置高度
   *
   * @returns 高度
   */
  public getBottomToolsHeight(): number {
    return this._bottomToolsHeight;
  }

  /**
   * 赋值栅格计算配置
   *
   * @param gutter 栅格配置
   */
  public setGutterConfig(gutter?: ColumnGutter): SlListConfigStateV2 {
    if (this._gutterConfig !== gutter) {
      this._gutterConfig = gutter;
      this.notifyStateChange(SlListConfigStPt.PT_GUTTER_CONFIG);
    }
    return this;
  }

  /**
   * 栅格计算配置
   *
   * @returns 栅格配置
   */
  public getGutterConfig(): ColumnGutter | undefined {
    return this._gutterConfig;
  }
}
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import { STATUS_WINDOW_LEFT_SCALE } from './GlassStatusbarManager';

const TAG: string = 'GlassStatusbarHoverManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);
const HIDE_POSITION_X = -36;

export class GlassStatusbarHoverManager {
  private static instance?: GlassStatusbarHoverManager;

  private constructor() {
  }

  public static getInstance(): GlassStatusbarHoverManager {
    if (!GlassStatusbarHoverManager.instance) {
      log.showInfo(`getInstance new instance`);
      GlassStatusbarHoverManager.instance = new GlassStatusbarHoverManager();
    }
    return GlassStatusbarHoverManager.instance;
  }

  public static destroyInstance(): void {
    if (!GlassStatusbarHoverManager.instance) {
      log.info('The GlassStatusbarHoverManager has not instantiated');
      return;
    }
    log.showInfo(`destroyInstance`);
    GlassStatusbarHoverManager.instance = undefined;
  }

  /**
   * 初始化
   */
  public init(): void {
    this.showAssist();
  }

  /**
   * 更新位置
   *
   * @param area 位置信息
   */
  public updateHoverPosition(area: Area): void {
    const width = vp2px(area.width as number);
    const height = vp2px(area.height as number);
    const left = (GlassLayoutManager.getInstance().getScreenWidthPx() - width) / STATUS_WINDOW_LEFT_SCALE;
    log.showInfo(`updateHoverPosition,width is ${width},height is ${height},left is ${left}`)
    GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_STATUS_BAR_HOVER, {
      left: left,
      height: height,
      width: width
    })
  }

  private async showAssist(): Promise<void> {
    GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_STATUS_BAR_HOVER);
    GlassSystemSceneManager.getInstance().setSystemViewOpacity(GlassSystemSceneType.GLASS_STATUS_BAR_HOVER, 1);
    GlassSystemSceneManager.getInstance()
      .updateWindowRect(GlassSystemSceneType.GLASS_STATUS_BAR_HOVER, { top: HIDE_POSITION_X })
  }
}
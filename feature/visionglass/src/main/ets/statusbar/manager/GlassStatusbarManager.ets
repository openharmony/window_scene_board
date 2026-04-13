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

import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import { GlassStatusManager } from '../../common/manager/GlassStatusManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { SCBSceneSession } from '@ohos/windowscene/src/main/ets/TsIndex';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';

const TAG: string = 'GlassStatusbarManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);
const SHOW_POSITION_Y = 20;
const HIDE_DELAY_TIME = 3 * 1000;

export const STATUS_WINDOW_LEFT_SCALE: number = 2;

export class GlassStatusbarManager {
  private static instance?: GlassStatusbarManager;
  private hasActiveAppScene: boolean = false;
  private timer: number | null = null;
  private isScenePanelShow: boolean = false;

  private constructor() {
  }

  public static getInstance(): GlassStatusbarManager {
    if (!GlassStatusbarManager.instance) {
      GlassStatusbarManager.instance = new GlassStatusbarManager();
    }
    return GlassStatusbarManager.instance;
  }

  public static destroyInstance(): void {
    if (!GlassStatusbarManager.instance) {
      log.info('The GlassStatusbarManager has not instantiated');
      return;
    }
    GlassStatusbarManager.instance.release();
    GlassStatusbarManager.instance = undefined;
  }

  /**
   * 初始化
   */
  public init(): void {
    log.showInfo(`init`);
    this.hasActiveAppScene = false;
    this.show();
    GlassStatusManager.getInstance().activeSystemScene?.subscribe(this.systemSceneListener);
    GlassStatusManager.getInstance().activeAppScene?.subscribe(this.activeAppSceneListener);
  }

  /**
   * 销毁
   */
  public release(): void {
    log.showInfo(`release`);
    GlassStatusManager.getInstance().activeSystemScene?.unsubscribe(this.systemSceneListener);
    GlassStatusManager.getInstance().activeAppScene?.unsubscribe(this.activeAppSceneListener);
  }

  /**
   * 更新位置
   *
   * @param area 位置信息
   */
  public updatePosition(area: Area): void {
    const width = vp2px(area.width as number);
    const height = vp2px(area.height as number);
    const left = (GlassLayoutManager.getInstance().getScreenWidthPx() - width) / STATUS_WINDOW_LEFT_SCALE;
    log.showInfo(`updatePosition,left is ${left}，height：${height}`);
    GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_STATUS_BAR, {
      left: left,
      height: height,
      width: width
    })
  }

  /**
   * 鼠标悬停
   *
   * @param isHover 是否处于鼠标悬停
   */
  public onHover(isHover: boolean): void {
    if (isHover && this.hasActiveAppScene) {
      this.show();
      this.clearTimeOut();
      return;
    }
    if (!isHover && this.hasActiveAppScene) {
      this.timer = setTimeout(() => {
        this.hide();
        this.timer = null;
      }, HIDE_DELAY_TIME);
    }
  }

  private clearTimeOut() {
    if (this.timer !== null) {
      clearTimeout(this.timer);
      this.timer = null;
    }
  }

  private show(): void {
    GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_STATUS_BAR);
    GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_STATUS_BAR, {
      top: SHOW_POSITION_Y
    })
  }

  private hide(): void {
    GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_STATUS_BAR);
  }

  private activeAppSceneListener = (set: Set<SCBSceneSession>): void => {
    this.hasActiveAppScene = !!set.size;
    // 添加横幅状态判断，避免接收到通知之后，打开应用再退出应用后状态栏会显示
    if (this.hasActiveAppScene || this.isScenePanelShow) {
      this.hide();
    } else {
      this.show();
      this.clearTimeOut();
    }
  };
  private systemSceneListener = (map: Map<GlassSystemSceneType, boolean>): void => {
    const status = map.get(GlassSystemSceneType.GLASS_BANNER);
    log.showInfo(`systemSceneListener isScenePanelShow：${this.isScenePanelShow},new banner status:${status}`);
    if (this.isScenePanelShow) {
      if (!status) {
        this.isScenePanelShow = false;
        if (!this.hasActiveAppScene) {
          this.show();
        }
      }
      return;
    }
    if (status) {
      this.isScenePanelShow = true;
      GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_STATUS_BAR);
    }
  }
}
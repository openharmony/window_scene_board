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

import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import { GlassSceneManager, Rect } from '../../scene/common/GlassSceneManager';
import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import GlassNtfConstant from '../common/GlassNtfConstant';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationUtil } from '../../notificationcenter/vm/NotificationGlassVm';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';

const TAG = 'GlassBannerPanelManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export const BANNER_PANEL_LEFT_SCALE: number = 2;

export class GlassBannerPanelManager {
  private static instance?: GlassBannerPanelManager;
  private windowRect?: Rect;
  private attrCallback?: () => void;

  private destroy(): void {
    this.attrCallback = undefined;
  }

  private constructor() {
  }

  /*
   * 获取横幅窗口管理类单实例
   *
   * @return GlassBannerPanelManager
   * */
  public static getInstance(): GlassBannerPanelManager {
    if (!GlassBannerPanelManager.instance) {
      GlassBannerPanelManager.instance = new GlassBannerPanelManager();
    }
    return GlassBannerPanelManager.instance;
  }

  /*
   * 销毁横幅管理类单实例
   *
   * */
  public static destroyInstance(): void {
    GlassBannerPanelManager.instance?.destroy();
    GlassBannerPanelManager.instance = undefined;
  }

  /*
   * 初始化横幅窗口rect
   * */
  public init(): void {
    this.windowRect = {
      top: GlassNtfConstant.BANNER_TOP,
      left: (GlassLayoutManager.getInstance().getScreenWidthPx() - GlassNtfConstant.BANNER_WIDTH) /
        BANNER_PANEL_LEFT_SCALE,
      width: GlassNtfConstant.BANNER_WIDTH,
      height: GlassNtfConstant.DEFAULT_BANNER_HEIGHT
    };
    this.attrCallback?.();
  }

  /*
   * 改变通知窗口显示隐藏状态
   *
   * @param visibility
   * */
  public setNtfWindowVisibility(visibility: boolean): void {
    log.info(`setNtfWindowVisibility`);
    if (visibility === undefined || visibility === null) {
      return;
    }
    if (visibility) {
      GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_BANNER);
    } else {
      GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_BANNER);
    }
  }

  /*
   * 注册横幅变更回调
   *
   * @param callback
   * */
  public registerAttrChanged(callback: () => void): void {
    if (!callback) {
      return;
    }
    this.attrCallback = callback;
  }

  /*
   * 获取横幅窗口rect
   *
   * @return  Rect | undefined
   * */
  public getPanelRect(): Rect | undefined {
    return this.windowRect;
  }

  /*
   * 按照消息类型刷新当前横幅窗口宽高定位
   * */
  public updateWindowRectByNtfType(ntf: NotificationEntry, isExpand: boolean) {
    if (!this.windowRect) {
      log.showInfo(`updateWindowRectByNtfType,windowRect is not exist`);
      return;
    }
    if (!NotificationUtil.isHintNtf(ntf)) {
      log.showInfo(`updateWindowRectByNtfType,type is hint`);
      this.windowRect.height = vp2px(GlassNtfConstant.HINT_HEIGHT);
      this.windowRect.width = vp2px(GlassNtfConstant.HINT_WIDTH);
    } else if (ntf.isLiveType()) {
      if (!GlassSceneManager.getInstance().isAliceAppForeground()) {
        this.windowRect.height = vp2px(GlassNtfConstant.HINT_HEIGHT);
        this.windowRect.width = vp2px(GlassNtfConstant.HINT_WIDTH);
      } else {
        this.windowRect.height = vp2px(GlassNtfConstant.LIVE_HEIGHT);
        this.windowRect.width = vp2px(GlassNtfConstant.LIVE_WIDTH);
      }
      log.showInfo(`updateWindowRectByNtfType,type is liveview`);
    } else {
      log.showInfo(`updateWindowRectByNtfType,type is normal`);
      this.windowRect.height = isExpand ? vp2px(GlassNtfConstant.EXPAND_HEIGHT) : vp2px(GlassNtfConstant.NORMAL_HEIGHT);
      this.windowRect.width = vp2px(GlassNtfConstant.NORMAL_WIDTH);
    }
    this.windowRect.left =
      (GlassLayoutManager.getInstance().getScreenWidthPx() - this.windowRect.width) / BANNER_PANEL_LEFT_SCALE;
    GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_BANNER, this.windowRect);
  }
}
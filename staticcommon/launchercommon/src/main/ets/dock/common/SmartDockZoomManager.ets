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
import { FolderLayoutUtil } from '../../utils/FolderLayoutUtil';
import { FolderStyleManager } from '../../folder/next/common/FolderStyleManager';
import { SmartDockZoomFeatureSwitch } from './SmartDockZoomFeatureSwitch';

const TAG = 'SmartDock_VM_SmartDockZoomManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_SCREEN_ID: number = 0;

/**
 * dock缩放功能管理类
 */
export class SmartDockZoomManager {
  private static dockScaleMap: Map<number, number> = new Map();
  private static isZooming: boolean = false;

  public static setIsZooming(value: boolean): void {
    SmartDockZoomManager.isZooming = value;
  }

  public static getIsZooming(): boolean {
    return SmartDockZoomManager.isZooming;
  }

  /**
   * 设置对应屏幕的dock缩放系数
   */
  public static setDockScale(scale: number, screen: number = DEFAULT_SCREEN_ID): void {
    log.showInfo('set screen: %{public}d  scale to %{public}d', screen, scale);
    SmartDockZoomManager.dockScaleMap.set(screen, scale);
    FolderLayoutUtil.dockZoomScale = scale;
    FolderStyleManager.getInstance().setDockZoomScale(scale);
  }

  public static getDockScale(screen: number = DEFAULT_SCREEN_ID): number {
    if (!SmartDockZoomManager.dockScaleMap.has(screen)) {
      return 1;
    }
    return SmartDockZoomManager.dockScaleMap.get(screen) ?? 1;
  }

  /**
   * dock当前是否在缩放
   */
  public static isZoom(screen: number = DEFAULT_SCREEN_ID): boolean {
    if (!SmartDockZoomFeatureSwitch.isSupportZoom()) {
      return false;
    }
    if (!SmartDockZoomManager.dockScaleMap.has(screen)) {
      return false;
    }
    if (SmartDockZoomManager.isZooming) {
      return true;
    }
    return (SmartDockZoomManager.dockScaleMap.get(screen) ?? 1) < 1;
  }
}

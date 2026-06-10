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
import {
  CommonUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { RotationConstants } from '@ohos/commonconstants';
import {
  CutoutEvent,
  EventManager,
  EvtBus,
  ViewArea
} from '@ohos/frameworkwrapper';
import { DisplayMgr, RecentsStyleConstants } from '@ohos/windowscene';
import { display } from '@kit.ArkUI';


const TAG = 'RecentDisplayManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 挖孔数据处理
 *
 * @since 2022-10-18
 */
export class RecentDisplayManager {
  private readonly DEFAULT_RATE: number = 120;
  /**
   * 屏幕高度
   */
  private displayHeight: number = 0;
  /**
   * 挖孔集
   * cutout_position => 挖孔区域
   */
  private cutouts: Map<number, ViewArea> = new Map();
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private _cutoutHeight: number = 0;
  /**
   * 真实旋转角度
   */
  private _realRotateAngle: number = RotationConstants.ROTATION_90;


  /**
   * 初始化
   */
  init(): void {
    log.showDebug('init recent display manager');
    this.eventMgr.on(CutoutEvent, this.handleCutoutEvent);
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    log.showDebug('onDestroy start destroy recent display manager');
    // 注销事假
    this.eventMgr.offAll();
  }

  /**
   * 获取挖孔数据
   *
   * @returns
   */
  public getCutouts(): Map<number, ViewArea> {
    return this.cutouts;
  }

  public set cutoutHeight(cutoutHeight: number) {
    this._cutoutHeight = cutoutHeight;
  }

  public get cutoutHeight(): number {
    return this._cutoutHeight;
  }

  public set realRotateAngle(realRotateAngle: number) {
    this._realRotateAngle = realRotateAngle;
  }

  public get realRotateAngle(): number {
    return this._realRotateAngle;
  }

  public isScreenVertical(): boolean {
    return this.realRotateAngle === RotationConstants.ROTATION_0 ||
      this.realRotateAngle === RotationConstants.ROTATION_180;
  }

  /**
   * 处理挖孔区域事件
   *
   * @param event 事件
   */
  private handleCutoutEvent = (event: CutoutEvent): void => {
    this.displayHeight = px2vp((DisplayMgr.getCacheDisplay()?.scbScreenProperty?.height) ?? 0);
    this.realRotateAngle = (DisplayMgr.getCacheDisplay()?.scbScreenProperty?.rotation) ?? 0;
    log.showInfo(`recent handleCutoutEvent,event.cutoutPosition: ${event?.cutoutPosition},event.cutoutRect: . \
      (${event?.cutoutRect?.left}, ${event?.cutoutRect?.top}, . \
      ${event?.cutoutRect?.width}, ${event?.cutoutRect?.height})`);
    // 缓存挖孔数据
    this.cutouts.set(event.cutoutPosition, event.cutoutRect);
    this._cutoutHeight = this.getCutoutHeight();
  };

  /**
   * 获取竖屏挖孔区域距离顶部高度，横屏为0
   *
   * @returns
   */
  public getCutoutHeight(): number {
    let cutoutHeight = 0;
    this.cutouts.forEach((value: ViewArea, key: number, map: Map<number, ViewArea>) => {
      if (value && value.height > 0) {
        // 取两个值中较小的值，确保挖空屏的高度计算正确
        cutoutHeight = Math.min(value.height + value.top, this.displayHeight - value.top);
      }
    });
    return cutoutHeight < this.displayHeight * RecentsStyleConstants.NORMAL_CUTOUT_HEIGHT_PERCENT ? cutoutHeight : 0;
  }

  public getRefreshRate(): number {
    try {
      let displayInfo: display.Display = display.getDefaultDisplaySync();
      if (CommonUtils.isInvalid(displayInfo)) {
        return this.DEFAULT_RATE;
      }
      return displayInfo.refreshRate;
    } catch (error) {
      log.error(`[RecentDisplayManager]getRefreshRate fail error: ${error}`);
      return this.DEFAULT_RATE;
    }
  }
}

export const recentDisplayManager: RecentDisplayManager = SingletonHelper.getInstance(RecentDisplayManager, TAG);
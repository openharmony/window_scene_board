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

import { CheckEmptyUtils, LogDomain, LogHelper, SingleBase, SingleContext, singleManager } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { InteractiveEvent, InteractiveType, themeWallpaperAniMgr } from '@ohos/themeservice/src/main/ets/TsIndex';

const TAG = 'GridSwiperWallpaperViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 壁纸滑动参数
 */
class WallpaperPosition {
  /**
   * 手指按压时位置
   */
  public touchEventDown: number[] = [0, 0];
  /**
   * 手指抬起时位置
   */
  public touchEventUp: number[] = [0, 0];
  /**
   * true发送开始滑动事件，false不发送
   */
  public sendMoveEnable: boolean = false;
} 

/**
 * 桌面滑动和双击与壁纸互动
 */
export class GridSwiperWallpaperViewModel extends SingleBase {
  public static singleName: string = 'GridSwiperWallpaperViewModel';

  private static mInstance: GridSwiperWallpaperViewModel;

  private wallpaperPosition: WallpaperPosition = new WallpaperPosition();

  constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(ctx?: SingleContext): GridSwiperWallpaperViewModel {
    return singleManager.get<GridSwiperWallpaperViewModel>(GridSwiperWallpaperViewModel, ctx);
  }

  public updateTouchEventDown(event: TouchEvent, isEditMode: boolean): void {
    if (isEditMode || CheckEmptyUtils.isEmpty(event) || CheckEmptyUtils.isEmptyArr(event.changedTouches)) {
      return;
    }
    this.wallpaperPosition.touchEventDown = [event.changedTouches[0].windowX, event.changedTouches[0].windowY];
  }

  public updateTouchEventUp(event: TouchEvent, isEditMode: boolean): void {
    if (isEditMode || CheckEmptyUtils.isEmpty(event) || CheckEmptyUtils.isEmptyArr(event.changedTouches)) {
      return;
    }
    this.wallpaperPosition.touchEventUp = [event.changedTouches[0].windowX, event.changedTouches[0].windowY];
  }

  public openSendMoveEnable(isEditMode: boolean): void {
    if (isEditMode) {
      return;
    }
    this.wallpaperPosition.sendMoveEnable = true;
  }

  public closeSendMoveEnable(isEditMode: boolean): void {
    if (isEditMode) {
      return;
    }
    this.wallpaperPosition.sendMoveEnable = false;
  }

  /**
   * 发送开始滑动事件
   * 壁纸左滑 currentOffset < lastSwipeOffset
   * 壁纸右滑 currentOffset > lastSwipeOffset
   */
  public sendMoveStart(currentOffset: number, lastSwipeOffset: number, isEditMode: boolean): void {
    if (!this.wallpaperPosition.sendMoveEnable || isEditMode || currentOffset === lastSwipeOffset) {
      return;
    }
    this.closeSendMoveEnable(isEditMode);
    let interactiveEvent: InteractiveEvent = {
      interactiveType: currentOffset < lastSwipeOffset ? InteractiveType.MOVE_LEFT_START :
      InteractiveType.MOVE_RIGHT_START,
      x: this.wallpaperPosition.touchEventDown[0],
      y: this.wallpaperPosition.touchEventDown[1]
    };
    log.showDebug(`sendMoveStart event=${this.interactiveEventToLog(interactiveEvent)}`);
    themeWallpaperAniMgr.sendHomeInteractiveEvent2Wallpaper(interactiveEvent);
  }

  /**
   * 发送移动结束事件
   * targetIndex - index
   * 等于0，桌面未滑动成功
   * 大于0，壁纸左滑
   * 小于0，壁纸右滑
   */
  public sendMovedEnd(index: number, targetIndex: number, isEditMode: boolean): void {
    if (isEditMode || targetIndex === index) {
      return;
    }
    let interactiveEvent: InteractiveEvent = {
      interactiveType: targetIndex > index ? InteractiveType.MOVE_LEFT_END : InteractiveType.MOVE_RIGHT_END,
      x: this.wallpaperPosition.touchEventUp[0],
      y: this.wallpaperPosition.touchEventUp[1]
    };
    log.showDebug(`sendMovedEnd event=${this.interactiveEventToLog(interactiveEvent)}`);
    themeWallpaperAniMgr.sendHomeInteractiveEvent2Wallpaper(interactiveEvent);
  }

  /**
   * 发送双击事件
   */
  public sendDoubleClicked(isEditMode: boolean): void {
    if (isEditMode) {
      return;
    }
    let interactiveEvent: InteractiveEvent = {
      interactiveType: InteractiveType.DOUBLE_CLICK,
      x: this.wallpaperPosition.touchEventDown[0],
      y: this.wallpaperPosition.touchEventDown[1]
    };
    log.showDebug(`sendDoubleClicked event=${this.interactiveEventToLog(interactiveEvent)}`);
    themeWallpaperAniMgr.sendHomeInteractiveEvent2Wallpaper(interactiveEvent);
  }

  /**
   * 发送单击事件
   */
  public sendSingleClicked(isEditMode: boolean): void {
    if (isEditMode || (!DeviceHelper.isPhone() && !DeviceHelper.isPad())) {
      return;
    }
    let interactiveEvent: InteractiveEvent = {
      interactiveType: InteractiveType.CLICK,
      x: this.wallpaperPosition.touchEventDown[0],
      y: this.wallpaperPosition.touchEventDown[1]
    };
    log.showDebug(`sendSingleClicked event=${this.interactiveEventToLog(interactiveEvent)}`);
    themeWallpaperAniMgr.sendHomeInteractiveEvent2Wallpaper(interactiveEvent);
  }

  private interactiveEventToLog(interactiveEvent: InteractiveEvent): string {
    return `{interactiveType:${interactiveEvent.interactiveType}, x:${interactiveEvent.x}, y:${interactiveEvent.y}}`;
  }
}
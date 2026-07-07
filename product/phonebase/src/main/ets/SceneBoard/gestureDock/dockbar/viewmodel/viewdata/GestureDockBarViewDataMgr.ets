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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { ResUtils } from '@ohos/windowscene';
import { desktopUtil, floatingNavigationInfoMgr, FloatingNavigationShowType, RTLUtil } from '@ohos/componenthelper';
import { layoutConfigManager, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FeatureConstants, SmartDockStyleConfig } from '@ohos/smartdock';
import { GestureDockConstants, GestureDockMode } from '../../../common/GestureDockConstants';
import { ScreenInfoUtil } from '../../../common/util/ScreenInfoUtil';
import { GestureDockViewModel } from '../../../dock/viewmodel/GestureDockViewModel';
import { GestureDockDirection, GestureDockState } from '../../../dock/viewmodel/viewevent/GestureDockViewEventMgr';
import { DockBarParam, DockBarOutParam, DockBarScrollerParam } from './GestureDockBarParam';
import { GestureDockBarViewData } from './GestureDockBarViewData';
import { DeviceHelper, sSettingsUtil } from '@ohos/frameworkwrapper';
import Display from '@ohos.display';
import { SCBAiBarConstants } from '../../../../aiBar/SCBAiBarConstants';

const TAG = 'GestureDockBarViewDataMgr';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockBarViewDataMgr
 */
export class GestureDockBarViewDataMgr implements GestureDockBarViewData {
  public dockBarParam: DockBarParam = new DockBarParam();
  public leftBarOutParam: DockBarOutParam = new DockBarOutParam();
  public rightBarOutParam: DockBarOutParam = new DockBarOutParam();
  public bottomGestureParams: DockBarOutParam = new DockBarOutParam();
  public dockBarScrollerParam: DockBarScrollerParam = new DockBarScrollerParam();
  public leftScroller: Scroller = new Scroller();
  public rightScroller: Scroller = new Scroller();
  public colorShowMode: number = 0;
  public endOffset: number = 0;
  public scrollTranslate: number = 0;
  private mSmartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);

  /**
   * 获取位移
   *
   * @param isLeft 方向
   * @returns translation 位移
   */
  public getTranslation(isLeft: boolean): number {
    return isLeft ? this.leftBarOutParam.translation : this.rightBarOutParam.translation;
  }

  /**
   * 获取偏移量
   *
   * @returns 偏移量
   */
  public getEndOffset(): number {
    return this.endOffset;
  }

  /**
   * 获取dockBar展示的最近任务区数量
   */
  public getDockBarRecentNum(): number {
    return this.dockBarScrollerParam.recentApps.length;
  }

  /**
   * 获取左右DockBar的挖孔距离
   *
   * @param isLeft
   * @returns
   * @returns cutOutDistance
   */
  public getCutOutDistance(direction: number): number {
    return direction === GestureDockState.GESTURE_DOCK_LEFT_OUT ?
      this.leftBarOutParam.cutOutDistance : this.rightBarOutParam.cutOutDistance;
  }

  /**
   * 获取底部挖孔距离
   *
   * @returns cutOutDistance
   */
  public getBottomCutOutDistance(): number {
    return this.bottomGestureParams.cutOutDistance;
  }

  /**
   * 获取侧边栏allApps分割线位置
   *
   * @param screenWidth 屏幕宽度
   * @returns divider position
   */
  public getDividerPositionX(screenWidth: number): number {
    let gestureDockViewData = GestureDockViewModel.getInstance().getViewData();
    return gestureDockViewData?.getGestureDockDirection() === GestureDockState.GESTURE_DOCK_LEFT_OUT ?
      GestureDockConstants.GESTURE_DOCK_WIDTH + this.leftBarOutParam.cutOutDistance :
      px2vp(screenWidth) - GestureDockConstants.GESTURE_DOCK_WIDTH -
      this.rightBarOutParam.cutOutDistance;
  }

  /**
   * 获取侧边dock的滑动量
   *
   * @returns scroller滑动量
   */
  public getScrollTranslate(): number {
    return this.scrollTranslate;
  }

  /**
   * 获取底部dock高度做避让
   *
   * @returns 底部dock高度
   */
  public getSmartDockHeight(): number {
    return this.mSmartDockStyleConfig.mDockHeight +
    this.mSmartDockStyleConfig.mBackPlanePadding + this.mSmartDockStyleConfig.mDockPadding;
  }

  /**
   * 获取DockBar的高度
   */
  public getGestureDockBarHeight(screenProperty: SCBScreenProperty): number {
    return px2vp(screenProperty.height) - ResUtils.getNumber($r('app.float.status_bar_phone_height')) -
      (ScreenInfoUtil.isVertical(screenProperty) ? this.getSmartDockHeight() :
      StyleConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT);
  }

  /**
   * 获取侧边dock在x轴的偏移值
   *
   * @param direction 侧边dock方向
   * @param screenWidth 屏幕宽度
   * @returns dockOffsetX
   */
  public getDockOffsetX(direction: number, screenWidth: number): Length | undefined {
    if (RTLUtil.isRTL()) {
      return direction === GestureDockDirection.GESTURE_DOCK_RIGHT ?
        GestureDockConstants.GESTURE_DOCK_WIDTH : -px2vp(screenWidth)
    }
    return direction === GestureDockDirection.GESTURE_DOCK_LEFT ?
      -GestureDockConstants.GESTURE_DOCK_WIDTH : px2vp(screenWidth)
  }

  /**
   * 获取侧边栏TranslateX
   * @param direction 方向
   * @returns TranslateX
   */
  public getDockTranslateX(direction: number): number {
    if (RTLUtil.isRTL()) {
      return direction === GestureDockDirection.GESTURE_DOCK_LEFT ? -this.leftBarOutParam.translation :
        -this.rightBarOutParam.translation;
    }
    return direction === GestureDockDirection.GESTURE_DOCK_LEFT ? this.leftBarOutParam.translation :
      this.rightBarOutParam.translation;
  }

  /**
   * 获取左右的scroller
   *
   * @param direction
   * @returns
   */
  public getScroller(direction: boolean): Scroller {
    return direction ? this.leftScroller : this.rightScroller;
  }

  /**
   * 获取侧边栏的位移
   *
   * @param isLeft
   * @returns
   */
  public getDockOutTranslation(isLeft: boolean): number {
    let dockOutTranslation = GestureDockConstants.GESTURE_DOCK_WIDTH + GestureDockConstants.GESTURE_DOCK_PADDING;
    let gestureDockViewData = GestureDockViewModel.getInstance().getViewData();
    if (gestureDockViewData && gestureDockViewData.getGestureDockShowMode() > GestureDockMode.APPEAR) {
      dockOutTranslation = GestureDockConstants.GESTURE_DOCK_WIDTH;
    }
    if (isLeft) {
      dockOutTranslation += this.leftBarOutParam.cutOutDistance;
    } else {
      dockOutTranslation += this.rightBarOutParam.cutOutDistance;
    }
    return dockOutTranslation + this.getFloatingNavigationDistance(isLeft);
  }

  /**
   * 获取Dock左右侧避让悬浮导航的距离
   *
   * @param isLeft 滑出Dock的方向
   * @returns
   */
  private getFloatingNavigationDistance(isLeft: boolean): number {
    if (!DeviceHelper.isPhone() || desktopUtil.isFoldExpandStatus()) {
      log.showInfo('Device is not phone or fold status.');
      return 0;
    }
    let isScreenVertical = SCBScreenSessionManager.getInstance().isScreenVertical();
    if (isScreenVertical) {
      log.showInfo('Screen is vertical.');
      return 0;
    }
    let floatingNavigationInfo = floatingNavigationInfoMgr.getFloatingNavigationInfo();
    let isFloatingNavigationShow = floatingNavigationInfo?.showType;
    let region = floatingNavigationInfo?.region;
    if (isFloatingNavigationShow !== FloatingNavigationShowType.THREE_KEYS || !region || region.length < 4) {
      log.showInfo('FloatingNavigation is not ThreeKeys or region is undefined or invalid.');
      return 0;
    }
    let x: number = region[0];
    let y: number = region[1];
    let width: number = region[2];
    let height: number = region[3];
    log.showInfo(`FloatingNavigation.region:{x:${x},y:${y},width:${width},height:${height}`);
    try {
      let display = Display.getDefaultDisplaySync();
      if (CommonUtils.isInvalid(display)) {
        log.showWarn(`display is invalid.`);
        return 0;
      }
      if (!isLeft && x > display.width * 3 / 4) {
        log.showInfo('DockBar Right avoid threeKeys navigation.');
        return px2vp(width);
      }
    } catch (error) {
      log.error('error', error);
    }
    return 0;
  }
}
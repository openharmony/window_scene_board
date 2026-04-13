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

import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { ApsUtils, ScreenState } from '@ohos/frameworkwrapper';
import {
  CommonConstants as DeskConstants,
  SmartDockZoomFeatureSwitch,
  StyleConstants
} from '@ohos/launchercommon';
import { CommonConstants as LockCommonConstants } from '@ohos/screenlockcommon';
import { DockRegionAnimationVm } from './DockRegionAnimationVm';
import {
  ItemAnimationParams,
  FoldAnimationConstants,
  FoldExpandAnimUtils,
} from '@ohos/launchercommon/Index';
import { SpaceAnimationUtils } from '@ohos/launchercommon/src/main/ets/animation/SpaceAnimationUtils';
import curves from '@ohos.curves';
import { PageDesktopViewModel } from '@ohos/pagedesktop';
// import apsManager from '@hms.graphic.apsManager';

const TAG = 'SmartDock_VM_DockRegionLayoutEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

/**
 * Dock区域解锁屏、折展等动效事件
 */
export class DockRegionAnimationEvent {
  private animationVm: DockRegionAnimationVm;

  constructor(vm: DockRegionAnimationVm) {
    this.animationVm = vm;
  }

  /**
   * 大屏展开动效
   *
   * @param screenWidth 屏幕宽度
   * @param layoutWidth 布局宽度
   * @param backgroundId 布局背景ID
   * @param isResident 是否是常驻区
   * @param onFinish 动效完成回调
   */
  public expandedAnimation(screenWidth: number, layoutWidth: number, backgroundId: string, isResident: boolean,
    onFinish?: Function): void {
    log.showInfo(`dock bg expandedAnimation start, id: ${backgroundId}`);
    this.animationVm.translateX = FoldExpandAnimUtils.getDockBgExpandAnimStartTranslateX(screenWidth);
    this.animationVm.scaleSizeX = FoldExpandAnimUtils.getDockBgExpandAnimStartScaleSize();
    this.animationVm.alpha = 0;
    let recentBgInfo: RectInfo = ItemUtils.getRectById(backgroundId);
    let recentBgDelayFactor: number = (screenWidth - recentBgInfo.right) / screenWidth;
    let recentBgDelay: number = FoldExpandAnimUtils.getRecentBgDelay(recentBgDelayFactor);
    if (!isResident && FoldExpandAnimUtils.isSupportProduct) {
      this.animationVm.dividerScale = FoldAnimationConstants.DIVIDER_SCALE;
      animateTo({
        curve: FoldAnimationConstants.SCALE_CURVE,
      }, () => {
        this.animationVm.dividerScale = 1;
      });
    }

    animateTo({
      curve: FoldExpandAnimUtils.getDockBgPanelScaleCurve(),
    }, () => {
      this.animationVm.scaleSizeX = FoldExpandAnimUtils.getBackPlaneAnimScale(layoutWidth);
    });
    animateTo({
      curve: FoldAnimationConstants.SCALE_CURVES,
      delay: isResident ? FoldAnimationConstants.DOCK_BG_DELAY : FoldAnimationConstants.RECENT_BG_DELAY,
      onFinish: onFinish?.()
    }, () => {
      this.animationVm.scaleSizeX = 1;
    });

    animateTo({
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
      delay: recentBgDelay,
    }, () => {
      this.animationVm.translateX = 0;
    });
    animateTo(FoldExpandAnimUtils.getIconOrDockBgAlphaAnimParam(recentBgDelay), () => {
      this.animationVm.alpha = 1;
    });
  }

  /**
   * 锁屏动效
   *
   * @param screenWidth 屏幕宽度
   * @param screenHeight 屏幕高度
   * @param backgroundId 背景布局ID
   */
  public lockAnimation(screenWidth: number, screenHeight: number, backgroundId: string): void {
    log.showInfo('dock bg lockAnimation start, backgroundId: %{public}s', backgroundId);
    this.animationVm.visible = Visibility.Visible;
    let residentRect: RectInfo = ItemUtils.getRectById(backgroundId);
    let itemAnimation: ItemAnimationParams = new ItemAnimationParams();
    itemAnimation.calUnlock(screenWidth, screenHeight, residentRect);

    this.animationVm.translateX = 0;
    this.animationVm.translateY = 0;
    this.animationVm.scaleSizeX = 1;
    this.animationVm.scaleSizeY = 1;
    this.animationVm.dividerScale = 1;
    this.animationVm.alpha = 1;
    this.animationVm.blurRadius = 0;
    this.animationVm.centerX =
      itemAnimation.screenCenterX - itemAnimation.itemCenterX + itemAnimation.rectInfoWidth / 2;
    this.animationVm.centerY =
      itemAnimation.screenCenterY * 1.5 - itemAnimation.itemCenterY + itemAnimation.rectInfoHeight / 2;
    let delayTimeAnim = LockCommonConstants.DESKTOP_TO_AOD_HOME_PAGE_DELAY + 100;

    animateTo({
      delay: 0,
      duration: DeskConstants.DESKTOP_TO_AOD_ICON_DELAY,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        setTimeout(() => {
          this.animationVm.scaleSizeX = 1;
          this.animationVm.scaleSizeY = 1;
          this.animationVm.dividerScale = 1;
          this.animationVm.blurRadius = 0;
          this.animationVm.alpha = 1;
          SpaceAnimationUtils.resetTimeMap();
        }, delayTimeAnim);
      }
    }, () => {
      this.animationVm.alpha = 0;
      this.animationVm.blurRadius = 100;
      this.animationVm.scaleSizeX = 0.8;
      this.animationVm.scaleSizeY = 0.8;
      this.animationVm.dividerScale = 0.8;
    });
  }

  public setVisible(visible: Visibility):void{
    this.animationVm.visible = visible;
  }

  /**
   * 解锁动效
   *
   * @param screenWidth 屏幕宽度
   * @param screenHeight 屏幕高度
   * @param backgroundId 背景布局ID
   */
  public unlockAnimation(screenWidth: number, screenHeight: number, backgroundId: string): void {
    log.showInfo('dock bg unlockAnimation start, backgroundId: %{public}s', backgroundId);
    this.animationVm.visible = Visibility.Visible;
    let bgRect: RectInfo = ItemUtils.getRectById(backgroundId);
    let itemAnimation: ItemAnimationParams = new ItemAnimationParams();
    itemAnimation.calUnlock(screenWidth, screenHeight, bgRect);
    this.animationVm.translateX = 0;
    this.animationVm.translateY = 0;
    this.animationVm.scaleSizeX = 0.6;
    this.animationVm.scaleSizeY = 0.6;
    this.animationVm.dividerScale = 0.6;
    this.animationVm.alpha = 0;
    this.animationVm.blurRadius = 0;
    this.animationVm.centerX =
      itemAnimation.screenCenterX - itemAnimation.itemCenterX + itemAnimation.rectInfoWidth / 2;
    this.animationVm.centerY =
      itemAnimation.screenCenterY * 1.5 - itemAnimation.itemCenterY + itemAnimation.rectInfoHeight / 2;

    let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
    let delayValue = itemAnimation.getDelay(mPageDesktopViewModel.unlockMin, mPageDesktopViewModel.unlockMax);

    // ApsUtils.setApsScene(apsManager.SceneAnimation.UNLOCK_TO_ENTER_DESKTOP, StyleConstants.DEFAULT_1);
    animateTo({
      delay: delayValue,
      curve: curves.springMotion(0.35, 0.8, 0),
      onFinish: () => {
        this.animationVm.centerX = '50%';
        this.animationVm.centerY = '50%';
        this.animationVm.isUnlocking = false;
        // ApsUtils.setApsScene(apsManager.SceneAnimation.UNLOCK_TO_ENTER_DESKTOP, StyleConstants.DEFAULT_0);
      },
    }, () => {
      this.animationVm.translateX = 0;
      this.animationVm.translateY = 0;
      this.animationVm.scaleSizeX = 1;
      this.animationVm.scaleSizeY = 1;
      this.animationVm.dividerScale = 1;
      this.animationVm.alpha = 1;
      this.animationVm.isUnlocking = true;
    });
  }

  /**
   * 亮屏事件
   */
  public onScreenOn(): void {
    if (this.animationVm.visible != Visibility.Visible) {
      this.animationVm.visible = Visibility.Visible;
    }
  }

  /**
   * 分割线touch事件
   *
   * @param event touch事件
   */
  public onDividerTouch(event?: TouchEvent): void {
    if (event?.type === TouchType.Down && !SmartDockZoomFeatureSwitch.isSupportZoom()) {
      animateTo({
        delay: 150,
        duration: 400,
        curve: Curve.Friction,
        playMode: PlayMode.Normal,
      }, () => {
        this.animationVm.dividerScale = 1.5;
      })
    } else if (event?.type === TouchType.Up) {
      animateTo({
        duration: 250,
        curve: Curve.Friction,
        playMode: PlayMode.Normal,
      }, () => {
        this.animationVm.dividerScale = 1.0;
      })
    }
  }
}
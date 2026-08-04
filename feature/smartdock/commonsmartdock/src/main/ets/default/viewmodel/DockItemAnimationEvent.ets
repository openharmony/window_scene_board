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

import { DomainName, LogDomain, LogHelper, RectInfo, TraceUtil } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { DesktopUtils, PageDesktopViewModel } from '@ohos/pagedesktop';
import {
  CommonConstants as DeskConstants,
  DockItemInfo,
} from '@ohos/launchercommon';
import { CommonConstants as LockCommonConstants } from '@ohos/screenlockcommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { ItemAnimationParams,
  PageDesktopOneShotManager,
  FoldAnimationConstants,
  FoldExpandAnimUtils,
} from '@ohos/launchercommon/Index';
import { SpaceAnimationUtils } from '@ohos/launchercommon/src/main/ets/animation/SpaceAnimationUtils';
import curves from '@ohos.curves';
import { DockItemAnimationVm } from './DockItemAnimationVm';
import SmartDockViewModel from './SmartDockViewModel';
import SmartDockDragHandler from '../common/SmartDockDragHandler';
import { gravityAnimationManager, GravityAnimationParameter } from '@ohos/componentanimator/Index';
import { ScreenState } from '@ohos/frameworkwrapper';
import { SmartDockZoomAnimationConfig } from '../common/SmartDockZoomAnimationConfig';

const TAG = 'SmartDock_VM_DockItemAnimationEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

/**
 * Dock区图标解锁屏、折叠展开等动效事件
 */
export class DockItemAnimationEvent {
  private animationVm: DockItemAnimationVm;

  constructor(vm: DockItemAnimationVm) {
    this.animationVm = vm;
  }

  /**
   * 亮屏
   */
  public onScreenOn(): void {
    if (this.animationVm.visible != Visibility.Visible) {
      this.animationVm.visible = Visibility.Visible;
    }
  }

  /**
   * 双折叠折叠动效
   *
   * @param screenWidth 屏幕宽度
   * @param index 元素索引
   * @param count 区域元素总数
   */
  public foldedAnimation(screenWidth: number, index: number, count: number): void {
    log.showInfo('dock item execute foldedAnimation, index: %{public}d, count: %{public}d', index, count);
    animateTo({
      duration: 0,
    }, () => {
      this.animationVm.translateX = FoldExpandAnimUtils.initItemTransX(index, count,
        FoldAnimationConstants.FOLD_FACTOR * screenWidth, screenWidth, false);
      this.animationVm.scaleSize = FoldExpandAnimUtils.getFoldExpandAnimScale();
    });
    this.animationVm.centerX = 0.5;
    this.animationVm.centerY = 0.5;
    this.animationVm.alpha = 0;
    let dockDelay: number = FoldExpandAnimUtils.getDockFoldAnimDelay(index, count);
    animateTo({
      curve: FoldExpandAnimUtils.getIconFoldedAnimCurve(),
      delay: dockDelay,
    }, () => {
      this.animationVm.translateX = 0;
      this.animationVm.scaleSize = 1;
    });
    animateTo(FoldExpandAnimUtils.getIconOrDockBgAlphaAnimParam(dockDelay), () => {
      this.animationVm.alpha = 1;
    });
  }

  /**
   * 双折叠展开动效
   *
   * @param screenWidth 屏幕宽度
   * @param screenHeight 屏幕高度
   * @param itemId 图标布局ID
   * @param index 位置索引
   * @param isResident 是否是常驻区
   */
  public expandedAnimation(screenWidth: number, screenHeight: number, itemId: string, index: number,
    isResident: boolean = true): void {
    log.showInfo(`dock execute expandedAnimation, itemId: ${itemId}, index: ${index}`);
    this.animationVm.alpha = 0;
    let rectInfo: RectInfo = ItemUtils.getRectById(itemId);
    let col: number[] = FoldExpandAnimUtils.getDockColumn(index, isResident);
    animateTo({
      duration: 0,
    }, () => {
      this.animationVm.translateX =
        FoldExpandAnimUtils.initItemTransX(col[0], col[1], FoldAnimationConstants.EXPAND_FACTOR * screenWidth,
          screenWidth, true);
      this.animationVm.translateY = FoldExpandAnimUtils.initItemTransY(FoldAnimationConstants.DOCK_ROW, screenHeight);
      this.animationVm.scaleSize = FoldExpandAnimUtils.getFoldExpandAnimScale();
    });
    let dockDelay: number = FoldExpandAnimUtils.getDockExpandAnimDelay(rectInfo, screenWidth, col[0], col[1]);
    animateTo({
      curve: FoldExpandAnimUtils.getDockItemExpandAnimCurve(col[0], col[1]),
      delay: dockDelay,
    }, () => {
      this.animationVm.translateX = 0;
      this.animationVm.translateY = 0;
      this.animationVm.scaleSize = 1;
    });
    let alphaDelayTime = FoldExpandAnimUtils.isMiddleCol(col[0], col[1]) ?
      dockDelay + FoldAnimationConstants.MIDDLE_DELAY : dockDelay;
    animateTo(FoldExpandAnimUtils.getIconOrDockBgAlphaAnimParam(alphaDelayTime), () => {
      this.animationVm.alpha = 1;
    });
  }

  /**
   * 锁屏动效
   *
   * @param screenWidth 屏幕宽度
   * @param screenHeight 屏幕高度
   * @param itemId 图标组件ID
   */
  public lockAnimation(screenWidth: number, screenHeight: number, itemId: string): void {
    if (!DesktopUtils.isSupportLockAnimation()) {
      log.info('lockAnimation not support');
      return;
    }
    let isBaseDeskPage: boolean = PageDesktopOneShotManager.getInstance().getIsBaseDeskPage();
    if (!isBaseDeskPage) {
      log.info('lockAnimation, not base desk page');
      return;
    }

    log.info(`Dock lockAnimation, itemId: ${itemId}`);
    let rectInfo: RectInfo = ItemUtils.getRectById(itemId);
    let itemAnimation: ItemAnimationParams = new ItemAnimationParams();
    itemAnimation.calUnlock(screenWidth, screenHeight, rectInfo);

    let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
    let unlockMin: number = mPageDesktopViewModel.unlockMin;
    mPageDesktopViewModel.unlockMin =
      unlockMin != 0 && (unlockMin < itemAnimation.distance) ? unlockMin : itemAnimation.distance;
    if (mPageDesktopViewModel.unlockMax < itemAnimation.distance) {
      mPageDesktopViewModel.unlockMax = itemAnimation.distance;
      mPageDesktopViewModel.unLockMaxDelayKey = itemAnimation.itemKey;
    }

    let delayTimeAnim = LockCommonConstants.DESKTOP_TO_AOD_HOME_PAGE_DELAY + 100;
    this.animationVm.centerX =
      itemAnimation.screenCenterX - itemAnimation.itemCenterX + itemAnimation.rectInfoWidth / 2;
    // 指示器和dock栏缩放中心在屏幕高度的0.6处
    this.animationVm.centerY =
      itemAnimation.screenCenterY * 1.5 - itemAnimation.itemCenterY + itemAnimation.rectInfoHeight / 2;
    this.animationVm.translateX = 0;
    this.animationVm.translateY = 0;
    this.animationVm.alpha = 1;
    this.animationVm.scaleSize = 1;
    this.animationVm.blurRadius = 0;
    animateTo({
      delay: 0,
      duration: DeskConstants.DESKTOP_TO_AOD_ICON_DELAY,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        setTimeout(() => {
          this.animationVm.scaleSize = 1;
          this.animationVm.blurRadius = 0;
          this.animationVm.alpha = 1;
          SpaceAnimationUtils.resetTimeMap();
        }, delayTimeAnim);
      }
    }, () => {
      this.animationVm.alpha = 0;
      this.animationVm.scaleSize = 0.8;
    });
  }

  /**
   * 解锁动效
   *
   * @param screenWidth 屏幕宽度
   * @param screenHeight 屏幕高度
   * @param itemId 图标组件ID
   * @param onFinish 动效结束回调
   */
  public unlockAnimation(screenWidth: number, screenHeight: number, itemId: string, onFinish?: Function): void {
    if (!DesktopUtils.isSupportLockAnimation()) {
      return;
    }

    log.showInfo(`Dock unlockAnimation ${itemId}`);
    this.animationVm.visible = Visibility.Visible;
    let rectInfo: RectInfo = ItemUtils.getRectById(itemId);
    let itemAnimation: ItemAnimationParams = new ItemAnimationParams();
    itemAnimation.calUnlock(screenWidth, screenHeight, rectInfo);
    let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
    let unlockMin: number = mPageDesktopViewModel.unlockMin;
    mPageDesktopViewModel.unlockMin =
      unlockMin != 0 && (unlockMin < itemAnimation.distance) ? unlockMin : itemAnimation.distance;
    if (mPageDesktopViewModel.unlockMax < itemAnimation.distance) {
      mPageDesktopViewModel.unlockMax = itemAnimation.distance;
      mPageDesktopViewModel.unLockMaxDelayKey = itemAnimation.itemKey;
    }
    this.animationVm.centerX =
      itemAnimation.screenCenterX - itemAnimation.itemCenterX + itemAnimation.rectInfoWidth / 2;
    // 指示器和dock栏缩放中心在屏幕高度的0.6处
    this.animationVm.centerY =
      itemAnimation.screenCenterY * 1.5 - itemAnimation.itemCenterY + itemAnimation.rectInfoHeight / 2;
    this.animationVm.translateX = 0;
    this.animationVm.translateY = 0;
    this.animationVm.alpha = 0;
    this.animationVm.scaleSize = 0.6;
    this.animationVm.blurRadius = 0
    let delayValue = itemAnimation.getDelay(mPageDesktopViewModel.unlockMin, mPageDesktopViewModel.unlockMax);

    animateTo({
      delay: delayValue,
      curve: curves.springMotion(0.35, 0.8, 0),
      onFinish: () => {
        if (onFinish) {
          onFinish();
          if (mPageDesktopViewModel.unLockMaxDelayKey === itemAnimation.itemKey) {
            performanceMonitor.end('CORE_METHOD_DESKTOP_SHOW');
          }
        }
      }
    }, () => {
      this.animationVm.translateX = 0;
      this.animationVm.translateY = 0;
      this.animationVm.scaleSize = 1;
      this.animationVm.alpha = 1;
    });
  }

  /**
   * 图标位移事件
   *
   * @param newCenterX 新中心点X坐标
   * @param immediate 是否立即执行
   * @param keyName 元素标识
   * @param length 常驻区元素个数
   * @param index 元素索引
   */
  public moveAnimation(newCenterX: number, immediate: boolean, keyName: string, length: number, index: number): void {
    const oldCenterX: number = SmartDockViewModel.getInstance().getDockItemCenter(length, index);
    log.showInfo('moveAnimation keyName: %{public}s, oldCenterX: %{public}d, newCenterX: %{public}d, immediate: %{public}s',
      keyName, oldCenterX, newCenterX, immediate);

    SmartDockDragHandler.getInstance().setDockItemTranslate(keyName, newCenterX - oldCenterX);
    // 原始位置获取异常、目标位置无效及两者位置一致时不执行动效，由于缩放可能导致小于1vp的偏移，将位置不一致的判断从1改为0.5
    if (oldCenterX < 0 || newCenterX < 0 || Math.abs(newCenterX - oldCenterX - this.animationVm.translateX) < 0.5) {
      return;
    }

    if (immediate) {
      this.animationVm.translateX = newCenterX - oldCenterX;
      return;
    }
    this.residentItemMoveAnimation(newCenterX - oldCenterX);
  }

  /**
   * 图标位移动效
   *
   * @param translateX 新中心点X坐标
   */
  public residentItemMoveAnimation(translateX: number): void {
    animateTo({
      duration: SmartDockZoomAnimationConfig.getAnimationDuration(),
      curve: SmartDockZoomAnimationConfig.getAnimationCurve(),
      onFinish: () => {
        log.showInfo('dockItemMoveInfoFunc onFinish');
        AppStorage.setOrCreate('isDockItemMove', false);
      }
    }, () => {
      this.animationVm.translateX = translateX;
      // 此变量设为true，表示dock栏图标动效期间，禁止点击图标
      AppStorage.setOrCreate('isDockItemMove', true);
    });
  }

  /**
   * 执行引力动效
   *
   * @param param 引力动效参数
   * @param appInfo 图标信息
   */
  public startGravityAnimation(param: GravityAnimationParameter, appInfo: DockItemInfo): void {
    log.showInfo('start dock-item gravity animation on %{public}s, delay %{public}d, duration %{public}d, ' +
      'from [%{public}d, %{public}d] -> [%{public}d, %{public}d]', appInfo.bundleName, param.delay,
      param.waveDuration, param.now.x, param.now.y, param.waveCrest.x, param.waveCrest.y);
    const id = 'DockItemGravityAnimation.' + appInfo.bundleName + '.' + appInfo.keyName;
    TraceUtil.startTraceWithTaskId(DomainName.HOME, id, 1);
    animateTo({
      curve: param.waveCurve,
      delay: param.delay * 1000,
      duration: param.waveDuration,
      onFinish: () => {
        this.startGravityRestoreAnimation(param, appInfo);
        TraceUtil.endTraceWithTaskId(DomainName.HOME, id, 1);
      }
    }, () => {
      this.animationVm.translateX = param.waveCrest.x - param.now.x;
      this.animationVm.translateY = param.waveCrest.y - param.now.y;
    });
  }

  private startGravityRestoreAnimation(param: GravityAnimationParameter, appInfo: DockItemInfo): void {
    log.showInfo('start to restore dock-item gravity animation on %{public}s, duration %{public}d', appInfo.bundleName,
      param.waveDuration);
    const id = 'DockItemGravityAnimationBack.' + appInfo.bundleName + '.' + appInfo.keyName;
    TraceUtil.startTraceWithTaskId(DomainName.HOME, id, 1);
    animateTo({
      curve: param.waveCurve,
      duration: param.waveDuration,
      onFinish: () => {
        TraceUtil.endTraceWithTaskId(DomainName.HOME, id, 1);
        gravityAnimationManager.markFinish(param);
      }
    }, () => {
      this.animationVm.translateX = 0;
      this.animationVm.translateY = 0;
    });
  }
}
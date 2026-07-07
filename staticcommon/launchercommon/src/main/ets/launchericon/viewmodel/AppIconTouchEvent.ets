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

import { appManager } from '@kit.AbilityKit';
import { curves } from '@kit.ArkUI';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LogDomain, Logger } from '@ohos/basicutils';
import { EventType, scbEventExclusiveManager, SCBTransitionManager, StartAbilityUtil } from '@ohos/windowscene';
import { GlobalContext,HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { DropAnimationCancelReason } from '@ohos/componentanimator';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { AppItemInfo, CloseAppManager, folderGesData, MultiSelectManager } from '../../TsIndex';
import { AppIconTouchEventIface } from '../interface/AppIconTouchEventIface';
import { AppIconConfig } from '../config/AppIconConfig';
import { AppIconData } from './AppIconData';
import { ActionEffectFlag } from '../../constants/CommonConstants';
import { DeliverUtil } from '../../utils/DeliverUtil';
import { PreLaunchType, SCBConstants } from '@ohos/commonconstants';
import { AppModel } from '../../model/AppModel';

const TAG = 'AppIconTouchEvent';
const log: Logger = Logger.getLogHelper(LogDomain.ICON);

export interface AppIconTouchEventParam {
  itemInfo: AppItemInfo;
  appIconConfig: AppIconConfig;
  iconData: AppIconData;
  touchDownCb?: (event: TouchEvent) => void;
  iconSizeCb?: () => number;
  iconScaleCb?: (scale: number) => void;
  iconLongPressAnimation?: (isZoomOut: boolean) => void;
}

export class AppIconTouchEvent implements AppIconTouchEventIface {
  private itemInfo?: AppItemInfo;
  private appIconConfig?: AppIconConfig;
  private iconData?: AppIconData;
  private touchDownCb?: (event: TouchEvent) => void;
  private iconSizeCb?: () => number;
  private iconScaleCb?: (scale: number) => void;
  private iconLongPressAnimation?: (isZoomOut: boolean) => void;

  private touchFingers: number = 0;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private onCancelLongPressAnimationCb: (isNeedAnimation: boolean) => void =
    (isNeedAnimation: boolean): void => this.cancelLongPressAnimation(isNeedAnimation);

  public initEventParam(param: AppIconTouchEventParam): AppIconTouchEventIface {
    if (!param) {
      log.showError(TAG, 'init event param failed!');
      return this;
    }

    this.itemInfo = param.itemInfo;
    this.appIconConfig = param.appIconConfig;
    this.iconData = param.iconData;
    this.iconSizeCb = param.iconSizeCb;
    this.touchDownCb = param.touchDownCb;
    this.iconScaleCb = param.iconScaleCb;
    this.iconLongPressAnimation = param.iconLongPressAnimation;
    return this;
  }

  public onTouch(event: TouchEvent): void {
    if (!event) {
      log.showError(TAG, 'onIconTouch failed, event is invalid!');
      return;
    }

    if (this.appIconConfig?.externCb?.enableHandleTouchEvent &&
      !this.appIconConfig?.externCb?.enableHandleTouchEvent()) {
      log.showInfo(TAG, 'onTouch is disabled because enableHandleTouchEvent return is false');
      return;
    }

    if (event.type === TouchType.Down) {
      this.onTouchDown(event);
    } else if (event.type === TouchType.Up) {
      this.onTouchUp(event);
    } else if (event.type === TouchType.Move) {
      this.onTouchMove(event)
    } else if (event.type === TouchType.Cancel) {
      this.onTouchCancel(event);
    } else {
      log.showWarn(TAG, `invalid touch type: ${event.type}!`);
    }
    this.appIconConfig?.externCb?.onIconTouch?.(event);
  }

  private onTouchDown(event: TouchEvent): void {
    log.showInfo(TAG, 'onTouchDown.');
    if (!this.itemInfo || !this.iconData || !this.appIconConfig) {
      log.showError(TAG, 'onTouchDown failed, itemInfo or iconData or appIconConfig is invalid!')
      return;
    }

    if (scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK) && event.touches?.length === 1) {
      log.showInfo(TAG, 'touch gesture Exclusive');
      return;
    }

    CloseAppManager.getInstance().setAdaptiveIcon(this.itemInfo.bundleName,
      this.itemInfo.moduleName ?? '', this.itemInfo.abilityName, this.itemInfo.appIconId);
    // 规避dh应用快速退出启动闪白屏的临时方案
    // dh应用响应点击事件时，打断应用退出动效，应用退出动效窗口一帧消失，与大文件夹闭合态体验一致
    if (DeliverUtil.isContainerItem(this.itemInfo.intent)) {
      SCBTransitionManager.getInstance().cancelCloseAppAnimate();
    }
    if (this.itemInfo.bundleName === SCBConstants.CAMERA_BUNDLE) {
      log.showInfo(TAG, `${SCBConstants.CAMERA_BUNDLE} onTouchDown preLaunchCamera`);
      StartAbilityUtil.preLaunchCamera(PreLaunchType.TOUCH_DOWN);
    }
    if (AppStorage.get('isPreLoadEnable') as boolean) {
      try {
        log.showInfo(TAG, `preloadApplication bundleName: ${this.itemInfo.bundleName}.`);
        if (AppModel.getInstance().mIsChangeTheme) {
          HiDfxEventUtil.reportChanThemSlideOrStart(false, true);
        }
        appManager.preloadApplication(this.itemInfo.bundleName, -1, appManager.PreloadMode.PRESS_DOWN);
      } catch (err) {
        log.showError(TAG, `preloadApplication error, code: ${err?.code}, msg:${err?.message}!`);
      }
    }

    if (this.iconData.isSuperposeApp) {
      log.showInfo(TAG, 'touch down isSuperposeApp return.');
      return;
    }

    dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);

    // 设置menu拉起位置
    this.touchDownCb?.(event);

    if (this.appIconConfig.enableEffectFlag & ActionEffectFlag.EFFECT_LONG_PRESS) {
      this.desktopContext?.eventHub.on('appIconLongPressEffectCancel', this.onCancelLongPressAnimationCb);
      // 解决响应时延问题，取消图标缩放动效。后续可考虑改DEFAULT_ENABLE_EFFECT_FLAG参数
      // this.iconLongPressAnimation?.(true);
    } else {
      // 解决响应时延问题，取消图标缩放动效
      // this.iconScaleAnimation(0.9);
    }
  }

  private onTouchUp(event: TouchEvent): void {
    log.showInfo(TAG, 'onTouchUp.');
    if (!this.iconData || !this.appIconConfig) {
      log.showError(TAG, 'onTouchUp failed, iconData or appIconConfig is invalid!')
      return;
    }

    if (this.iconData.isLongPressHideMask) {
      this.iconData?.setIsLongPressHideMask(false);
    }

    this.iconData?.resetLongPressVibrated();
    this.iconData.touchMaskVisible = false;
    this.touchFingers = event.touches?.length ?? 0;

    if (this.iconData.isSuperposeApp) {
      return;
    }

    if (this.appIconConfig.enableEffectFlag & ActionEffectFlag.EFFECT_LONG_PRESS) {
      this.desktopContext?.eventHub.off('appIconLongPressEffectCancel', this.onCancelLongPressAnimationCb);
    }

    // 解决响应时延问题，取消图标缩放动效
    // this.iconScaleAnimation(1.0);
  }

  private onTouchMove(event: TouchEvent): void {
    if (!this.iconData || !this.iconSizeCb) {
      log.showError(TAG, 'onTouchMove failed, iconData or iconSizeCb is invalid!')
      return;
    }

    const iconSize: number = this.iconSizeCb() ?? 0;
    const touchObj: TouchObject = event.touches?.[0];
    if (this.iconData.touchMaskVisible && touchObj &&
      (touchObj.x < 0 || touchObj.x > iconSize || touchObj.y < 0 || touchObj.y > iconSize)) {
      // 按在图标上慢慢移动至图标外,此时不会触发cancel事件,需要在此处将蒙层下掉
      this.iconData.setTouchMaskVisible(false);
    }
  }

  private onTouchCancel(event: TouchEvent): void {
    log.showInfo(TAG, 'onTouchCancel.');
    if (!this.iconData) {
      log.showError(TAG, 'onTouchCancel failed, iconData is invalid!')
      return;
    }

    if (this.iconData.isLongPressHideMask) {
      this.iconData?.setIsLongPressHideMask(false);
    }
    if (this.itemInfo?.bundleName === SCBConstants.CAMERA_BUNDLE) {
      log.showInfo(TAG, `${SCBConstants.CAMERA_BUNDLE} onTouchCancel preLaunchCamera`);
      StartAbilityUtil.preLaunchCamera(PreLaunchType.TOUCH_CANCEL);
    }
    this.iconData?.resetLongPressVibrated();

    // touch事件取消时需要取消按压动效，如图标长按拖拽的场景
    this.cancelLongPressAnimation();
  }

  public onClick(event?: ClickEvent): void {
    log.showInfo(TAG, `onClick. bundleName = ${this.itemInfo?.bundleName}, appStatus = ${this.itemInfo?.appStatus}`);
    const manager = MultiSelectManager.getInstance();
    if (manager.getStatus().isSelectAble() && this.appIconConfig?.enableMultiSelect) {
      manager.onIconClick(manager.getUniqueId(this.itemInfo));
    }
    // 判断iconOpacity
    if ((this.iconData?.iconOpacity ?? 0) <= SCBConstants.NEAR_ZERO_VALUE &&
      SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0) {
      HiDfxEventUtil.reportIconStatusAbnormal('icon visibility invalid', this.itemInfo?.bundleName);
    }
    // 通知外部点击事件
    this.appIconConfig?.externCb?.onIconClick?.(event, this.touchFingers);
  }

  /**
   * 图标缩放动效
   * @param isZoomOut
   */
  private iconScaleAnimation(scale: number): void {
    log.showInfo(TAG, `icon scale: ${scale}.`);
    // animateToImmediately({
    //   duration: 160,
    //   curve: curves.interpolatingSpring(0, 1, 410, 38),
    //   playMode: PlayMode.Normal,
    //   onFinish: () => {
    //     this.iconData?.setTouchMaskVisible(false);
    //     log.showInfo(TAG, 'TouchScale play end.');
    //   }
    // }, () => {
      this.iconData?.setIconScale(scale);
      this.iconScaleCb?.(scale);
      this.iconData?.setTouchMaskVisible(false);
      log.showInfo(TAG, 'TouchScale play end.');
    // });
  }

  private cancelLongPressAnimation(isNeedAnimation: boolean = false): void {
    log.showInfo(TAG, `appIconLongPress animation cancel isNeedAnimation = ${isNeedAnimation}`);
    if (!this.iconData?.touchMaskVisible && !isNeedAnimation) {
      // 动效打断场景时需保证蒙层节点在树上,避免因为蒙层节点提前下树导致蒙层动效无法打断出现空动效引起功耗问题
      // 典型问题场景:按在图标上快速滑动,move事件会比cancel事件先执行,造成蒙层节点提前下树导致动效打断失败
      this.iconData?.setTouchMaskVisible(true);
    }
    animateTo({
      duration: isNeedAnimation ? 250 : 0,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.desktopContext?.eventHub.off('appIconLongPressEffectCancel', this.onCancelLongPressAnimationCb);
      }
    }, () => {
      this.iconData?.setIconScale(1);
      this.iconScaleCb?.(1);
    });

    // 图标蒙层动效, 与长按松手后动效保持一致
    // touchMaskVisible不和scale在同一个动画闭包，避免蒙层与图标同时动画导致不贴合
    animateTo({
      duration: isNeedAnimation ? 250 : 0,
      curve: Curve.Linear
    }, () => {
      this.iconData?.setTouchMaskVisible(false);
    });
  }
}
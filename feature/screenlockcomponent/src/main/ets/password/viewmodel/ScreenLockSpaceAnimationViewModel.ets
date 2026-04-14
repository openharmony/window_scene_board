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
import { SCBScreenProperty } from '@ohos/windowscene';
import Constants from '../../common/Constants';
import { curves } from '@kit.ArkUI';
import { SlWidgetId } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { ISlState, WidgetPivot } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slStateHelper } from '../../common/helper/SlStateHelper';
import { SlBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import {
  slClockOneShotToDesktopService,
  VerifyDataManager,
} from '@ohos/screenlockcommon';
import {
  ScreenLockSpaceAniData,
  SpaceAniComponentType,
  spaceAniHelper,
} from '@ohos/screenlockcommon/Index'
import { immersiveKgMgr, ImmersiveState } from '@ohos/systemuicommon';

const TAG = 'SpaceAnimationViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const TOP_SCALE_RATIO: number = 0.65;
const MIDDLE_SCALE_RATIO: number = 0.35;
const BASE_SCALE_RATIO: number = 0.25;
const BOTTOM_SCALE_RATIO: number = 0.45;

/**
 * 空间动效
 */
export default class ScreenLockSpaceAnimationViewModel {
  private lockIconAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniLockIconState();
  private clockAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniClockState();
  private formAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniFormState();
  private quickToolAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniQuickToolState();
  private cameraAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniCameraState();
  private immersiveCapAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniImmersiveCapState();
  private immersiveListAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniImmersiveListState();
  private immersiveCardAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniImmersiveCardState();
  private greetAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniGreetState();
  private screenProp: SCBScreenProperty = new SCBScreenProperty();
  /**
   * 沉浸状态
   */
  private immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();

  private viewIdMap: Map<number, string> = new Map<number, string>([
    [SpaceAniComponentType.LOCK_ICON, SlWidgetId.LOCK_HEAD],
    [SpaceAniComponentType.CLOCK, SlWidgetId.CLOCK],
    [SpaceAniComponentType.FORM, SlWidgetId.FORM],
    [SpaceAniComponentType.QUICK_TOOL, SlWidgetId.QUICK_TOOLS_ICON],
    [SpaceAniComponentType.CAMERA, SlWidgetId.CAMERA_ICON],
    [SpaceAniComponentType.IMMERSIVE_CAP, SlWidgetId.IMMERSIVE_CAP],
    [SpaceAniComponentType.IMMERSIVE_LIST, SlWidgetId.IMMERSIVE_LIST],
    [SpaceAniComponentType.IMMERSIVE_CARD, SlWidgetId.IMMERSIVE_CARD],
    [SpaceAniComponentType.GREET, SlWidgetId.SL_GREET],
  ]);

  private viewScaleOffset: Map<number, number> = new Map<number, number>([
    [SpaceAniComponentType.LOCK_ICON, TOP_SCALE_RATIO],
    [SpaceAniComponentType.CLOCK, MIDDLE_SCALE_RATIO],
    [SpaceAniComponentType.FORM, BASE_SCALE_RATIO],
    [SpaceAniComponentType.QUICK_TOOL, BOTTOM_SCALE_RATIO],
    [SpaceAniComponentType.CAMERA, BOTTOM_SCALE_RATIO],
    [SpaceAniComponentType.IMMERSIVE_CAP, BOTTOM_SCALE_RATIO],
    [SpaceAniComponentType.IMMERSIVE_LIST, BASE_SCALE_RATIO],
    [SpaceAniComponentType.IMMERSIVE_CARD, BASE_SCALE_RATIO],
    [SpaceAniComponentType.GREET, BASE_SCALE_RATIO],
  ]);

  viewModelInit(
    screenProp: SCBScreenProperty,
  ): void {
    log.showInfo('SpaceAnimationViewModel init');
    this.screenProp = screenProp;
  }

  private doScaleAnimation(delay: number, callback: Function, finish: Function): void {
    animateTo({
      curve: curves.springMotion(0.4, 0.825, 0),
      delay: delay,
      onFinish: () => {
        finish();
      }
    }, () => {
      callback();
    })
  }

  private doOpacityAnimation(duration: number = 200, delay: number, callback: Function, finish: Function): void {
    animateTo({
      duration: duration,
      delay: delay,
      onFinish: () => {
        finish();
      }
    }, () => {
      callback();
    })
  }

  private doAnimationWrapper(isShow: boolean, delay: number, baseCallback: Function, baseOnFinish: Function,
    opacityDuration: number, opacityCallback: Function, opacityOnFinish: Function, isSkipAnim: boolean): void {
    if (isSkipAnim) {
      opacityCallback();
      return;
    }
    this.doScaleAnimation(
      delay,
      () => {
        baseCallback();
      },
      () => {
        baseOnFinish();
      }
    )
    this.doOpacityAnimation(
      opacityDuration,
      delay,
      () => {
        opacityCallback();
      },
      () => {
        opacityOnFinish();
      }
    )
  }

  private getOpt(comp: number): ScreenLockSpaceAniData {
    switch (comp) {
      case SpaceAniComponentType.LOCK_ICON:
        return this.lockIconAniOpt;
      case SpaceAniComponentType.CLOCK:
        return this.clockAniOpt;
      case SpaceAniComponentType.FORM:
        return this.formAniOpt;
      case SpaceAniComponentType.QUICK_TOOL:
        return this.quickToolAniOpt;
      case SpaceAniComponentType.CAMERA:
        return this.cameraAniOpt;
      case SpaceAniComponentType.IMMERSIVE_CAP:
        return this.immersiveCapAniOpt;
      case SpaceAniComponentType.IMMERSIVE_LIST:
        return this.immersiveListAniOpt;
      case SpaceAniComponentType.IMMERSIVE_CARD:
        return this.immersiveCardAniOpt;
      default:
        return this.greetAniOpt;
    }
  }

  private doAnimation(isShow: boolean, noDelay: boolean, isSkipAnim: boolean, comp: number) {
    let viewId = this.viewIdMap.get(comp);
    if (viewId === undefined) {
      return;
    }
    let opt: ScreenLockSpaceAniData = this.getOpt(comp);
    this.doAnimationWrapper(
      isShow,
      noDelay ? 0 : this.getDelay(viewId),
      () => { opt.setSpaceScale(isShow ? 1 : 1 + (this.viewScaleOffset.get(comp) || BASE_SCALE_RATIO)); },
      () => {},
      this.getOpacityDuration(opt.getSpaceOpacity(), isShow ? 1 : 0),
      () => { opt.setSpaceOpacity(isShow ? 1 : 0); },
      () => {},
      isSkipAnim
    );
  }

  /**
   * 计算横向缩放中心
   * @param id string
   * @param screenWidthPx number
   * @returns number | string
   */
  public static getScaleCenterX(id: string, screenWidthPx: number): number | string {
    let rectInfo: RectInfo = ItemUtils.getRectById(id);
    let width: number = px2vp(screenWidthPx);
    return width / 2 - rectInfo.left;
  }

  /**
   * 计算纵向缩放中心
   * @param id string
   * @param screenHeightPx number
   * @returns number | string
   */
  public static getScaleCenterY(id: string, screenHeightPx: number): number | string {
    let rectInfo: RectInfo = ItemUtils.getRectById(id);
    let height: number = px2vp(screenHeightPx);
    return height / 2 - rectInfo.top;
  }

  /**
   * 执行解锁动效
   * @param isShow boolean
   * @param noDelay boolean ture滑动解锁,false面容指纹解锁
   */
  public doItemNoPwdUnlockAnimation(isShow: boolean, noDelay: boolean): void {
    let isSkipAnim: boolean = !this.isUnlockToHome();
    log.showInfo(`doItemNoPwdUnlockAnimation: ${isSkipAnim}`);
    (Object.values(SpaceAniComponentType) as number[]).forEach(comp => {
      this.doAnimation(isShow, noDelay, isSkipAnim, comp);
    });
  }

  public isUnlockToHome(): boolean {
    return slClockOneShotToDesktopService.isClockOneShotAnimAvailable();
  }

  /**
   * 设置解锁动效参数值
   * @param opacity number
   * @param scale number
   */
  public setUnlockAnimation(opacity: number, scale: number): void {
    (Object.values(SpaceAniComponentType) as number[]).forEach(comp => {
      let opt: ScreenLockSpaceAniData = this.getOpt(comp);
      opt.setSpaceOpacity(opacity);
      opt.setSpaceScale(scale);
    });
  }

  public setSlideAnimation(opacity: number, scale: number): void {
    (Object.values(SpaceAniComponentType) as number[]).forEach(comp => {
      let opt: ScreenLockSpaceAniData = this.getOpt(comp);
      opt.setSpaceOpacity(opacity);
      opt.setSpaceScale(scale * (this.viewScaleOffset.get(comp) || BASE_SCALE_RATIO) + 1);
    });
  }

  /**
   * 计算时延
   * @param id string
   * @returns number
   */
  public getDelay(id: string): number {
    // Set min is bottom and max is lock icon
    let screenHeightPx = this.screenProp.height;
    let screenHeight: number = px2vp(screenHeightPx / 2);
    let bottomRectInfo: RectInfo =
      ItemUtils.getRectById(this.viewIdMap.get(SpaceAniComponentType.IMMERSIVE_CAP));
    let bottomDistance = Math.abs(bottomRectInfo.top - screenHeight);

    let topRectInfo: RectInfo = ItemUtils.getRectById(this.viewIdMap.get(SpaceAniComponentType.LOCK_ICON));
    let topDistance = Math.abs(screenHeight - topRectInfo.top);
    let maxDistance = Math.max(bottomDistance, topDistance);

    let rectInfo: RectInfo = ItemUtils.getRectById(id);
    let distance = Math.abs(screenHeight - rectInfo.top);
    let ratio = Math.abs((distance - maxDistance) / maxDistance);
    return (1.8 * ratio - 0.8 * ratio * ratio) * 300;
  }

  /**
   * 计算时长
   * @param opacity number
   * @param target number
   * @returns number
   */
  public getOpacityDuration(opacity: number, target: number): number {
    return 200 * Math.abs(opacity - target);
  }

  public getImmersiveKeyguardListScale(isSlidingOrUnlocking: boolean): ScaleOptions | undefined {
    if (isSlidingOrUnlocking && this.immersiveState.isList()) {
      return {
        x: this.immersiveListAniOpt.getSpaceScale(),
        y: this.immersiveListAniOpt.getSpaceScale(),
        centerX: ScreenLockSpaceAnimationViewModel.getScaleCenterX(SlWidgetId.IMMERSIVE_LIST, this.screenProp.width),
        centerY: ScreenLockSpaceAnimationViewModel.getScaleCenterY(SlWidgetId.IMMERSIVE_LIST, this.screenProp.height)
      };
    }
    return undefined;
  }

  public getImmersiveKeyguardListOpacity(isSlidingOrUnlocking: boolean): number | undefined {
    if (isSlidingOrUnlocking && this.immersiveState.isList()) {
      return this.immersiveListAniOpt.getSpaceOpacity();
    }
    return undefined;
  }

  public getImmersiveKeyguardCardScale(isSlidingOrUnlocking: boolean): ScaleOptions | undefined {
    if (isSlidingOrUnlocking && this.immersiveState.isImmersive()) {
      return {
        x: this.immersiveCardAniOpt.getSpaceScale(),
        y: this.immersiveCardAniOpt.getSpaceScale(),
        centerX: ScreenLockSpaceAnimationViewModel.getScaleCenterX(SlWidgetId.IMMERSIVE_CARD, this.screenProp.width),
        centerY: ScreenLockSpaceAnimationViewModel.getScaleCenterY(SlWidgetId.IMMERSIVE_CARD, this.screenProp.height)
      };
    }
    return undefined;
  }

  public getImmersiveKeyguardCardOpacity(isSlidingOrUnlocking: boolean): number | undefined {
    if (isSlidingOrUnlocking && this.immersiveState.isImmersive()) {
      return this.immersiveCardAniOpt.getSpaceOpacity();
    }
    return undefined;
  }

  getClockScale(scaleValue: number, pivot: WidgetPivot): ScaleOptions {
    return {
      x: scaleValue,
      y: scaleValue,
      centerX: pivot?.centerX ?? '50%',
      centerY: pivot?.centerY ?? '50%'
    }
  }

  getQuickToolsIconScale(isSlidingOrUnlocking: boolean, scaleValue: number, ntfScaleValue: number, pivot: WidgetPivot):
    ScaleOptions {
    if (isSlidingOrUnlocking) {
      return {
        x: scaleValue,
        y: scaleValue,
        centerX: ScreenLockSpaceAnimationViewModel.getScaleCenterX(SlWidgetId.QUICK_TOOLS_ICON, this.screenProp.width),
        centerY: ScreenLockSpaceAnimationViewModel.getScaleCenterY(SlWidgetId.QUICK_TOOLS_ICON, this.screenProp.height)
      }
    } else {
      return {
        x: ntfScaleValue,
        y: ntfScaleValue,
        centerX: pivot?.centerX ?? '50%',
        centerY: pivot?.centerY ?? '50%'
      }
    }
  }

  getCameraIconScale(isSlidingOrUnlocking: boolean, scaleValue: number, ntfScaleValue: number,
    pivot: WidgetPivot): ScaleOptions {
    if (isSlidingOrUnlocking) {
      return {
        x: scaleValue,
        y: scaleValue,
        centerX: ScreenLockSpaceAnimationViewModel.getScaleCenterX(SlWidgetId.CAMERA_ICON, this.screenProp.width),
        centerY: ScreenLockSpaceAnimationViewModel.getScaleCenterY(SlWidgetId.CAMERA_ICON, this.screenProp.height)
      }
    } else {
      return {
        x: ntfScaleValue,
        y: ntfScaleValue,
        centerX: pivot?.centerX ?? '50%',
        centerY: pivot?.centerY ?? '50%'
      }
    }
  }

  getLockIconScale(isSlidingOrUnlocking: boolean, scaleValue: number, isNtfAnim: boolean, ntfScaleValue: number,
    pivot: WidgetPivot): ScaleOptions | undefined {
    if (isSlidingOrUnlocking) {
      return {
        x: scaleValue,
        y: scaleValue,
        centerX: '50%',
        centerY: ScreenLockSpaceAnimationViewModel.getScaleCenterY(SlWidgetId.LOCK_HEAD, this.screenProp.height)
      }
    } else if (isNtfAnim) {
      return {
        x: ntfScaleValue,
        y: ntfScaleValue,
        centerX: pivot?.centerX ?? '50%',
        centerY: pivot?.centerY ?? '50%'
      }
    } else {
      return undefined;
    }
  }

  getClockAnimScale(isCurAnimating: boolean, curAnimateScale: ScaleOptions, sceneAnimateScale: ScaleOptions):
    ScaleOptions {
    return isCurAnimating ? curAnimateScale : sceneAnimateScale;
  }

  getClockSlideAnimScale(scaleValue: number): ScaleOptions {
    return {
      x: scaleValue,
      y: scaleValue,
      centerX: '50%',
      centerY: ScreenLockSpaceAnimationViewModel.getScaleCenterY(SlWidgetId.CLOCK, this.screenProp.height)
    };
  }

  /**
   * 非时钟控件解锁空间感动效，条件：1、滑动；2、无密码或者解锁成功；
   *
   * @returns 是否空间感
   */
  private static isComponentSpaceUnlockAnimation(): boolean {
    let slBindState: ISlState | undefined = slStateHelper.getSlBindState();
    let zoomRatio = slBindState?.getSlState(SlBindStateType.SL_ZOOM_RATIO) ?? Constants.DEFAULT_ZOOM_RATIO;
    return VerifyDataManager.getInstance().hasNoPwd && zoomRatio > Constants.DEFAULT_ZOOM_RATIO;
  }

  /**
   * 时钟控件解锁空间感动效，条件：1、滑动；2、无密码或者解锁成功；3、非时钟一镜到底场景
   *
   * @returns 是否空间感
   */
  private static isClockSpaceUnlockAnimation(): boolean {
    if (!ScreenLockSpaceAnimationViewModel.isComponentSpaceUnlockAnimation()) {
      return false;
    }

    // 非时钟一镜到底
    return !slClockOneShotToDesktopService.isClockOneShotAnimAvailable();
  }

  /**
   * 控件解锁空间感动效
   * 时钟控件解锁空间感动效，条件：1、滑动；2、无密码或者解锁成功；3、非时钟一镜到底场景
   * 非时钟控件解锁空间感动效，条件：1、滑动；2、无密码或者解锁成功；
   *
   * @returns 是否空间感
   */
  public static isSpaceUnlockAnimation(componentId?: SlWidgetId): boolean {
    // 时钟
    if (componentId && componentId === SlWidgetId.CLOCK) {
      return ScreenLockSpaceAnimationViewModel.isClockSpaceUnlockAnimation();
    }

    // 非时钟
    return ScreenLockSpaceAnimationViewModel.isComponentSpaceUnlockAnimation();
  }
}

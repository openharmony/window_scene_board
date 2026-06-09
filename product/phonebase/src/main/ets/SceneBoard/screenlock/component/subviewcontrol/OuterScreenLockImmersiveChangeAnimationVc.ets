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
import { WallpaperData, WallpaperManager } from '@ohos/frameworkwrapper';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { BannerPanelType, IState, OnStateChangeListener, StateType } from '@ohos/systemuicommon';
import { immersiveKgMgr, ImmersiveState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import ThemeHelperUtil from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import { slStateHelper } from '../../model/helper/SlStateHelper';
import { bannerMgr, SceneFlag } from '@ohos/systemuicommon';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import lazy { SlOuterFormBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlOuterFormBindState';
import lazy { SlOuterToolsBindState } from '../../model/data/SlOuterToolsBindState';

const TAG = 'ImmersiveStateChangeAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const DEFAULT_DURATION = 300;

export enum OuterScreenLockImmersiveChangeState {
  SCREEN_LOCK_UN_NEED_ANIMATION = -1,
  SCREEN_LOCK_CAPSULE_TO_LIST = 0,
  SCREEN_LOCK_LIST_TO_CAPSULE = 1,
  SCREEN_LOCK_LIST_TO_AOD = 2,
  SCREEN_LOCK_IMMERSIVE_TO_CAPSULE = 3,
  SCREEN_LOCK_IMMERSIVE_TO_AOD = 4,
}

/**
 * 小折叠外屏沉浸式状态切换时，锁屏元素联动动效控制类
 */
export class OuterScreenLockImmersiveChangeAnimationVc {

  private isImmersiveList: boolean = false;

  private animationMap: Map<OuterScreenLockImmersiveChangeState, Function>;

  constructor() {
    this.animationMap = new Map<OuterScreenLockImmersiveChangeState, Function>([
      [OuterScreenLockImmersiveChangeState.SCREEN_LOCK_CAPSULE_TO_LIST, this.shrinkAnimation],
      [OuterScreenLockImmersiveChangeState.SCREEN_LOCK_LIST_TO_CAPSULE, this.zoomToScreenLockAnimation],
      [OuterScreenLockImmersiveChangeState.SCREEN_LOCK_LIST_TO_AOD, this.zoomToAODAnimation],
      [OuterScreenLockImmersiveChangeState.SCREEN_LOCK_IMMERSIVE_TO_CAPSULE, this.zoomToScreenLockAnimation],
      [OuterScreenLockImmersiveChangeState.SCREEN_LOCK_IMMERSIVE_TO_AOD, this.zoomToAODAnimation],
    ]);
  }

  /**
   * 消息通知状态切换时，锁屏元素缩小动画
   */
  public shrinkAnimation(): void {
    let wallpaperData: WallpaperData = WallpaperManager.getInstance().wallpaperData;
    log.showInfo('immersiveChange shrinkAnimation');
    animateTo({
      duration: DEFAULT_DURATION,
      curve: Curve.Linear,
      onFinish: () => {
        OuterScreenLockImmersiveChangeAnimationVc.endAnimationState('shrinkAnimation');
      }
    }, () => {
      if (ThemeHelperUtil.isStaticTheme()) {
        wallpaperData.wallpaperScale = Constants.DEFAULT_SCALE;
      }
      OuterScreenLockImmersiveChangeAnimationVc
        .setAnimationState(Constants.IMMERSIVE_LIST_CARD_SCALE, 0, 'shrinkAnimation');
    });
  }

  /**
   * 消息通知状态在锁屏上切换时，锁屏元素放大动画
   */
  public zoomToScreenLockAnimation(): void {
    let wallpaperData: WallpaperData = WallpaperManager.getInstance().wallpaperData;
    log.showInfo('immersiveChange zoomToScreenLockAnimation');
    animateTo({
      duration: DEFAULT_DURATION,
      curve: Curve.Linear,
      onFinish: () => {
        OuterScreenLockImmersiveChangeAnimationVc.endAnimationState('zoomToScreenLockAnimation');
      }
    }, () => {
      if (ThemeHelperUtil.isStaticTheme()) {
        wallpaperData.wallpaperScale = Constants.DEFAULT_WALLPAPER_SCALE;
      }
      OuterScreenLockImmersiveChangeAnimationVc
        .setAnimationState(Constants.DEFAULT_SCALE, 1.0, 'zoomToScreenLockAnimation');
    });
  }

  /**
   * 消息通知状态切换AOD，锁屏元素放大动画
   */
  public zoomToAODAnimation(): void {
    let wallpaperData: WallpaperData = WallpaperManager.getInstance().wallpaperData;
    log.showInfo('immersiveChange zoomToAODAnimation');
    animateTo({
      duration: DEFAULT_DURATION,
      curve: Curve.Linear,
      onFinish: () => {
        OuterScreenLockImmersiveChangeAnimationVc.endAnimationState('zoomToAODAnimation');
      }
    }, () => {
      if (ThemeHelperUtil.isStaticTheme()) {
        wallpaperData.wallpaperScale = Constants.DEFAULT_SCB_WALLPAPER_SCALE;
      }
      OuterScreenLockImmersiveChangeAnimationVc.setAnimationState(Constants.DEFAULT_SCALE, 1, 'zoomToAODAnimation');
      log.showInfo(`onImmersiveChange wallpaperScale ${wallpaperData.wallpaperScale}`);
    });
  }

  /**
   * 清除对应动效标志位
   * @param animScene 动效名称
   */
  public static endAnimationState(animScene: string) {
    let clockAnimState: WidgetAnimState = slStateHelper.getClockViewAnimSt();
    let slOuterFormAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlOuterFormAnimCtrl();
    let slOuterToolsAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlOuterToolsAnimCtrl();
    if (clockAnimState.isSceneAnimating(animScene)) {
      clockAnimState.setAnimScene({isAnimating: false, animScene: animScene, isForceRemove: true});
    }
    if (slOuterFormAnimCtrl?.isSceneAnimating(animScene)) {
      slOuterFormAnimCtrl?.setAnimScene({isAnimating: false, animScene: animScene, isForceRemove: true});
    }
    if (slOuterToolsAnimCtrl?.isSceneAnimating(animScene)) {
      slOuterToolsAnimCtrl?.setAnimScene({isAnimating: false, animScene: animScene, isForceRemove: true});
    }
  }

  /**
   * 设置动效属性
   * @param endValue 动效目标值
   * @param alpha 透明度动效目标值
   * @param animScene 动效名称
   */
  public static setAnimationState(endValue: number, alpha: number, animScene: string) {
    let clockAnimState: WidgetAnimState = slStateHelper.getClockViewAnimSt();
    let slOuterFormAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlOuterFormAnimCtrl();
    let slOuterToolsAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlOuterToolsAnimCtrl();
    clockAnimState.setAnimScene({isAnimating: true, animScene: animScene, isForceRemove: true})
      .setScaleX(endValue)
      .setScaleY(endValue)
      .setAlpha(alpha);
    slOuterFormAnimCtrl?.setAnimScene({isAnimating: true, animScene: animScene, isForceRemove: true})
      .setScaleX(endValue)
      .setScaleY(endValue);
    slOuterToolsAnimCtrl?.setAnimScene({isAnimating: true, animScene: animScene, isForceRemove: true})
      .setScaleX(endValue)
      .setScaleY(endValue);
    log.showInfo(`onImmersiveChange endValue ${endValue}`);
  }

  /**
   * 设置动效结束后组件属性值
   * @param endValue 动效结束后组件属性值
   * @param alpha 动效结束后时钟透明度值
   */
  public static setBindState(endValue: number, alpha: number) {
    let slClockBindCtrl: SlClockBindState = slStateHelper.getSlClockBindState();
    let slOuterFormBindCtrl: SlOuterFormBindState | undefined = slStateHelper.getSlOuterFormBindState();
    let slOuterToolsBindCtrl: SlOuterToolsBindState | undefined = slStateHelper.getSlOuterToolsBindState();
    slClockBindCtrl.setLayoutScale(endValue);
    slClockBindCtrl.setLayoutOpacity(alpha);
    slOuterFormBindCtrl?.setLayoutScale(endValue);
    slOuterToolsBindCtrl?.setLayoutScale(endValue);
    log.showInfo(`immersiveChange slClockBindCtrl: ${slClockBindCtrl.getLayoutOpacity()}`);
  }

  /**
   * 复位所有动效
   */
  public clearAnimationState(): void {
    OuterScreenLockImmersiveChangeAnimationVc.endAnimationState('shrinkAnimation');
    OuterScreenLockImmersiveChangeAnimationVc.endAnimationState('zoomToScreenLockAnimation');
    OuterScreenLockImmersiveChangeAnimationVc.endAnimationState('zoomToAODAnimation');
    OuterScreenLockImmersiveChangeAnimationVc.setAnimationState(Constants.DEFAULT_SCALE, 1, 'clearAnimationState');
    OuterScreenLockImmersiveChangeAnimationVc.setBindState(Constants.DEFAULT_SCALE, 1);
    OuterScreenLockImmersiveChangeAnimationVc.endAnimationState('clearAnimationState');
  }

  private getAnimationType(): number {
    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST)) {
      this.isImmersiveList = true;
      return OuterScreenLockImmersiveChangeState.SCREEN_LOCK_CAPSULE_TO_LIST;
    } else if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_NONE) && this.isImmersiveList) {
      this.isImmersiveList = false;
      if (bannerMgr.getBannerState().bannerPanelType.isTypeScene(SceneFlag.SCENE_RELEASE_LIVE_LIST_BY_SCREEN_OFF)) {
        return OuterScreenLockImmersiveChangeState.SCREEN_LOCK_LIST_TO_AOD;
      }
      return AppStorage.get('isPwdVisible') ? OuterScreenLockImmersiveChangeState.SCREEN_LOCK_UN_NEED_ANIMATION :
      OuterScreenLockImmersiveChangeState.SCREEN_LOCK_LIST_TO_CAPSULE;
    }
    log.showInfo('outerScreen immersiveChange unNeedAnimation');
    return OuterScreenLockImmersiveChangeState.SCREEN_LOCK_UN_NEED_ANIMATION;
  }

  private CapsuleAnimationProcess(preImmersiveState: ImmersiveState): number {
    if (preImmersiveState.isList()) {
      return bannerMgr.getBannerState().bannerPanelType.isTypeScene(SceneFlag.SCENE_RELEASE_LIVE_LIST_BY_SCREEN_OFF) ?
      OuterScreenLockImmersiveChangeState.SCREEN_LOCK_LIST_TO_AOD :
      OuterScreenLockImmersiveChangeState.SCREEN_LOCK_LIST_TO_CAPSULE;
    } if (preImmersiveState.isImmersive()) {
      log.showInfo('CapsuleAnimationProcess isImmersive');
      return bannerMgr.getBannerState().bannerPanelType.isTypeScene(SceneFlag.SCENE_RELEASE_LIVE_LIST_BY_SCREEN_OFF) ?
      OuterScreenLockImmersiveChangeState.SCREEN_LOCK_IMMERSIVE_TO_AOD :
      OuterScreenLockImmersiveChangeState.SCREEN_LOCK_IMMERSIVE_TO_CAPSULE;
    }
    log.showInfo('CapsuleAnimationProcess unNeed');
    return OuterScreenLockImmersiveChangeState.SCREEN_LOCK_UN_NEED_ANIMATION;
  }
}
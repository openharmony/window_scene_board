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
import { LogHelper, LogDomain, SingletonHelper, CommonUtils } from '@ohos/basicutils';
import { ViewManagerPolicy, ViewType, ViewController, } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { AnimParam } from './LiveItemStartAnimManager';
import { OverlayStartAnimHelper } from '../../overlay/OverlayStartAnimHelper';
import { StartAbilityOverlayAnimateData, StartAbilityOverlayAnimateConstants } from './StartAbilityOverlayAnimateData';
import HiTrace from '@ohos.hiTraceMeter';
import { CardBorderRadius, OverlayAnimScene, OverlayCardInfo } from '../../overlay/OverlayCardInfo';
import { DefaultPanelZIndex } from '../../base/common/info/DefaultPanelZIndex';
import { LiveUseScene, LiveViewCommonConstants } from './LiveConstants';

const TAG = 'Ntf.StartAbilityOverlayAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const TRACE_TAG = 'START_LOCK_NTF';
const ANIM_DURATION: number = 400;
const ANIM_DURATION_DELAY: number = 20;
/*
动效开始调整壁纸层级比桌面层级高; 桌面层级为2
 */
const WALLPAPER_Z_INDEX_ANIM = 4;
/*
动效结束还原壁纸层级;
 */
const WALLPAPER_Z_INDEX = 1;

export class StartAbilityOverlayAnimate {
  private animateData?: StartAbilityOverlayAnimateData;
  private resetAnimTimeout?: number;
  private animParam?: AnimParam;


  public static getInstance(): StartAbilityOverlayAnimate {
    let startAbilityAnimate: StartAbilityOverlayAnimate = SingletonHelper.getInstance(StartAbilityOverlayAnimate, TAG);
    return startAbilityAnimate;
  }

  public initData(animateData: StartAbilityOverlayAnimateData) {
    this.animateData = animateData;
  }

  prepareForOverlayAnimate(param: AnimParam) {
    this.adjustScreenLockZIndex();
    this.setParamsForOverlayAnim(param);
    this.clearResetTimeout();
    this.handleAnimFinish();
  }

  private handleAnimFinish(): void {
    this.resetAnimTimeout = setTimeout(() => {
      log.showInfo('handleAnimFinish');
      if (this.animateData) {
        this.animateData.initData();
      }
      this.resetScreenLockZIndex();
      this.animParam?.onAnimComplete?.();
      this.cleanData();
    }, OverlayCardInfo.sceneAnimParam.duration ?? ANIM_DURATION + ANIM_DURATION_DELAY); // 动画时延 400ms, 这里多一帧
  }

  /**
   * 清理数据
   */
  private cleanData(): void {
    if (!CommonUtils.isInvalid(this.animParam)) {
      this.animParam = undefined;
    }
  }

  /**
   * 清除重置任务
   */
  private clearResetTimeout(): void {
    if (!CommonUtils.isInvalid(this.resetAnimTimeout)) {
      clearTimeout(this.resetAnimTimeout);
      this.resetAnimTimeout = undefined;
    }
  }

  adjustScreenLockZIndex() {
    // 动画准备
    let sysSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_KEYGUARD);
    let controller: ViewController | undefined = ViewManagerPolicy.getViewController(ViewType.WALLPAPER);
    controller?.setZIndex(WALLPAPER_Z_INDEX_ANIM);
    sysSession.zIndex = DefaultPanelZIndex.PANEL_SCENE_PANEL - 2;
  }

  resetScreenLockZIndex() {
    // 恢复默认z序
    log.showInfo('resetScreenLockZIndex');
    let sysSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_KEYGUARD);
    let controller: ViewController | undefined = ViewManagerPolicy.getViewController(ViewType.WALLPAPER);
    controller?.setZIndex(WALLPAPER_Z_INDEX);
    sysSession.zIndex = DefaultPanelZIndex.PANEL_SCREEN_LOCK;
  }

  private setParamsForOverlayAnim(param: AnimParam) {
    this.animParam = param;
    if (!param.startBundleName) {
      param?.onPreComplete?.();
      param?.onAnimComplete?.();
      this.cleanData();
      return;
    }
    if (!param.cardComponentId) {
      param.scene = LiveUseScene.SCENE_SCREEN_LOCK;
    }
    OverlayStartAnimHelper.startAnimPre({
      animScene: OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN,
      cardBgId: this.getItemContentId(param),
      cardContentId: this.getItemContentId(param),
      startBundleName: param.startBundleName,
      oriPanelZIndex: DefaultPanelZIndex.PANEL_SCREEN_LOCK,
      cardBgColor: LiveViewCommonConstants.ITEM_LOCK_NTF_BG_COLOR,
      cardRadius: this.getItemRadius(param)
    }, OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN);
  }

  onOverlayAnimateStart() {
    HiTrace.startTrace(TRACE_TAG, 1);
    animateTo({
      curve: Curve.Friction,
      duration: StartAbilityOverlayAnimateConstants.SCREEN_ANIM_DURATION,
      onFinish: () => {
        HiTrace.finishTrace(TRACE_TAG, 1);
      }
    }, () => {
      if (this.animateData) {
        this.animateData.ntfAnimScaleValue = StartAbilityOverlayAnimateConstants.SCREEN_ANIM_SCALE_VALUE;
      }
    })
  }

  getItemContentId(param: AnimParam): string {
    return !param.cardComponentId || CommonUtils.isEmpty(param.cardComponentId) ?
      LiveViewCommonConstants.getItemContentId(param?.cardId, param?.scene) : param.cardComponentId;
  }

  getItemRadius(param: AnimParam): CardBorderRadius {
    if (param.cardRadius === undefined || CommonUtils.isInvalid(param.cardRadius)) {
      return {
        topLeft: LiveViewCommonConstants.ITEM_BG_RADIUS,
        topRight: LiveViewCommonConstants.ITEM_BG_RADIUS,
        bottomLeft: LiveViewCommonConstants.ITEM_BG_RADIUS,
        bottomRight: LiveViewCommonConstants.ITEM_BG_RADIUS
      };
    }
    return param.cardRadius;
  }
}



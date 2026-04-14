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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { GestureDockConstants, GestureDockMode } from '../../../common/GestureDockConstants';
import { DockBarOutParam, DockBarParam, DockBarScrollerParam } from '../viewdata/GestureDockBarParam';
import { GestureDockBarViewDataMgr } from '../viewdata/GestureDockBarViewDataMgr';
import { curves } from '@kit.ArkUI';
import { GestureDockUtil } from '../../../common/util/GestureDockUtil';
import { GestureDockViewData } from '../../../dock/viewmodel/viewdata/GestureDockViewData';
import { GestureDockState } from '../../../dock/viewmodel/viewevent/GestureDockViewEventMgr';
import { GestureDockViewModel } from '../../../dock/viewmodel/GestureDockViewModel';
import { GestureDockItemInfo } from '../../model/GestureDockItemInfo';
import { GestureDockPreferenceMgr } from '../../../common/preference/GestureDockPreferenceMgr';

const TAG = 'GestureDockBarViewAnimate';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockBarViewAnimate
 */
export default class GestureDockBarViewAnimate {
  private dockViewModel: GestureDockViewModel = GestureDockViewModel.getInstance();
  private viewDataMgr: GestureDockBarViewDataMgr;
  private dockBarParam: DockBarParam;
  private dockBarScrollerParam: DockBarScrollerParam;
  private leftBarOutParam: DockBarOutParam;
  private rightBarOutParam: DockBarOutParam;

  /**
   * 构造器
   *
   * @param GestureDockBarViewDataMgr
   */
  constructor(viewDataMgr: GestureDockBarViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.dockBarParam = this.viewDataMgr.dockBarParam;
    this.dockBarScrollerParam = this.viewDataMgr.dockBarScrollerParam;
    this.leftBarOutParam = this.viewDataMgr.leftBarOutParam;
    this.rightBarOutParam = this.viewDataMgr.rightBarOutParam;
  }

  /**
   * gestureDock呼出动效
   * @param animationType 启动类型
   */
  public gestureDockAppearAnimate(animationType: number): void {
    animateTo({
      duration: GestureDockConstants.APPEAR_DELAY,
      curve: Curve.Linear,
      iterations: 1,
      playMode: PlayMode.Normal,
    }, () => {
      if (animationType === GestureDockState.GESTURE_DOCK_LEFT_OUT) {
        this.leftBarOutParam.shadow = this.viewDataMgr.colorShowMode ===
          GestureDockConstants.DARK_COLOR_MODE ? undefined : ShadowStyle.OUTER_DEFAULT_MD;
      } else {
        this.rightBarOutParam.shadow = this.viewDataMgr.colorShowMode ===
          GestureDockConstants.DARK_COLOR_MODE ? undefined : ShadowStyle.OUTER_DEFAULT_MD;
      }
    });
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 350, 28),
    }, () => {
      if (animationType === GestureDockState.GESTURE_DOCK_LEFT_OUT) {
        this.leftBarOutParam.translation = RTLUtil.isRTL() ? -this.viewDataMgr.getDockOutTranslation(true) :
          this.viewDataMgr.getDockOutTranslation(true);
      } else {
        this.rightBarOutParam.translation = RTLUtil.isRTL() ?
          this.viewDataMgr.getDockOutTranslation(false) : -this.viewDataMgr.getDockOutTranslation(false);
      }
    });
  }

  /**
   * gestureDock呼入动效
   * @param originDirection
   * @param isGestureDockAppear
   * @param resetDockPositionCallback
   * @param immediately
   */
  public dockBarRestPositionAnimate(originDirection: number, isGestureDockAppear: boolean,
    resetDockPositionCallback?: Function, immediately?: boolean): void {
    let animParam: AnimateParam = {
      curve: curves.interpolatingSpring(0, 1, 350, 28),
      onFinish: (() => {
        this.dockViewModel.getViewEvent()?.showGestureDock(isGestureDockAppear);
        resetDockPositionCallback?.();
      })
    };
    let event = () => {
      if (originDirection === GestureDockState.GESTURE_DOCK_LEFT_OUT) {
        this.leftBarOutParam.translation = 0;
      } else {
        this.rightBarOutParam.translation = 0;
      }
    };
    if (immediately) {
      animateToImmediately(animParam, event);
    } else {
      animateTo(animParam, event);
    }
    this.dockShadowDisappearAnimate(originDirection);
  }

  private dockShadowDisappearAnimate(originDirection: number) {
    setTimeout(() => {
      animateTo({
        duration: GestureDockConstants.APPEAR_DELAY,
        curve: Curve.Linear,
        iterations: 1,
        playMode: PlayMode.Normal,
      }, () => {
        if (originDirection === GestureDockState.GESTURE_DOCK_LEFT_OUT) {
          this.leftBarOutParam.shadow = undefined;
        } else {
          this.rightBarOutParam.shadow = undefined;
        }
      });
    }, GestureDockConstants.DISAPPEAR_DELAY);
  }

  /**
   * allApps显示动效
   */
  public doTranslateAnimateOnAllAppsShow(): void {
    animateTo({
      curve: curves.springMotion(0.4, 1),
      duration: 250
    }, () => {
      let dockViewData = this.dockViewModel.getViewData();
      if (dockViewData?.isShowAllApps()) {
        if (dockViewData.getGestureDockDirection() === GestureDockState.GESTURE_DOCK_LEFT_OUT) {
          this.leftBarOutParam.translation = RTLUtil.isRTL() ?
            -this.viewDataMgr.getDockOutTranslation(true) : this.viewDataMgr.getDockOutTranslation(true);
        } else {
          this.rightBarOutParam.translation = RTLUtil.isRTL() ?
            this.viewDataMgr.getDockOutTranslation(false) : -this.viewDataMgr.getDockOutTranslation(false);
        }
        this.dockBarParam.blurRadius = 0;
        this.dockBarParam.backGroundColor = $r('app.color.transparent');
        return;
      }
      if (dockViewData?.getGestureDockDirection() === GestureDockState.GESTURE_DOCK_LEFT_OUT) {
        this.leftBarOutParam.translation =
          RTLUtil.isRTL() ? -this.viewDataMgr.getDockOutTranslation(true) :
            this.viewDataMgr.getDockOutTranslation(true);
      } else {
        this.rightBarOutParam.translation =
          RTLUtil.isRTL() ? this.viewDataMgr.getDockOutTranslation(false) :
            -this.viewDataMgr.getDockOutTranslation(false);
      }
      this.dockBarParam.blurRadius = GestureDockConstants.GESTURE_DOCK_BLUR_RADIUS;
      this.dockBarParam.backGroundColor = $r('app.color.gesture_dock_bg_color');
    });
  }

  /**
   * 做删除App动效
   *
   * @param index
   */
  public doDeleteAppAnimation(index: number): void {
    animateTo({ duration: 0 }, () => {
      let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
      residentApps.splice(index, 1);
      if (this.dockViewModel.getViewData()?.getGestureDockShowMode() === GestureDockMode.EDIT) {
        residentApps.push(new GestureDockItemInfo());
      }
      AppStorage.setOrCreate('gestureDockList', residentApps);
      GestureDockPreferenceMgr.getInstance().updateDockAppsPreference(residentApps);
    });
  }
}
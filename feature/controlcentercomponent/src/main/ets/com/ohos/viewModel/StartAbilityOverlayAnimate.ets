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

import image from '@ohos.multimedia.image';
import { LogHelper, LogDomain, SingletonHelper, AnimateToScheduleUtils } from '@ohos/basicutils';
import { ViewType } from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/TsIndex';
import parameter from '@ohos.systemParameterEnhance';
import { OverlayAnimScene } from '@ohos/systemuicommon/src/main/ets/overlay/OverlayCardInfo';
import { DefaultPanelZIndex } from '@ohos/systemuicommon/src/main/ets/base/common/info/DefaultPanelZIndex';
import { ScreenLockStatus } from '@ohos/screenlockcommon/src/main/ets/interface/ScreenOnOffMediator';
import { OverlayStartAnimHelper } from '@ohos/systemuicommon/src/main/ets/overlay/OverlayStartAnimHelper';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ICON_ID_SETTINGS, COMPONENT_ID_SETTINGS } from '../pages/newStyle/ControlCenterHeaderLayout'
import { StartAbilityOverlayAnimateData, StartAbilityOverlayAnimateConstants } from '../model/StartAbilityOverlayAnimateData'
import { HeaderViewModel } from './HeaderViewModel';
import { OverlayStartAnimHelperAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/OverlayStartAnimHelperAdapter';
import { ViewManagerAdapter, ViewMgrPolicyViewCallback } from '@ohos/systemuicommon/src/main/ets/adapter/ViewManagerAdapter';
import { ScreenLockAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenLockAdapter';

const TAG = 'Ctrl.StartAbilityOverlayAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class StartAbilityOverlayAnimate {

  private static readonly ANIM_START_TIMEOUT: number = 50;

  private animateData?: StartAbilityOverlayAnimateData;

  private timeoutId?: number | undefined;

  constructor() {
    ViewManagerAdapter.registerViewCallback(this.dropDownCallback, `${TAG}_registerViewCallback`);
  }

  private dropDownCallback: ViewMgrPolicyViewCallback = {
    viewType: ViewType.DROPDOWN,
    onHide: (): void => {
      // 控制中心收起之后参数复原
      if (this.animateData) {
        this.animateData.initData();
      }
      HeaderViewModel.getInstance().setVisibleOfSettingIcon(true);
    }
  }

  public static getInstance(): StartAbilityOverlayAnimate {
    let startAbilityAnimate: StartAbilityOverlayAnimate = SingletonHelper.getInstance(StartAbilityOverlayAnimate, TAG);
    return startAbilityAnimate;
  }

  initData(animateData: StartAbilityOverlayAnimateData) {
    this.animateData = animateData;
  }

  public saveBackGroundImage(image: image.PixelMap) {
    if (this.animateData) {
      log.showInfo('saveBackGroundImage');
      this.animateData.snapshot = image;
    }
  }

  prepareForOverlayAnimate() {
    if (!this.animateData) {
      log.showError('animateData not init, return');
      return;
    }

    // 当前如果处于需要输入密码的锁屏状态走原动效流程
    if (ScreenLockAdapter.getLock() && AppStorage.get('lockStatus') === ScreenLockStatus.LOCKING) {
      log.showInfo('status is locking');
      return;
    }

    // 提前设置拦截器避免dropDownPanel收到应用启动广播触发控制中心自动收起动效
    this.animateData.shouldInterceptHideAnim = true;

    // 遮盖下方内容，避免控制中心下面内容变化造成的突变
    this.animateData.shouldCoverBelow = true;

    // 为overlay动效应用窗口的动效提前准备参数和添加拦截器，从而在窗口进行onStartFromOther应用启动系统动效时使用此处定制动效代替原有动效
    this.setParamsForOverlayAnim();

    // 超时处理
    this.timeoutId = setTimeout(() => {
      log.showInfo('overlay anim not happen in 50ms, hide controlCenter');
      this.onOverlayAnimateCancel();
    }, StartAbilityOverlayAnimate.ANIM_START_TIMEOUT);
  }

  private async setParamsForOverlayAnim() {
    let settingCardPosition = ItemUtils.getRectById(COMPONENT_ID_SETTINGS);
    let settingCardContentPosition = ItemUtils.getRectById(ICON_ID_SETTINGS);
    OverlayStartAnimHelperAdapter.startAnimPre({
      cardResource: $r('app.media.ic_public_settings'),
      cardPosition: {
        left: settingCardPosition?.left,
        top: settingCardPosition?.top,
        width: settingCardPosition?.width,
        height: settingCardPosition?.height,
      },
      cardContentPosition: {
        left: settingCardContentPosition?.left,
        top: settingCardContentPosition?.top,
        width: settingCardContentPosition?.width,
        height: settingCardContentPosition?.height,
      },
      onAnimActive: (): void => this.onOverlayAnimateStart(),
      onAnimCanceled: (): void => this.onOverlayAnimateCancel(),
      onAnimInactive: (): void => {
        log.showInfo('onAnimInactive');
        AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
        HeaderViewModel.getInstance().setVisibleOfSettingIcon(true);
      }
    }, `${TAG}_startAnimPre`);
  }

  // overlay整体动效中涉及控制中心面板的淡出动效
  onOverlayAnimateStart() {
    if (!this.animateData) {
      log.showError('animateData not init, return');
      return;
    }
    // 清理计时器
    if (this.timeoutId !== undefined) {
      log.showInfo('cancel timeout, begin overlay anim');
      clearTimeout(this.timeoutId);
      this.timeoutId = undefined;
    }
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
    // 隐藏设置按钮
    HeaderViewModel.getInstance().setVisibleOfSettingIcon(false);
    // 控制中心面板淡出动效
    animateToImmediately({
      curve: Curve.Friction,
      duration: StartAbilityOverlayAnimateConstants.MAIN_LAYOUT_ANIM_TIME
    }, () => {
      if (this.animateData) {
        this.animateData.mainLayoutOpacity = StartAbilityOverlayAnimateConstants.MAIN_LAYOUT_OPACITY;
        this.animateData.mainLayoutScale = StartAbilityOverlayAnimateConstants.MAIN_LAYOUT_SCALE;
      }
    })
    // 设置-系统-过渡动画缩放，1表示正常速度，2代表放慢2倍
    let animationScale = Number.parseInt(parameter.getSync('persist.sys.graphic.animationscale', '1'));
    let stayTime = animationScale * StartAbilityOverlayAnimateConstants.MAIN_LAYOUT_STAY_TIME;
    setTimeout(() => {
      log.showInfo('hideWindowDirectly');
      DropDownPanelManager.hideWindowDirectly();
    }, stayTime);
  }

  // 动画取消则直接收起控制中心
  onOverlayAnimateCancel() {
    log.showInfo('onOverlayAnimateCancel');
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
    if (this.animateData) {
      // 收起面板前先取消遮盖，避免面板收起后再取消遮盖造成突变
      this.animateData.initData();
    }
    // 及时重置动效控制器，避免影响其他的例如桌面点击图标一镜到底动效
    OverlayStartAnimHelperAdapter.resetOverlayTransition('StartAbilityOnOverlayAnimationCancel');
    HeaderViewModel.getInstance().setVisibleOfSettingIcon(true);
    DropDownPanelManager.animToDismiss();
  }
}
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

import {
  DesktopMode,
  HiEditModeDataEnterType,
  editModeManager,
  HiEditModeDataExitType,
  FormCenterViewManager,
  CommonConstants,
  MultiSelectManager,
  ReceiveEventInfo,
  LayoutViewModel,
} from '@ohos/launchercommon';
import { LightOutdoorConfig, localEventManager } from '@ohos/frameworkwrapper';
import { OutdoorConfig, LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, SystemParamUtils } from '@ohos/frameworkwrapper'
import { editModeViewManager } from '../manager/EditModeViewManager';
import { EventConstants } from '@ohos/launchercommon';
import { editModeUIExtensionViewModel } from '../../uiExtension/viewmodel/EditModeUIExtensionViewModel';
import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';

const TAG: string = 'EditModeViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const VALID_PINCH_GESTURE_DISTANCE = 72;
const TWO_FINGERS = 2;
const SQUARED = 2;

/**
 * 编辑模式手势枚举
 */
export enum PinchGestureActionType {
  ACTION_START,
  ACTION_UPDATE,
  ACTION_END
}

/**
 * 编辑模式viewEvent
 */
export class EditModeViewEvent {
  private inExitAnimation: boolean = false;
  private pinchStartDistance: number = 0;
  // 编辑模式点击空白处，手指的起始 or 结束位置
  private touchDownX: number = 0;
  private touchDownY: number = 0;
  private touchUpX: number = 0;
  private touchUpY: number = 0;
  private onDesktopModeChangeEvent: Function = (): void => editModeViewManager.onDesktopModeChange();
  private onStatusBarHideAnimationFinishEvent: Function = () => {
    this.onStatusBarHideAnimationFinish();
  }
  private readonly appExitListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: boolean): void => {
      log.showInfo(`appExitListener, receive event : ${event},param is ${params}`);
      if (event === EventConstants.EVENT_IN_APP_EXIT) {
        this.inExitAnimation = params;
        this.resetExitFlagDelay();
      }
    }
  };
  private onDesktopModeAnimateChangeEvent: (isEditMode: boolean) => void =
    (isEditMode: boolean) => editModeViewManager.onDesktopModeAnimateChange(isEditMode);
  // Edit Mode Switch, On by default
  private editSwitchEnable_: boolean = true;
  public get editSwitchEnable(): boolean {
    return this.editSwitchEnable_;
  }
  public set editSwitchEnable(value: boolean) {
    log.showInfo(`set editSwitchEnable from ${this.editSwitchEnable_} to ${value}`);
    this.editSwitchEnable_ = value;
  }
  public getPinchStartDistance() {
    return this.pinchStartDistance
  }
  public registerEvent() {
    GlobalContext.getContext().eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    GlobalContext.getContext()?.eventHub.on(CommonConstants.EVENTHUB_STATUS_BAR_HIDE_ANIMATION_FINISH,
      this.onStatusBarHideAnimationFinishEvent);
    GlobalContext.getContext().eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE_ANIMATE,
      this.onDesktopModeAnimateChangeEvent);
    localEventManager.registerEventListener(this.appExitListener, [EventConstants.EVENT_IN_APP_EXIT]);
  }

  private resetExitFlagDelay() {
    if (this.inExitAnimation) {
      setTimeout(() => {
        this.inExitAnimation = false;
      }, 800);
    }
  }

  public unRegisterEvent() {
    GlobalContext.getContext().eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    GlobalContext.getContext()?.eventHub.off(CommonConstants.EVENTHUB_STATUS_BAR_HIDE_ANIMATION_FINISH,
      this.onStatusBarHideAnimationFinishEvent);
    GlobalContext.getContext().eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE_ANIMATE,
      this.onDesktopModeAnimateChangeEvent);
    localEventManager.unregisterEventListener(this.appExitListener);
  }

  private onStatusBarHideAnimationFinish() {
    if (editModeManager.isInEditMode()) {
      // 编辑模式改变statusBar的背景色
    }
  }

  public doPinchGestureEvent(event: GestureEvent, type: PinchGestureActionType): void {
    if (!DeviceHelper.isPhone() && !DeviceHelper.isPad()) {
      log.showInfo('onPinchGesture, isPinchGestureSwitchOff');
      return;
    }

    // 户外模式模式禁用编辑模式
    if (OutdoorConfig.getInstance().isInOutdoorMode() ||
      LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      log.showInfo('onPinchGesture, isOutdoorMode');
      return;
    }

    //云端2禁用编辑模式
    if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      log.showInfo('onPinchGesture, onLightOutdoorMode');
      return;
    }

    if (event.fingerList.length !== TWO_FINGERS) {
      log.showInfo('onPinchGesture, finger count: %{public}d.', event.fingerList.length);
      return;
    }

    if (AppStorage.get('isInGridSwiperGesture')) {
      log.showInfo('onPinchGesture, currently in GridSwiper Gesture');
      return;
    }
    // 退出动效过程中，禁止双指捏合
    if (this.inExitAnimation) {
      log.showInfo('inExitAnimation,return');
      return;
    }
    //mask edit mode
    if (!this.editSwitchEnable) {
      return;
    }

    const fingerDistance = this.getPinchFingerDistance(event.fingerList[0], event.fingerList[1]);
    log.showInfo(`pinchGestureEvent, type = ${type}, fingerDistance = ${fingerDistance}`);

    switch (type) {
      case PinchGestureActionType.ACTION_START:
        this.pinchStartDistance = fingerDistance;
        break;
      case PinchGestureActionType.ACTION_UPDATE:
        let distance: number = fingerDistance - this.pinchStartDistance;
        if (distance > 0 && distance > VALID_PINCH_GESTURE_DISTANCE && editModeManager.isInEditMode()) {
          log.showInfo('start to show normal mode');
          editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_PINCH);
        } else if (distance < 0 && -distance > VALID_PINCH_GESTURE_DISTANCE && !editModeManager.isInEditMode()) {
          log.showInfo('start to show edit mode');
          editModeManager.changeDesktopMode(DesktopMode.EDIT_MODE, HiEditModeDataEnterType.ENTER_PINCH);
          // 关闭新形态折叠产品外屏编辑提示页
          AppStorage.setOrCreate('isShowEditModeGuidePage', false);
        }
        break;
      case PinchGestureActionType.ACTION_END:
        this.pinchStartDistance = 0;
        break;
      default:
        break;
    }
  }

  /**
   * back手势处理
   *
   * @param isExitEditMode 是否退出编辑模式
   */
  public backGestureHandler(): void {
    log.showInfo('backGestureHandler deal BACK_GESTURE_EVENT');
    if (FormCenterViewManager.getInstance().isFormCenterViewShowing()) {
      FormCenterViewManager.getInstance().closeFormCenterView();
      return;
    }
    if (editModeViewManager.isShowUIExtension()) {
      editModeUIExtensionViewModel.sendBackEvent();
    } else if (!MultiSelectManager.getInstance().inAnimation) {
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_GESTURE);
    }
  }

  /**
   * 记录编辑模式下，单击空白处手指的起始及结束位置
   */
  public calTouchDistance(event: TouchEvent): void {
    if (editModeManager.isInNormalMode() || !event.touches || !event.touches[0]) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.touchDownX = event.touches[0].x;
      this.touchDownY = event.touches[0].y;
    }
    if (event.type === TouchType.Up) {
      this.touchUpX = event.touches[0].x;
      this.touchUpY = event.touches[0].y;
    }
  }

  /**
   * 通过计算touch过程中移动距离判断是否可以为点击事件
   */
  public canExitEditMode(): boolean {
    return Math.hypot(this.touchDownX - this.touchUpX, this.touchDownY - this.touchUpY) <
      EditModeStyleConstants.EDIT_MODE_BACKPLANE_PAN_GESTURE_MIN_DISTANCE;
  }

  private getPinchFingerDistance(fingerLeft: FingerInfo, fingerRight: FingerInfo): number {
    if (!fingerLeft || !fingerRight) {
      return 0;
    }
    return Math.sqrt(Math.pow(fingerLeft.globalX - fingerRight.globalX, SQUARED) +
    Math.pow(fingerLeft.globalY - fingerRight.globalY, SQUARED));
  }
}
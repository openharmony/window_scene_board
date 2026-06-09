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

import { image } from '@kit.ImageKit';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import formInfo from '@ohos.app.form.formInfo';
import { CheckEmptyUtils, DomainName,
  LogDomain,
  LogHelper,
  JsonUtils,
  TraceUtil,
  PixelMapUtil
} from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { SnapshotType, dragSnapshotHelper } from '@ohos/componenthelper';
import {
  CardItemInfo,
  CloseAppManager,
  CommonConstants,
  desktopItemDraggableManager,
  FormCommonUtil,
  GridLayoutItemInfo,
  GridLayoutUtil,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { OverflowConstants } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { NumberConstants } from '@ohos/commonconstants';
import { FormBackboardVm, FormItemRelativeVm, FormMaskVm } from '../../form/viewmodel/FormItemRelativeVm';
import lazy {
  OverflowFormConnectionType,
  OverflowFormDisconnectionType,
  OverflowFormStatus,
  OverflowFormVm,
  ConnectionInfo,
} from '../viewmodel/OverflowFormVm';
import { FormItemRelativeEvent } from '../../form/viewmodel/FormItemRelativeEvent';
import { FormMenuEvent } from '../../form/viewmodel/FormMenuEvent';
import lazy OverflowFormUtils, { DisableGesture } from '../common/OverflowFormUtils';
import lazy { OverflowListener, OverflowViewModel } from '../viewmodel/OverflowViewModel';
import lazy { OverflowController } from '../controller/overflow/OverflowController';
import lazy { OverflowFormStatusController } from '../controller/status/OverflowFormStatusController';
import lazy OverflowEventReport from '../common/OverflowEventReport';
import { OverflowThresholdConfig } from '../common/OverflowThresholdConfig';

const TAG = 'OverflowSceneAnimationFormEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CLICK_FORM_ID_AVAILABLE_DURATION: number = 500;
const SNAPSHOT_TIMEOUT: number = 500;
const FOREGROUND_TIMEOUT: number = 800;

export class OverflowSceneAnimationFormEvent extends FormItemRelativeEvent implements OverflowListener {
  private mOverflowFormVm?: OverflowFormVm;
  private mOverflowFormId: string = '';
  private mRelativeItemId: string = '';
  private mUiContext?: UIContext;
  private overflowInfo: formInfo.OverflowInfo | undefined = undefined;
  private mIsRequestOverflow: boolean = false;
  private mOverflowController: OverflowController | undefined = undefined;
  private mOverflowFormStatusController?: OverflowFormStatusController;
  private uiExtProxy: UIExtensionProxy | null = null;
  private mIsSystemApp: boolean = false;
  private mSnapshotItemKey: string = '';
  private mAfterStartLongActiveOverflowTimer?: number;
  private mAfterStartLongActiveSizeTimer?: number;
  private mStopOverflowTimer?: number;
  private mConnectionTimer?: number;
  private mBackgroundTimer?: number;
  private mForegroundTimer?: number;
  private isInStartOverflow: boolean = false;
  private mIsInBackground: boolean = false;
  private isUpdateOverflowSnapshotSucceed: boolean = false;
  private updateOverflowSnapshot?: (formImage: image.PixelMap) => void;
  private releaseOverflowSnapshot?: () => void;

  // 打点相关
  private clickCardTime: number = 0; // 点击卡片时间
  private overflowFormActiveTime: number = 0; // 卡片激活时间
  private overflowFormActiveDuration: number = 0; // 激活总时长
  private isBaseFormInLongPress: boolean = false;
  private isUpdateSnapshotFailed: boolean = false;
  private isMenuShow: boolean = false;
  private mUseDefaultAnimation: boolean = true;
  private requestOverflowInner: Function = (overflowInfo: formInfo.OverflowInfo): boolean => {
    return false;
  };
  private mIsLongActiveForm?: boolean = false;

  constructor(formItemVm: FormItemRelativeVm, formBackVm: FormBackboardVm, formMaskVm: FormMaskVm,
    isOuter: boolean = false) {
    super(formItemVm, formBackVm, formMaskVm, isOuter);
  }

  public isInBackground(): boolean {
    return this.mIsInBackground;
  }

  public getOverflowInfo(): formInfo.OverflowInfo | undefined {
    return this.overflowInfo;
  }

  public isSystemApp(): boolean {
    return this.mIsSystemApp;
  }

  public isRequestOverflow(): boolean {
    return this.mIsRequestOverflow;
  }

  public useDefaultAnimation(): boolean {
    return this.mUseDefaultAnimation;
  }

  /**
   * 卡片配置信息初始化, 当前卡片为sceneAnimation卡片，如果此时设备类型为手机时, enabled 恒为 false，阻断卡片向元服务页面透传事件
   *
   * @param formItem 卡片配置信息
   * @param formHeight 卡片高度
   * @param formWidth 卡片宽度
   */
  public initFormInfo(formItem: CardItemInfo, formHeight: number, formWidth: number,
    formComponentBuilderId?: string): void {
    super.initFormInfo(formItem, formHeight, formWidth, formComponentBuilderId);
    let layoutItemInfo: GridLayoutItemInfo = (this.mFormItem as Object as GridLayoutItemInfo);
    this.mIsSystemApp = OverflowFormUtils.isSystemApp(layoutItemInfo.bundleName);
    log.showInfo(`initFormInfo: isGameForm = true, isFormEnabled: ${this.mFormItemVm.isFormEnabled}` +
      `, bundleName: ${(this.mFormItem as Object as GridLayoutItemInfo).bundleName}` +
      `, isSystemApp: ${this.mIsSystemApp}`);
    OverflowViewModel.getInstance().registerOverflowListener(this.mFormItem.cardId, this);
    this.mOverflowController = new OverflowController(this.mFormItemWidth, this.mFormItemHeight,
      this.mIsSystemApp,
      this.mFormItem.gameCardInfo);
    this.initRequestOverflowInner(this.mOverflowController);
    this.initOverflowControllerFunction();
  }

  private initRequestOverflowInner(overflowController: OverflowController | undefined): void {
    this.requestOverflowInner = (overflowInfo: formInfo.OverflowInfo, isLongActiveForm: boolean = false): boolean => {
      if (!overflowController) {
        return false;
      }
      let result: boolean = overflowController.handleOverflowRequest(overflowInfo, isLongActiveForm);
      if (!result) {
        return false;
      }
      log.showInfo(`Overflow Request is success, formId: ${this.mFormItem.cardId}` +
        `, the area of overflowInfo: [${overflowInfo.area.left}, ${overflowInfo.area.top}, ` +
        `${overflowInfo.area.width}, ${overflowInfo.area.height}]` +
        `, the duration of overflowInfo: ${overflowInfo.duration}`);
      return true;
    }
  }

  /**
   * 解注册 Overflow 监听
   */
  public unregisterOverflowListener(): void {
    OverflowViewModel.getInstance().unregisterOverflowListener(this.mFormItem.cardId, this);
  }

  /**
   * 卡片触发溢出动效回调，准备尺寸修改过程显示卡片截图，防止切换过程中画面跳变，
   */
  public startOverflow(): void {
    if (this.isLongActiveForm()) {
      this.startLongActiveFormOverflow();
    }
  }

  private clearLongActiveStartOverflowTimer(): void {
    this.isInStartOverflow = false;
    this.clearLongActiveOverflowTimer();
    this.clearLongActiveSizeTimer();
    this.clearRequestOverflowTimer();
  }

  private clearLongActiveOverflowTimer(): void {
    if (this.mAfterStartLongActiveOverflowTimer) {
      clearTimeout(this.mAfterStartLongActiveOverflowTimer);
      this.mAfterStartLongActiveOverflowTimer = undefined;
    }
  }

  private clearLongActiveSizeTimer(): void {
    if (this.mAfterStartLongActiveSizeTimer) {
      clearTimeout(this.mAfterStartLongActiveSizeTimer);
      this.mAfterStartLongActiveSizeTimer = undefined;
    }
  }

  private clearForegroundTimer(): void {
    if (this.mForegroundTimer) {
      clearTimeout(this.mForegroundTimer);
      this.mForegroundTimer = undefined;
    }
  }

  private clearStopOverflowTimer(): void {
    if (this.mStopOverflowTimer) {
      clearTimeout(this.mStopOverflowTimer);
      this.mStopOverflowTimer = undefined;
    }
  }

  private clearBackgroundTimer(): void {
    if (this.mBackgroundTimer) {
      clearTimeout(this.mBackgroundTimer);
      this.mBackgroundTimer = undefined;
    }
  }

  private clearStatusTimer(): void {
    this.clearLongActiveStartOverflowTimer();
    this.clearForegroundTimer();
    this.clearStopOverflowTimer();
    this.clearBackgroundTimer();
  }

  private startLongActiveFormOverflow(): void {
    if (!this.mOverflowFormVm) {
      log.showWarn('startLongActiveFormOverflow, mOverflowFormVm is undefined');
      return;
    }

    this.isInStartOverflow = true;
    if (this.mOverflowFormVm.overflowFormStatus !== OverflowFormStatus.ACTIVE) {
      log.showWarn('startLongActiveFormOverflow, overflowFormStatus is not active: %{public}d',
        this.mOverflowFormVm.overflowFormStatus);
      return;
    }

    if (this.mIsRequestOverflow) {
      log.showInfo('startLongActiveFormOverflow, overflow already, formId: %{public}s', this.mFormItem.cardId);
      this.isInStartOverflow = false;
      return;
    }

    // 更新截图
    this.updateLongActiveSnapshot();
  }

  public afterStartLongActiveFormOverflow(overflowInfo: formInfo.OverflowInfo | undefined): void {
    if (!this.mOverflowFormVm) {
      log.showWarn('afterStartLongActiveFormOverflow, mOverflowFormVm is undefined');
      return;
    }
    if (!overflowInfo) {
      log.showWarn('afterStartLongActiveFormOverflow, overflowInfo is undefined');
      return;
    }
    if (!this.isInStartOverflow) {
      log.showWarn('afterStartLongActiveFormOverflow, isInStartOverflow is false');
      return;
    }
    if (this.mIsRequestOverflow) {
      log.showInfo('afterStartLongActiveFormOverflow, overflow already, formId: %{public}s', this.mFormItem.cardId);
      this.isInStartOverflow = false;
      return;
    }

    if (this.mStopOverflowTimer || this.mBackgroundTimer || this.mForegroundTimer) {
      log.showInfo(`afterStartLongActiveFormOverflow, is in state change formId: ${this.mFormItem.cardId}` +
        `, this.mStopOverflowTimer: ${this.mStopOverflowTimer}, this.mBackgroundTimer: ${this.mBackgroundTimer}` +
        `, this.mForegroundTimer: ${this.mForegroundTimer}`);

      // 截图失败，清理定时器
      this.notifyStatusChange(OverflowConstants.OVERFLOW_FAILED);
      this.clearLongActiveStartOverflowTimer();
      return;
    }

    log.showInfo('afterStartLongActiveFormOverflow, start show image, formId: %{public}s, uecOpacity: %{public}d' +
      ', overflowFormVisibility: %{public}d, uecWidth: %{public}d, uecHeight: %{public}d, imageOpacity: %{public}d',
      this.mFormItem.cardId, this.mOverflowFormVm.uecOpacity, this.mOverflowFormVm.overflowFormVisibilityStatus,
      this.mOverflowFormVm.uiExtensionComponentWidth, this.mOverflowFormVm.uiExtensionComponentHeight,
      this.mOverflowFormVm.imageOpacity);
    this.clearLongActiveSizeTimer();
    this.mOverflowFormVm.imageOpacity = 1;
    this.mAfterStartLongActiveSizeTimer = setTimeout(() => {
      if (this.mOverflowFormVm && !this.mIsRequestOverflow) {
        log.showInfo(`afterStartLongActiveFormOverflow, start hide extension, formId: ${this.mFormItem.cardId}`);
        this.mOverflowFormVm.uecOpacity = 0;
        this.updateExtensionComponentToOverflow(overflowInfo);
      }
      this.mAfterStartLongActiveSizeTimer = undefined;
    }, NumberConstants.CONSTANT_NUMBER_100);

    this.clearLongActiveOverflowTimer();
    this.mAfterStartLongActiveOverflowTimer = setTimeout(() => {
      if (this.mIsRequestOverflow) {
        log.showInfo('afterStartLongActiveFormOverflow, is overflow already');
      } else if (this.mOverflowFormVm) {
        // 发送溢出失败信息
        this.notifyStatusChange(OverflowConstants.OVERFLOW_FAILED);
        this.mOverflowFormStatusController?.registerOperation(this, OverflowFormStatus.INACTIVE,
          true, this.mOverflowFormVm,
          this.uiExtProxy);
      } else {
        log.showInfo('afterStartLongActiveFormOverflow, mOverflowFormVm empty');
      }
      this.mAfterStartLongActiveOverflowTimer = undefined;
    }, SNAPSHOT_TIMEOUT);
  }

  public startShowLongActiveFormOverflow(): void {
    if (!this.mOverflowFormVm) {
      log.showInfo(`is not avaliable form, formId: ${this.mFormItem.cardId}`);
      return;
    }
    if (this.mOverflowFormVm.overflowFormStatus !== OverflowFormStatus.ACTIVE ||
      this.mIsRequestOverflow || !this.isInStartOverflow || !this.mIsLongActiveForm) {
      log.showInfo('can not show overflow, formId: %{public}s, status: %{public}s, isLongActiveForm: %{public}s' +
        ', isRequestOverflow: %{public}s, isInStartOverflow: %{public}s', this.mFormItem.cardId,
        this.mOverflowFormVm.overflowFormStatus, this.mIsLongActiveForm, this.mIsRequestOverflow,
        this.isInStartOverflow);
      return;
    }

    log.showInfo('startShowLongActiveFormOverflow formId: %{public}s, uecOpacity: %{public}d' +
      ', overflowFormVisibility: %{public}d, uecWidth: %{public}d, uecHeight: %{public}d, imageOpacity: %{public}d',
      this.mFormItem.cardId, this.mOverflowFormVm.uecOpacity, this.mOverflowFormVm.overflowFormVisibilityStatus,
      this.mOverflowFormVm.uiExtensionComponentWidth, this.mOverflowFormVm.uiExtensionComponentHeight,
      this.mOverflowFormVm.imageOpacity);
    this.mIsRequestOverflow = true;
    AppStorage.setOrCreate('activeForm', this.mFormItem as Object as GridLayoutItemInfo);
    this.mOverflowFormVm.imageOpacity = 0;
    this.mOverflowFormVm.uecOpacity = 1;
    this.isInStartOverflow = false;
    this.releaseOverflowSnapshot?.();
  }

  public stopLongActiveFormActive(hasDelay: boolean, isLongPress: boolean = false): void {
    if (!this.isLongActiveForm() || !this.mOverflowFormVm) {
      return;
    }
    log.showInfo('stopLongActiveFormActive, formId: %{public}s, hasDelay: %{public}s',
      this.mFormItem.cardId, hasDelay);
    this.notifyStatusChange(OverflowConstants.ON_BACKGROUND);
    if (!hasDelay) {
      this.stopLongActiveFormActiveInner();
      return;
    }

    this.clearBackgroundTimer();
    this.mBackgroundTimer = setTimeout(() => {
      this.stopLongActiveFormActiveInner();
    }, NumberConstants.CONSTANT_NUMBER_250);
  }

  private stopLongActiveFormActiveInner(): void {
    // 更新截图
    log.showInfo('stopLongActiveFormActiveInner, start, formId: %{public}s', this.mFormItem.cardId);
    this.mIsInBackground = true;
    this.updateLongActiveSnapshot();
  }

  public afterStopLongActiveFormActive(): void {
    if (!this.mOverflowFormVm) {
      this.mIsInBackground = false;
      return;
    }
    log.showInfo('afterStopLongActiveFormActive, start show image, formId: %{public}s', this.mFormItem.cardId);
    this.mOverflowFormVm.imageOpacity = 1;
    this.mOverflowFormStatusController?.registerOperation(this, OverflowFormStatus.PAUSE, false,
      this.mOverflowFormVm, this.uiExtProxy);
  }

  public resumeLongActiveFormActive(hasAnimation: boolean): void {
    if (!this.isLongActiveForm() || !this.mOverflowFormVm) {
      return;
    }
    log.showInfo('resumeLongActiveFormActive, formId: %{public}s', this.mFormItem.cardId);
    this.notifyStatusChange(OverflowConstants.ON_FOREGROUND);
    this.clearBackgroundTimer();
    this.mOverflowFormStatusController?.registerOperation(this, OverflowFormStatus.ACTIVE,
      hasAnimation, this.mOverflowFormVm, this.uiExtProxy);
  }

  public stopOverflow(hasAnimation: boolean, isTimeOut: boolean): void {
    this.overflowInfo = undefined;
    if (!this.mOverflowFormVm) {
      log.showWarn('stopOverflow: mOverflowFormVm is undefined');
      return;
    }
    if (isTimeOut) {
      this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.PROVIDER_QUIT;
    }
    this.notifyStatusChange(OverflowConstants.STOP_OVERFLOW);
    this.clearStatusTimer();
    if (this.mIsLongActiveForm) {
      this.mStopOverflowTimer = setTimeout(() => {
        this.stopOverflowInner(hasAnimation);
        this.mStopOverflowTimer = undefined;
      }, NumberConstants.CONSTANT_NUMBER_250);
      return;
    }
    this.stopOverflowInner(hasAnimation);
  }

  private stopOverflowInner(hasAnimation: boolean): void {
    if (!this.mOverflowFormVm) {
      log.showWarn('stopOverflowInner: mOverflowFormVm is undefined');
      return;
    }
    let isWithAnimation: boolean = (this.mIsSystemApp || !this.mUseDefaultAnimation) ? false : hasAnimation;
    this.mOverflowFormStatusController?.registerOperation(this, OverflowFormStatus.INACTIVE, isWithAnimation,
      this.mOverflowFormVm, this.uiExtProxy);
  }

  public notifyStatusChange(info: string): void {
    if (!this.mIsSystemApp) {
      log.showInfo('notifyStatusChange not system app');
      return;
    }
    if (!info || info.trim().length === 0) {
      log.showError('notifyStatusChange info error');
      return;
    }
    if (!this.mOverflowFormVm) {
      log.showInfo('notifyStatusChange mOverflowFormVm is empty');
      return;
    }
    if (this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.PAUSE &&
      info === OverflowConstants.ON_BACKGROUND) {
      log.showInfo('notifyStatusChange has in pause');
      return;
    }

    if (this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE &&
      info === OverflowConstants.ON_FOREGROUND) {
      log.showInfo('notifyStatusChange has actived');
      return;
    }
    if (!this.mIsRequestOverflow && info === OverflowConstants.STOP_OVERFLOW) {
      log.showInfo('notifyStatusChange stop has notified');
      return;
    }
    log.showInfo('notifyStatusChange formId: %{public}s, info: %{public}s, uiExtProxy empty: %{public}s',
      this.mFormItem.cardId, info, this.uiExtProxy === null || this.uiExtProxy === undefined);
    try {
      this.uiExtProxy?.send({
        'formStatusChange': JsonUtils.toJson({
          'formId': this.mFormItem.cardId,
          'formStatus': info
        })
      });
    } catch (error) {
      log.showError('notifyStopOverflow card send data failed, error: %{public}s, message: %{public}s',
        error?.code, error?.message);
    }
  }

  public stopLongActiveFormOverflowWhenRotation(): void {
    this.notifyStatusChange(OverflowConstants.SCREEN_ROTATION);
    if (this.mOverflowFormVm) {
      this.mOverflowFormStatusController?.registerOperation(this, OverflowFormStatus.INACTIVE,
        true, this.mOverflowFormVm,
        this.uiExtProxy);
    }
  }

  public initOverflowControllerFunction(): void {
    this.mOverflowController?.initFunction(
      () => this.startOverflow?.(),
      (hasAnimation: boolean, isTimeOut: boolean) => this.stopOverflow?.(hasAnimation, isTimeOut)
    );
  }

  public release(): void {
    this.clearActiveFormAfterAnimation();
    this.mOverflowController?.release();
  }

  /**
   * 长按事件处理回调，用于触发场景动效互动卡片状态切换
   */
  public handleFormStatusChange(): void {
    if (this.mFormItemVm.isOverflowFormEnable && this.mOverflowFormVm) {
      this.mOverflowFormStatusController?.registerOperation(this, OverflowFormStatus.INACTIVE, false,
        this.mOverflowFormVm, this.uiExtProxy);
    }
  }

  /**
   * FormItemRelative 组件长按事件处理回调，回调触发长按事件阈值 NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU
   */
  public handleLongPressGestureAction(): void {
    log.showInfo('handleLongPressGestureAction, set isBaseFormInLongPress');

    // 无动效状态切换，普通互动卡片切换为非激活态，长时激活卡片切换到暂停态
    if (this.mFormItemVm.isOverflowFormEnable && this.mOverflowFormVm) {
      this.updateOverflowDisconnectionType(OverflowFormDisconnectionType.LONGPRESS_EXIT);
      if (this.isLongActiveForm() && this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE) {
        this.notifyStatusChange(OverflowConstants.LONG_PRESS);
      } else {
        this.mOverflowFormStatusController?.registerOperation(this, OverflowFormStatus.INACTIVE, false,
          this.mOverflowFormVm, this.uiExtProxy);
      }
    }

    this.isBaseFormInLongPress = true;
    super.handleLongPressGestureAction();
  }

  /**
   * FormItemRelative 组件长按事件结束处理回调，回调触发长按事件阈值 NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU
   */
  public handleLongPressGestureActionEnd(): void {
    log.showInfo(`handleLongPressGestureActionEnd: isMenuShow: ${this.isMenuShow}` +
      `, isBaseFormInLongPress: ${this.isBaseFormInLongPress}`);
    this.isBaseFormInLongPress = false;
  }

  /**
   * 卡片长按震动处理回调, 回调触发长按时间阈值 NumberConstants.LONG_PRESS_VIBRATOR_TIME
   *
   * @param formMenuEvent 卡片菜单时间处理类
   */
  public handleLongPressVibration(formMenuEvent: FormMenuEvent): void {

    // 无动效状态切换，普通互动卡片切换为非激活态，长时激活卡片切换到暂停态
    if (this.mFormItemVm.isOverflowFormEnable && this.mOverflowFormVm) {
      this.updateOverflowDisconnectionType(OverflowFormDisconnectionType.LONGPRESS_EXIT);
      this.mOverflowFormStatusController?.registerOperation(this, OverflowFormStatus.INACTIVE, false,
        this.mOverflowFormVm, this.uiExtProxy);
    }

    super.handleLongPressVibration(formMenuEvent);
    this.updateLongPressStatus(true);
    this.isBaseFormInLongPress = true;
    this.isMenuShow = true;
  }

  private updateOverflowDisconnectionType(overflowFormDisconnectionType: OverflowFormDisconnectionType) {
    if (this.mOverflowFormVm) {
      this.mOverflowFormVm.overflowFormDisconnectionType = overflowFormDisconnectionType;
    }
  }

  /**
   * 卡片 touch 事件触发的缩放动效处理回调, 当卡片禁用长按手势时，不做缩放动效
   *
   * @param isZoomOut 是否执行缩小动效
   * @param cardDimension 卡片尺寸
   * @param endScale 缩放终点
   */
  public playLongPressAnimation(isZoomOut: boolean, cardDimension: number, endScale?: number): void {
    if (this.isActiveOverflowForm() &&
    OverflowFormUtils.isBehaviorDisabled(DisableGesture.LONG_CLICK, this.mFormItem as Object as GridLayoutItemInfo)) {
      log.showInfo('playLongPressAnimation: is active form and disable long click, do not play animation');
      return;
    }
    super.playLongPressAnimation(isZoomOut, cardDimension, endScale);
  }

  /**
   * 卡片长按菜单下树时处理回调, 点击使得卡片菜单消失，此时卡片需切换进入暂停态
   */
  public handleMenuDisappear(): void {
    log.showInfo('handleMenuDisappear');
    this.isMenuShow = false;
  }

  /**
   * FormItemRelative 组件长按事件结束处理回调，回调触发长按事件阈值 NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU
   */
  public handleLongPressVibrationEnd(): void {
    log.showInfo('handleLongPressVibrationEnd, reset isBaseFormInLongPress');
    super.handleLongPressVibrationEnd();
    this.isBaseFormInLongPress = false;
  }

  /**
   * 判断是否接受对应的手势
   *
   * @param gestureInfo 手势信息
   * @param event 手势事件
   * @returns 是否接受对应的手势
   */
  public onGestureJudgeBegin(gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult {
    // 锁定布局及其他不可拖拽场景禁止拖拽
    let isUnableDrag: boolean = gestureInfo.type === GestureControl.GestureType.DRAG &&
      !desktopItemDraggableManager.getEnableDrag();
    if (isUnableDrag) {
      return GestureJudgeResult.REJECT;
    }
    if (!this.isActiveOverflowForm() || CheckEmptyUtils.isEmpty(gestureInfo)) {
      return GestureJudgeResult.CONTINUE;
    }
    let isDisableLongPress: boolean = gestureInfo.type === GestureControl.GestureType.LONG_PRESS_GESTURE &&
    OverflowFormUtils.isBehaviorDisabled(DisableGesture.LONG_CLICK, this.mFormItem as Object as GridLayoutItemInfo);
    let isDisableDrag: boolean = gestureInfo.type === GestureControl.GestureType.DRAG &&
    OverflowFormUtils.isBehaviorDisabled(DisableGesture.DRAG, this.mFormItem as Object as GridLayoutItemInfo);
    if (isDisableLongPress || isDisableDrag) {
      return GestureJudgeResult.REJECT;
    }
    return GestureJudgeResult.CONTINUE;
  }

  private isActiveOverflowForm(): boolean {
    if (!this.mOverflowFormVm) {
      return false;
    }
    return this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE;
  }

  public setBaseFormVisibility(visibility: Visibility): void {
    this.mFormItemVm.formVisibilityStatus = visibility;
  }

  /**
   * 非默认过渡动效场景，需要手动释放截图资源
   */
  public releaseSnapshot() {
    if (this.mUseDefaultAnimation) {
      return;
    }
    dragSnapshotHelper.releaseSnapshot(SnapshotType.BOTH, this.mSnapshotItemKey);
  }

  /**
   * 设置卡片暂停溢出并更新溢出状态
   */
  public pauseOverflowForm(): void {
    if (!this.mOverflowFormVm) {
      log.showInfo('pauseOverflowForm, viewModel is not valid');
      return;
    }
    log.showInfo('pauseOverflowForm start');
    OverflowFormUtils.setActiveFormTouch(false);
    if (!this.isUpdateOverflowSnapshotSucceed) {
      this.setBaseFormVisibility(Visibility.Visible);
    }
    this.mOverflowFormVm.overflowFormStatus = OverflowFormStatus.PAUSE;
    this.mOverflowFormVm.overflowFormVisibilityStatus = Visibility.Hidden;
  }

  /**
   * 设置普通卡片的可见性状态
   */
  public stopOverflowForm(): void {
    if (!this.mOverflowFormVm) {
      log.showInfo('stopOverflowForm, viewModel is not valid');
      return;
    }
    OverflowFormUtils.setActiveFormTouch(false);
    this.mOverflowFormVm.overflowFormStatus = OverflowFormStatus.INACTIVE;
    this.mOverflowFormVm.overflowFormVisibilityStatus = Visibility.Hidden;
    this.mOverflowFormVm.overflowPauseVisibilityStatus = Visibility.Hidden;
    this.mOverflowFormVm.overflowMaskVisibilityStatus = Visibility.Visible;
  }

  public clearActiveFormAfterAnimation(): void {
    let activeForm: GridLayoutItemInfo | undefined = AppStorage.get<GridLayoutItemInfo>('activeForm');
    log.showInfo('clearActiveFormAfterAnimation, active card id %{public}s, form id is %{public}s',
      activeForm?.cardId, this.mFormItem.cardId);
    if (activeForm?.cardId === this.mFormItem.cardId) {
      AppStorage.setOrCreate('activeForm', undefined);
      log.showInfo('clearRequestOverflowTimer, activeForm clean succeed');
    }
    this.clearRequestOverflowTimer();
  }

  public afterStopOverflowForm(): void {
    log.showInfo(`afterStopOverflowForm, form id is ${this.mFormItem.cardId}`);
    this.clearActiveFormAfterAnimation();
    this.clearStatusTimer();
    if (this.mConnectionTimer) {
      clearTimeout(this.mConnectionTimer);
      this.mConnectionTimer = undefined;
    }
    if (this.mOverflowFormVm) {
      this.mOverflowFormVm.imageOpacity = 0;
      this.mOverflowFormVm.uecOpacity = 1;
    }
    this.mIsInBackground = false;
    this.isUpdateOverflowSnapshotSucceed = false;
    this.resetConnectionInfo();
    this.releaseOverflowSnapshot?.();
  }

  public clearRequestOverflowTimer(): void {
    log.showInfo('clearRequestOverflowTimer, form id is %{public}s', this.mFormItem.cardId);
    this.mOverflowController?.release();
    this.mIsRequestOverflow = false;
    OverflowViewModel.getInstance().clearRequestOverflowTimer(this.mFormItem.cardId);
  }

  public setActiveFormBeforeAnimation(): void {
    if (!this.mIsLongActiveForm) {
      AppStorage.setOrCreate('activeForm', this.mFormItem as Object as GridLayoutItemInfo);
    }
  }

  /**
   * Overflow 卡片开始溢出并更新溢出状态
   */
  public startOverflowForm(): void {
    if (!this.mOverflowFormVm) {
      log.showInfo('startOverflowForm, viewModel is not valid');
      return;
    }
    log.showInfo('startOverflowForm, start formId: %{public}s', this.mFormItem.cardId);
    this.mOverflowFormVm.overflowFormStatus = OverflowFormStatus.ACTIVE;
    this.mOverflowFormVm.overflowFormVisibilityStatus = Visibility.Visible;
    this.mOverflowFormVm.overflowPauseVisibilityStatus = Visibility.Hidden;
    this.mOverflowFormVm.overflowMaskVisibilityStatus = Visibility.Hidden;
  }

  /**
   * 更新 Overflow 卡片的加载状态
   *
   * @param value 是否加载 Overflow 卡片
   */
  public updateOverflowFormEnableStatus(value: boolean): void {
    if (this.mFormItemVm) {
      this.mFormItemVm.isOverflowFormEnable = value;
    }
  }

  /**
   * Overflow 卡片初始化时，向 event 同步最新属性
   *
   * @param overflowFormVm Overflow 卡片 ViewModel 相关属性
   * @param formComponentBuilderId Overflow 卡片截图层 id
   * @param context OverflowForm 组件上下文
   * @param overflowFormId ExtensionComponent 组件 id
   * @param relativeItemId FormItemRelative 组件 id
   */
  public updateOverflowFormConfig(overflowFormVm: OverflowFormVm, formComponentBuilderId: string,
    context: UIContext, overflowFormId: string, relativeItemId: string,
    overflowFormStatusController: OverflowFormStatusController | undefined,
    uiExtensionProxy: UIExtensionProxy | null): void {
    this.mOverflowFormVm = overflowFormVm;
    this.mFormComponentBuilderId = formComponentBuilderId;
    this.mOverflowFormId = overflowFormId;
    this.mRelativeItemId = relativeItemId;
    this.mUiContext = context;
    this.mOverflowFormStatusController = overflowFormStatusController;
    this.uiExtProxy = uiExtensionProxy;
  }

  public setProxy(uiExtensionProxy: UIExtensionProxy | null): void {
    this.uiExtProxy = uiExtensionProxy;
  }

  /**
   * 记录 Overflow 卡片的激活时间
   */
  public getOverflowFormActiveTime(): void {
    this.overflowFormActiveTime = new Date().getTime();
  }

  /**
   * 记录并上报 Overflow 卡片启动信息
   */
  public recordLaunchOverflowCardInfo(): void {
    if (!this.mOverflowFormVm) {
      log.showError(`recordLaunchOverflowCardInfo, mOverflowFormVm is undefined, formId:${this.mFormItem.cardId}`);
      return;
    }
    log.showInfo('recordLaunchOverflowCardInfo');
    let currentTime: number = new Date().getTime();
    let loadDuration: number = currentTime - this.clickCardTime;
    let initDuration: number = this.overflowFormActiveTime - this.clickCardTime;
    let interval: number = OverflowConstants.INIT_INTERVAL;
    OverflowEventReport.reportLaunchOverflowCardEvent(this.mFormItem, interval, initDuration,
      loadDuration, this.mOverflowFormVm.overflowFormConnectionType);
  }

  /**
   * 处理触摸事件
   *
   * @param event 触摸事件
   * @param itemId 表单项ID
   * @param isInDrag 是否处于拖拽状态
   */
  public onTouchEventHandler(event: TouchEvent, itemId: string, isInDrag: boolean): void {
    super.onTouchEventHandler(event, itemId, isInDrag);
    if (CheckEmptyUtils.isEmpty(event)) {
      log.showWarn('touch event is null');
      return;
    }

    // 场景动效卡片场景下，普通互动卡片在 uiExtensionComponent 组件未销毁前不支持截图，
    let canGetSnapshot: boolean = this.mOverflowFormVm?.overflowFormStatus !== OverflowFormStatus.ACTIVE;
    if (event.type === CommonConstants.TOUCH_TYPE_MOVE && canGetSnapshot && this.isUpdateSnapshotFailed && !isInDrag) {
      this.isUpdateSnapshotFailed = false;
      log.showInfo('onTouchEventHandler dragSnapshotHandler start');
      this.dragSnapshotHandler(itemId, itemId, isInDrag);
    }
  }

  /**
   * 处理拖拽结束事件
   * 重置长按状态
   */
  public handlerDragEnd(): void {
    super.handlerDragEnd();
    this.isBaseFormInLongPress = false;
    log.showInfo(`handlerDragEnd: reset long press status after drag, isBaseFormInLongPress: ` +
      `${this.isBaseFormInLongPress}, OverflowForm is long press : ${this.mOverflowFormVm?.isInLongPress}`);
  }

  /**
   * 更新长按状态
   *
   * @param value 是否处于长按状态
   */
  public updateLongPressStatus(value: boolean): void {
    log.showInfo(`updateLongPressStatus isBaseFormInLongPress: ${this.isBaseFormInLongPress}` +
      `, isInLongPress: ${this.mOverflowFormVm?.isInLongPress}, value: ${value}`);
    this.isBaseFormInLongPress = value;
    if (this.mOverflowFormVm) {
      this.mOverflowFormVm.isInLongPress = value;
    }
  }

  /**
   * 处理 overflow 卡片断开连接事件并上报
   */
  public handleDisconnectOverflowCardEvent(): void {
    if (!this.mOverflowFormVm) {
      log.showError(`reportDisconnectGameCardEvent, mOverflowFormVm is undefined` +
        `, formId:${this.mFormItem.cardId}`);
      return;
    }
    // 激活态直接进入非激活态，距上一次暂停态持续时间为0
    let interval: number = 0;
    this.overflowFormActiveDuration = new Date().getTime() - this.overflowFormActiveTime;
    this.overflowFormActiveTime = 0;
    OverflowEventReport.reportDisconnectOverflowCardEvent(this.mFormItem, interval,
      this.mOverflowFormVm.overflowFormDisconnectionType, this.overflowFormActiveDuration);
  }

  protected dragSnapshotHandler(itemId: string, cacheId: string, isInDrag: boolean): void {
    if (!this.mFormItemVm || !this.mFormItemVm.isOverflowFormEnable) {
      log.showInfo(`do super dragSnapshotHandler, isOverflowFormEnable: ${this.mFormItemVm.isOverflowFormEnable}`);
      super.dragSnapshotHandler(itemId, cacheId, isInDrag);
      return;
    }

    // 当 isInDrag 为 True 时候，表示组件正在处理拖拽的状态，此时执行截图会有两个问题:
    // 1. FormComponent 组件此时 visibility 状态为 Hidden，对齐父组件截图无法得到正确内容
    // 2. 在拖拽结束之后，现有 snapshot 会执行 release 动作
    // 所以在这种场景下，将截图动作延迟到 MOVE 过程中执行
    // 同时，场景动效卡片场景下，普通互动卡片在 uiExtensionComponent 组件未销毁前不支持截图，
    if (isInDrag && !this.isUpdateSnapshotFailed ||
      this.mOverflowFormVm?.overflowFormStatus === OverflowFormStatus.ACTIVE) {
      log.showInfo('dragSnapshotHandler: do not get snapshot, isInDrag: %{public}s' +
        ', uiExtensionComponent enable: %{public}s', isInDrag, this.mFormItemVm.isOverflowFormEnable);
      this.isUpdateSnapshotFailed = true;
      return;
    }
    this.getSnapshot(itemId, cacheId);
  }

  private getSnapshot(itemId: string, cacheId: string): void {
    let snapshotId: string = this.mFormComponentBuilderId === '' ? itemId : this.mFormComponentBuilderId;
    log.showInfo('getSnapshot: snapshotFromId: %{public}s, %{public}s', snapshotId, cacheId);
    TraceUtil.startTrace(DomainName.HOME, 'snapshotFromId: %{public}s', this.mFormComponentBuilderId);
    this.mSnapshotItemKey = GridLayoutUtil.generateUniqueKey(this.mFormItem as Object as GridLayoutItemInfo)
    try {
      dragSnapshotHelper.snapshotUntilRenderFinishedFromId(snapshotId, SnapshotType.BOTH, this.mSnapshotItemKey,
        (value: image.PixelMap) => {
          this.updateDragImage?.(value);
          ResourceManager.getInstance().setAppResourceCache(cacheId, 'cardSnapshot', value);
          CloseAppManager.getInstance().setCardStartSnapshot(cacheId, value);
          TraceUtil.endTrace(DomainName.HOME, 'snapshotFromId: %{public}s', snapshotId);
          log.showInfo('getSnapshot: snapshotFromId: %{public}s ok', cacheId);
        });
    } catch (error) {
      log.showError('getSnapshot: snapshotFromId %{public}s failed, error %{public}s', cacheId, error);
    }
  }

  /**
   * 处理长按震动取消事件并重置长按状态
   */
  public handleLongPressVibrationCancel(): void {
    log.showInfo('handleLongPressVibrationCancel, reset isBaseFormInLongPress');
    this.isBaseFormInLongPress = false;
  }

  /**
   * 处理长按手势取消事件并重置长按状态
   */
  public handleLongPressGestureActionCancel(): void {
    log.showInfo('handleLongPressGestureActionCancel, reset isBaseFormInLongPress');
    this.isBaseFormInLongPress = false;
  }

  /**
   * 加载扩展 Want 参数
   *
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @param formBorderRadius 卡片圆角
   */
  public loadExtWant(formItemWidth: number, formItemHeight: number, formBorderRadius: number): void {
    let formItemId: string = FormCommonUtil.getFormComponentId(this.mFormItem);
    log.showInfo(`loadSceneAnimationExtWant: formItemId ${formItemId}` +
      `, mFormItemWidth: ${formItemWidth}|${vp2px(formItemWidth)}` +
      `, mFormItemHeight: ${formItemHeight}|${vp2px(formItemHeight)}` +
      `, mFormBorderRadius: ${formBorderRadius}`);
    if (!this.mOverflowFormVm) {
      log.showInfo('loadSceneAnimationExtWant, overflowFormVm is not ready');
      return;
    }
    log.showInfo(`formBundle: ${this.mFormItem.bundleName},` +
      ` formBindGame: ${this.mFormItem.gameCardInfo?.formBindGame},` +
      ` subBundleName: ${this.mFormItem.gameCardInfo?.subBundleName},` +
      ` formBindAbility: ${this.mFormItem.gameCardInfo?.formBindAbility}}`)
    if (this.mFormItem.gameCardInfo?.extensionType === OverflowConstants.ANIMATION_TYPE) {
      this.mOverflowFormVm.uiExtWant = {
        bundleName: this.mFormItem.bundleName,
        abilityName: this.mFormItem.gameCardInfo?.formBindAbility,
        parameters: {
          'ability.want.params.uiExtensionType': 'liveForm',
          'extraInfo': {
            'formInfo': {
              'formId': this.mFormItem.cardId,
              'rect': {
                'left': this.overflowInfo ? -this.overflowInfo.area.left : 0,
                'top': this.overflowInfo ? -this.overflowInfo.area.top : 0,
                'width': formItemWidth,
                'height': formItemHeight
              },
              'borderRadius': formBorderRadius,
            }
          }
        }
      }
    } else {
      log.showWarn(`loadSceneAnimationExtWant. Invalid animation type: ${this.mFormItem.gameCardInfo?.extensionType}`);
    }
  }

  public getLiveFormStatus(): OverflowFormStatus {
    let status: OverflowFormStatus = OverflowFormStatus.INACTIVE;
    if (this.mOverflowFormVm) {
      status = this.mOverflowFormVm.overflowFormStatus;
    }
    log.showInfo(`getLiveFormStatus, status: ${status}`);
    return status;
  }

  public requestOverflow(overflowInfo: formInfo.OverflowInfo): boolean {
    log.showInfo('requestOverflow, mFormItemVm: %{public}s, isOverflowFormEnable: %{public}s, ' +
      ', this.mOverflowFormVm?.overflowFormStatus: %{public}d, useDefaultAnimation: %{public}s' +
      ', isLongActiveForm: %{public}s, duration: %{public}d, this.mIsRequestOverflow: %{public}s',
      CheckEmptyUtils.isEmpty(this.mFormItemVm),
      this.mFormItemVm.isOverflowFormEnable, this.mOverflowFormVm?.overflowFormStatus,
      overflowInfo.useDefaultAnimation, this.mIsLongActiveForm, overflowInfo.duration, this.mIsRequestOverflow);
    if (!this.mOverflowController?.canOverflow(overflowInfo, this.mFormItem.cardDimension)) {
      return false;
    }
    this.mUseDefaultAnimation = overflowInfo.useDefaultAnimation ?? true;

    // 处理长时激活卡片，当仅当长时溢出请求可以合法响应
    if (this.mIsLongActiveForm && !this.mIsRequestOverflow &&
      this.mOverflowFormVm?.overflowFormStatus === OverflowFormStatus.ACTIVE &&
      overflowInfo.duration >= OverflowThresholdConfig.getInstance().getLongOverflowProtectedDuration()) {
      this.overflowInfo = overflowInfo;
      this.requestOverflowInner(overflowInfo, this.mIsLongActiveForm);
      return true;
    }

    // 处理普通互动卡片
    if (!this.activateSceneAnimationInner()) {
      return false;
    }
    this.mIsRequestOverflow = true;
    this.overflowInfo = overflowInfo;
    return true;
  }

  public cancelOverflow(overflowFormDisconnectionType: OverflowFormDisconnectionType): boolean {
    if (!this.mIsRequestOverflow) {
      if (this.mFormItemVm.isOverflowFormEnable) {
        log.showError('cancelOverflow: Illegal use, ' +
          'cancelOverflow can only be used with requestOverflow');
      } else {
        log.showWarn('cancelOverflow: The sceneAnimation form is already inactive.');
      }
      return false;
    }
    if (this.mOverflowFormVm) {
      this.mOverflowFormVm.overflowFormDisconnectionType = overflowFormDisconnectionType;
    }
    this.mOverflowController?.cancelOverflow();
    return true;
  }

  /**
   * 请求激活 SceneAnimation 卡片
   * @returns 是否成功激活
   */
  public activateSceneAnimation(isLongActiveForm?: boolean): boolean {
    if (!this.mFormItemVm || !this.mIsSystemApp) {
      return false;
    }
    return this.activateSceneAnimationInner(isLongActiveForm);
  }

  private activateSceneAnimationInner: Function = (isLongActiveForm?: boolean): boolean => {
    if (!this.mFormItemVm) {
      return false;
    }

    // 激活态下，请求是非法的
    if (this.mFormItemVm.isOverflowFormEnable ||
      this.mOverflowFormVm?.overflowFormStatus === OverflowFormStatus.ACTIVE) {
      return false;
    }

    // 在激活卡片之前，执行截图
    if (!this.mUseDefaultAnimation) {
      let formComponentId: string = FormCommonUtil.getFormComponentId(this.mFormItem);
      this.dragSnapshotHandler(formComponentId, formComponentId, false);
    }

    this.mFormItemVm.isOverflowFormEnable = true;
    this.mIsLongActiveForm = isLongActiveForm;
    return true;
  };

  /**
   * 请求取消激活 SceneAnimation 卡片
   */
  public deactivateSceneAnimation(overflowFormDisconnectionType: OverflowFormDisconnectionType): boolean {
    if (this.mIsRequestOverflow && !this.mIsLongActiveForm) {
      log.showError('deactivateSceneAnimation: Illegal use, ' +
        'not long active form and during overflow');
      return false;
    }
    if (!this.mFormItemVm.isOverflowFormEnable) {
      log.showWarn('deactivateSceneAnimation: The sceneAnimation form is already inactive.');
      return false;
    }
    if (!this.mFormItemVm) {
      log.showWarn('deactivateSceneAnimation: mFormItemVm is undefined');
      return false;
    }
    if (!this.mOverflowFormVm) {
      log.showWarn('deactivateSceneAnimation: mOverflowFormVm is undefined');
      this.mFormItemVm.isOverflowFormEnable = false;
      return true;
    }
    if (!this.mOverflowFormStatusController) {
      log.showWarn('deactivateSceneAnimation: mOverflowFormStatusController is undefined');
      this.mFormItemVm.isOverflowFormEnable = false;
      return true;
    }
    this.mOverflowFormVm.overflowFormDisconnectionType = overflowFormDisconnectionType;
    this.mOverflowFormStatusController.registerOperation(this, OverflowFormStatus.INACTIVE,
      this.mIsSystemApp ? false : true, this.mOverflowFormVm, this.uiExtProxy);
    return true;
  }

  public afterStartOverflowForm(): void {
    if (this.mOverflowFormVm) {
      this.mOverflowFormVm.imageOpacity = 0;
      this.mOverflowFormVm.uecOpacity = 1;
    }
    if (this.mIsLongActiveForm) {
      log.showInfo('afterStartOverflowForm, release snapshot, id: %{public}s, uecOpacity: %{public}d' +
        ', overflowFormVisibility: %{public}d, uecWidth: %{public}d, uecHeight: %{public}d, imageOpacity: %{public}d',
        this.mFormItem.cardId, this.mOverflowFormVm?.uecOpacity, this.mOverflowFormVm?.overflowFormVisibilityStatus,
        this.mOverflowFormVm?.uiExtensionComponentWidth, this.mOverflowFormVm?.uiExtensionComponentHeight,
        this.mOverflowFormVm?.imageOpacity);
      this.releaseOverflowSnapshot?.();
      if (this.mForegroundTimer) {
        clearTimeout(this.mForegroundTimer);
        this.mForegroundTimer = undefined;
      }
      this.mForegroundTimer = setTimeout(() => {
        this.notifyStatusChange(OverflowConstants.EXTENSION_READY);
        this.mForegroundTimer = undefined;
      }, FOREGROUND_TIMEOUT);
      return;
    }
    if (!this.mIsLongActiveForm && this.overflowInfo) {
      this.requestOverflowWhenStart();
      return;
    }
  }

  public requestOverflowWhenStart(): void {
    if (this.mIsRequestOverflow) {
      this.requestOverflowInner(this.overflowInfo);
    }
  }

  public updateConnectionInfo(): void {
    if (this.mConnectionTimer) {
      clearTimeout(this.mConnectionTimer);
      this.mConnectionTimer = undefined;
    }
    let requestForm: ConnectionInfo = {
      connectType: OverflowFormConnectionType.USER_CLICK,
      formId: this.mFormItem.cardId
    };
    AppStorage.setOrCreate<ConnectionInfo>(OverflowConstants.CONNECTION_INFO, requestForm);
    log.showInfo('ConnectionInfo set %{public}s, status: %{public}d', this.mFormItem.cardId,
      this.mOverflowFormVm?.overflowFormStatus);
    this.mConnectionTimer = setTimeout(() => {
      this.resetConnectionInfo();
      this.mConnectionTimer = undefined;
    }, CLICK_FORM_ID_AVAILABLE_DURATION);
  }

  private resetConnectionInfo(): void {
    // 若当前记录的被点击卡片 ID 有效，同时不等于当前卡片 ID，不处理
    let userRequestForm: ConnectionInfo =
      AppStorage.get<ConnectionInfo>(OverflowConstants.CONNECTION_INFO) ?? new ConnectionInfo();
    log.showInfo(`ConnectionInfo reset ${userRequestForm.formId}`);
    if (userRequestForm.formId !== this.mFormItem.cardId) {
      return;
    }
    AppStorage.setOrCreate<ConnectionInfo>(OverflowConstants.CONNECTION_INFO, new ConnectionInfo());
  }

  public isLongActiveForm(): boolean {
    if (!this.mIsLongActiveForm) {
      return false;
    }
    return this.mIsLongActiveForm;
  }

  /**
   * 针对长时激活卡片触发溢出动效时候，修改 ExtensionComponent 宽高和偏移值
   *
   * @params overflowInfo 溢出请求参数
   */
  public updateExtensionComponentToOverflow(overflowInfo: formInfo.OverflowInfo): void {
    if (!this.mOverflowFormVm) {
      log.showWarn('updateExtensionComponentToOverflow, mOverflowFormVm is undefined');
      return;
    }
    log.showInfo('updateExtensionComponentToOverflow, start update');
    this.mOverflowFormVm.uiExtensionComponentWidth = overflowInfo.area.width;
    this.mOverflowFormVm.uiExtensionComponentHeight = overflowInfo.area.height;
    this.mOverflowFormVm.uiExtensionComponentOffsetX = (overflowInfo.area.width - this.mFormItemWidth) /
      NumberConstants.CONSTANT_NUMBER_TWO + overflowInfo.area.left;
    this.mOverflowFormVm.uiExtensionComponentOffsetY = (overflowInfo.area.height - this.mFormItemHeight) /
      NumberConstants.CONSTANT_NUMBER_TWO + overflowInfo.area.top;
    this.mOverflowFormVm.overflowFormHotAreaOffsetX = -overflowInfo.area.left;
    this.mOverflowFormVm.overflowFormHotAreaOffsetY = -overflowInfo.area.top;
  }

  /**
   * 设置 ExtensionComponent 默认属性，此时卡片不溢出
   */
  public setDefaultUiExtComponentProperties(): void {
    if (!this.mOverflowFormVm) {
      log.showWarn('setDefaultUiExtComponentProperties, mOverflowFormVm is undefined');
      return;
    }
    log.showInfo('setDefaultUiExtComponentProperties, start reset, formId: %{public}s', this.mFormItem.cardId);
    this.mOverflowFormVm.uiExtensionComponentWidth = this.mFormItemWidth;
    this.mOverflowFormVm.uiExtensionComponentHeight = this.mFormItemHeight;
    this.mOverflowFormVm.uiExtensionComponentOffsetX = 0;
    this.mOverflowFormVm.uiExtensionComponentOffsetY = 0;
    this.mOverflowFormVm.overflowFormHotAreaOffsetX = 0;
    this.mOverflowFormVm.overflowFormHotAreaOffsetY = 0;
  }

  public isOverflowFormEnable(): boolean {
    return this.mFormItemVm.isOverflowFormEnable;
  }

  public afterPauseOverflowForm(): void {
    this.mIsInBackground = false;
    this.isUpdateOverflowSnapshotSucceed = false;
    this.resetConnectionInfo();
  }

  private updateLongActiveSnapshot(): void {
    // 更新截图
    let formComponentId: string = FormCommonUtil.getFormComponentId(this.mFormItem);
    this.getOverflowSnapshot(formComponentId, formComponentId);
  }

  public initOverflowSnapshotFunction(
    setOverflowSnapshot?: (formImage: image.PixelMap) => void,
    releaseOverflowSnapshot?: () => void): void {
    this.updateOverflowSnapshot = setOverflowSnapshot;
    this.releaseOverflowSnapshot = releaseOverflowSnapshot;
  }

  private getOverflowSnapshot(itemId: string, cacheId: string): void {
    this.isUpdateOverflowSnapshotSucceed = false;
    let snapshotId: string = this.mFormComponentBuilderId === '' ? itemId : this.mFormComponentBuilderId;
    log.showInfo('getOverflowSnapshot: snapshotFromId: %{public}s, %{public}s', snapshotId, cacheId);
    TraceUtil.startTrace(DomainName.HOME, 'snapshotFromId: %{public}s', this.mFormComponentBuilderId);
    try {
      componentSnapshot.get(snapshotId, {waitUntilRenderFinished: true}).then((value: image.PixelMap) => {
        PixelMapUtil.addName(value, `overflowSnapshot_${itemId}`);
        this.isUpdateOverflowSnapshotSucceed = true;
        this.updateOverflowSnapshot?.(value);
        TraceUtil.endTrace(DomainName.HOME, 'snapshotFromId: %{public}s', snapshotId);
        log.showInfo('getOverflowSnapshot: snapshotFromId: %{public}s ok', cacheId);
      }).catch((error: Error) => {
        log.showError('getOverflowSnapshot: snapshotFromId %{public}s failed, error %{public}s', cacheId, error);
        this.isUpdateOverflowSnapshotSucceed = false;

        // 截图失败，清理定时器
        this.notifyStatusChange(OverflowConstants.OVERFLOW_FAILED);
        this.clearLongActiveStartOverflowTimer();
      })
    } catch (error) {
      log.showError('getOverflowSnapshot: call componentSnapshot.get failed' +
        ', snapshotFromId %{public}s failed, error %{public}s', cacheId, error);
    }
  }
}
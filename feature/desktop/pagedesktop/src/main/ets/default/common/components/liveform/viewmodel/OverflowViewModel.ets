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

import { LinkedList } from '@kit.ArkTS';
import { displaySync } from '@kit.ArkGraphics2D';
import { BusinessError, commonEventManager, power, thermal } from '@kit.BasicServicesKit';
import formInfo from '@ohos.app.form.formInfo';
import formHost from '@ohos.app.form.formHost';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseViewModel, GridLayoutItemInfo, FormModel, LiveFormSupportMgr } from '@ohos/launchercommon';
import { UserSwitchService, UserSwitchListener, SwitchEventData } from '@ohos/screenlockcommon';
import { OverflowConstants } from '@ohos/commonconstants';
import { openFolderLayout } from '@ohos/bigfolder/src/main/ets/default/viewmodel/OpenFolderLayout';
import { OverflowFormConnectionType, ConnectionInfo, OverflowFormStatus, StatusInfo } from './OverflowFormVm';
import { OverflowGrayAppManager } from '../common/OverflowGrayAppManager';
import { OverflowFormDisconnectionType } from '../viewmodel/OverflowFormVm';
import { OverflowFunInteractionFormEvent } from '../event/OverflowFunInteractionFormEvent';
import { PageDesktopViewModel } from '../../../viewmodel/PageDesktopViewModel';
import { OverflowThresholdConfig } from '../common/OverflowThresholdConfig';

const TAG = 'OverflowViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ALL_FORM: string = 'ALL_FORM';
const LIVE_FORM_STATUS_MAP: Record<string, string> = {
  'INACTIVE_FALSE': '00',
  'INACTIVE_TRUE': '01',
  'PAUSE_FALSE': '10',
  'PAUSE_TRUE': '11',
  'ACTIVE_FALSE': '20',
  'ACTIVE_TRUE': '21',
};

export class OverflowViewModel extends BaseViewModel {
  private mFunInterOverflowListenerMap: Map<string, OverflowFunInteractionFormEvent> = new Map();
  private mSceneAnimOverflowListenerMap: Map<string, OverflowListener> = new Map();
  private longActiveLinkedList: LinkedList<string> = new LinkedList();
  private executingConnection: ConnectionInfo | undefined = undefined;
  private overflowAnimationTimer?: number;

  private isPowerSaveMode: boolean = false;
  private thermalLevel: number = 0;
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED,
      commonEventManager.Support.COMMON_EVENT_THERMAL_LEVEL_CHANGED
    ]
  };
  private longOverflowRequestTimeout?: number;
  private mDefaultActivatedFormIdSet: Set<string> = new Set();

  private initSubscriber(): void {
    try {
      this.mSubscriber = commonEventManager.createSubscriberSync(this.subscribeInfo);
      commonEventManager.subscribe(this.mSubscriber, this.subscribeCB);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.showError(`Failed to init subscriber. Code is ${err.code}, message is ${err.message}`);
    }
  }

  private subscribeCB: (err: BusinessError, data: commonEventManager.CommonEventData) => void =
    (err: BusinessError, data: commonEventManager.CommonEventData): void => {
      if (err) {
        log.showError(`Can't handle common event, err: ${err.code}, err: ${err.message}`);
        return;
      }
      if (!data) {
        log.showError('subscribeCB, invalid data');
        return;
      }

      switch (data.event) {
        case commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED: {
          this.handlePowerSaveModeChanged(data);
          break;
        }
        case commonEventManager.Support.COMMON_EVENT_THERMAL_LEVEL_CHANGED: {
          this.handleThermalLevelChanged(data);
          break;
        }
        default:
          log.showError(`subscribeCB, invalid event: ${data.event}`);
          break;
      }
  }

  private handlePowerSaveModeChanged(data: commonEventManager.CommonEventData): void {
    log.showInfo(`power mode changed, current mode: ${data.code}`);
    if (data.code === power.DevicePowerMode.MODE_POWER_SAVE ||
      data.code === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE) {
      this.clearOverflowLinkedList(OverflowFormDisconnectionType.LOW_POWER_EXIT);
      this.cancelOverflow(this.executingConnection?.formId, OverflowFormDisconnectionType.LOW_POWER_EXIT);
      this.isPowerSaveMode = true;
    } else {
      this.isPowerSaveMode = false;
    }
  }

  private handleThermalLevelChanged(data: commonEventManager.CommonEventData): void {
    if (!data.parameters || typeof data.parameters['0'] !== 'number') {
      log.showError('subscribeCB, invalid parameters');
      return;
    }

    this.thermalLevel = data.parameters['0'];
    log.showInfo(`Thermal Level changed, current mode: ${this.thermalLevel}`);
    if (this.thermalLevel >= thermal.ThermalLevel.OVERHEATED) {
      this.clearOverflowLinkedList(OverflowFormDisconnectionType.THERMAL_LEVEL_EXIT);
      this.cancelOverflow(this.executingConnection?.formId, OverflowFormDisconnectionType.THERMAL_LEVEL_EXIT);
    }
  }

  private initPowerMode(): void {
    try {
      let mode: power.DevicePowerMode = power.getPowerMode();
      log.showInfo(`initPowerMode, power mode: ${mode}`);
      if (mode === power.DevicePowerMode.MODE_POWER_SAVE ||
        mode === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE) {
        this.isPowerSaveMode = true;
      }
    } catch (err) {
      log.showError(`get power mode failed, err: ${err.code}, err: ${err.message}`);
    }
  }

  private initThermalLevel(): void {
    try {
      this.thermalLevel = thermal.getLevel();
      log.showInfo(`initThermalLevel, thermal level is: ${this.thermalLevel}`);
    } catch (err) {
      log.showError(`get thermal level failed, err: ${err.code}, err: ${err.message}`);
    }
  }

  private readonly userSwitchListener: UserSwitchListener = {
    onSwitching: (switchEventData: SwitchEventData): void => {
      this.clearOverflowLinkedList();
    },
    onUserActiveChanged:(isCurrentUserActive: boolean) : void => {
      log.showInfo(`onUserActiveChanged, isCurrentUserActive:${isCurrentUserActive}`);
      if (isCurrentUserActive) {
        FormModel.getInstance().registerGetFromRectInfoCallback();
        this.registerOverflowCallback();
      }
    }
  }

  private constructor() {
    super();
    this.initSubscriber();
    this.initPowerMode();
    this.initThermalLevel();
  }

  /**
   * Obtains the PageDesktopViewModel instance.
   *
   * @return PageDesktopViewModel
   */
  static getInstance(): OverflowViewModel {
    if (globalThis.OverflowViewModel == null) {
      globalThis.OverflowViewModel = new OverflowViewModel();
    }
    return globalThis.OverflowViewModel;
  }

  public clearAllRequestOverflowTimer(): void {
    this.clearRequestOverflowTimer(ALL_FORM);
  }

  public clearRequestOverflowTimer(formId: string): void {
    log.showInfo('clearRequestOverflowTimer, executingConnection is %{public}s, formId is %{public}s',
      this.executingConnection?.formId, formId);
    if (formId === ALL_FORM || formId === this.executingConnection?.formId) {
      this.clearOverflowTimer();
      this.executingConnection = undefined;
      log.showInfo('clearRequestOverflowTimer, executingConnection clean succeed');
    }
  }

  // 电源模式和热管控策略校验
  private deviceStatusCheck(): boolean {
    if (this.isPowerSaveMode || this.thermalLevel >= thermal.ThermalLevel.OVERHEATED) {
      log.showInfo(`check failed, ${this.isPowerSaveMode ? '[MODE_POWER_SAVE]' : '[OVERHEATED]'}`);
      return false;
    }

    let requestForm: ConnectionInfo =
      AppStorage.get<ConnectionInfo>(OverflowConstants.CONNECTION_INFO) ?? new ConnectionInfo();
    let connectType: OverflowFormConnectionType = requestForm.connectType;
    if (this.thermalLevel === thermal.ThermalLevel.HOT &&
      (connectType === OverflowFormConnectionType.DATA_REFRESH || connectType === OverflowFormConnectionType.SWING)) {
      log.showInfo('check failed, HOT and [DATA_REFRESH or SWING]');
      return false;
    }

    return true;
  }

  public exitExecutingConnectionProtected(formId: string): void {
    if (formId !== this.executingConnection?.formId) {
      log.showInfo('exitExecutingConnectionProtected form is not executingConnection, formId = %{public}s', formId);
      return;
    }
    if (this.executingConnection.isLongRequest) {
      log.showInfo('exitExecutingConnectionProtected, start update form, formId = %{public}s', formId);
      this.executingConnection.isInProtected = false;
    }
  }

  // 溢出动效竞争策略校验
  private canOverflow(formId: string, overflowInfo: formInfo.OverflowInfo): boolean {
    const longOverflowProtectedDuration: number =
      OverflowThresholdConfig.getInstance().getLongOverflowProtectedDuration();
    if (!this.mSceneAnimOverflowListenerMap.has(formId)) {
      log.showError(`overflowListener does not exist. key = ${formId}`);
      return false;
    }
    if (this.executingConnection) {
      // 打印正在执行请求信息
      log.showInfo('canOverflow, executingConnection connectType: %{public}d, formId: %{public}s' +
        ', isLongRequest: %{public}s, isInProtected: %{public}s', this.executingConnection.connectType,
        this.executingConnection?.formId, this.executingConnection.isLongRequest,
        this.executingConnection.isInProtected);
    }

    // 新发起请求
    let requestForm: ConnectionInfo =
      AppStorage.get<ConnectionInfo>(OverflowConstants.CONNECTION_INFO) ?? new ConnectionInfo();
    let ret: boolean = false;
    if (requestForm.connectType === OverflowFormConnectionType.USER_CLICK ||
      (this.executingConnection?.connectType === OverflowFormConnectionType.USER_CLICK &&
      this.executingConnection.isInProtected)) {
      // 新发起请求为主动触发或者正在执行请求处于长时溢出保护期，此时判断新发起请求是否为主动触发
      ret = requestForm.connectType === OverflowFormConnectionType.USER_CLICK && formId === requestForm.formId;
    } else if (this.executingConnection?.isLongRequest) {
      // 正在执行的为长时溢出请求，新发起请求为被动触发。短时溢出请求可打断，正在执行的长时溢出请求不在长时溢出保护期时刻打断
      ret = !this.executingConnection.isInProtected;
    } else {
      // 其他被动场景，先到先得
      ret = CheckEmptyUtils.checkStrIsEmpty(this.executingConnection?.formId);
    }
    if (ret) {
      this.executingConnection = new ConnectionInfo();
      this.executingConnection.formId = formId;
      this.executingConnection.connectType = requestForm.connectType;
      this.executingConnection.isLongRequest =
        overflowInfo.duration >= longOverflowProtectedDuration;
      this.executingConnection.isInProtected = this.executingConnection.isLongRequest;

      // 当长时溢出胜出时，设置 60s 的保护时间，在保护时间段内，不能被其他被动溢出请求打断
      this.clearLongOverflowRequestTimeout();
      if (this.executingConnection.isLongRequest) {
        this.longOverflowRequestTimeout = setTimeout(() => {
          if (this.executingConnection) {
            this.executingConnection.isInProtected = false;
          }
        }, longOverflowProtectedDuration);
      }
    }
    log.showInfo('canOverflow, requestForm info, canOverflow: %{public}s, connectType: %{public}d' +
      ', formId: %{public}s, isLongRequest: %{public}s', ret, requestForm.connectType, formId,
      (overflowInfo.duration >= longOverflowProtectedDuration));
    return ret;
  }

  private isReadyToResponse(): boolean {
    // 多任务
    let isShowRecent: boolean = AppStorage.get<boolean>('showRecent')?? false;

    // 桌面焦点
    let isOnDesktop: boolean = AppStorage.get<boolean>('onDeskTop')?? true;

    // 桌面双指捏合编辑模式
    let isNormalDesktopMode: boolean = AppStorage.get<boolean>('isNormalDesktopMode')?? true;

    // 无障碍模式
    let isAccessibilityMode: boolean = AppStorage.get<boolean>('isAccessibilityMode')?? false;

    // 文件夹打开
    let isShowOpenFolder: boolean = openFolderLayout.getGridSwiperLayout().isShowOpenFolder;

    log.showInfo('isReadyToResponse, isShowRecent: %{public}s, isOnDesktop: %{public}s' +
      ', isNormalDesktopMode: %{public}s, isAccessibilityMode: %{public}s, isShowOpenFolder: %{public}s',
      isShowRecent, isOnDesktop, isNormalDesktopMode, isAccessibilityMode, isShowOpenFolder);
    return !isShowRecent && isOnDesktop && isNormalDesktopMode && !isAccessibilityMode && !isShowOpenFolder;
  }

  private clearLongOverflowRequestTimeout(): void {
    if (this.longOverflowRequestTimeout) {
      clearTimeout(this.longOverflowRequestTimeout);
      this.longOverflowRequestTimeout = undefined;
    }
  }

  private startOverflowTimer(formId: string, overflowInfo: formInfo.OverflowInfo): void {
    log.showInfo(`startOverflowTimer, formId: ${formId}, duration: ${overflowInfo.duration}`);
    if (LiveFormSupportMgr.getInstance().isLowVisualEffect()) {
      log.showInfo(`low visual effect, setExpectedFrameRate 60 start`);
    }
    this.clearOverflowTimer();
    this.overflowAnimationTimer = setTimeout(() => {
      if (LiveFormSupportMgr.getInstance().isLowVisualEffect()) {
        log.showInfo(`low visual effect, setExpectedFrameRate 60 stop`);
      }
      let requestForm: ConnectionInfo =
        AppStorage.get<ConnectionInfo>(OverflowConstants.CONNECTION_INFO) ?? new ConnectionInfo();
      if (requestForm.formId === this.executingConnection?.formId) {
        AppStorage.setOrCreate<ConnectionInfo>(OverflowConstants.CONNECTION_INFO, new ConnectionInfo());
        this.clearRequestOverflowTimer(requestForm.formId);
      }
    }, overflowInfo.duration);
  }

  private clearOverflowTimer(): void {
    if (this.overflowAnimationTimer) {
      clearTimeout(this.overflowAnimationTimer);
    }
    this.overflowAnimationTimer = undefined;
  }

  /**
   * 请求溢出
   *
   * @param formId 卡片ID
   * @param overflowInfo 溢出参数
   * @returns 是否成功溢出
   */
  public requestOverflow(formId: string, overflowInfo: formInfo.OverflowInfo): boolean {
    log.showInfo(`requestOverflow, formId = ${formId}`);
    let overflowListener: OverflowListener | undefined = this.mSceneAnimOverflowListenerMap.get(formId);
    if (!overflowListener) {
      log.showError(`requestOverflow: overflowListener does not exist, formId = ${formId}`);
      return false;
    }
    return overflowListener.requestOverflow(overflowInfo);
  }

  /**
   * 请求取消溢出
   *
   * @param formId 卡片ID
   * @returns 是否成功取消溢出
   */
  public cancelOverflow(formId: string | undefined,
    overflowFormDisconnectionType: OverflowFormDisconnectionType): boolean {
    if (!formId) {
      log.showInfo('cancelOverflow failed, formId is empty');
      return false;
    }
    log.showInfo(`cancelOverflow formId = ${formId}`);
    let overflowListener: OverflowListener | undefined = this.mSceneAnimOverflowListenerMap.get(formId);
    if (!overflowListener) {
      log.showError(`cancelOverflow: overflowListener does not exist, formId = ${formId}`);
      return false;
    }
    return overflowListener.cancelOverflow(overflowFormDisconnectionType);
  }


  public addDefaultActivatedFormId(formId: string): void {
    log.showInfo(`addDefaultActivatedFormId: formId = ${formId}`);
    this.mDefaultActivatedFormIdSet.add(formId);
  }

  public activateDefaultActivatedForms(): void {
    this.mDefaultActivatedFormIdSet.forEach((formId: string) => {
      this.activateSceneAnimation(formId);
    });
  }

  /**
   * 请求激活 SceneAnimation 卡片
   *
   * @param formId 卡片ID
   * @returns 是否成功激活
   */
  public activateSceneAnimation(formId: string): boolean {
    log.showInfo(`activateSceneAnimation: formId = ${formId}`);
    let overflowListener: OverflowListener | undefined = this.mSceneAnimOverflowListenerMap.get(formId);
    if (!overflowListener) {
      log.showError(`activateSceneAnimation: overflowListener does not exist, formId = ${formId}`);
      return false;
    }
    if (this.longActiveLinkedList.has(formId)) {
      log.showError(`activateSceneAnimation: formId ${formId} has been activated`);
      return false;
    }

    let liveFormMaxActivationNumber: number = LiveFormSupportMgr.getInstance().getLiveFormMaxActivationNumber() ??
      Number(OverflowConstants.LIVE_FORM_MAX_ACTIVATION_NUMBER_DEFAULT);
    while (this.longActiveLinkedList.length >= liveFormMaxActivationNumber) {
      let formIdToRemove: string = this.longActiveLinkedList.getFirst();
      log.showDebug(`remove the oldest formId: ${formIdToRemove}`);
      this.deactivateSceneAnimation(formIdToRemove, OverflowFormDisconnectionType.ACTIVATE_QUEUE_IS_FULL_EXIT);
    }
    let activateResult: boolean = overflowListener.activateSceneAnimation(true);
    if (!activateResult) {
      log.showError(`activateSceneAnimation: activate formId ${formId} failed.`);
      return false;
    }
    this.longActiveLinkedList.add(formId);
    log.showInfo(`activateSceneAnimation: activate formId ${formId} success.` +
      ` the length of longActiveLinkedList now is ${this.longActiveLinkedList.length}`);
    return true;
  }

  /**
   * 请求取消激活 SceneAnimation 卡片
   *
   * @param formId 关键字
   */
  public deactivateSceneAnimation(formId: string,
    overflowFormDisconnectionType: OverflowFormDisconnectionType): boolean {
    log.showInfo(`deactivateSceneAnimation: formId = ${formId}`);
    let overflowListener: OverflowListener | undefined = this.mSceneAnimOverflowListenerMap.get(formId);
    if (!overflowListener) {
      log.showError(`deactivateSceneAnimation: overflowListener does not exist, formId = ${formId}`);
      return false;
    }
    let deactivateResult: boolean = overflowListener.deactivateSceneAnimation(overflowFormDisconnectionType);
    if (!deactivateResult) {
      log.showError(`deactivateSceneAnimation: deactivate formId ${formId} failed.`);
      return false;
    }
    this.removeKeyFromOverflowLinkedList(formId);
    log.showInfo(`deactivateSceneAnimation: deactivate formId ${formId} success.` +
      ` the length of longActiveLinkedList now is ${this.longActiveLinkedList.length}`);
    return true;
  }

  /**
   * 清理 OverflowLinkedLis 链表, 移除对应的 formId
   *
   * @param formId 关键字
   */
  public removeKeyFromOverflowLinkedList(formId: string): void {
    if (!this.longActiveLinkedList.has(formId)) {
      log.showWarn(`removeKeyFromOverflowLinkedList: formId ${formId} does not exist in longActiveLinkedList`);
      return;
    }
    this.longActiveLinkedList.remove(formId);
    log.showInfo(`removeKeyFromOverflowLinkedList: remove formId ${formId} success.` +
      ` the length of longActiveLinkedList now is ${this.longActiveLinkedList.length}`);
  }

  /**
   * 清理 OverflowLinkedLis 链表里的所有 formId，将其都取消激活
   */
  private clearOverflowLinkedList(
    type: OverflowFormDisconnectionType = OverflowFormDisconnectionType.USER_SWITCH_EXIT): void {
    while (this.longActiveLinkedList.length > 0) {
      let formIdToRemove: string = this.longActiveLinkedList.removeFirst();
      log.showDebug(`clearOverflowLinkedList: formIdToRemove:${formIdToRemove}`);
      this.deactivateSceneAnimation(formIdToRemove, type);
    }
  }

  /**
   * 注册Overflow监听
   *
   * @param formId 卡片ID
   * @param listener 监听
   */
  public registerOverflowListener(formId: string, listener: OverflowListener): void {
    log.showInfo(`registerOverflowListener. formId = ${formId}`);
    this.mSceneAnimOverflowListenerMap.set(formId, listener);
  }

  /**
   * 解注册Overflow监听
   *
   * @param formId 卡片ID
   * @param listener 监听
   */
  public unregisterOverflowListener(formId: string, listener: OverflowListener): void {
    if (!this.mSceneAnimOverflowListenerMap.has(formId)) {
      log.showError(`unregisterOverflowListener: OverflowListener does not exist. formId = ${formId}`);
      return;
    }
    if (this.mSceneAnimOverflowListenerMap.get(formId) === listener) {
      this.mSceneAnimOverflowListenerMap.delete(formId);
    }
  }

  /**
   * 注册Overflow监听
   *
   * @param formId 卡片ID
   * @param listener 监听
   */
  public registerFunInterOverflowListener(formId: string, listener: OverflowFunInteractionFormEvent): void {
    log.showInfo(`registerFunInterOverflowListener. formId = ${formId}`);
    this.mFunInterOverflowListenerMap.set(formId, listener);
  }

  /**
   * 解注册Overflow监听
   *
   * @param formId 卡片ID
   * @param listener 监听
   */
  public unregisterFunInterOverflowListener(formId: string): void {
    if (!this.mFunInterOverflowListenerMap.has(formId)) {
      log.showError(`unregisterFunInterOverflowListener: OverflowListener does not exist. formId = ${formId}`);
      return;
    }
    this.mFunInterOverflowListenerMap.delete(formId);
  }

  /**
   * 注冊溢出监听回调和激活监听回调
   */
  public registerOverflowCallback(): void {
    this.registerOverflowRequestCallback();
    this.registerChangeSceneAnimationStateRequestCallback();
    this.registerGetLiveFormStatusCallback();
  }

  /*
   * 解注冊溢出监听和激活监听
   */
  public unregisterOverflowCallback(): void {
    try {
      formHost.off('formOverflow');
      formHost.off('changeSceneAnimationState');
      formHost.off('getLiveFormStatus');
    } catch (error) {
      log.showError(`unregisterOverflowCallback failed, code is ${error.code}, message is ${error.message}`);
    }
  }

  private registerOverflowRequestCallback(): void {
    let overflowRequestCallback = (request: formInfo.OverflowRequest) => {
      log.showInfo(`overflowRequestCallback: Callback start - formId: ${request.formId}, ` +
        `isOverflow:${request.isOverflow}`);
      if (!request.formId || !request.overflowInfo) {
        log.showError('overflowRequestCallback: Invalid parameters');
        throw new Error('LiveForm:requestOverflow params(formId or overflowInfo) error.');
      }

      try {
        if (!request.isOverflow) {
          let result = this.cancelOverflow(request.formId, OverflowFormDisconnectionType.PROVIDER_QUIT);
          if (!result) {
            throw new Error('LiveForm:cancelOverflow fail.');
          }
          return;
        }
        if (!this.deviceStatusCheck() || !this.isReadyToResponse() ||
          !this.canOverflow(request.formId, request.overflowInfo)) {
          throw new Error('LiveForm:requestOverflow condition check fail.');
        }
        let requestResult: boolean = this.requestOverflow(request.formId, request.overflowInfo);
        log.showInfo(`overflowRequestCallback: request result is: ${requestResult}`);
        if (requestResult) {
          this.startOverflowTimer(request.formId, request.overflowInfo);
        } else {
          this.clearRequestOverflowTimer(request.formId);
          throw new Error('LiveForm:requestOverflow execute fail.');
        }
      } catch (error) {
        log.showError(`overflowRequestCallback: Error processing request, code is ${error.code},` +
          `message is ${error.message}, formId:${request.formId}`);
        throw new Error('LiveForm:requestOverflow catch error.');
      }
    };

    log.showInfo('registerOverflowRequestCallback: Registering callback');
    try {
      formHost.on('formOverflow', overflowRequestCallback);
    } catch (error) {
      log.showError(`registerOverflowRequestCallback failed, code is ${error.code}, message is ${error.message}`);
    }
  }

  private registerChangeSceneAnimationStateRequestCallback(): void {
    let changeSceneAnimationStateRequestCallback = (request: formInfo.ChangeSceneAnimationStateRequest) => {
      log.showInfo(`changeSceneAnimationStateRequestCallback: Callback start - formId: ${request.formId}`);
      if (!request.formId) {
        log.showError('changeSceneAnimationStateRequestCallback: Invalid parameters');
        throw new Error('LiveForm:activateSceneAnimation params(formId) error.');
      }

      try {
        if (!request.state) {
          let result = this.deactivateSceneAnimation(request.formId, OverflowFormDisconnectionType.PROVIDER_QUIT);
          if (!result) {
            throw new Error('LiveForm:deactivateSceneAnimation fail.');
          }
          return;
        }
        if (!this.deviceStatusCheck() || !this.isReadyToResponse()) {
          throw new Error('LiveForm:activateSceneAnimation device status check fail.');
        }
        let requestResult: boolean = this.activateSceneAnimation(request.formId);
        log.showInfo(`changeSceneAnimationStateRequestCallback: request result is: ${requestResult}`);
        if (!requestResult) {
          throw new Error('LiveForm:activateSceneAnimation execute fail.');
        }
      } catch (error) {
        log.showError(`changeSceneAnimationStateRequestCallback: Error processing request, code is ${error.code},` +
          `message is ${error.message}, formId:${request.formId}`);
        throw new Error('LiveForm:activateSceneAnimation catch error.');
      }
    };

    log.showInfo('registerChangeSceneAnimationStateRequestCallback: Registering callback');
    try {
      formHost.on('changeSceneAnimationState', changeSceneAnimationStateRequestCallback);
    } catch (error) {
      log.showError(`registerChangeSceneAnimationStateRequestCallback failed, code is ${error.code},` +
        `message is ${error.message}`);
    }
  }

  private getLiveFormStatus(status: OverflowFormStatus, isSupportLauncher: boolean): string {
    let key: string = StatusInfo.toKey({ formStatus: status, isSupportLauncher: isSupportLauncher });
    let ret: string | undefined = LIVE_FORM_STATUS_MAP[key];
    if (!ret) {
      key = StatusInfo.toKey(new StatusInfo());
      ret = LIVE_FORM_STATUS_MAP[key];
    }
    return ret;
  }

  private registerGetLiveFormStatusCallback(): void {
    let getLiveFormStatusCallback = (): Record<string, string> => {
      log.showInfo('registerGetLiveFormStatusCallback: Callback start');
      let liveFormStatus: Record<string, string> = {};

      this.mFunInterOverflowListenerMap.forEach((event, formId) => {
        let status: string = this.getLiveFormStatus(event.getLiveFormStatus(),
          LiveFormSupportMgr.getInstance().hasSupportLauncher(formId));
        liveFormStatus[formId] = status;
      });

      this.mSceneAnimOverflowListenerMap.forEach((event, formId) => {
        let status: string = this.getLiveFormStatus(event.getLiveFormStatus(),
          LiveFormSupportMgr.getInstance().hasSupportLauncher(formId));
        liveFormStatus[formId] = status;
      });

      return liveFormStatus;
    };

    log.showInfo('registerGetLiveFormStatusCallback: Register callback');
    try {
      formHost.on('getLiveFormStatus', getLiveFormStatusCallback);
    } catch (error) {
      log.showError(`registerGetLiveFormStatusCallback failed: ${error}`);
    }
  }

  /**
   * 注册观察者, 用于取消激活 OverflowLinkedLis 链表里所有的 key
   */
  public registerClearOverflowLinkedListListener(): void {
    UserSwitchService.getInstance().registerObserver(this.userSwitchListener);
  }

  /**
   * 注销观察者
   */
  public unregisterClearOverflowLinkedListListener(): void {
    UserSwitchService.getInstance().unRegisterObserver(this.userSwitchListener);
  }

  /**
   * 注册overflow卡片状态禁用监听
   * @param item 桌面元素
   * @returns
   */
  public registerOverflowGrayAppEventListener(item: GridLayoutItemInfo): void {
    if (item?.gameCardInfo) {
      // 当前规格：分身应用不支持卡片，就将appIndex写成默认值0
      OverflowGrayAppManager.getInstance().registerEventListener({ bundleName: item.bundleName, appIndex: 0 });
    }
  }

  /**
   * 解注册overflow卡片状态禁用监听
   */
  public unregisterOverflowGrayAppEventListener(): void {
    OverflowGrayAppManager.getInstance().unregisterEventListener();
  }
}

/**
 * UiExtensionComponent占位图数据结构
 */
export class ExtensionPlaceholderParams {
  private width: Length = 0;
  private height: Length = 0;
  private cornerRadius: Length = 0;
  private pixelMap: PixelMap;

  constructor(pixelMap: PixelMap, width: Length, height: Length, cornerRadius: Length) {
    this.pixelMap = pixelMap;
    this.width = width;
    this.height = height;
    this.cornerRadius = cornerRadius;
  }

  getWidth(): Length {
    return this.width;
  }

  getHeight(): Length {
    return this.height;
  }

  getCornerRadius(): Length {
    return this.cornerRadius;
  }

  getPixelMap(): PixelMap {
    return this.pixelMap;
  }
}

export interface OverflowChangeListener {
  onOverflowChanged(overflowInfo: formInfo.OverflowInfo): boolean;
}

export interface OverflowListener {
  activateSceneAnimation(isLongActiveForm?: boolean): boolean;
  deactivateSceneAnimation(overflowFormDisconnectionType: OverflowFormDisconnectionType): boolean;
  requestOverflow(overflowInfo: formInfo.OverflowInfo): boolean;
  cancelOverflow(overflowFormDisconnectionType: OverflowFormDisconnectionType): boolean;
  getLiveFormStatus(): OverflowFormStatus;
}
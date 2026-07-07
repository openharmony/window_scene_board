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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import {
  ConfigurationEvent,
  EventManager,
  EvtBus,
  GlobalContext,
  localEventManager
} from '@ohos/frameworkwrapper';
import {
  EventConstants,
  FormLayoutCacheManager,
  GridLayoutItemInfo,
  ReceiveEventInfo,
  FormHostService,
  RecycleChangeListener,
  VisibleChangeListener,
} from '@ohos/launchercommon';
import { Alarm, AlarmListener } from '@ohos/componenthelper';

import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { AiSuggestionEventName } from '../constants/AiSuggestionEventName';
import { AiSuggestionViewModel } from '../model/AiSuggestionViewModel';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { AiSuggestionFormRecycleManager } from '../manager/AisuggestionFormRecycleManager';
import AiSuggestionActionManager from '../manager/AiSuggestionActionManager';
import { LongPressType } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';

const TAG = 'AiSuggestionEvent';
const log: Logger = Logger.getLogHelper(LogDomain.AISUGGESTION);
const LANGUAGE_BO_CN = 'bo-CN';

/**
 * 语音助手建议事件处理类
 *
 * @since 2025-05-27
 */
export class AiSuggestionEvent {
  public updateAppName?: Function;
  private mViewModel?: AiSuggestionViewModel;
  private formItem?: GridLayoutItemInfo;
  private cardId: string = '';
  private eventMgr: EventManager = EvtBus.createEventManager();
  private isOuterDesktop: boolean = false;
  private reorderAlarm: Alarm = new Alarm();
  public isDuringAppExitAnimFunction?: Function;
  private updateCardFunction = (cardInfo: LauncherCardInfo): void => {
    this.mViewModel?.updateCard(cardInfo);
  }
  private deleteCardFunction = (cardId: string): void => {
    this.mViewModel?.deleteCard(cardId);
  }
  private resetCardFunction = (cardId: string): void => {
    this.mViewModel?.resetCard();
  }
  /**
   * 卡片可见性变化事件
   */
  private visibleListener: VisibleChangeListener = {
    onVisibleChange: (visible: boolean): void => {
      AbilityFormUtil.notifyVisibleChange(visible, this.cardId);
    }
  }
  /**
   * 卡片回收事件
   */
  private recycleListener: RecycleChangeListener = {
    onRecycleChange: (state: boolean): void => {
      AiSuggestionFormRecycleManager.getInstance().onRecycleStateChange(state, this.cardId);
    }
  }

  /**
   * 计时器
   */
  private alarmListener: AlarmListener = {
    onAlarm: (): void => {
      this.mViewModel?.setArriveTime(true);
      AbilityFormUtil.updateDisplayMode(this.mViewModel?.getViewData().portfolioInfo, this.formItem?.cardDimension);
    }
  }

  /**
   * 处理config属性事件
   *
   * @param event 事件
   */
  private handleConfigurationEvent = (event: ConfigurationEvent | null): void => {
    log.showInfo(TAG, 'handleConfigurationEvent');
    if (!CheckEmptyUtils.isEmpty(event?.config?.language) && this.mViewModel?.getViewData().recItems?.length === 1 &&
    AbilityFormUtil.isDefaultCard(this.mViewModel?.getViewData().recItems[0])) {
      // 切换语言时，如果当前容器内元素只有一个并且是欢迎卡片，则重新刷新appName
      this.updateAppName?.(this.mViewModel.getAppName());
    }

    const desc2TopMargin = event?.config?.language === LANGUAGE_BO_CN ? 5 : 0;
    this.mViewModel?.updateDesc2TopMargin(desc2TopMargin);

    if (CheckEmptyUtils.isEmpty(event?.config?.colorMode)) {
      return;
    }
    const curColorMode = event?.config?.colorMode!;
    this.mViewModel?.updateCurColorMode(curColorMode);
    this.mViewModel?.updateColorMode(this.mViewModel?.getViewData().portfolioInfo);
  }

  /**
   * 应用退出事件
   */
  private readonly appExitListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: boolean): void => {
      log.showInfo(TAG, `appExitListener, receive event : ${event},param is ${params}`);
      if (event === EventConstants.EVENT_IN_APP_EXIT) {
        this.mViewModel?.setDuringAppExitAnim(params);
        this.isDuringAppExitAnimFunction?.(params);
      }
    }
  };

  private mDeleteOuterCardListener?: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string): void => {
      log.showInfo(TAG, `localEventListener receive event: ${event}, params: ${params}, cardId: ${this.formItem?.cardId}`);
      if (event === EventConstants.EVENT_REQUEST_OUTER_AI_CARD_DELETE) {
        let cardInfo: GridLayoutItemInfo | undefined = FormLayoutCacheManager.getInstance().
        selectGridLayoutItemByCardId(params, true);
        if (!cardInfo) {
          return;
        }
        AiSuggestionActionManager.getInstance().removeForm(cardInfo);
      }
    }
  };

  private formPressTypeChangeCallback = (type: LongPressType): void => {
    log.showInfo(TAG, `formPressTypeChangeCallback type: ${type}`);
    this.mViewModel?.onLongPressTypeChange(type);
  }

  public constructor(viewModel: AiSuggestionViewModel, cardId: string,
    formItem: GridLayoutItemInfo, isOuterDesktop: boolean, isDuringAppExitAnimFunction?: Function) {
    this.mViewModel = viewModel;
    this.formItem = formItem;
    this.cardId = cardId;
    this.isOuterDesktop = isOuterDesktop;
    this.isDuringAppExitAnimFunction = isDuringAppExitAnimFunction;
    this.registerEvent(cardId)
  }

  /**
   * 注册监听事件
   *
   * @param cardId 卡片id
   */
  private registerEvent(cardId: string | undefined): void {
    if (!cardId) {
      log.showError(TAG, 'initEvent cardId invalid');
      return;
    }
    log.showError(TAG, `initEvent cardId: ${cardId}`);
    // 注册更新卡片事件
    GlobalContext.getContext()?.eventHub.off(AiSuggestionEventName.getUpdateCardEventName(cardId),
      this.updateCardFunction);
    GlobalContext.getContext()?.eventHub.on(AiSuggestionEventName.getUpdateCardEventName(cardId),
      this.updateCardFunction);

    // 注册删除卡片事件
    GlobalContext.getContext()?.eventHub.off(AiSuggestionEventName.getDeleteCardEventName(cardId),
      this.deleteCardFunction);
    GlobalContext.getContext()?.eventHub.on(AiSuggestionEventName.getDeleteCardEventName(cardId),
      this.deleteCardFunction);

    // 注册重置卡片事件
    GlobalContext.getContext()?.eventHub.off(AiSuggestionEventName.getResetCardEventName(cardId),
      this.resetCardFunction);
    GlobalContext.getContext()?.eventHub.on(AiSuggestionEventName.getResetCardEventName(cardId),
      this.resetCardFunction);

    FormHostService.getInstance().registerFormVisibleListener(cardId, this.visibleListener);
    FormHostService.getInstance().registerFormRecycleListener(cardId, this.recycleListener);
    this.eventMgr.on(ConfigurationEvent, this.handleConfigurationEvent);
    localEventManager.registerEventListener(this.appExitListener, [EventConstants.EVENT_IN_APP_EXIT]);
    if (this.isOuterDesktop) {
      this.registerDeleteOuterCardListener();
    }
    GlobalContext.getContext()?.eventHub.on(`mFormStackPressTypeChange_${cardId}`, this.formPressTypeChangeCallback);
  }

  /**
   * 解注册事件
   */
  public unRegisterEvent(): void {
    log.showInfo(TAG, `unRegisterEvent cardId: ${this.cardId}`);
    this.eventMgr.offAll();
    // 注册更新卡片事件
    GlobalContext.getContext()?.eventHub.off(AiSuggestionEventName.getUpdateCardEventName(this.cardId),
      this.updateCardFunction);
    // 注册删除卡片事件
    GlobalContext.getContext()?.eventHub.off(AiSuggestionEventName.getDeleteCardEventName(this.cardId),
      this.deleteCardFunction);
    // 注册重置卡片事件
    GlobalContext.getContext()?.eventHub.off(AiSuggestionEventName.getResetCardEventName(this.cardId),
      this.resetCardFunction);
    localEventManager.unregisterEventListener(this.appExitListener);
    if (this.cardId) {
      FormHostService.getInstance().unRegisterFormVisibleListener(String(this.cardId), this.visibleListener);
      FormHostService.getInstance().unRegisterFormRecycleListener(this.cardId, this.recycleListener);
    }
    this.unRegisterAlarm();
    if (this.isOuterDesktop) {
      localEventManager.unregisterEventListener(this.mDeleteOuterCardListener);
    }
    GlobalContext.getContext()?.eventHub.off(`mFormStackPressTypeChange_${this.cardId}`,
      this.formPressTypeChangeCallback);
  }

  /**
   * 注册场景栏消失计时器
   */
  public registerAlarm(): void {
    if (this.reorderAlarm.isAlarmPending()) {
      log.showInfo(TAG, 'registerAlarm alarm is Pending');
      return;
    }
    log.showInfo(TAG, `registerAlarm cardId:${this.cardId}`);
    this.reorderAlarm.setHandler(this.alarmListener);
    const delaySeconds: number = this.mViewModel?.getViewData().portfolioInfo?.delaySeconds ?? 0;
    this.reorderAlarm.setAlarm(delaySeconds * 1000);
  }

  private unRegisterAlarm(): void {
    this.reorderAlarm.cancelAlarm();
    this.reorderAlarm.setHandler(null);
  }

  private registerDeleteOuterCardListener(): void {
    localEventManager.registerEventListener(this.mDeleteOuterCardListener, [
      EventConstants.EVENT_REQUEST_OUTER_AI_CARD_DELETE
    ]);
    log.showInfo(TAG, 'registerDeleteOuterCardListener listener on create');
  }
}
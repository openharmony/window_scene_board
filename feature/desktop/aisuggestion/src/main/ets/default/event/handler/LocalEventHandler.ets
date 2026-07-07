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

import type ctx from '@ohos.app.ability.common';
import CommonEventManager from '@ohos.commonEventManager';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  GlobalContext,
  localEventManager,
  sEventManager,
  ViewCallback,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { CommonConstants, EventConstants, LauncherAnimUtil, ReceiveEventInfo } from '@ohos/launchercommon';
import { FormStackEventInfo } from '../../bean/FormStackEventInfo';
import { CommandConsumer } from '../../command/CommandConsumer';
import { AiSuggestionFormManager } from '../../manager/AiSuggestionFormManager';
import { LayoutChangeEventProcessor } from './LayoutChangeEventProcessor';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import type { CommonEventData } from 'commonEvent/commonEventData';
import { RemoveAllAbilityForm } from '../../service/impl/RemoveAllAbilityForm';
import { RemoveFormInfo } from '../../service/entity/RemoveFormInfo';
import { ResetAiSuggestionForms } from '../../service/impl/ResetAiSuggestionForms';
import { AbilityFormUtil } from '../../utils/AbilityFormUtil';
import { AiSuggestionDataProcess } from '../../helper/AiSuggestionDataProcess';
import { ExposeEventRecorder } from '../../donate/ExposeEventRecorder';

const TAG = 'LocalEventHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const COMMAND_EXECUTE_DELAY: number = 300;

/**
 * 语音助手建议本地事件监听
 *
 * @since 2024-12-26
 */
export class LocalEventHandler {
  private static instance: LocalEventHandler;
  private eventSubscriber?: CommonEventSubscriber;
  private desktopContext?: ctx.ServiceExtensionContext = GlobalContext.getContext();
  private enabled: boolean = true;

  /**
   * 桌面的内部事件
   */
  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: boolean | number): void => {
      log.showInfo(`receive event ${event}`);
      if (event === EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH && typeof params === 'number') {
        LayoutChangeEventProcessor.getInstance().handleEvent(params);
      } else if (event === EventConstants.EVENT_CLEAR_DELETE_CARDS) {
        AiSuggestionFormManager.getInstance().clearDeletedCards();
      } else if (event === EventConstants.EVENT_REQUEST_FORM_RECYCLE && typeof params === 'boolean') {
        this.onReceiveRecycleEvent(params);
      } else if (event === EventConstants.EVENT_REQUEST_SET_OPERATE_STACK_ENABLED && typeof params === 'boolean') {
        this.enabled = params;
      }
    }
  };

  public getIsEnabled(): boolean {
    return this.enabled
  }

  /**
   * 桌面的焦点变化事件
   */
  private desktopFocusCallback: ViewCallback = {
    onGainFocus: (): void => {
      const isFormServiceShow: boolean = AppStorage.get('formServiceShow') ?? false;
      const isFormManageShow: boolean = AppStorage.get('formManageShow') ?? false;
      const isFolderClose: boolean = AppStorage.get('openFolderStatus') === CommonConstants.OPEN_FOLDER_STATUS_CLOSE;
      log.showDebug('onGainFocus, isFormServiceShow:%{public}s, isFormManageShow:%{public}s, isFolderClose:%{public}s',
        isFormServiceShow, isFormManageShow, isFolderClose);
      if (!isFormServiceShow && !isFormManageShow && isFolderClose) {
        ExposeEventRecorder.getInstance().recordExposeOnPageChange();
      }
    },
    // 桌面前台失去焦点
    onLoseFocus: (): void => {
      log.showDebug('onLoseFocus');
      ExposeEventRecorder.getInstance().recordExposeEndAll();
    },
  };

  /**
   * 应用更新事件
   */
  private readonly mUpdateAppInfoListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string): void => AiSuggestionDataProcess.processEvent(event, params)
  };

  /**
   * 桌面可见性变化事件
   */
  private desktopRecoverStateCallBack = (): void => {
    ExposeEventRecorder.getInstance().recordExposeOnPageChange();
  };

  /**
   * 桌面可见性变化事件
   */
  private desktopInvisibleStateCallBack = (): void => ExposeEventRecorder.getInstance().recordExposeEndAll();

  private constructor() {
    this.initListener();
  }

  private initListener(): void {
    this.subscribeAppEvent();
    this.registerUnlockEvent();
    this.registerLocalEventListener();
    this.registerFormStackItemStatusChangeEvent();
    this.registerDesktopFocusCallback();
    this.registerExposeEvent();
    this.registerUpdateAppListener();
  }

  private registerExposeEvent(): void {
    this.desktopContext?.eventHub.on(CommonConstants.DESKTOP_RECOVER_STATE, this.desktopRecoverStateCallBack);
    this.desktopContext?.eventHub.on(CommonConstants.DESKTOP_INVISIBLE_STATE, this.desktopInvisibleStateCallBack);
  }

  /**
   * Get ai model object
   *
   * @return Single instance of ai data model
   */
  static getInstance(): LocalEventHandler {
    if (LocalEventHandler.instance == null) {
      LocalEventHandler.instance = new LocalEventHandler();
    }
    return LocalEventHandler.instance;
  }

  private registerUpdateAppListener(): void {
    localEventManager.registerEventListener(this.mUpdateAppInfoListener, [
      EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE
    ]);
    log.showInfo('local voice listener on create');
  }

  private onReceiveRecycleEvent(params: boolean): void {
    if (params) {
      // 打开应用的时候，设置UI繁忙
      LauncherAnimUtil.setIsUIBusy(TAG, true);
    } else {
      CommandConsumer.getInstance().debounceExecuteCommands();
    }
  }

  private registerLocalEventListener(): void {
    log.showInfo('register layout change listener');
    localEventManager.registerEventListener(this.localEventListener, [
      EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH,
      EventConstants.EVENT_CLEAR_DELETE_CARDS,
      EventConstants.EVENT_REQUEST_FORM_RECYCLE,
      EventConstants.EVENT_REQUEST_SET_OPERATE_STACK_ENABLED,
    ]);
  }

  private registerFormStackItemStatusChangeEvent(): void {
    GlobalContext.getContext()?.eventHub.off(EventConstants.EVENT_FORM_STACK_ITEM_STATUS_CHANGE_EVENT);
    GlobalContext.getContext()?.eventHub.on(EventConstants.EVENT_FORM_STACK_ITEM_STATUS_CHANGE_EVENT,
      (eventInfo: FormStackEventInfo): void => AiSuggestionDataProcess.onFormStackNotify(eventInfo));
  }

  /**
   * 注册解锁进桌面的事件，进入桌面后，开始执行缓存命令
   */
  private registerUnlockEvent(): void {
    try {
      sEventManager.subscribe('ScreenLockExit', () => {
        log.showInfo('receive unlockScreen event');
        setTimeout(() => {
          CommandConsumer.getInstance().checkAndExecuteCommands();
        }, COMMAND_EXECUTE_DELAY);
      });
    } catch (err) {
      log.showError('registerUnlockEvent, err');
    }
  }

  /**
   * subscribe app clear event
   */
  private subscribeAppEvent(): void {
    log.showInfo('subscribeAppEvent start');
    // 订阅者信息
    const subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [CommonEventManager.Support.COMMON_EVENT_PACKAGE_DATA_CLEARED,
        CommonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED] // 订阅公共事件
    };
    CommonEventManager.createSubscriber(subscribeInfo).then((res) => {
      this.eventSubscriber = res;
      try {
        CommonEventManager.subscribe(this.eventSubscriber, (err, data) => {
          log.showInfo('receive subscribe callback');
          if (err) {
            log.showError(`subscribe callback err:${err}`);
            return;
          }
          log.showDebug(`receive subscribe callback data:${data?.bundleName}`);
          if (CommonUtils.isInvalid(data)) {
            return;
          }
          this.handleAiDispatchService(data);
          this.handleVassistantLauncher(data);
        });
      } catch (err) {
        log.showError(`subscribe err:${err}`);
      }
    });
  }

  private handleAiDispatchService(data: CommonEventData): void {
    if ((data.event === CommonEventManager.Support.COMMON_EVENT_PACKAGE_DATA_CLEARED ||
      data.event === CommonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED) &&
      data.bundleName === 'com.ohos.aidispatchservice') {
      new ResetAiSuggestionForms().execute();
    }
  }

  private handleVassistantLauncher(data: CommonEventData): void {
    if (data.event === CommonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED &&
      data.bundleName === 'com.ohos.vassistant.launcher') {
      const forms = AbilityFormUtil.getAllAiSuggestionItems();
      if (CommonUtils.containerIsEmpty(forms)) {
        return;
      }
      const removeFormInfos: RemoveFormInfo[] = forms.map(form => new RemoveFormInfo(form.cardId ?? ''));
      new RemoveAllAbilityForm().execute(removeFormInfos);
    }
  }

  private registerDesktopFocusCallback(): void {
    log.showInfo('registerDesktopFocusCallback');
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, this.desktopFocusCallback);
  }
}
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
  NotificationBridgeEventManagerParams,
  NotificationBridgeEventParams,
  NotificationBridgeMsgParser
} from './NotificationBridgeMsgParser';
import { messageChannel } from '../messageChannel/MessageChannel';
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { LogDomain, LogHelper, SingletonHelper, ThreadUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CustomPromise, Event, EventListener, sEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';
import { Events } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';

interface EnableRegisterParams {
  fnName: string,
  args: Object[]
}

const log = LogHelper.getLogHelper(LogDomain.NC, `NotificationBridge`);

// 主线程bridge需要监听子线程的EventBus事件列表
const eventBusListMain = ['NotificationEvent', 'RequestWindowEvent', 'LiveViewShowAuthEvent',
  'StatusBarStyleChangeEvent', 'WindowEvent', 'StatusBarAvoidHeightChangeEvent', 'ShowBatteryDialogEvent',
  'StatusBarShowHideChangeEvent', 'NotificationEventForBridge', 'ScreenRecordEvent',
  'LiveViewRequestEnterImmersiveEvent', 'LiveViewRequestExitImmersiveEvent', 'NtfAutoScreenOnEvent'];

// 子线程bridge需要监听主线程的EventBus事件列表
const eventBusListSub =
  ['ScreenLockEvent', 'BasicStatementAgreedEvent', 'ConfigurationEvent', 'PackageCommonEvent', 'ScreenOnOffEvent',
    'FaceSwitchEnableEvent', 'HiddenBannerNtfEnableEvent', 'FingerprintUnlockSwitchEnableEvent',
    'TimeFormatEvent', 'TimeChangeEvent', 'FocusModeSwitchDataEvent', 'RealTimeNetworkSpeedEvent',
    'ScreenPropertyChangeEvent', 'WallpaperChangeEvent', 'StartSceneFromOtherEvent',
    'OobeActivatedEvent', 'ColorModeChangeEvent', 'ScreenStatusChangeEvent', 'RssNotifyEvent',
    'CellularDataEnableEvent', 'PureShowEvent', 'BatterySocEvent', 'SatelliteModeSwitchEvent', 'FlashlightLiveEvent',
    'MultiDeviceCollaborationServiceEnableEvent', 'CutoutEvent', 'DisplayEvent', 'NotificationIconEvent',
    'EnableSwitchEvent', 'NotifyStatusBarShowHideEvent', 'MediaControlEvent',
    'MultiWindowRotateChangeEvent', 'RgmStatusChangeEvent', 'LiveViewEnterImmersiveEvent',
    'LiveViewExitImmersiveEvent'];

// 主线程bridge需要监听子线程的EventManager事件列表
const eventManagerListMain = [];

// 子线程bridge需要监听主线程的EventManager事件列表
const eventManagerListSub = ['startAbilityEvent', 'startServiceExtEvent'];

/**
 * 通知业务跨线程处理业务的桥梁
 */
export class NotificationBridge {
  /**
   * 获取单例
   */
  public static get = SingletonHelper.createFactory(() => new NotificationBridge());

  /**
   * 对端bridge是否已初始化完成
   */
  private isRemoteBridgeInit = new CustomPromise<void>();

  /**
   * 保存全量EventListener，子线程重启时需要清理
   */
  private eventBusListenerMap: Map<Event<Object>, EventListener<Object>> = new Map();
  private eventManagerListenerMap: Map<Events, EventListener<Object>> = new Map();

  /**
   * 初始化
   */
  public init(): void {
    if (ThreadUtil.isMainThread && !SystemUICcmConfig.instance.isEnabledWorker) {
      // 不启用静态切分时无需初始化bridge
      return;
    }

    log.showInfo(`NotificationBridge init`);
    this.clear();

    this.initDynamicRegister();

    this.initEventManagerPostListener();
    this.preRegisterEventManager();

    this.initEventBusPostListener();
    this.preRegisterEventBus();

    if (!ThreadUtil.isMainThread) {
      // 子线程场景。可以确定主线程channel已经在DC组件启动之前完成初始化
      this.isRemoteBridgeInit.resolve();

      // 通知主线程，子线程已完成初始化
      messageChannel.sendMessage('remoteBridgeInit', undefined);
    } else {
      // 主线程场景，监听子线程初始化完成的事件。
      messageChannel.onMessage('remoteBridgeInit', () => {
        this.isRemoteBridgeInit.resolve();
      });
    }
  }

  /**
   * 初始化前的清理动作，确保子线程重拉时init方法可重入
   */
  private clear(): void {
    this.isRemoteBridgeInit = new CustomPromise<void>();

    // 清理已注册的事件监听，子线程重启时需要重新监听。
    this.eventBusListenerMap.forEach((listenerFn, event) => {
      InnerEventUtil.off(event, listenerFn);
    });
    this.eventBusListenerMap.clear();

    this.eventManagerListenerMap.forEach((listenerFn, event) => {
      sEventManager.off(event, listenerFn);
    });
    this.eventManagerListenerMap.clear();
  }

  /**
   * 发消息使能对端的注册函数，在对端线程上监听事件
   * @param params 函数名以及参数
   * @returns
   */
  private async enableRemoteRegister(params: EnableRegisterParams): Promise<void> {
    // 等待子线程bridge初始化完成后，再触发动态注册
    if (ThreadUtil.isMainThread) {
      await this.isRemoteBridgeInit;
    }

    // 发消息到对端
    messageChannel.sendMessage('enableRegister', params);
  }

  /**
   * 子线程需要注册监听事件时，发送消息通知主线程，通过函数名和动态参数，调用提前定义在主线程中的注册函数完成跨线程事件监听。
   */
  private initDynamicRegister(): void {
    messageChannel.onMessage('enableRegister', (params: EnableRegisterParams) => {
      const fnName = params.fnName;
      log.showInfo(`onMessage enableRegister fnName: ${params.fnName}`);

      // 获取函数
      const func = Reflect.get(this, fnName as PropertyKey, this) as Function;
      if (!func) {
        return;
      }

      // 触发执行
      const args = params.args;
      if (args) {
        func(...args);
      } else {
        func();
      }
    });
  }

  /**
   * 初始化监听对端发送过来的EventBus Post事件
   */
  private initEventBusPostListener(): void {
    messageChannel.onMessage<NotificationBridgeEventParams<Object>>('eventBusPost', param => {
      log.showInfo(`bridge eventbus receive: ${JSON.stringify(param.event)}`);

      // 转换对端发送过来的数据结构
      const parsedParam = NotificationBridgeMsgParser.covertEventBusReceive(param);

      // 在本端发送post事件
      InnerEventUtil.post(parsedParam.event, parsedParam.data);
    });
  }

  /**
   * 注册跨线程EventBus监听
   */
  private preRegisterEventBus(): void {
    const eventList = ThreadUtil.isMainThread ? eventBusListMain : eventBusListSub;

    eventList.forEach(eventTypeName => {
      // 本端触发on事件时，一次性获取对端的produceOn数据
      this.registerEventBusProduceOn(eventTypeName);
      // 持续监听对端的eventbus post事件
      this.registerEventBusPost(eventTypeName);
    });
  }

  /**
   * 一次性获取对端的produceOn数据
   * @param eventTypeName 事件名称
   */
  private registerEventBusProduceOn(eventTypeName: string): void {
    // 监听本端的on事件
    InnerEventUtil.produceOn<Object>({ eventTypeName } as unknown as Event<Object>, (param, listener): Object => {
      log.showInfo(`produceOn enableRemoteRegister ${eventTypeName}`);

      // 监听对端produceOn，数据只会发送一次。如果有多个produceOn可以保持先后顺序一致，依次触发本端回调。
      this.onMessageOnceForProduceOn(eventTypeName, listener);

      // 触发对端的produceOn
      this.enableRemoteRegister({ fnName: 'eventBusProduceOn', args: [{ eventTypeName }] });

      return;
    });
  }

  /**
   * 监听对端ProduceOn发送过来的消息，触发本端回调
   * @param eventTypeName
   * @param listener
   */
  private onMessageOnceForProduceOn(eventTypeName: string, listener: EventListener<Object>): void {
    messageChannel.onMessageOnce<NotificationBridgeEventParams<Object>[]>(this.getProduceOnMsgName(eventTypeName),
      (resArray) => {
        log.showInfo(`produceOn recive res ${eventTypeName} res length: ${resArray?.length}`);
        resArray.forEach(res => {
          // 对端没有提供produceOn
          if (res === undefined) {
            return;
          }

          // 转换对端发送过来的数据结构
          const parsedParam = NotificationBridgeMsgParser.covertEventBusReceive(res);
          listener(parsedParam.data);
        })
      });
  }

  /**
   * 监听对端的eventbus post事件
   * @param eventTypeName 事件名称
   */
  private registerEventBusPost(eventTypeName): void {
    this.enableRemoteRegister({ fnName: 'eventBusPost', args: [{ eventTypeName }] });
  }

  /**
   * 注册EvtBus的事件监听，被dynamicRegister动态调用，用于动态向对端注册事件监听。
   */
  private eventBusPost = <T>(event: Event<T>): void => {
    log.showInfo(`register bridge eventbus: ${JSON.stringify(event)}`);

    let sendMsg = (data: T): void => {
    };
    const listenerFn = (data: T): void => {
      sendMsg(data);
    };

    // 监听的时候会触发produceOn，此时sendMsg为空，不会产生多余的数据。
    InnerEventUtil.on(event, listenerFn);

    // on完成之后再给sendMsg赋值，只监听后续的post事件。
    sendMsg = (data: T): void => {
      log.showInfo(`bridge eventbus send: ${JSON.stringify(event)}`);

      const paramForSend = NotificationBridgeMsgParser.covertEventSend<T>({ event, data });
      if (!paramForSend) {
        return;
      }
      messageChannel.sendMessage('eventBusPost', paramForSend);
    };

    // 保存监听函数，worker重新拉起时需要清理。
    this.eventBusListenerMap.set(event, listenerFn);
  };

  /**
   * 一次性获取produceOn的数据，被dynamicRegister动态调用。
   */
  private eventBusProduceOn = <T>(event: Event<T>): void => {
    log.showInfo(`register produceOn eventbus: ${JSON.stringify(event)}`);
    const eventTypeName = (Reflect.get(event, 'eventTypeName') as string);

    const dataArr: T[] = [];
    const listenerFn = (produceOnData: T): void => {
      dataArr.push(produceOnData);
    };

    // 监听的时候如果有producer，会立即调用listenerFn给data赋值。
    InnerEventUtil.on(event, listenerFn);
    // 这里只需要获取produceOn数据，监听之后可以直接取消。
    InnerEventUtil.off(event, listenerFn);

    const paramForSend: Object[] = [];
    dataArr.forEach((data) => {
      const sendItem = NotificationBridgeMsgParser.covertEventSend<T>({ event, data });
      if (sendItem) {
        paramForSend.push(sendItem);
      }
    })

    messageChannel.sendMessage(this.getProduceOnMsgName(eventTypeName), paramForSend);
  };

  /**
   * 获取produceOn数据时的MessageChannel监听事件名称
   * @param eventTypeName
   * @returns
   */
  private getProduceOnMsgName(eventTypeName: string): string {
    return eventTypeName + '_EventBusProduceOn';
  }

  /**
   * 注册跨线程EventBus监听
   */
  private preRegisterEventManager(): void {
    const eventList = ThreadUtil.isMainThread ? eventManagerListMain : eventManagerListSub;

    eventList.forEach(eventTypeName => {
      // 持续监听对端的eventManager post事件
      this.registerEventManagerPost(eventTypeName);
    });
  }

  /**
   * 监听对端的eventbus post事件
   * @param eventTypeName 事件名称
   */
  private registerEventManagerPost(eventTypeName): void {
    log.showInfo(`registerEventManagerPost ${eventTypeName}`);
    this.enableRemoteRegister({ fnName: 'eventManagerPost', args: [eventTypeName] });
  }

  /**
   * 注册sEventManager的事件监听，被dynamicRegister动态调用，用于动态向对端注册事件监听。
   */
  private eventManagerPost = <T>(event: string): void => {
    log.showInfo(`register bridge eventManager: ${event}`);

    const listenerFn = (data: T): void => {
      log.showInfo(`bridge eventManager send: ${event}`);

      const paramForSend = NotificationBridgeMsgParser.covertEventSend<T>({ event, data });
      if (!paramForSend) {
        return;
      }
      messageChannel.sendMessage('eventManagerPost', paramForSend);
    };
    sEventManager.subscribe(event, listenerFn);

    // 保存监听函数，worker重新拉起时需要清理。
    this.eventManagerListenerMap.set(event, listenerFn);
  };

  /**
   * 初始化监听对端发送过来的EventManager Post事件
   */
  private initEventManagerPostListener(): void {
    messageChannel.onMessage<NotificationBridgeEventManagerParams<Object>>('eventManagerPost', param => {
      log.showInfo(`bridge eventManager receive: ${param.event}`);

      // 转换对端发送过来的数据结构
      const parsedParam = NotificationBridgeMsgParser.covertEvenManagerReceive(param);

      // 在本端发送emit事件
      sEventManager.mEventBus.emit(parsedParam.event, parsedParam.data);
    });
  }
}
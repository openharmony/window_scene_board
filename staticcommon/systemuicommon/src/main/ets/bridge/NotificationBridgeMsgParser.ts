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

import { LiveViewShowAuthEvent, NotificationEvent } from '../event/NotificationEvent';
import { LiveCapsuleModel } from '../live/model/LiveCapsuleModel';
import { LiveCardModel } from '../live/model/LiveCardModel';
import { LiveNotification } from '../live/model/LiveNotification';
import { NotificationBase } from '../model/NotificationBase';
import { NtfControlConfig } from '../model/NtfControlFlags';
import { NotificationAction, NotificationRole } from '../model/NotificationContent';
import { NtfReminderConfig } from '../model/NtfRemindFlags';
import {
  BasicStatementAgreedEvent,
  FaceSwitchEnableEvent,
  FingerprintUnlockSwitchEnableEvent,
  FocusModeSwitchDataEvent,
  HiddenBannerNtfEnableEvent,
  TimeFormatEvent,
  CellularDataEnableEvent,
  RealTimeNetworkSpeedEvent,
  PureShowEvent,
  BatterySocEvent,
  SatelliteModeSwitchEvent,
  MultiDeviceCollaborationServiceEnableEvent,
  NotificationIconEvent,
  EnableSwitchEvent
} from '../datasharemanager/SysUIDataShareEvent';
import { cloneSerializableProperties } from '../messageChannel/MessageChannel';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { Event } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { RgmStatusChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import {
  AbilityStateChangedEvent,
  ConfigurationEvent,
  CutoutEvent,
  PackageCommonEvent,
  RequestWindowEvent,
  ScreenLockEvent,
  ScreenOnOffEvent,
  StartSceneFromOtherEvent,
  TimeChangeEvent,
  WindowEvent,
  OobeActivatedEvent,
  RssNotifyEvent,
  ColorModeChangeEvent,
  MultiWindowRotateChangeEvent,
  ScreenStatusChangeEvent,
  MediaControlEvent,
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  FlashlightLiveEvent,
  StatusBarStyleChangeEvent,
  LiveViewRequestEnterImmersiveEvent,
  LiveViewRequestExitImmersiveEvent,
  LiveViewEnterImmersiveEvent,
  LiveViewExitImmersiveEvent
} from '../event/LiveViewEvent';
import { DisplayEvent } from '@ohos/windowscene';
import {
  NotifyStatusBarShowHideEvent,
  ScreenRecordEvent,
  StatusBarAvoidHeightChangeEvent,
  StatusBarShowHideChangeEvent,
} from '../event/StatusBarEvent';
import { ShowBatteryDialogEvent } from '../event/ShowBatteryDialogEvent';
import { ScreenLockAdapter } from '../adapter/ScreenLockAdapter';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationBridgeMsgParser');

/**
 * EventBus跨线程传递的数据结构，包含event类型和对应的data
 */
export interface NotificationBridgeEventParams<T> {
  event: Event<T>,
  data: T
}

/**
 * EventManager跨线程传递的数据结构，包含event类型和对应的data
 */
export interface NotificationBridgeEventManagerParams<T> {
  event: string,
  data: T
}

/**
 * 每一类事件指定对应的处理函数进行数据恢复
 */
const EventCovertFnMap: Record<string, Function> = {
  NotificationEvent: (data: NotificationEvent): NotificationEvent => {
    const parsedData = new NotificationEvent(data.eventType, data.notificationList);
    Object.assign(parsedData, data);
    parsedData.notificationList.forEach((item, index) => {
      let ntf: NotificationBase;
      if (item.role === NotificationRole.LIVE_VIEW) {
        ntf = new LiveNotification();
      } else {
        ntf = new NotificationBase();
      }
      Object.assign(ntf, item);

      // 恢复ntf对象上的method
      NotificationBridgeMsgParser.recoverNtfMethod(ntf);
      // 如果是实况类型，恢复实况卡片对象上的method
      if (ntf?.isLiveView()) {
        NotificationBridgeMsgParser.recoverLiveMethod(ntf);
      }
      parsedData.notificationList[index] = ntf;
    });

    return parsedData;
  },

  FaceSwitchEnableEvent: (data: FaceSwitchEnableEvent): FaceSwitchEnableEvent => {
    const parsedData = new FaceSwitchEnableEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  HiddenBannerNtfEnableEvent: (data: HiddenBannerNtfEnableEvent): HiddenBannerNtfEnableEvent => {
    const parsedData = new HiddenBannerNtfEnableEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  FingerprintUnlockSwitchEnableEvent: (data: FingerprintUnlockSwitchEnableEvent): FingerprintUnlockSwitchEnableEvent => {
    const parsedData = new FingerprintUnlockSwitchEnableEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  ScreenLockEvent: (data: ScreenLockEvent): ScreenLockEvent => {
    const parsedData = new ScreenLockEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  RequestWindowEvent: (data: RequestWindowEvent): RequestWindowEvent => {
    const parsedData = RequestWindowEvent.create(data.windowName, data.requestType);
    Object.assign(parsedData, data);
    return parsedData;
  },

  WindowEvent: (data: WindowEvent): WindowEvent => {
    const parsedData = new WindowEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  BasicStatementAgreedEvent: (data: BasicStatementAgreedEvent): BasicStatementAgreedEvent => {
    const parsedData = new BasicStatementAgreedEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  ConfigurationEvent: (data: ConfigurationEvent): ConfigurationEvent => {
    const parsedData = new ConfigurationEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  PackageCommonEvent: (data: PackageCommonEvent): PackageCommonEvent => {
    const parsedData = new PackageCommonEvent(data);
    Object.assign(parsedData, data);
    return parsedData;
  },

  ScreenOnOffEvent: (data: ScreenOnOffEvent): ScreenOnOffEvent => {
    const parsedData = new ScreenOnOffEvent(data);
    Object.assign(parsedData, data);
    return parsedData;
  },

  TimeFormatEvent: (data: TimeFormatEvent): TimeFormatEvent => {
    const parsedData = new TimeFormatEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  TimeChangeEvent: (data: TimeChangeEvent): TimeChangeEvent => {
    const parsedData = new TimeChangeEvent(data);
    Object.assign(parsedData, data);
    return parsedData;
  },

  LiveViewShowAuthEvent: (data: LiveViewShowAuthEvent): LiveViewShowAuthEvent => {
    const parsedData = new LiveViewShowAuthEvent(data.hashCode);
    Object.assign(parsedData, data);
    return parsedData;
  },

  FocusModeSwitchDataEvent: (data: FocusModeSwitchDataEvent): FocusModeSwitchDataEvent => {
    const parsedData = new FocusModeSwitchDataEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  CellularDataEnableEvent: (data: CellularDataEnableEvent): CellularDataEnableEvent => {
    const parsedData = new CellularDataEnableEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  RealTimeNetworkSpeedEvent: (data: RealTimeNetworkSpeedEvent): RealTimeNetworkSpeedEvent => {
    const parsedData = new RealTimeNetworkSpeedEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  StatusBarStyleChangeEvent: (data: StatusBarStyleChangeEvent): StatusBarStyleChangeEvent => {
    const parsedData = new StatusBarStyleChangeEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  PureShowEvent: (data: PureShowEvent): PureShowEvent => {
    const parsedData = new PureShowEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  BatterySocEvent: (data: BatterySocEvent): BatterySocEvent => {
    const parsedData = new BatterySocEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  SatelliteModeSwitchEvent: (data: SatelliteModeSwitchEvent): SatelliteModeSwitchEvent => {
    const parsedData = new SatelliteModeSwitchEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  MultiDeviceCollaborationServiceEnableEvent: (data: MultiDeviceCollaborationServiceEnableEvent): MultiDeviceCollaborationServiceEnableEvent => {
    const parsedData = new MultiDeviceCollaborationServiceEnableEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  AbilityStateChangedEvent: (data: AbilityStateChangedEvent): AbilityStateChangedEvent => {
    const parsedData =
      new AbilityStateChangedEvent(data.bundleName, data.state, data.abilityName, data.uid, data.moduleName, data.pid, data.abilityType);
    Object.assign(parsedData, data);
    return parsedData;
  },

  StartSceneFromOtherEvent: (data: StartSceneFromOtherEvent): StartSceneFromOtherEvent => {
    const parsedData = new StartSceneFromOtherEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  CutoutEvent: (data: CutoutEvent): CutoutEvent => {
    const parsedData = new CutoutEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  DisplayEvent: (data: DisplayEvent): DisplayEvent => {
    const parsedData = new DisplayEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  NotificationIconEvent: (data: NotificationIconEvent): NotificationIconEvent => {
    const parsedData = new NotificationIconEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  ColorModeChangeEvent: (data: ColorModeChangeEvent): ColorModeChangeEvent => {
    const parsedData = ColorModeChangeEvent.create(data.currColorMode);
    Object.assign(parsedData, data);
    return parsedData;
  },

  ScreenStatusChangeEvent: (data: ScreenStatusChangeEvent): ScreenStatusChangeEvent => {
    const parsedData = ScreenStatusChangeEvent.create(data.lockStatus, data.foldStatusForOuterScreen,
      data.autoRotateStatus);
    Object.assign(parsedData, data);
    return parsedData;
  },

  RssNotifyEvent: (data: RssNotifyEvent): RssNotifyEvent => {
    const parsedData = RssNotifyEvent.create(data.component);
    Object.assign(parsedData, data);
    return parsedData;
  },

  OobeActivatedEvent: (data: OobeActivatedEvent): OobeActivatedEvent => {
    const parsedData = new OobeActivatedEvent();
    Object.assign(parsedData, data);
    return parsedData;
  },

  StatusBarAvoidHeightChangeEvent: (data: StatusBarAvoidHeightChangeEvent): StatusBarAvoidHeightChangeEvent => {
    const parsedData = StatusBarAvoidHeightChangeEvent.create(data.avoidHeight);
    Object.assign(parsedData, data);
    return parsedData;
  },

  FlashlightLiveEvent: (data: FlashlightLiveEvent): FlashlightLiveEvent => {
    const parsedData = FlashlightLiveEvent.create(false);
    Object.assign(parsedData, data);
    return parsedData;
  },

  ShowBatteryDialogEvent: (data: ShowBatteryDialogEvent): ShowBatteryDialogEvent => {
    const parsedData = new ShowBatteryDialogEvent(data.isCharging, data.batterySoc);
    Object.assign(parsedData, data);
    return parsedData;
  },

  MultiWindowRotateChangeEvent: (data: MultiWindowRotateChangeEvent): MultiWindowRotateChangeEvent => {
    const parseData = MultiWindowRotateChangeEvent.create(data.isRotateUnavailable);
    Object.assign(parseData, data);
    return parseData;
  },

  EnableSwitchEvent: (data: EnableSwitchEvent): EnableSwitchEvent => {
    const parsedData = new EnableSwitchEvent(data.subEventType);
    Object.assign(parsedData, data);
    return parsedData;
  },

  NotifyStatusBarShowHideEvent: (data: NotifyStatusBarShowHideEvent): NotifyStatusBarShowHideEvent => {
    const parsedData = new NotifyStatusBarShowHideEvent(data.flag, data.enableAnimation);
    Object.assign(parsedData, data);
    return parsedData;
  },

  MediaControlEvent: (data: MediaControlEvent): MediaControlEvent => {
    const parseData = new MediaControlEvent(data);
    Object.assign(parseData, data);
    return parseData;
  },

  StatusBarShowHideChangeEvent: (data: StatusBarShowHideChangeEvent): StatusBarShowHideChangeEvent => {
    const parseData = StatusBarShowHideChangeEvent.create(data.isShow);
    Object.assign(parseData, data);
    return parseData;
  },

  RgmStatusChangeEvent: (data: RgmStatusChangeEvent): RgmStatusChangeEvent => {
    return new RgmStatusChangeEvent(data);
  },

  ScreenRecordEvent: (data: ScreenRecordEvent): ScreenRecordEvent => {
    const parseData = new ScreenRecordEvent(data.status, data.color);
    Object.assign(parseData, data);
    return parseData;
  },

  LiveViewRequestEnterImmersiveEvent: (data: LiveViewRequestEnterImmersiveEvent): LiveViewRequestEnterImmersiveEvent => {
    const parseData = new LiveViewRequestEnterImmersiveEvent(data.hashCode);
    Object.assign(parseData, data);
    return parseData;
  },

  LiveViewRequestExitImmersiveEvent: (data: LiveViewRequestExitImmersiveEvent): LiveViewRequestExitImmersiveEvent => {
    const parseData = new LiveViewRequestExitImmersiveEvent();
    Object.assign(parseData, data);
    return parseData;
  },

  LiveViewEnterImmersiveEvent: (data: LiveViewEnterImmersiveEvent): LiveViewEnterImmersiveEvent => {
    const parseData = new LiveViewEnterImmersiveEvent(data.hashCode);
    Object.assign(parseData, data);
    return parseData;
  },

  LiveViewExitImmersiveEvent: (data: LiveViewExitImmersiveEvent): LiveViewExitImmersiveEvent => {
    const parseData = new LiveViewExitImmersiveEvent(data.hashCode);
    Object.assign(parseData, data);
    return parseData;
  }
};

const EventSendCovertMap: Record<string, Function> = {
  NotificationEvent: (inputData: NotificationEvent): NotificationEvent | undefined => {
    if (!ScreenLockAdapter.isScreenLock && inputData.eventType !== NotificationEvent.EVENT_TYPE_INIT) {
      // 当前仅有锁屏场景，需要发原始通知数据到主线程。
      // （XR眼镜已确认对应监听代码已废弃）
      return undefined;
    }

    const data = new NotificationEvent(inputData.eventType, inputData.notificationList);
    if (data.eventType === NotificationEvent.EVENT_TYPE_INIT) {
      data.notificationList = data.notificationList.filter(item => {
        return item.isLiveView() || item.isOngoing;
      });
    }

    if (data.eventType !== NotificationEvent.EVENT_TYPE_INIT && data.notificationList.length === 0) {
      return undefined;
    }

    return data;
  },
}


/**
 * 通知跨线程数据传递Parser
 */
export class NotificationBridgeMsgParser {
  /**
   * EventBus跨线程事件传输前的格式转换。
   * @param params 待转换的数据
   * @returns
   */
  public static covertEventSend<T>(params: NotificationBridgeEventParams<T> | NotificationBridgeEventManagerParams<T>):
  NotificationBridgeEventParams<T> | NotificationBridgeEventManagerParams<T> | undefined {
    const eventTypeName =
      typeof params.event === 'string' ? params.event : Reflect.get(params.event, 'eventTypeName') as string;

    const covertFn = EventSendCovertMap[eventTypeName];
    if (covertFn) {
      const res: T = covertFn(params.data);
      if (res === undefined) {
        return undefined;
      }
      params.data = res;
    }

    if (typeof params.data !== 'object' || params.data === null) {
      return params;
    }

    const dataForSend: Record<string, Object> = {};
    cloneSerializableProperties(params.data, dataForSend);
    params.data = dataForSend as T;
    return params;
  }

  /**
   * EventBus跨线程事件传输后的格式转换。将onMessage收到的数据恢复成原始的数据类型，主要是添加类方法
   * @param params onMessage收到的数据
   * @returns
   */
  public static covertEventBusReceive<T>(params: NotificationBridgeEventParams<T>):
    NotificationBridgeEventParams<Object> {
    const eventTypeName = Reflect.get(params.event, 'eventTypeName') as string;

    const covertFn = EventCovertFnMap[eventTypeName];
    if (covertFn) {
      params.data = covertFn(params.data);
    }

    return params;
  }

  /**
   * 恢复实况卡片的对象方法
   * @param ntf
   */
  public static recoverLiveMethod(ntf: LiveNotification): void {
    // 恢复card的static方法
    if (ntf.card) {
      const keys = Object.getOwnPropertyNames(LiveCardModel.prototype);
      keys.forEach((key) => {
        if (typeof LiveCardModel.prototype[key] === 'function') {
          ntf.card[key] = LiveCardModel.prototype[key];
        }
      });
    }

    // 恢复capsule的static方法
    if (ntf.capsule) {
      const keys = Object.getOwnPropertyNames(LiveCapsuleModel.prototype);
      keys.forEach((key) => {
        if (typeof LiveCapsuleModel.prototype[key] === 'function') {
          ntf.capsule[key] = LiveCapsuleModel.prototype[key];
        }
      });
    }
  }

  /**
   * 恢复通知卡片的对象方法
   * @param ntf
   */
  public static recoverNtfMethod(ntf: NotificationBase): void {
    ntf.controlConfig = new NtfControlConfig(ntf.controlConfig?.flags ?? 0);
    ntf.remindConfig = new NtfReminderConfig(ntf.remindConfig?.flags);
    ntf.actionButtons?.forEach((btn, index) => {
      ntf.actionButtons[index] = new NotificationAction({
        title: btn.actionTitle,
        wantAgent: btn.wantAgent,
        userInput: {
          inputKey: btn.userInputKey
        }
      });
    })
  }

  /**
   * EventManager跨线程事件传输后的格式转换。将onMessage收到的数据恢复成原始的数据类型，主要是添加类方法
   * @param params onMessage收到的数据
   * @returns
   */
  public static covertEvenManagerReceive<T>(params: NotificationBridgeEventManagerParams<T>): NotificationBridgeEventManagerParams<Object> {
    const eventTypeName = params.event;

    const covertFn = EventCovertFnMap[eventTypeName];
    if (covertFn) {
      params.data = covertFn(params.data);
    }

    return params;
  }
}
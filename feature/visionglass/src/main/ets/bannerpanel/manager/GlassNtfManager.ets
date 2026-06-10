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

import { NotificationEntryEvent } from '@ohos/notificationcomponent/src/main/ets/common/event/NotificationEvent';
import type { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { GlassNtfEventManager } from './GlassNtfEventManager';
import { BusinessError } from '@kit.BasicServicesKit';
import GlassNtfConstant from '../common/GlassNtfConstant';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { call } from '@kit.TelephonyKit';
import notificationManager from '@ohos.notificationManager';
import { ntfListener } from '@ohos/notificationcomponent/src/main/ets/model/NotificationListener';
import { EvtBus } from '@ohos/frameworkwrapper';
import { GlassCallEvent } from '../../common/event/CommonEvent';
import { LiveViewData, SysTypeCode } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NotificationUtil } from '../../notificationcenter/vm/NotificationGlassVm';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassNtfManager');

export interface NtfChangeCallBack {
  addNtf?: (ntf: NotificationEntry[]) => void;
  updateNtf?: (ntf: NotificationEntry[]) => void;
  removeNtf?: (ntfList: NotificationEntry[]) => void;
}

export const enum PhoneCallEvent {
  Accept = 'PhoneCallAccept',
  HangUp = 'PhoneCallHangUp',
}

export class GlassNtfManager {
  private static instance?: GlassNtfManager;
  private curNtf: NotificationEntry | null = null;
  private ntfChangeCallBacks: NtfChangeCallBack[] = [];
  private onNtfEvent = (event: NotificationEntryEvent): void => {
    const ntfList: NotificationEntry[] = event.notificationList;
    log.showInfo(`onNtfEvent`);
    if (ArrayUtils.isEmpty(ntfList)) {
      return;
    }
    const ntf: NotificationEntry = ntfList[0];
    if (this.isMediaPlaybackController(ntf)) {
      log.showInfo(`isMediaPlaybackController true`);
      return;
    }
    log.showInfo(`hashcode is ${ntf.hashCode},isHeadsUp:${ntf.isHeadsUp()}`);
    if (!this.isNtfValid(ntf)) {
      log.showWarn(`ntf is invalid`);
      return;
    }
    if (NotificationUtil.checkIsCallNtf(ntf)) {
      log.showInfo(`post GlassCallEvent,eventType is ${event.eventType},hashcode is ${ntf.hashCode}`);
      EvtBus.post(GlassCallEvent, new GlassCallEvent(ntf.liveViewData?.getTimerData()));
    }
    switch (event.eventType) {
      case NotificationEntryEvent.EVENT_TYPE_POST_ADD:
      case NotificationEntryEvent.EVENT_TYPE_POST_UPDATE:
        this.onPublishEvent(ntfList);
        break;
      case NotificationEntryEvent.EVENT_TYPE_POST_CANCEL:
        this.onCancelEvent(ntfList);
        break;
      default:
        break;
    }
  };

  private constructor() {
  }

  /*
   * 消息监听回调
   *
   * @param ntfList
   * */
  private onPublishEvent(ntfList: NotificationEntry[]): void {
    const ntfId: string = ntfList[0].hashCode;
    if (this.curNtf && this.curNtf.hashCode === ntfId) {
      this.ntfChangeCallBacks.forEach((callBack: NtfChangeCallBack) => {
        callBack.updateNtf?.(ntfList);
      });
    } else {
      this.ntfChangeCallBacks.forEach((callBack: NtfChangeCallBack) => {
        callBack.addNtf?.(ntfList);
      });
    }
    this.curNtf = ntfList[0];
  }

  private onCancelEvent(ntfList: NotificationEntry[]): void {
    const ntfId: string = ntfList[0].hashCode;
    if (this.curNtf && this.curNtf.hashCode === ntfId) {
      this.curNtf = null;
    }
    this.ntfChangeCallBacks.forEach((callBack: NtfChangeCallBack) => {
      callBack.removeNtf?.(ntfList);
    });
  }

  private isNtfValid(ntf: NotificationEntry): boolean {
    if (GlassNtfConstant.blackAppList.indexOf(ntf.creatorBundleName) !== -1) {
      log.showInfo(`ntf in blackAppList`);
      return false;
    } else if (!ntf.getAppIcon(true)) {
      return false;
    }
    return true;
  }

  private destroy(): void {
    this.curNtf = null;
    this.ntfChangeCallBacks = [];
  }

  /*
   * 获取当前消息管理类单实例
   *
   * @param GlassNtfManager
   * */
  public static getInstance(): GlassNtfManager {
    if (!GlassNtfManager.instance) {
      log.showInfo(`getInstance new instance`);
      GlassNtfManager.instance = new GlassNtfManager();
    }
    return GlassNtfManager.instance;
  }

  /*
   * 注销消息管理类单实例
   * */
  public static destroyInstance(): void {
    log.showInfo('destroy Instance');
    GlassNtfManager.instance?.destroy();
    GlassNtfManager.instance = undefined;
  }

  /*
   * 初始化消息管理事件监听
   * */
  public init(): void {
    log.showInfo(`Ntf Manager init`);
    GlassNtfEventManager.getInstance().registerNtfEventCallBack(this.onNtfEvent);
  }

  /*
   * 注册消息变更事件监听
   *
   * @param callBack
   * */
  public registerNtfChangeCallBack(callBack: NtfChangeCallBack): void {
    const index = this.ntfChangeCallBacks.indexOf(callBack);
    if (index < 0) {
      log.showInfo('register NtfChange CallBack');
      this.ntfChangeCallBacks.push(callBack);
    }
  }

  /*
   * 注销消息变更事件监听
   *
   * @param callBack
   * */
  public unregisterNtfChangeCallBack(callBack: NtfChangeCallBack): void {
    const index = this.ntfChangeCallBacks.indexOf(callBack);
    if (index >= 0) {
      log.showInfo('unregister NtfChange CallBack');
      this.ntfChangeCallBacks.splice(index, 1);
    }
  }

  /*
   * 取消当前消息
   *
   * @param ntf
   * */
  public cancelNtf(ntf: NotificationEntry): void {
    log.showInfo(`cancelNtf, id: ${ntf.id}`);
    if (this.curNtf) {
      this.curNtf = null;
    }
  }


  /*
   * 判断当前消息是否为播控类型消息
   *
   * @param entry 新消息
   * @return boolean 是否为播控类型消息
   * */
  private isMediaPlaybackController(entry: NotificationEntry): boolean {
    if (!entry || entry.liveViewData === undefined) {
      return false;
    }
    let liveViewData: LiveViewData = entry.liveViewData;
    return liveViewData?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER;
  }

  /*
   * 检查并获取当前来电/通话消息
   * */
  public checkAndGetCallNtf(): void {
    call.getCallState()
      .then((state: call.CallState) => {
        if (state !== call.CallState.CALL_STATE_UNKNOWN && state !== call.CallState.CALL_STATE_IDLE) {
          log.showInfo(`checkAndGetCallNtf,callState is ${state}`);
          notificationManager.getAllActiveNotifications()
            .then((ntfList: notificationManager.NotificationRequest[]) => {
              let callNtfHashcode: string | undefined = undefined;
              const NO_NTF: number = 0;
              if (ntfList && ntfList.length > NO_NTF) {
                callNtfHashcode = ntfList.find((ntf) => ntf.creatorBundleName === GlassNtfConstant.PHONE_BUNDLE_NAME &&
                  ntf.content.systemLiveView?.typeCode === SysTypeCode.PHONE)?.hashCode;
              }
              if (callNtfHashcode) {
                let callNtf: NotificationEntry | undefined = ntfListener.getNtfEntry(callNtfHashcode);
                let event: NotificationEntryEvent = new NotificationEntryEvent();
                event.eventType = NotificationEntryEvent.EVENT_TYPE_POST_ADD;
                event.notificationList = [callNtf!];
                this.onNtfEvent(event);
                log.showInfo(`callNtfHashcode ${callNtfHashcode} is exist and post`);
              }
            })
            .catch((err: BusinessError) => {
              log.showError(`getAllActiveNotifications fail,error is ${err.code}`);
            })
        } else {
          log.showInfo(`CheckAndGetCallNtf,no call message exists now`);
        }
      })
      .catch((err: BusinessError) => {
        log.showError(`getCallState fail,error is ${err.code}`);
      })
  }
}
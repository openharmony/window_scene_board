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

import { Want } from '@kit.AbilityKit';
import { GlassSceneManager } from '../../scene/common/GlassSceneManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { SCBSceneInfo } from '@ohos/windowscene/src/main/ets/TsIndex';
import { EvtBus } from '@ohos/frameworkwrapper';
import { GlassCallEvent } from '../../common/event/CommonEvent';
import { LiveTimerData } from '@ohos/systemuicommon';
import { call } from '@kit.TelephonyKit';

const TAG: string = 'GlassPhoneCapsule';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export class SCBPhoneInfo {
  public bundleName = 'com.ohos.callui';
  public abilityName = 'com.ohos.callui.MainAbility';
  public typeName = 'phone';
  public moduleName = 'callui'
}

/**
 * 通话实况
 */
export default class GlassPhoneCapsule {
  public static instance: GlassPhoneCapsule | undefined = undefined;
  public phoneSceneInfo?: SCBSceneInfo;
  public phoneInfo: SCBPhoneInfo = new SCBPhoneInfo();
  public isAccept: boolean = false;
  public liveTimerData: LiveTimerData | undefined = undefined;
  public onCallingStatusChangeCallback?: ((isCalling: boolean) => void);
  private onCallEvent = (event: GlassCallEvent): void => {
    try {
      let callState: call.CallState = call.getCallStateSync();
      log.showInfo(`onCallEvent,callState is ${callState}`);
      this.liveTimerData = event.liveTimerData;
      if (callState === call.CallState.CALL_STATE_OFFHOOK) {
        this.isAccept = true;
      } else {
        this.isAccept = false;
      }
      this.onCallingStatusChangeCallback?.(this.isAccept);
    } catch (err) {
      log.showError(`onCallEvent,error is ${err.message}`);
    }
  }

  private registerPhoneCallEvent() {
    log.showInfo(`registerPhoneCallEvent`);
    EvtBus.on(GlassCallEvent, this.onCallEvent);
  }

  private unRegisterPhoneCallEvent() {
    log.showInfo(`unRegisterPhoneCallEvent`);
    EvtBus.off(GlassCallEvent, this.onCallEvent);
  }

  private initPhoneInfo() {
    let want: Want = {
      bundleName: this.phoneInfo.bundleName,
      abilityName: this.phoneInfo.abilityName,
      type: this.phoneInfo.typeName,
      flags: 0,
    };
    this.phoneSceneInfo =
      new SCBSceneInfo(this.phoneInfo.bundleName, this.phoneInfo.moduleName, this.phoneInfo.abilityName);
    this.phoneSceneInfo.screenId = GlassSceneManager.getInstance().getScreenId();
    this.phoneSceneInfo.want = want;
  }

  public constructor() {
    log.showInfo(`constructor`);
  }

  public registerCallingStatusChangeCallback(callback: ((isCalling: boolean) => void)): void {
    log.showInfo(`registerCallingStatusChangeCallback`);
    this.onCallingStatusChangeCallback = callback;
  }

  public static getInstance(): GlassPhoneCapsule {
    log.showInfo(`getInstance,is need to create ${!GlassPhoneCapsule.instance}`);
    if (!GlassPhoneCapsule.instance) {
      GlassPhoneCapsule.instance = new GlassPhoneCapsule();
    }
    return GlassPhoneCapsule.instance;
  }

  /*
   * 重置单实例内属性
   * */
  public release(): void {
    log.showInfo(`release`);
    this.phoneSceneInfo = undefined;
    this.liveTimerData = undefined;
    this.onCallingStatusChangeCallback = undefined;
    this.isAccept = false;
    this.unRegisterPhoneCallEvent();
  }

  /*
   * 销毁单实例
   * */
  public static destroy(): void {
    log.showInfo(`destroy`);
    GlassPhoneCapsule.instance?.release();
    GlassPhoneCapsule.instance = undefined;
  }

  /*
   * 初始化
   * */
  public init(): void {
    log.showInfo(`init`);
    this.registerPhoneCallEvent();
    this.initPhoneInfo();
  }
}
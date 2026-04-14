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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import lazy { SCBScreenSession, SCBScreenSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { threadCall, ThreadCallCommRegisterIntf, ThreadCallType } from '../messageChannel/ThreadCall';
import lazy { ENABLE_FORCE_CLOSE_HDR } from '../template/common/SCBVisualEffectOption';

const TAG = 'ScreenSessionAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


interface BeforeScreenPropertyChangeCallbacksIntf extends ThreadCallCommRegisterIntf {
  screenId: number;
}

interface ScreenPropertyChangeCallbacksIntf extends ThreadCallCommRegisterIntf {
  screenId: number;
  isRotatable: boolean;
  persistentId: number | null;
}

interface ScreenRotateChangeCallbacksIntf extends ThreadCallCommRegisterIntf {
  mainScreenId: number;
}

export class ScreenSessionAdapter {
  @threadCall()
  public static setForceCloseHdr(isForceCloseHdr: boolean): void {
    log.showInfo(`setForceCloseHdr isForceCloseHdr ${isForceCloseHdr} `)
    if (ENABLE_FORCE_CLOSE_HDR) {
      SCBScreenSessionManager.getInstance().setForceCloseHdr(isForceCloseHdr);
    }
  }

  @threadCall()
  public static isFoldablePhoneExpandStatus(): boolean | Promise<boolean> {
    log.showInfo(`isFoldablePhoneExpandStatus`)
    return SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  }

  @threadCall(ThreadCallType.Sync)
  public static isFoldablePhoneExpandStatusSync(): boolean {
    log.showInfo(`isFoldablePhoneExpandStatusSync`);
    return SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  }

  @threadCall(ThreadCallType.Register)
  public static registerBeforeScreenPropertyChangeCallbacks(obj: BeforeScreenPropertyChangeCallbacksIntf, tag: string): void {
    log.showInfo(`registerBeforeScreenPropertyChangeCallbacks tag ${tag}`)
    SCBScreenSessionManager.getInstance()
      .registerBeforeScreenPropertyChangeCallbacks(obj.callback, obj.screenId);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterBeforeScreenPropertyChangeCallbacks(obj: BeforeScreenPropertyChangeCallbacksIntf, tag: string): void {
    log.showInfo(`unRegisterBeforeScreenPropertyChangeCallbacks tag ${tag}`)
    SCBScreenSessionManager.getInstance()
      .unRegisterBeforeScreenPropertyChangeCallbacks(obj.callback, obj.screenId);
  }

  @threadCall()
  public static getMainScreenSessionScreenId(): number {
    let screenId: number = 0;
    if (SCBScreenSessionManager.getInstance().getMainScreenSession()?.session) {
      screenId = SCBScreenSessionManager.getInstance().getMainScreenSession().session.screenId;
    }
    return screenId;
  }

  @threadCall()
  public static getScreenOrientationLocked(): boolean | Promise<boolean> {
    log.showInfo(`getScreenOrientationLocked`);
    return SCBScreenSessionManager.getInstance().getScreenOrientationLocked();
  }

  @threadCall()
  public static setIsRestoreRotation(status : boolean) {
    log.showInfo(`setIsRestoreRotation`);
    SCBScreenSessionManager.getInstance().setIsRestoreRotation(status);
  }

  @threadCall()
  public static setScreenOrientationLocked(status : boolean): void  {
    log.showInfo(`tracelog SCBScreenSessionManagerApiUtil setScreenOrientationLocked`);
    SCBScreenSessionManager.getInstance().setScreenOrientationLocked(status);
  }

  @threadCall(ThreadCallType.Sync)
  public static getSCBScreenProperty(): SCBScreenProperty {
    log.showInfo(`getSCBScreenProperty`);
    return SCBScreenSessionManager.getInstance().getMainScreenSession()?.scbScreenProperty;
  }

  @threadCall()
  public static isSecondaryFoldablePhoneExpandStatus() {
    log.showInfo(`tracelog SCBScreenSessionManagerApiUtil isSecondaryFoldablePhoneExpandStatus`);
    return SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus();
  }

  @threadCall(ThreadCallType.Register)
  public static registerScreenPropertyChangeCallbacks(obj: ScreenPropertyChangeCallbacksIntf, tag: string): void {
    log.showInfo(`registerScreenPropertyChangeCallbacks tag ${tag}`);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(obj.callback, obj.screenId, obj.isRotatable, obj.persistentId);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterScreenPropertyChangeCallbacks(obj: ScreenPropertyChangeCallbacksIntf, tag: string): void {
    log.showInfo(`unRegisterScreenPropertyChangeCallbacks tag ${tag}`)
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(obj.callback, obj.screenId, obj.isRotatable, obj.persistentId);
  }

  @threadCall(ThreadCallType.Register)
  public static registerScreenRotateChangeCallbacks(obj: ScreenRotateChangeCallbacksIntf, tag: string): void {
    log.showInfo(`registerScreenRotateChangeCallbacks tag ${tag}`);
    SCBScreenSessionManager.getInstance()
      .registerScreenRotateChangeCallbacks(obj.callback, obj.mainScreenId);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterScreenRotateChangeCallbacks(obj: ScreenRotateChangeCallbacksIntf, tag: string): void {
    log.showInfo(`unRegisterScreenRotateChangeCallbacks tag ${tag}`)
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenRotateChangeCallbacks(obj.callback, obj.mainScreenId);
  }
}
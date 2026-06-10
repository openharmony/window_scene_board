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
import wantAgent from '@ohos.app.ability.wantAgent';
import { Want } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LogWithHa, SystemuiConstants } from '@ohos/systemuicommon';
import { WantAgentUtil } from '@ohos/systemuicommon/newTsIndex';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';

const TAG = 'InvokePushAgentParam';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * systemUI拉起pushservice参数包装类
 */
export class InvokePushAgentParam {
  private pushWantInfo: wantAgent.WantAgentInfo | undefined;

  private startResult: number;

  private code: number;

  private message: string;

  constructor(pushWantInfo: wantAgent.WantAgentInfo | undefined, startResult: number, code: number, message: string) {
    this.pushWantInfo = pushWantInfo;
    this.startResult = startResult;
    this.code = code;
    this.message = message;
  }


  public setPushWantInfo(pushWantInfo: wantAgent.WantAgentInfo): void {
    this.pushWantInfo = pushWantInfo;
  }

  public getPushWantInfo(): wantAgent.WantAgentInfo | undefined {
    return this.pushWantInfo;
  }


  public setStartResult(startResult: number): void {
    this.startResult = startResult;
  }

  public getStartResult(): number {
    return this.startResult;
  }


  public setCode(code: number): void {
    this.code = code;
  }

  public getCode(): number {
    return this.code;
  }


  public setMessage(message: string): void {
    this.message = message;
  }

  public getMessage(): string {
    return this.message;
  }

  /**
   * get WantAgentInfo of want from push
   * @param want
   * @returns WantAgentInfo
   */
  public static getPushWantAgentInfo(want: Want): wantAgent.WantAgentInfo | undefined {
    if (!want) {
      log.showWarn('want is null when getPushWantAgentInfo');
      return undefined;
    }
    if (!want.parameters) {
      log.showWarn('want.parameters is null when getPushWantAgentInfo');
      return undefined;
    }
    // get wantInfo from push notification
    return want.parameters[SystemuiConstants.KEY_PUSH_WANT_AGENT_INFO] as wantAgent.WantAgentInfo;
  }

  /**
   * systemUI拉起三方应用时，移除掉want中parameters.push_wantAgentInfo参数
   * @param want
   */
  public static removePushWantAgentForInvokeThdApp(want: Want): void {
    if (!want) {
      log.showWarn('want is null when removePushWantAgentForInvokeThdApp');
      return;
    }
    if (!want.parameters) {
      log.showWarn('want.parameters is null when removePushWantAgentForInvokeThdApp');
      return;
    }
    let pushWantInfo = want.parameters[SystemuiConstants.KEY_PUSH_WANT_AGENT_INFO] as wantAgent.WantAgentInfo;
    if (pushWantInfo) {
      want.parameters[SystemuiConstants.KEY_PUSH_WANT_AGENT_INFO] = {} as wantAgent.WantAgentInfo;
    }
  }

  /**
   * invoke push service
   *
   * @param pushWantInfo pushWantInfo
   * @param startResult result for invoking app
   * @returns
   */
  public static async startPushAgent(invokePushAgentParam : InvokePushAgentParam): Promise<void> {
    if (!invokePushAgentParam) {
      log.warn('invokePushAgentParam is null when startPushAgent');
      return;
    }
    if (!invokePushAgentParam.getPushWantInfo()) {
      log.warn('invokePushAgentParam.getPushWantInfo() is null when startPushAgent');
      return;
    }
    let pushWantInfo = invokePushAgentParam.getPushWantInfo();
    try {
      if (!pushWantInfo?.wants || !pushWantInfo.wants[0]) {
        log.warn('want is null when startPushAgent');
        return;
      }
      let want = pushWantInfo.wants[0];
      if (want.bundleName !== SystemuiConstants.PUSH_BUNDLE_NAME) {
        log.warn(`reject to startPushAgent, bundleName is :${pushWantInfo.wants[0].bundleName}`);
        return;
      }

      if (want.parameters) {
        want.parameters[SystemuiConstants.KEY_START_APP_RESULT] = invokePushAgentParam.getStartResult();
        want.parameters[SystemuiConstants.KEY_INVOKE_PUSH_WANT_PARAMETERS_ERROR_CODE] = invokePushAgentParam.getCode();
        want.parameters[SystemuiConstants.KEY_INVOKE_PUSH_WANT_PARAMETERS_DESC] = invokePushAgentParam.getMessage();
      }
      const pushWantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [
          want
        ],
        actionType: pushWantInfo.actionType,
        actionFlags: pushWantInfo.actionFlags,
        requestCode: pushWantInfo.requestCode
      };
      const pushWantAgentWithStartResult = await wantAgent.getWantAgent(pushWantAgentInfo);
      await WantAgentUtil.triggerAsync(pushWantAgentWithStartResult, {
        code: SystemuiConstants.INVOKE_APP_SUCCESS,
      });
      wantAgent.cancel(pushWantAgentWithStartResult, () => {
        log.showInfo('cancel wantAgent complete in startPushAgent');
      });
      log.showInfo('startPushAgent complete');
    } catch (error) {
      LogWithHa.error(log, `startPushAgent trigger error: ${error}`,
        NotificationExceptionCode.START_PUSH_AGENT_FAIL, error);
    }
  }
}
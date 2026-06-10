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

import type { NotificationBase } from '../model/NotificationBase';
import { NotificationWantAgentInfo } from '../model/NotificationAppInfo';
import { Want, wantAgent, WantAgent } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SystemuiConstants } from '../constants/SystemuiConstants';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../maintenance/CommonExceptionCode';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  ClickMaintenanceInfo,
  ClickNotificationErrorCode,
  ClickNotificationMaintenance,
} from '../maintenance/ClickNotificationMaintenance';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'WantAgentUtil');

/**
 * 拉起应用失败，返回push的code
 */
const TRIGGER_WANTAGENT_FAIL = 2003;

export class WantAgentUtil {
  /**
   * 解析通知跳转信息
   * @returns
   */
  public static async parseWantAgentInfo(agent: WantAgent | undefined): Promise<NotificationWantAgentInfo | undefined> {
    try {
      if (!agent) {
        log.showInfo(`Invalid wantAgent object`);
        return undefined;
      }

      const result = await Promise.all([
        wantAgent.getBundleName(agent),
        wantAgent.getOperationType(agent),
        wantAgent.getWant(agent)
      ]);

      const bundleName = result[0];
      const operationType = result[1];
      const want = result[2];

      const wantAgentInfo: NotificationWantAgentInfo = {
        want,
        operationType,
        bundleName: WantAgentUtil.parseBundleName(operationType, want, bundleName)
      };

      log.showInfo('ParseWantAgentInfo: bundleNameInWant: %{public}s, bundleName: %{public}s, ' +
        'operationType: %{public}d', want?.bundleName, bundleName, operationType);

      return wantAgentInfo;
    } catch (e) {
      log.error('Parse wantAgentInfo failed:', e);
      return undefined;
    }
  }

  private static parseBundleName(operationType: number, want?: Want, bundleName?: string): string {
    const startBundleName = want?.parameters?.startBundleName as string;
    if (operationType === wantAgent.OperationType.SEND_COMMON_EVENT) {
      return startBundleName ?? '';
    }
    return want?.bundleName ?? bundleName ?? '';
  }

  /**
   * 拉起远程WantAgent
   *
   * @param agent
   * @param triggerInfo 拉起携带的信息
   */
  public static async startWantAgent(agent: WantAgent, triggerInfo?: wantAgent.TriggerInfo): Promise<boolean> {
    log.showInfo('StartWantAgent begin');
    const pushWantInfo = await WantAgentUtil.getPushWantInfo(agent);
    return new Promise(async (resolve) => {
      try {
        await WantAgentUtil.triggerAsync(agent, triggerInfo ?? { code: 0 }, true);
        WantAgentUtil.callBackPush(pushWantInfo);
        log.showInfo('StartWantAgent complete');
        resolve(true);
      } catch (error) {
        WantAgentUtil.callBackPush(pushWantInfo, error);
        log.error('StartWantAgent error:', error);
        resolve(false);
      }
    });
  }

  private static async callBackPush(pushWantInfo?: wantAgent.WantAgentInfo, error?: Error): Promise<void> {
    if (!pushWantInfo) {
      log.showInfo('push want is null, no need call back push');
      return;
    }
    if (error) {
      await WantAgentUtil.startPushAgent(pushWantInfo, SystemuiConstants.INVOKE_APP_FAIL,
        TRIGGER_WANTAGENT_FAIL, 'startWantAgent create error:' + error);
    } else {
      await WantAgentUtil.startPushAgent(pushWantInfo, SystemuiConstants.INVOKE_APP_SUCCESS,
        SystemuiConstants.INVOKE_APP_SUCCESS, '');
    }
  }

  /**
   * invoke push service
   *
   * @param pushWantInfo pushWantInfo
   * @param startResult result for invoking app
   * @returns
   */
  private static async startPushAgent(pushWantInfo: wantAgent.WantAgentInfo, startResult: number, code: number,
    message: string): Promise<void> {
    try {
      if (!pushWantInfo.wants || !pushWantInfo.wants[0]) {
        log.showWarn('want is null when startPushAgent');
        return;
      }
      const want = pushWantInfo.wants[0];
      if (want.bundleName !== SystemuiConstants.PUSH_BUNDLE_NAME) {
        log.showWarn(`reject to startPushAgent, bundleName is :${pushWantInfo.wants[0].bundleName}`);
        return;
      }

      if (want.parameters) {
        want.parameters[SystemuiConstants.KEY_START_APP_RESULT] = startResult;
        want.parameters[SystemuiConstants.KEY_INVOKE_PUSH_WANT_PARAMETERS_ERROR_CODE] = code;
        want.parameters[SystemuiConstants.KEY_INVOKE_PUSH_WANT_PARAMETERS_DESC] = message;
      }
      const pushWantAgentWithStartResult = await wantAgent.getWantAgent({
        wants: [
          want
        ],
        actionType: pushWantInfo.actionType,
        actionFlags: pushWantInfo.actionFlags,
        requestCode: pushWantInfo.requestCode
      });
      await WantAgentUtil.triggerAsync(pushWantAgentWithStartResult, {
        code: SystemuiConstants.INVOKE_APP_SUCCESS,
      });
      wantAgent.cancel(pushWantAgentWithStartResult, () => {
        log.showInfo('cancel wantAgent complete in startPushAgent');
      });
      log.showInfo('startPushAgent complete');
    } catch (error) {
      LogWithHa.error(log, `startPushAgent trigger error: ${error}`,
        CommonExceptionCode.START_PUSH_AGENT_FAIL, error);
    }
  }

  /**
   * 获取Push的Want信息并进行安全处理
   * 拉起三方应用之前，先移除掉pushWantAgentInfo，避免将push信息暴露给三方应用
   *
   * @param agent
   * @returns
   */
  private static async getPushWantInfo(agent: WantAgent): Promise<wantAgent.WantAgentInfo | undefined> {
    try {
      const want = await wantAgent.getWant(agent);
      if (!want || !want.parameters) {
        log.warn('want or want.parameters is null when getPushWantAgentInfo');
        return undefined;
      }
      const pushWantInfo = want.parameters[SystemuiConstants.KEY_PUSH_WANT_AGENT_INFO] as wantAgent.WantAgentInfo;
      want.parameters[SystemuiConstants.KEY_PUSH_WANT_AGENT_INFO] = '';
      return pushWantInfo;
    } catch (error) {
      log.showError('GetPushWantInfoWithSecurityHandle error by [%{public}d] [%{public}s]', error.code, error.message);
      return undefined;
    }
  }

  /**
   * 获取卡片会拉起的应用名
   * 1. 如果是push的消息，取creatorBundleName
   * 2. 如果want里有数据，取want里的数据
   * 3. 取wantAgent的数据
   * @returns
   */
  public static getLauncherBundleName(ntf: NotificationBase, agentInfo?: NotificationWantAgentInfo): string {
    let bundleName = '';
    if (agentInfo?.operationType === wantAgent.OperationType.SEND_COMMON_EVENT && agentInfo.bundleName) {
      bundleName = agentInfo.bundleName;
      log.showInfo('GetLauncherTargetBundleName for %{public}s is %{public}s by commonEvent', ntf.hashCode, bundleName);
    } else if (ntf.isFromPush && ntf.creatorBundleName) {
      bundleName = ntf.creatorBundleName;
      log.showInfo('GetLauncherTargetBundleName for %{public}s is %{public}s by creator', ntf.hashCode, bundleName);
    } else if (agentInfo?.want?.bundleName) {
      bundleName = agentInfo?.want?.bundleName;
      log.showInfo('GetLauncherTargetBundleName for %{public}s is %{public}s by want', ntf.hashCode, bundleName);
    } else {
      bundleName = agentInfo?.bundleName;
      log.showInfo('GetLauncherTargetBundleName for %{public}s is %{public}s by aAgent', ntf.hashCode, bundleName);
    }

    return bundleName;
  }

  /**
   * 判断agentInfo是否是拉起应用（支持commonEvent拉起应用的识别）
   * @param agentInfo agentInfo
   * @returns 若是拉起应用，则返回true，否则返回false
   */
  public static isStartApp(agentInfo: NotificationWantAgentInfo): boolean {
    if (agentInfo.operationType === wantAgent.OperationType.SEND_COMMON_EVENT) {
      if (agentInfo.bundleName) {
        log.showInfo('isStartApp is true by SEND_COMMON_EVENT for %{public}s', agentInfo.bundleName);
        return true;
      } else {
        log.showInfo('isStartApp is false by SEND_COMMON_EVENT for %{public}s.', agentInfo.bundleName);
        return false;
      }
    } else {
      const ret = agentInfo.operationType !== wantAgent.OperationType.UNKNOWN_TYPE;
      log.showInfo('isStartApp is %{public}s, operationType: %{public}d', ret, agentInfo.operationType);
      return ret;
    }
  }

  /**
   * 检查是否为拉起Service
   * @param operationType 操作类型
   */
  public static isStartService(operationType: number | undefined): boolean {
    return operationType === wantAgent.OperationType.START_SERVICE;
  }

  public static async triggerAsync(agent: WantAgent, triggerInfo: wantAgent.TriggerInfo,
    isReportClick: boolean = false): Promise<void> {
    const maintenanceInfo: ClickMaintenanceInfo = ClickNotificationMaintenance.getInfo();
    try {
      log.showInfo('triggerAsync start');
      const context = GlobalContext.getContext();
      // @ts-ignore
      await wantAgent.triggerAsync(agent, triggerInfo, context);
      if (isReportClick) {
        ClickNotificationMaintenance.reportClick(undefined, maintenanceInfo);
      }
      log.showInfo('triggerAsync complete');
    } catch (err) {
      log.error('triggerAsync error:', err);
      if (isReportClick) {
        ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL, maintenanceInfo);
      }
      throw err;
    }
  }
}
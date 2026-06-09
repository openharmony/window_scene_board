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

import Ntf from '@ohos.notificationSubscribe';
import NtfManger from '@ohos.notificationManager';
import CommonEventManager from '@ohos.commonEventManager';
import PromptAction from '@ohos.promptAction';
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';
import {
  CommonUtils,
  SingletonHelper,
  LogDomain,
  LogHelper, Trace,
} from '@ohos/basicutils';
import { ExtAppConstants } from '@ohos/commonconstants';
import { sEventManager, obtainLocalEvent } from '@ohos/frameworkwrapper';
import { StartAbilityUtil, ResUtils, SCBSceneMode } from '@ohos/windowscene';
import { NotificationEntry } from '../model/NotificationEntry';
import { NotificationSysEventReporter, SystemuiConstants, SysTypeCode } from '@ohos/systemuicommon';
import { Callback } from '@kit.BasicServicesKit';
import { ntfListener } from './NotificationListener';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import {
  ClickMaintenanceInfo,
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import Want from '@ohos.app.ability.Want';
import { InvokePushAgentParam } from './InvokePushAgentParam';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { GlobalContext, DeviceHelper } from '@ohos/frameworkwrapper';
import ohosWantAgent from '@ohos.wantAgent';
import { image } from '@kit.ImageKit';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { NotificationDataManager, NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
// import { serviceNotification } from '@kit.PushKit';
import { WantAgentUtil } from '@ohos/systemuicommon/src/main/ets/utils/WantAgentUtil';
import { MetaServiceConnect } from '@ohos/systemuicommon/src/main/ets/manager/MetaServiceConnect';

const TAG = 'SysUI_NotificationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const EVENT_BROADCASTING_CENTER_REMOVE = 'event.broadcast.center.notification.remove';
const MID_SCENE_NOTIFICATION = 'midSceneNotification';
const KEY_NOT_FOUND_ERROR_CODE = 14700101;

/**
 * 通知API管理
 *
 * @since 2022-12-06
 */
export class NotificationManager {
  /**
   * 获取Push的Want信息并进行安全处理
   * 拉起三方应用之前，先移除掉pushWantAgentInfo，避免将push信息暴露给三方应用
   *
   * @param agent
   * @returns
   */
  private async getPushWantInfoWithSecurityHandle(agent: WantAgent): Promise<wantAgent.WantAgentInfo | undefined> {
    try {
      const want = await wantAgent.getWant(agent);
      const pushWantInfo = this.getPushWantAgentInfo(want);
      this.removePushWantAgentForInvokeThdApp(want);
      return pushWantInfo;
    } catch (error) {
      log.showError('GetPushWantInfoWithSecurityHandle error by [%{public}d] [%{public}s]', error.code, error.message);
      return undefined;
    }
  }

  /**
   * 拉起远程WantAgent
   *
   * @param agent 远程agent
   * @param inputKey 输入action键值
   * @param inputContent 输入action内容
   */
  async startWantAgent(agent: WantAgent, callback?: Callback<number>, inputKey?: string,
    inputContent?: string, ntfEntry?: NotificationEntry): Promise<void> {
    log.showInfo(`enter startWantAgent`);
    const pushWantInfo = await this.getPushWantInfoWithSecurityHandle(agent);

    try {
      await WantAgentUtil.triggerAsync(agent, {
        code: 0,
        extraInfos: {
          key: inputKey,
          data: inputContent,
          'ohos.params.launchReasonMessage': SystemuiConstants.NC_LAUNCH_REASON_MESSAGE,
        },
      }, true);
      this.invokeCallback(callback);
      this.startPushAgent(new InvokePushAgentParam(pushWantInfo, SystemuiConstants.INVOKE_APP_SUCCESS,
        SystemuiConstants.INVOKE_APP_SUCCESS, ''));
      log.showInfo('startWantAgent has start want complete');
    } catch (error) {
      this.invokeCallback(callback);
      this.startPushAgent(new InvokePushAgentParam(pushWantInfo, SystemuiConstants.INVOKE_APP_FAIL,
        ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL, 'startWantAgent create error:' + error));
      log.error('trigger error', error);
    }
  }

  /**
   * invoke push service
   *
   * @param pushWantInfo pushWantInfo
   * @param startResult result for invoking app
   * @returns
   */
  async startPushAgent(invokePushAgentParam : InvokePushAgentParam): Promise<void> {
    if (!invokePushAgentParam) {
      log.warn('invokePushAgentParam is null when startPushAgent');
      return;
    }
    if (!invokePushAgentParam.getPushWantInfo()) {
      log.warn('invokePushAgentParam.getPushWantInfo() is null when startPushAgent');
      return;
    }
    let pushWantInfo: wantAgent.WantAgentInfo | undefined = invokePushAgentParam.getPushWantInfo();
    try {
      if (!pushWantInfo?.wants || !pushWantInfo?.wants[0]) {
        log.warn('want is null when startPushAgent');
        return;
      }
      let want = pushWantInfo?.wants[0];
      if (want.bundleName !== SystemuiConstants.PUSH_BUNDLE_NAME) {
        log.warn(`reject to startPushAgent, bundleName is :${pushWantInfo?.wants[0].bundleName}`);
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

  async startMidSceneAgent(entry: NotificationEntry, callback?: Callback<number>): Promise<void> {
    log.showInfo(`enter startMidSceneWantAgent`);
    if (entry.wantAgentInfo?.want?.parameters) {
      entry.wantAgentInfo.want.parameters[MID_SCENE_NOTIFICATION] = true;
    }
    const maintenanceInfo: ClickMaintenanceInfo | undefined = ClickNotificationMaintenance.getInfo();
    const pushWantInfo = await this.getPushWantInfoWithSecurityHandle(entry.wantAgent!);
    let agent: WantAgent | undefined = entry.wantAgent;
    try {
      await WantAgentUtil.triggerAsync(agent, {
        code: 0,
        want: entry.wantAgentInfo!.want,
        extraInfos: { 'ohos.params.launchReasonMessage': SystemuiConstants.NC_LAUNCH_REASON_MESSAGE },
      }, true);
      this.invokeCallback(callback);
      this.startPushAgent(new InvokePushAgentParam(pushWantInfo, SystemuiConstants.INVOKE_APP_SUCCESS,
        SystemuiConstants.INVOKE_APP_SUCCESS, ''));
      log.showInfo('startMidSceneAgent has start want complete');
    } catch (error) {
      this.invokeCallback(callback);
      this.startPushAgent(new InvokePushAgentParam(pushWantInfo, SystemuiConstants.INVOKE_APP_FAIL,
        ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL, 'startMidSceneAgent trigger error:' + error));
      log.error('trigger error', error);
    }
  }

  /**
   * 点击移除通知
   *
   * @param entry 通知
   */
  removeNotificationByClick(entry: NotificationEntry): void {
    const hashCode = entry?.hashCode;
    log.showInfo(`removeNotificationByClick: ${hashCode}`);
    const deleteInfo = DeleteNotificationMaintenance.getDeleteInfo([entry]);
    try {
      Ntf.remove(hashCode, Ntf.RemoveReason.CLICK_REASON_REMOVE).then(() => {
        log.showInfo(`removeNotificationByClick has remove: ${hashCode}`);
      }).catch((err: object) => {
        DeleteNotificationMaintenance.manualDelete([entry], deleteInfo,
          DeleteNotificationErrorCode.NTF_CANCEL_FAIL);
        log.error(`removeNotificationByClick:${hashCode} fail:`, err);
      });
    } catch (error) {
      DeleteNotificationMaintenance.manualDelete([entry], deleteInfo,
        DeleteNotificationErrorCode.NTF_CANCEL_FAIL);
      log.error('removeNotificationByClick error', error);
    }
    this.sendBatchNtfRemoveEvent([entry]);
  }

  /**
   * 删除按钮移除通知
   *
   * @param entry 通知
   */
  removeNotificationByCancel(entry: NotificationEntry): void {
    const hashCode = entry?.hashCode;
    const deleteInfo = DeleteNotificationMaintenance.getDeleteInfo([entry]);
    log.showInfo(`removeNotificationByCancel: ${hashCode}`);
    if (hashCode === undefined || hashCode === null) {
      log.showWarn(`removeNotificationByCancel hashCode is invalid: ${hashCode}`);
      DeleteNotificationMaintenance.manualDelete([entry], deleteInfo,
        DeleteNotificationErrorCode.NTF_HASHCODE_INVALID_FAIL);
      return;
    }

    // 发送通知删除事件
    this.sendNotificationRemoveEvent(entry);

    Ntf.remove(hashCode, Ntf.RemoveReason.CANCEL_REASON_REMOVE).then(() => {
      log.showInfo(`removeNotificationByCancel has remove: ${hashCode}`);
    }).catch((err: Object) => {
      DeleteNotificationMaintenance.manualDelete([entry], deleteInfo, DeleteNotificationErrorCode.NTF_CANCEL_FAIL);
      log.error(`removeNotificationByCancel:${hashCode} fail:`, err);
    });
    this.sendBatchNtfRemoveEvent([entry]);
  }

  /**
   * 批量删除通知
   *
   * @param entrys 待删除的通知列表
   * @param reason 删除理由
   */
  batchRemoveNtf(entrys: Array<NotificationEntry>,
    reason: Ntf.RemoveReason = Ntf.RemoveReason.CANCEL_REASON_REMOVE): void {
    let hashCodes = entrys?.map((ntf) => ntf?.hashCode);
    const deleteInfo = DeleteNotificationMaintenance.getDeleteInfo(entrys);
    if (!Array.isArray(hashCodes) || hashCodes.length === 0) {
      DeleteNotificationMaintenance.manualDelete(entrys, deleteInfo,
        DeleteNotificationErrorCode.NTF_HASHCODE_INVALID_FAIL);
      log.showError('batchRemoveNtf not start, invalid array');
      return;
    }
    log.showInfo(`batchRemoveNtf start, length: ${hashCodes.length}, reason: ${reason}`);

    // 发送通知删除事件
    entrys.forEach(entry => {
      this.sendNotificationRemoveEvent(entry);
    });

    try {
      Ntf.remove(hashCodes, reason).then(() => {
        log.showInfo('batchRemoveNtf remove succeed');
      }).catch((err: Object) => {
        DeleteNotificationMaintenance.manualDelete(entrys, deleteInfo, DeleteNotificationErrorCode.NTF_CANCEL_FAIL);
        log.error('batchRemoveNtf remove fail', err);
      });
    } catch (error) {
      DeleteNotificationMaintenance.manualDelete(entrys, deleteInfo, DeleteNotificationErrorCode.NTF_CANCEL_FAIL);
      log.error('batchRemoveNtf remove error', error);
    }
    this.sendBatchNtfRemoveEvent(entrys);
  }

  /**
   * 点击移除通知
   *
   * @param entry 通知数据
   */
  removeNtfEntryByClick(entry: NotificationEntry): void {
    if (CommonUtils.isInvalid(entry)) {
      return;
    }
    // 组通知全部删除
    if (entry.isGroup) {
      this.batchRemoveNtf(entry.childrenEntry!, Ntf.RemoveReason.CLICK_REASON_REMOVE);
      return;
    }

    this.sendNotificationRemoveEvent(entry);
    // 删除单通知
    this.removeNotificationByClick(entry);
  }

  /**
   * 删除按钮移除通知
   *
   * @param entry 通知数据
   */
  removeNtfEntryByCancel(entry: NotificationEntry): void {
    if (CommonUtils.isInvalid(entry)) {
      return;
    }
    // 组通知全部删除
    if (entry.isGroup) {
      this.batchRemoveNtf(entry.childrenEntry!);
      return;
    }
    // 删除单通知
    this.removeNotificationByCancel(entry);
  }

  /**
   * 跳转日历首页
   */
  startCalendarMainAbility(): void {
    let date = new Date();
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_CALENDAR,
      abilityName: ExtAppConstants.ABILITY_CALENDAR,
      moduleName: ExtAppConstants.MODULE_CALENDAR,
      parameters: {
        action: 'CLICK_MONTH_FORM_HEADER',
        tabIndex: '1',
        year: date.getFullYear(),
        month: date.getMonth(),
        day: date.getDate()
      }
    });
  }

  /**
   * 跳转时钟首页
   */
  startClockMainAbility(): void {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_CLOCK,
      abilityName: ExtAppConstants.ABILITY_CLOCK,
      moduleName: ExtAppConstants.MODULE_CLOCK,
      parameters: {
        action: 'CLICK_TIME_FORM_HEADER',
        tabActive: 'ALARM_CLOCK_TAB'
      }
    });
  }

  /**
   * 跳转通知管理首页
   */
  startNtfMgrMainAbility(): void {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_PC_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
      moduleName: ExtAppConstants.MODULE_PHONE_SETTINGS_SOUND,
      uri: 'systemui_notification_settings',
    });
  }

  /**
   * Pc跳转通知管理首页
   */
  startPcNtfMgrMainAbility(): void {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_PC_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
      moduleName: ExtAppConstants.MODULE_PHONE_SETTINGS_SOUND,
      uri: 'systemui_notification_settings',
    });
  }

  /**
   * 跳转对应应用通知管理页面
   *
   * @param itemBundle 应用包名
   */
  startNtfMgrItemAbility(itemBundle: string, moduleName?: string, appIndex?: number,
    uri: string = 'systemui_notification_settings', uid?: number): void {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
      moduleName: moduleName,
      uri: uri,
      parameters: {
        pushParams: {
          config: {bundleName: itemBundle, isFromNc: true, appIndex: appIndex, uid: uid}
        }
      }
    });
  }

  /**
   * 跳转元服务通知管理详情页面
   *
   * @param itemBundle 服务名
   * @param appIndex 分身
   */
  startMetaServiceItemAbility(itemBundle: string, appIndex?: number, uid?: number): void {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
      moduleName: ExtAppConstants.MODULE_PHONE_SETTINGS_SOUND,
      uri: 'systemui_notification_settings',
      parameters: {
        pushParams: {
          config: { bundleName: itemBundle, isFromNc: true, appIndex, uid, isMetaService: true },
        }
      }
    });
  }

  /**
   * 应用级别的通知开关
   *
   * @param bundleName 应用包名
   * @param uid 应用uid
   * @param enable 是否开启
   */
  enablePkgNotification(bundleName: string, uid: number, enable: boolean): void {
    const maintenanceInfo: ClickMaintenanceInfo | undefined = ClickNotificationMaintenance.getInfo();
    NtfManger.setNotificationEnable({
      bundle: bundleName,
      uid: uid
    }, enable).then(() => {
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.SET_NTF_ENABLE_SUCC, maintenanceInfo);
      log.showInfo(`enablePkgNotification bundleName: ${bundleName}, ${enable}`);
    }).catch((e: Object) => {
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.SET_NTF_ENABLE_FAIL, maintenanceInfo);
      log.error('setNotificationEnable fail' + e + 'bundleName: ' + bundleName);
    });
  }

  /**
   * 设置应用实况窗开关
   *
   * @param bundleName 应用包名
   * @param uid 应用uid
   * @param enable 是否开启
   */
  async setLiveViewEnable(bundleName: string, uid: number, enable: boolean): Promise<void> {
    const maintenanceInfo: ClickMaintenanceInfo | undefined = ClickNotificationMaintenance.getInfo();
    try {
      log.showInfo(`Set live view enable begin: ${bundleName}, ${uid}, ${enable}`);
      await NtfManger.setNotificationEnableSlot({
        bundle: bundleName,
        uid: uid
      }, NtfManger.SlotType.LIVE_VIEW, enable, true);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.LIVE_VIEW_DISABLE, maintenanceInfo);
      log.showInfo(`Set live view enable success: ${bundleName}, ${uid}, ${enable}`);
    } catch (e) {
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.SET_LIVE_VIEW_FAIL, maintenanceInfo);
      log.error(`Set live view enable failed: ${bundleName}, ${uid}, ${enable}, error:`, e);
    }
  }

  /**
   * 设置元服务通知开关
   *
   * @param bundleName 应用包名
   * @param uid 应用uid
   * @param enable 是否开启
   */
  async setMetaServiceNotificationEnable(bundleName: string, uid: number, enable: boolean): Promise<void> {
    try {
      log.showInfo(`set meta service notification enable begin: ${bundleName}, ${uid}, ${enable}`);
      await NtfManger.setNotificationEnable({ bundle: bundleName, uid }, enable);
      // await serviceNotification.setSubscribeNotificationSetting(bundleName, { bundleName, enable });
      log.showInfo(`set meta service notification enable success: ${bundleName}, ${uid}, ${enable}`);
    } catch (err) {
      log.error(`set meta service notification enable failed: ${bundleName}`, err);
    }
  }

  /**
   * 设置未安装元服务实况开关
   *
   * @param bundleName 应用包名
   * @param uid 应用uid
   * @param enable 是否开启
   */
  async setUnstallMetaServiceLiveEnable(bundleName: string, uid: number, enable: boolean): Promise<void> {
    await MetaServiceConnect.instance.collectMetaSerciveLiveChange('', bundleName)
  }

  /**
   * 当前应用通知开关是否开启
   *
   * @param bundleName 应用包名
   * @param uid 应用uid
   * @return true 开启
   */
  async isPkgNtfEnable(bundleName: string, uid: number): Promise<boolean> {
    return NtfManger.isNotificationEnabled({
      bundle: bundleName,
      uid: uid
    });
  }

  /**
   * 锁屏点击提示 再次点击打开
   */
  showKeyguardClickTip(): void {
    try {
      PromptAction.showToast({
        message: ResUtils.getInnerStringByName('ntf_keyguard_click_tip')
      });
    } catch (error) {
      log.error('showToast error', error);
    }
  }

  /**
   * 锁屏点击提示 该通知没有内容
   */
  showKeyguardNoContentClickTip(): void {
    try {
      PromptAction.showToast({
        message: ResUtils.getInnerStringByName('ntf_keyguard_no_content_click_tip')
      });
    } catch (error) {
      log.error('showToast error', error);
    }
  }

  sendNotificationRemoveEvent(entry: NotificationEntry, removeAll: boolean = false): void {
    if (entry?.liveViewData?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER) {
      sEventManager.publish(obtainLocalEvent(EVENT_BROADCASTING_CENTER_REMOVE, true));
    }
    if (entry == null) {
      log.showError('not send Notification Remove Event');
      return;
    }

    if (removeAll) {
      // 批量删除通知
      let options: CommonEventManager.CommonEventPublishData = {

        subscriberPermissions: ['ohos.permission.NOTIFICATION_CONTROLLER']
      };
      log.showInfo(`sendNotificationRemoveEvent removeAll`);
    }
  }


  private sendBatchNtfRemoveEvent(entrys: Array<NotificationEntry>): void {
    // 容错机制，防止ANS删除失败后，通知一直显示在通知中心
    if (SystemUICcmConfig.instance.isEnabledLive2) {
      // NotificationListener不适用于实况2.0开启后
      const hashCodes = entrys.map(ntf => ntf.hashCode);
      NotificationDataManager.instance.removeLocalNtfByHashCode(hashCodes);
    }
    ntfListener.onNotificationBatchCancel(entrys?.map((ntf) => this.getNtfCancelRequest(ntf)));
    log.showInfo('Canceled because the deletion failed');
  }

  private getNtfCancelRequest(entry: NotificationEntry): Ntf.SubscribeCallbackData {
    return {
      request: {
        id: entry?.id,
        hashCode: entry?.hashCode,
        creatorUserId: entry?.creatorUserId,
        creatorBundleName: entry?.creatorBundleName,
        content: {},
        notificationSlotType: entry?.slotType,
      },
      reason: 1,
    };
  }

  /**
   * get WantAgentInfo of want from push
   * @param want
   * @returns WantAgentInfo
   */
  public getPushWantAgentInfo(want: Want): wantAgent.WantAgentInfo | undefined {
    if (!want) {
      log.warn('want is null when getPushWantAgentInfo');
      return undefined;
    }
    if (!want.parameters) {
      log.warn('want.parameters is null when getPushWantAgentInfo');
      return undefined;
    }
    // get wantInfo from push notification
    return want.parameters[SystemuiConstants.KEY_PUSH_WANT_AGENT_INFO] as wantAgent.WantAgentInfo;
  }

  /**
   * systemUI拉起三方应用时，移除掉want中parameters.push_wantAgentInfo参数
   * @param want
   */
  public removePushWantAgentForInvokeThdApp(want: Want): void {
    if (!want) {
      log.warn('want is null when removePushWantAgentForInvokeThdApp');
      return;
    }
    if (!want.parameters) {
      log.warn('want.parameters is null when removePushWantAgentForInvokeThdApp');
      return;
    }
    let pushWantInfo = want.parameters[SystemuiConstants.KEY_PUSH_WANT_AGENT_INFO] as wantAgent.WantAgentInfo;
    if (pushWantInfo) {
      want.parameters[SystemuiConstants.KEY_PUSH_WANT_AGENT_INFO] = {} as wantAgent.WantAgentInfo;
    }
  }

  private invokeCallback(callback?: Callback<number>): void {
    try {
      callback?.(0);
    } catch (error) {
      log.error('invokeCallback occ error:', error);
    }
  }

}



// 单例
export let ntfMgr: NotificationManager = SingletonHelper.getInstance(NotificationManager, TAG);
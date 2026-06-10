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
import { NotificationSettingAppStateParams, NotificationSysEventReporter } from '../utils/NotificationSysEventReporter';
import { LogDomain, Logger, LogHelper, Trace } from '@ohos/basicutils';
import { AccountMgr } from '@ohos/frameworkwrapper';
import { notificationManager } from '@kit.NotificationKit';
import { BitUtil } from '../utils/BitUtil';
import { NotificationConfigEntity } from '../model/NotificationConfigEntity';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';
import { NtfSettingManagerUtils, SwitchState } from '../utils/NtfSettingManagerUtils';

const TAG = 'NotificationConfigStateEvent';
const log: Logger = Logger.getLogHelper(LogDomain.NC);
const ZERO_USER_ID = 0;

export class NotificationAppConfigStateEvent {

  /**
   * 查询置顶状态
   * @param uid
   * @returns
   */
  public async getPinTopState(uid: number): Promise<boolean> {
    try {
      const config = await NotificationConfigEntity.queryByProps({ uid });
      return config?.pinTop ?? false;
    } catch (e) {
      log.error(TAG, `Get pipTop state for ${uid} error:`, e);
      return false;
    }
  }

  /**
   * 查询静默通知开关状态
   * @param uid
   * @returns
   */
  public async getSilenceState(bundleName: string, uid: number): Promise<boolean> {
    try {
      const result = await NtfSettingManagerUtils.isSilentReminderEnabled(bundleName, uid);
      return result === SwitchState.USER_MODIFIED_ON;
    } catch (e) {
      log.error(TAG, `Get silence state for ${uid} ${bundleName} error:`, e);
      return false;
    }
  }

  public async report(): Promise<void> {
    Trace.start('REPORT_APP_CONFIG_WEEKLY');
    const appList = await this.getAppList();
    for (const appItem of appList) {
      if (appItem !== appList[0]) {
        await SystemUICommonUtil.sleep(3000);
      }
      let bundleOption: notificationManager.BundleOption = { bundle: appItem.bundle, uid: appItem.uid };
      let num = await notificationManager.getSlotFlagsByBundle(bundleOption);
      let slots = await notificationManager.getSlotsByBundle(bundleOption);
      let socialType = Number(slots.find((slot) => slot.notificationType === notificationManager.SlotType.SOCIAL_COMMUNICATION)?.enabled);
      let serviceType = Number(slots.find((slot) => slot.notificationType === notificationManager.SlotType.SERVICE_INFORMATION)?.enabled);
      let contentType = Number(slots.find((slot) => slot.notificationType === notificationManager.SlotType.CONTENT_INFORMATION)?.enabled);
      let customerType = Number(slots.find((slot) => slot.notificationType === notificationManager.SlotType.CUSTOMER_SERVICE)?.enabled);
      let otherType = Number(slots.find((slot) => slot.notificationType === notificationManager.SlotType.OTHER_TYPES)?.enabled);
      let params: NotificationSettingAppStateParams = {
        CREATOR_BUNDLE_NAME: appItem.bundle,
        IS_ALLOW_STATE_ON: Number(await notificationManager.isNotificationEnabled(bundleOption)),
        IS_TOP_STATE_ON: Number(await this.getPinTopState(appItem.uid)),
        IS_LOCK_STATE_ON: Number(BitUtil.getStateByIdx(num, 1)),
        IS_BANNER_STATE_ON: Number(BitUtil.getStateByIdx(num, 2)),
        IS_CORNER_STATE_ON: Number(await notificationManager.isBadgeDisplayed(bundleOption)),
        NOTIFICATION_RING_STATE: BitUtil.getStateByIdx(num, 0) ?
          (BitUtil.getStateByIdx(num, 4) ? 0 : 1) : (BitUtil.getStateByIdx(num, 4) ? 2 : 3),
        NOTIFICATION_SOCIAL_TYPE_STATE: isNaN(socialType) ? 1 : socialType,
        NOTIFICATION_SERVICE_TYPE_STATE: isNaN(serviceType) ? 1 : serviceType,
        NOTIFICATION_CONTENT_TYPE_STATE: isNaN(contentType) ? 1 : contentType,
        NOTIFICATION_CUSTOMER_TYPE_STATE: isNaN(customerType) ? 1 : customerType,
        NOTIFICATION_OTHER_TYPE_STATE: isNaN(otherType) ? 1 : otherType,
        LIVE_VIEW_STATE: await this.getLiveViewStatus(bundleOption),
        IS_SILENCE_STATE_ON: Number(await this.getSilenceState(appItem.bundle, appItem.uid))
      };
      NotificationSysEventReporter.notificationSettingAppState(params);
    }
    Trace.end('REPORT_APP_CONFIG_WEEKLY');
  }

  /**
   * 处理获取实况窗开关的异常
   */
  private async getLiveViewStatus(bundleOption: notificationManager.BundleOption): Promise<number> {
    let status: boolean = true;
    try {
      status = await notificationManager.isNotificationSlotEnabled(
        bundleOption,
        notificationManager.SlotType.LIVE_VIEW,
      );
    } catch (e) {
      log.warn(TAG, `Get ${bundleOption.bundle} ${bundleOption.uid} live view switch status failed: [${e.code}]${e.message}`);
    }
    return Number(status);
  }

  /**
   * 获取应用列表
   */
  public async getAppList(): Promise<NotificationConfigEntity[]> {
    let appList: NotificationConfigEntity[] = [];
    try {
      const userId = await AccountMgr.getCurrentAccountId();
      const predicates = NotificationConfigEntity.getPredicates()
        .inCondition({ userId: [userId, ZERO_USER_ID] })
        .equalTo({ settingIgnore: false })
        .or()
        .equalTo({ settingIgnore: false, systemApp: false })
      appList = await NotificationConfigEntity.queryList(predicates, { columns: ['bundle', 'uid'] });
      log.showInfo(TAG, `Get app list success: ${appList.length}`);
    } catch (e) {
      log.error(TAG, `Get app list error code:` + e?.code + ', message:' + e?.message);
    }
    return appList;
  }
}
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
import { NotificationMgmtModel } from '../model/NotificationMgmtModel';
import type { PinTopDialogOption } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { NotificationMgmtViewData } from './NotificationMgmtViewData';
import { RemindType, SlotType } from '../common/NotificationMgmtCommon';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';

const TAG = 'NotificationMgmtBase_ViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NotificationMgmtBaseViewEvent {
  protected viewData: NotificationMgmtViewData = new NotificationMgmtViewData();
  protected model?: NotificationMgmtModel;
  protected pinTopExceededDialogControllerBuilder?: (option: PinTopDialogOption) => CustomDialogController;
  protected bundleName: string = '';

  public initViewData(viewData: NotificationMgmtViewData): void {
    this.viewData = viewData;
  }

  public initModel(appInfo: ESObject) {
    this.bundleName = appInfo.appBundleName ?? '';
    const uid = appInfo.appUid ? Number.parseInt(appInfo.appUid.toString()) : undefined;
    this.model = new NotificationMgmtModel(this.bundleName, uid);
  }

  public initDialog(dialog: (option: PinTopDialogOption) => CustomDialogController) {
    this.pinTopExceededDialogControllerBuilder = dialog;
  }

  /**
   * 加载开关数据
   */
  public load(): void {}

  /**
   * 允许通知开关UI变化事件
   */
  public allowStateChanged = (isOn: boolean): void => {}

  /**
   * 置顶通知开关UI变化事件
   */
  public pinTopStateChanged = (isOn: boolean) => {}

  /**
   * 静默通知开关变化事件
   */
  public silentStateChanged = (isOn: boolean): void => {}

  /**
   * 可视化提醒方式开关UI变化事件
   */
  public remindStateChanged = (type: RemindType, isOn: boolean): void => {}

  /**
   * 桌面角标开关UI变化事件
   */
  public badgeStateChanged = (isOn: boolean): void => {}

  /**
   * 类型状态开关UI变化事件
   */
  public slotStateChanged = (isOn: boolean, slotType: SlotType): void => {}

  protected async reportMgmtOperate(switchId: string, isOn: boolean): Promise<void> {
    try {
      NtfSettingSysEventReporter.notificationSettingAppManagement({
        CREATOR_BUNDLE_NAME: this.bundleName,
        SWITCH_ID: switchId,
        SWITCH_STATUS: isOn ? 0 : 1
      });
    } catch (e) {
      log.showError('ReportMgmtOperate Error. bundleName: %{public}s switchId: %{public}s isOn: %{public}s',
        this.bundleName, switchId, isOn);
    }
  }

  protected async reportTypeOperate(switchId: string, isOn: boolean): Promise<void> {
    try {
      NtfSettingSysEventReporter.notificationSettingAppManagementTypeChange({
        CREATOR_BUNDLE_NAME: this.bundleName,
        SWITCH_ID: switchId,
        SWITCH_STATUS: isOn ? 0 : 1
      });
    } catch (e) {
      log.showError('ReportTypeOperate Error. bundleName: %{public}s switchId: %{public}s isOn: %{public}s',
        this.bundleName, switchId, isOn);
    }
  }
}
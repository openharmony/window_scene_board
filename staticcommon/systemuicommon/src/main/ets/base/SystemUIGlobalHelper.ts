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
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName
} from '@ohos/basicutils';
import {
  ConfigMgr,
  AccountMgr,
  CEManager,
  DeviceHelper,
  GlobalContext
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import ctx from '@ohos.app.ability.common';
import { TintMgr } from '../windowmanager/TintManager';
import { DataShareMgr } from '../datasharemanager/DataShareManager';
import TimeManager from '../manager/TimeManager';
import { phoneAppMgr } from '../plugin/PhoneAppManager';
import { notificationStore } from '../database/NotificationStore';
import { SystemUIStateEventReporter } from '../reporter/SystemUIStateReporter';
import { SystemUISettingsManager } from '../manager/SystemUISettingsManager';
import { PinTopLimitDialogVmManager } from '../dialog/PinTopLimitDialogInterface';
import { PinTopLimitDialogVm } from '../dialog/PinTopLimitDialogVm';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';

const TAG = 'SystemUIGlobalHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * SystemUI全局工具
 */
export class SystemUIGlobalHelper {
  /**
   * APP应用初始化
   *
   * @param context环境
   */
  static async appInit(context: ctx.ServiceExtensionContext): Promise<void> {
    TraceUtil.startTrace(DomainName.SCB, 'SystemUIGlobalHelper');
    log.showInfo(`appInit start`);
    GlobalContext.setContext(context);
    // 资源工具初始化
    ResUtils.init(context);
    log.showInfo('ResUtils init done');
    // 多用户初始化
    AccountMgr.init();
    log.showInfo('AccountMgr init done');
    // 外部广播初始化
    CEManager.init();
    log.showInfo('CEManager init done');
    // time manager初始化
    TimeManager.init(context);
    log.showInfo('TimeManager init done');
    // config manager初始化
    ConfigMgr.init(context);
    log.showInfo('ConfigMgr init done');
    // 沉浸式初始化
    TintMgr.init(context);
    log.showInfo('TintMgr init done');
    // 数据库监听初始化
    DataShareMgr.init(context);
    log.showInfo('DataShareMgr init done');
    // 初始化通知DB
    notificationStore.init(context);
    log.showInfo('notificationStore init done');
    // phone应用状态管理
    if (DeviceHelper.isPhoneOrPad()) {
      phoneAppMgr.init();
      log.showInfo('phoneAppMgr init done');
    }
    log.showInfo(`appInit ok, ctx is null: ${!context}`);

    log.showInfo(`PinTopLimitDialog init ok.`);
    // 置顶弹框初始化
    PinTopLimitDialogVmManager.setVm(new PinTopLimitDialogVm());
    // // 初始化systemUI设置
    SystemUICommonUtil.sleep(10).then(() => {
      SystemUISettingsManager.get().init();
      log.showInfo('systemUI settings init done');
    })
    TraceUtil.endTrace(DomainName.SCB, 'SystemUIGlobalHelper');
  }

  /**
   * APP应用去初始化
   *
   * @param context环境
   */
  static appUnInit(context: ctx.ServiceExtensionContext): void {
    AccountMgr.unInit();
  }
}

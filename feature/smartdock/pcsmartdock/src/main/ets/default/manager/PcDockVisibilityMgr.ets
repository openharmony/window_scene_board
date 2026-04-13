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
import { GlobalContext, HiSysEventUtil } from '@ohos/frameworkwrapper';
import context from '@ohos.app.ability.common';
import settings from '@ohos.settings';

const TAG = 'PcDockVisibleMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

const DATA_SHARE_DOCK_AUTO_HIDE_STYLE: string = 'settings.dock.auto_hide';

export class DockVisibilityMgr {
  private static instance: DockVisibilityMgr = new DockVisibilityMgr();
  public isAutoHide: boolean = false;

  public static getInstance(): DockVisibilityMgr {
    if (!DockVisibilityMgr.instance) {
      DockVisibilityMgr.instance = new DockVisibilityMgr();
    }
    return DockVisibilityMgr.instance;
  }

  private constructor() {
    this.initSetting();
  }

  private initSetting(): void {
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return;
    }
    try {
      this.isAutoHide = settings.getValueSync(context, DATA_SHARE_DOCK_AUTO_HIDE_STYLE, '0',
        settings.domainName.USER_PROPERTY) === '1';
      settings.registerKeyObserver(context, DATA_SHARE_DOCK_AUTO_HIDE_STYLE, settings.domainName.USER_PROPERTY,
        () => {
          this.settingDataChanged();
        });
      AppStorage.setOrCreate('isDockAutoHide', this.isAutoHide);
    } catch (error) {
      log.showError(`registerKeyObserver error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  private settingDataChanged(): void {
    log.showInfo(`dock auto hide changed`);
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return;
    }
    const isAutoHide = settings.getValueSync(context, DATA_SHARE_DOCK_AUTO_HIDE_STYLE, '0',
      settings.domainName.USER_PROPERTY) === '1';
    if (this.isAutoHide === isAutoHide) {
      return;
    }
    this.isAutoHide = isAutoHide;
    HiSysEventUtil.reportDockAutoHide(isAutoHide);
    AppStorage.setOrCreate('isDockAutoHide', this.isAutoHide);
  }
}
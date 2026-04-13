/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { DockItemInfo, ResidentLayoutCacheMgr } from '@ohos/launchercommon';
import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { DfxEvent, reportIntervalMgr } from '@ohos/frameworkwrapper'
import PcSmartDockViewModel from '../viewmodel/SmartDockViewModel';
import FixedLayout from './FixedLayout';
import { PcDockHiSysEventMgr } from '../manager/PcDockHiSysEventMgr';
import { PCDockUtils } from '../utils/PCDockUtils';

const TAG = 'FixedSmartDock';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

@Component
export struct FixedSmartDock {
  @Link screenProp: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  @Link currColorMode: number;
  private mSmartDockViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  private readonly dockAppCountEvent: DfxEvent = {
    report: (): void => {
      const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      const appCounts: number[] = PCDockUtils.getDockAppCount(residentList);
      log.showInfo(`dockAppCountEvent report happen, appNumber ${appCounts[0]} shortcutNumber ${appCounts[1]}`);
      PcDockHiSysEventMgr.reportDockAppCountData(appCounts[0], appCounts[1]);
    }
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear start!');
    try {
      this.mSmartDockViewModel = PcSmartDockViewModel.getInstance();
      this.mSmartDockViewModel.registerAppListChangeCallback();
    } catch (error) {
      log.showError(`catch error`);
    }
    // 刷新状态栏状态
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    this.mSmartDockViewModel.initRecentDataList(containerSessionList);
    reportIntervalMgr.registerEvent(this.dockAppCountEvent);
    log.showInfo('aboutToAppear end!');
  }

  aboutToDisappear() {
    reportIntervalMgr.unRegisterEvent(this.dockAppCountEvent);
    this.mSmartDockViewModel.unregisterAppListChangeCallback();
    PcSmartDockViewModel.getInstance().unregisterDataChangeCallback();
    log.showInfo('aboutToDisappear!');
  }

  build() {
    FixedLayout({
      screenProp: this.screenProp,
      singleContext: this.singleContext,
      currColorMode: this.currColorMode
    })
  }
}

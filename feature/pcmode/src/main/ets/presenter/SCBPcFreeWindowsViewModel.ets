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

import { SCBSceneInfo, SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { DeviceHelper, sOutSideWindowMgr } from '@ohos/frameworkwrapper'
import { SCBBaseFreeWindowsViewModel } from './SCBBaseFreeWindowsViewModel';
import { SCBScenePanelProxy } from './SCBScenePanelProxy';
import { LogUtil } from '../utils/LogUtil';
import { PcDockAnimationMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockAnimationMgr';
import { RectInfo } from '@ohos/basicutils';
import { AppItemInfo } from '@ohos/launchercommon';
import { PcModeRSSUtils } from '../utils/PcModeRSSUtils';

/**
 * pc窗口管理代理类
 */
export class SCBPcFreeWindowsViewModel extends SCBBaseFreeWindowsViewModel {
  protected tag = 'SCBPcFreeWindowsViewModel';
  private mDockAnimationMgr: PcDockAnimationMgr;
  private exitSplitViewCallback = (persistentId: number): void => {
    this.exitSplitView(persistentId);
  };
  constructor(uiContext: UIContext, screenProperty: SCBScreenProperty, panelProxy: SCBScenePanelProxy) {
    super(uiContext, screenProperty, panelProxy);
    this.log = LogUtil.getInstance().createLogHelper(this.tag, this.screenId);
    this.mDockAnimationMgr = PcDockAnimationMgr.getInstance(this.screenProperty.screenId);
  }

  protected registerCallback(): void {
    super.registerCallback();
    const managerInstance: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    managerInstance.registerExitSplitViewCallback(this.exitSplitViewCallback);
  }

  protected unRegisterCallback(): void {
    super.unRegisterCallback();
    const managerInstance: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    managerInstance.unRegisterExitSplitViewCallback();
  }

  protected fixAttractionTranslate(): number {
    return 0;
  }

  protected getIconRect(appItem: AppItemInfo): RectInfo {
    const minimizeItem = this.mDockAnimationMgr.getIconRect(appItem, this.getUiContext());
    return minimizeItem.minimizeItemRect;
  }

  protected isHideOnDock(appItem: AppItemInfo): boolean {
    const minimizeItem = this.mDockAnimationMgr.getIconRect(appItem, this.getUiContext());
    return minimizeItem.isHide;
  }

  protected notifyWhenStartSceneFromOther(sceneInfo: SCBSceneInfo) {
    this.closeGlobalSearchIfNeed();
  }

  protected notifyWhenStartSceneFromIcon() {
    this.closeGlobalSearchIfNeed();
  }

  private closeGlobalSearchIfNeed(): void {
    if (DeviceHelper.is2In1DevicePcType() && sOutSideWindowMgr.isShowGlobalSearch()) {
      sOutSideWindowMgr.hideGlobalSearch();
    }
  }

  protected onInitConfigs(): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      this.needMutexListener = true;
    }
  }

  /**
   * 重载应用互斥业务特殊处理,pc不涉及
   */
  protected tryInterruptStartWithRss(sceneInfo: SCBSceneInfo): void {
    if (!this.needMutexListener) {
      return;
    }
  }
}
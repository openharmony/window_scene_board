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

import { AppIconCommonEvent, AppIconConfig } from '@ohos/launchercommon/Index';
import { DockType, GestureDockConstants, GestureDockMode } from '../../../common/GestureDockConstants';
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';
import { DockAppItemParam } from './GestureDockAppItemParam';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { FeatureConstants, SmartDockStyleConfig } from '@ohos/smartdock';
import { SCBExpandController, SCBScreenProperty } from '@ohos/windowscene';
import { layoutConfigManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockViewParam } from '../../../dock/viewmodel/viewdata/GestureDockParam';
import { GestureDockBarViewModel } from '../../../dockbar/viewmodel/GestureDockBarViewModel';
import { GestureDockEventIdUtil } from '../../../common/util/GestureDockEventIdUtil';

/**
 * GestureDockAllAppsViewDataMgr
 */
export default class GestureDockAppItemViewDataMgr {
  public screenProperty: SCBScreenProperty = new SCBScreenProperty();
  public appItemParam: DockAppItemParam = new DockAppItemParam();
  public gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
  public desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  public mSmartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
  public expandController?: SCBExpandController;
  public dockType: number = DockType.RESIDENT;
  public gestureDockParam: GestureDockViewParam = new GestureDockViewParam();
  // 标识是否是应用内dock
  public isIntegratedDock: boolean = false;
  public dockBarViewModel: GestureDockBarViewModel = GestureDockBarViewModel.getInstance();
  // 图标配置项
  public appIconConfig: AppIconConfig = new AppIconConfig();
  public iconEvent: AppIconCommonEvent = new AppIconCommonEvent();
  public dockDirection: number = 0;
  public itemOnClick: Function = (event: ClickEvent, item: GestureDockItemInfo, dockType: number) => {
  };

  /**
   * 图标ID
   * @returns 图标ID
   */
  public getItemId(): string {
    return GestureDockEventIdUtil.getResidentLayoutAppTag(this.gestureDockItemInfo) +
    this.dockDirection + this.dockType;
  }

  /**
   * 图标透明度
   * @returns 图标透明度
   */
  public getOpacity(): number {
    // 编辑模式只判断角标,非编辑模式判应用是否启动
    return GestureDockConstants.APP_ICON_OPACITY_100;
  }
}
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
import { PluginInfo } from '@ohos/frameworkwrapper';
import { IStatusBarIconVm, StatusBarVmInjector } from '@ohos/systemuicommon/newIndex';
// instrument ignore file

const TAG = 'StatusBarIconView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct StatusBarIconView {
  @BuilderParam child: () => void;
  @Param @Require pluginInfo: PluginInfo;
  @Consumer() statusBarVmInjector: StatusBarVmInjector = StatusBarVmInjector.HOLDER;

  @Computed get iconVm(): IStatusBarIconVm {
    return this.statusBarVmInjector.getStatusBarIconVm(this.pluginInfo.pluginParseInfo.pluginSlot);
  }

  aboutToAppear(): void {
    log.showInfo(`about to appear, plugin slot(${this.pluginInfo.pluginParseInfo.pluginSlot}).`);
    this.iconVm.init(this.pluginInfo);
  }

  aboutToDisappear(): void {
    log.showInfo(`about to disappear, plugin slot(${this.pluginInfo.pluginParseInfo.pluginSlot}).`);
    this.iconVm.unInit();
  }

  build() {
    this.child()
  }

}
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginInfo, PluginSlot } from '@ohos/frameworkwrapper';
import { StatusBarVmInjector } from '@ohos/systemuicommon/newIndex';
import { StatusBarCapsuleIconVm } from '../vm/StatusBarCapsuleIconVm';
import { LiveCapsuleListWithoutHoleView } from '@ohos/systemuicommon/newIndex';
// instrument ignore file

const TAG = 'CapsuleListWithoutHoleStatusView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct CapsuleListWithoutHoleStatusView {
  @Param @Require pluginInfo: PluginInfo;
  @Consumer() statusBarVmInjector: StatusBarVmInjector = StatusBarVmInjector.HOLDER;
  capsuleVm = this.statusBarVmInjector.getStatusBarIconVm(PluginSlot.LIVE_VIEW_CAPSULE) as StatusBarCapsuleIconVm;

  aboutToAppear(): void {
    this.capsuleVm.init(this.pluginInfo);
    log.showInfo(`about to appear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`about to disappear`);
  }

  build() {
    Stack() {
      LiveCapsuleListWithoutHoleView()
    }
    .id(`${TAG}_LiveCapsuleListContainer`)
  }
}
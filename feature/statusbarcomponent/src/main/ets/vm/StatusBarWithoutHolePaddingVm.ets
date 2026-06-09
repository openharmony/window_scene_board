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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { StatusBarHeightVm } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarHeightVm';
import { StatusBarPaddingBaseVm } from './StatusBarPaddingBaseVm';
import { ResUtils } from '@ohos/windowscene';
import { lockIconForOuterHome } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusbarConstants';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'StatusBarWithoutHolePaddingVm');
const STATUS_BAR_HEIGHT: number = 24;

@ObservedV2
export class StatusBarWithoutHolePaddingVm extends StatusBarPaddingBaseVm {
  // 无孔设备16vp padding
  @Trace public statusBarLeftPadding: number = this.withoutHoleDefaultPadding;
  @Trace public statusBarRightPadding: number = this.withoutHoleDefaultPadding;
  @Trace public statusBarTopPadding: number = (StatusBarHeightVm.getInstance().getAvoidHeight() -
  this.defaultHeight) / 2;

  public calcStatusBarPadding(): void {
  }
}
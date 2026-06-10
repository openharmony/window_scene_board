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
  IStatusBarSettingVm,
  StatusBarVmInjector,
  IStatusBarLayoutVm,
  IStatusBarIconListVm,
  IStatusBarAnimVm,
  IStatusBarIconAnimVm,
  IStatusBarPaddingVm,
  DeviceInfoVm,
  CutoutVm
} from '@ohos/systemuicommon/newIndex';
import lazy { IMouseTypeStyleVm } from '@ohos/systemuicommon/newIndex';
import { StatusBarLayoutVm } from './vm/StatusBarLayoutVm';
import { StatusBarXTLayoutVm } from './vm/StatusBarXTLayoutVm';
import { StatusBarAnimVm } from './vm/StatusBarAnimVm';
import { StatusBarIconAnimVm } from './vm/StatusBarIconAnimVm';
import { StatusBarIconListVm } from './vm/StatusBarIconListVm';
import { IStatusBarIconVm } from '@ohos/systemuicommon/src/main/ets/statusbar/interface/IStatusBarIconVm';
import { StatusBarIconVm } from './vm/StatusBarIconVm';
import { StatusBarClockIconVm } from './vm/StatusBarClockIconVm';
import { StatusBarNotificationIconVm } from './vm/StatusBarNotificationIconVm';
import { StatusBarCapsuleIconVm } from './vm/StatusBarCapsuleIconVm';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { StatusBarSettingVm } from './vm/StatusBarSettingVm';
import { Singleton } from '@ohos/systemuicommon/newTsIndex';
import { StatusBarCommonPaddingVm } from './vm/StatusBarCommonPaddingVm';
import { StatusBarWithoutHolePaddingVm } from './vm/StatusBarWithoutHolePaddingVm';
import { StatusBarXTPaddingVm } from './vm/StatusBarXTPaddingVm';
import { CutoutType } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/CutoutVm';
import { StatusBarNotchPaddingVm } from './vm/StatusBarNotchPaddingVm';
import { LayoutUtils } from '@ohos/systemuicommon';
import lazy { MouseTypeStyleVm } from './vm/MouseTypeStyleVm';

export class PhoneStatusBarVmInjector extends StatusBarVmInjector {
  @Singleton.decorate() static get instance() { return new PhoneStatusBarVmInjector(); }

  constructor() {
    super();
  }

  getStatusBarIconVm(pluginName: string): IStatusBarIconVm {
    if (pluginName === PluginSlot.SLOT_STATUS_CLOCK) {
      return this.getVm(this.getStatusBarIconKey(StatusBarClockIconVm, pluginName),
        () => new StatusBarClockIconVm(this, pluginName));
    } else if (pluginName === PluginSlot.SLOT_STATUS_NOTIFICATION) {
      return this.getVm(this.getStatusBarIconKey(StatusBarNotificationIconVm, pluginName),
        () => new StatusBarNotificationIconVm(this, pluginName));
    } else if (pluginName === PluginSlot.LIVE_VIEW_CAPSULE) {
      return this.getVm(this.getStatusBarIconKey(StatusBarCapsuleIconVm, pluginName),
        () => new StatusBarCapsuleIconVm(this, pluginName));
    } else {
      return this.getVm(this.getStatusBarIconKey(StatusBarIconVm, pluginName),
        () => new StatusBarIconVm(this, pluginName));
    }
  }

  getStatusBarSettingVm(): IStatusBarSettingVm {
    return this.getVm(StatusBarSettingVm.name, () => new StatusBarSettingVm(this));
  }

  getStatusBarLayoutVm(): IStatusBarLayoutVm {
    if (LayoutUtils.isXTProductType()) {
      return this.getVm(StatusBarXTLayoutVm.name, () => new StatusBarXTLayoutVm(this));
    }
    return this.getVm(StatusBarLayoutVm.name, () => new StatusBarLayoutVm(this));
  }

  getStatusBarIconListVm(): IStatusBarIconListVm {
    return this.getVm(StatusBarIconListVm.name, () => new StatusBarIconListVm(this));
  }

  getStatusBarAnimVm(): IStatusBarAnimVm {
    return this.getVm(StatusBarAnimVm.name, () => new StatusBarAnimVm(this));
  }

  getStatusBarIconAnimVm(): IStatusBarIconAnimVm {
    return this.getVm(StatusBarIconAnimVm.name, () => new StatusBarIconAnimVm(this));
  }

  protected getStatusBarIconKey(vmClass: Function, pluginName: string): string {
    return vmClass.name + '_' + pluginName;
  }

  getStatusBarPaddingVm(): IStatusBarPaddingVm {
    if (LayoutUtils.isXTProductType()) {
      return this.getVm(StatusBarXTPaddingVm.name, () => new StatusBarXTPaddingVm(this));
    } else if (CutoutVm.instance.deviceCutoutType === CutoutType.WITHOUT_HOLE) {
      return this.getVm(StatusBarWithoutHolePaddingVm.name, () => new StatusBarWithoutHolePaddingVm(this));
    } else if (CutoutVm.instance.deviceCutoutType === CutoutType.NOTCH) {
      return this.getVm(StatusBarNotchPaddingVm.name, () => new StatusBarNotchPaddingVm(this));
    }
    return this.getVm(StatusBarCommonPaddingVm.name, () => new StatusBarCommonPaddingVm(this));
  }

  getMouseTypeStyleVm(): IMouseTypeStyleVm {
    return this.getVm(MouseTypeStyleVm.name, () => new MouseTypeStyleVm(this));
  }
}
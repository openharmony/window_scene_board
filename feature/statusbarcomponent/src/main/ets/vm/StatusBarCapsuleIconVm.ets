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
import { RotationConstants } from '@ohos/commonconstants';
import { PluginInfo } from '@ohos/frameworkwrapper';
import { LayoutUtils } from '@ohos/systemuicommon';
import { CutoutVm, DeviceInfoVm, IStatusBarPaddingVm,
  ResourceVm, StatusBarVmInjector } from '@ohos/systemuicommon/newIndex';
import { SCBRotateChangeReason } from '@ohos/windowscene';
import { CapsuleListWithoutHoleStatusView } from '../view/CapsuleListWithoutHoleStatusView';
import { StatusBarIconBaseVm } from './StatusBarIconBaseVm';

const TAG = 'StatusBarCapsuleIconVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class StatusBarCapsuleIconVm extends StatusBarIconBaseVm {
  private deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;

  private cutoutVm: CutoutVm = CutoutVm.instance;

  private resourceVm: ResourceVm = ResourceVm.instance;

  public id = 'PluginRootComponent_Stack_live_view_capsule';

  @Trace public pixelRound: PixelRoundPolicy | undefined = undefined;

  private statusbarPaddingVm = this.vmInjector.getStatusBarPaddingVm();

  constructor(vmInjector: StatusBarVmInjector, pluginName: string) {
    super(vmInjector, pluginName);
  }

  initIcon(): void {

  }

  @Monitor('deviceInfoVm.xtLayoutType', 'cutoutVm.left', 'cutoutVm.position', 'resourceVm.isRTL',
  'statusbarPaddingVm.statusBarLeftPadding', 'cutoutVm.top')
  updateXTCapsulePosition(monitor: IMonitor): void {
    if (this.cutoutVm.isMiddleCutout()) {
      this.vmInjector.getStatusBarIconListVm().iconSwitchOnInfo.delete(this.pluginName);
      this.isOnTheTree = false;
    } else {
      this.vmInjector.getStatusBarIconListVm().iconSwitchOnInfo.add(this.pluginName);
      this.isOnTheTree = true;
    }
    if (!LayoutUtils.isXTProductType()) {
      return;
    }
    if (this.deviceInfoVm.isXTLandscapeInvertedStatus() && !this.resourceVm.isRTL) {
      const capsuleX = this.cutoutVm.left + this.cutoutVm.width - this.statusbarPaddingVm.statusBarLeftPadding;
      log.showInfo(`update capsuleX: ${capsuleX}`)
      this.marginStart = capsuleX;
    } else {
      this.marginStart = 0;
    }
  }

  getIsOnTheTree(): boolean {
    const isRotation0Start = DeviceInfoVm.instance.orientationReason === SCBRotateChangeReason.ROTATE_BEGIN &&
      DeviceInfoVm.instance.realRotateAngle === RotationConstants.ROTATION_0 &&
      DeviceInfoVm.instance.isPortraitMiddleCutout;
    log.showInfo(`StatusBarCapsuleIconVm isMiddleCutout: ${CutoutVm.instance.isMiddleCutout()}, isRotationStart: ${isRotation0Start}`);
    if (CutoutVm.instance.isMiddleCutout() || isRotation0Start) {
      return false;
    } else {
      return true;
    }
  }

  getBuilder(): WrappedBuilder<[PluginInfo]> {
    return wrapBuilder(withoutHoleCapsuleIconBuilder);
  }
}

@Builder
function withoutHoleCapsuleIconBuilder(pluginInfo: PluginInfo) {
  CapsuleListWithoutHoleStatusView({ pluginInfo: pluginInfo })
}
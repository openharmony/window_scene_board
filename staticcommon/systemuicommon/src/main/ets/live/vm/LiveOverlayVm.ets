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
import { StatusBarHeightVm } from '../../statusbar/vm/StatusBarHeightVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ILiveOverlayVm } from '../interface/ILiveOverlayVm';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { LiveBaseVm } from './LiveBaseVm';

@ObservedV2
export class LiveOverlayVm extends LiveBaseVm implements ILiveOverlayVm {
  protected readonly TAG = 'LiveOverlayVm';

  @Trace public visible: boolean = false;
  public builder?: WrappedBuilder<[ILiveVmInjector]>;

  show(builder: WrappedBuilder<[ILiveVmInjector]>): void {
    this.log.showInfo('Show');
    this.builder = builder;
    this.visible = true;
    StatusBarHeightVm.getInstance().preSetShowHeight(ArkUIAdapter.px2vp(DeviceInfoVm.instance.height), this.TAG);
  }

  hide(): void {
    this.log.showInfo('Hide');
    this.visible = false;
    StatusBarHeightVm.getInstance().clearShowHeight(this.TAG);
  }
}
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

import { CommonUtils } from '@ohos/basicutils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { StatusBarStyleChangeEvent } from '@ohos/systemuicommon';
import { EnvVm, IStatusBarPaddingVm } from '@ohos/systemuicommon/newIndex';
import { CutoutVm } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/CutoutVm';
import { StatusBarBaseVm } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarBaseVm';
import { StatusBarHeightVm } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarHeightVm';
import { DeviceInfoVm } from '@ohos/systemuicommon/src/main/ets/vm/DeviceInfoVm';


@ObservedV2
export abstract class StatusBarPaddingBaseVm extends StatusBarBaseVm implements IStatusBarPaddingVm {
  protected defaultHeight: number = 24;
  protected leftCutoutPadding: number = 5;
  protected withoutHoleDefaultPadding: number = 16;
  @Trace public statusBarLeftPadding: number = 20;
  @Trace public statusBarRightPadding: number = 20;
  @Trace public statusBarTopPadding: number = (StatusBarHeightVm.getInstance().getAvoidHeight() -
  this.defaultHeight) / 2;
  protected cutoutVm = CutoutVm.instance;
  protected deviceInfoVm = DeviceInfoVm.instance;
  protected envVm = EnvVm.instance;

  private eventMgr: EventManager = EvtBus.createEventManager();

  public init(): void {
    this.eventMgr.produceOn(StatusBarStyleChangeEvent, () => {
      let event = new StatusBarStyleChangeEvent();
      event.statusBarPaddingLeft = CommonUtils.spliceVp(this.statusBarLeftPadding);
      event.statusBarPaddingTop = CommonUtils.spliceVp(this.statusBarTopPadding);
      event.statusBarPaddingRight = CommonUtils.spliceVp(this.statusBarRightPadding);
      event.orientation = DeviceInfoVm.instance.orientation;
      return event;
    });
  }

  public unInit(): void {
    this.eventMgr.offAll();
  }

  public updateStatusBarPadding(): void {
    this.calcStatusBarPadding();
    this.postStatusBarStyleChangeEvent();
  }

  abstract calcStatusBarPadding(): void;

  postStatusBarStyleChangeEvent(): void {
    let event = new StatusBarStyleChangeEvent();
    event.statusBarPaddingLeft = CommonUtils.spliceVp(this.statusBarLeftPadding);
    event.statusBarPaddingTop = CommonUtils.spliceVp(this.statusBarTopPadding);
    event.statusBarPaddingRight = CommonUtils.spliceVp(this.statusBarRightPadding);
    event.orientation = DeviceInfoVm.instance.orientation;
    EvtBus.post(StatusBarStyleChangeEvent, event);
  }
}
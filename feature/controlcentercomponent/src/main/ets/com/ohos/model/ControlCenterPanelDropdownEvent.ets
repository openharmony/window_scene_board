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

import {
  DropDownEvent,
  DropDownPanelManagerWrapper,
  proxyDefaultSetter,
  ProxyTarget,
  TargetChangeState,
  TargetPanel
} from '@ohos/frameworkwrapper';

@Observed
export class ControlCenterPanelDropdownEvent extends ProxyTarget {
  
  public get pullFraction(): number { return DropDownEvent.DEFAULT_PULL_FRACTION; }
  public get progress(): number { return 0; };
  public get translateY(): number { return 0; };
  public get target(): TargetPanel { return TargetPanel.NONE; }
  public get targetChanged(): TargetChangeState { return TargetChangeState.NONE; }

  public static create(): ControlCenterPanelDropdownEvent {

    return DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.createProxy(
      new ControlCenterPanelDropdownEvent(), {
        pullFraction: proxyDefaultSetter,
        target: proxyDefaultSetter,
        targetChanged: proxyDefaultSetter,
        progress: proxyDefaultSetter,
        translateY:proxyDefaultSetter,
    });
  }
}
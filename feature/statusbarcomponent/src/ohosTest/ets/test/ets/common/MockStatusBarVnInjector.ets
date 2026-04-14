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
  IMouseTypeStyleVm,
  IStatusBarAnimVm,
  IStatusBarIconAnimVm,
  IStatusBarIconListVm,
  IStatusBarIconVm,
  IStatusBarLayoutVm,
  IStatusBarPaddingVm,
  IStatusBarSettingVm,
  StatusBarVmInjector
} from "@ohos/systemuicommon/newIndex";
import { MockUtils } from "./MockUtils";

export class MockStatusBarVmInjector extends StatusBarVmInjector {
  getStatusBarIconVm(pluginName: string): IStatusBarIconVm {
    return MockUtils.mockInterface<IStatusBarIconVm>();
  }

  getStatusBarSettingVm(): IStatusBarSettingVm {
    return MockUtils.mockInterface<IStatusBarSettingVm>();
  }

  getStatusBarLayoutVm(): IStatusBarLayoutVm {
    return MockUtils.mockInterface<IStatusBarLayoutVm>();
  }

  getStatusBarIconListVm(): IStatusBarIconListVm {
    return MockUtils.mockInterface<IStatusBarIconListVm>();
  }

  getStatusBarAnimVm(): IStatusBarAnimVm {
    return MockUtils.mockInterface<IStatusBarAnimVm>();
  }

  getStatusBarIconAnimVm(): IStatusBarIconAnimVm {
    return MockUtils.mockInterface<IStatusBarIconAnimVm>();
  }

  getStatusBarPaddingVm(): IStatusBarPaddingVm {
    return MockUtils.mockInterface<IStatusBarPaddingVm>();
  }

  getMouseTypeStyleVm(): IMouseTypeStyleVm {
    return MockUtils.mockInterface<IMouseTypeStyleVm>();
  }
}
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
import { DeviceHelper, PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { PluginProperty } from '../viewdata/PluginProperty';
import { VisibleControlBase } from './VisibleControlBase';

export class ImmediatelyVisibleControl extends VisibleControlBase {
  private immediatelyPluginCustomVisibleMap: Map<string, () => boolean> = new Map([
    [PluginSlot.SLOT_STATUS_SCREEN_RECORDER, this.setEmulatorScreenRecorderInvisible]
  ]);

  protected notifyPluginAdd(plugin: PluginProperty): void {
    this.notifyVisibleStatus(plugin, this.immediatelyPluginCustomVisibleMap.get(plugin?.getSlot())?.() ?? true);
  }

  private setEmulatorScreenRecorderInvisible(): boolean {
    return !DeviceHelper.isEmulator();
  }
}
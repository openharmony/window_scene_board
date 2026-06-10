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

import { PluginSlot } from '@ohos/frameworkwrapper';

export class PluginSlotMappingNew {

  // 默认DYNAMIC固定区按照顺序排列的图标，虚拟键盘保存的是应用包名
  public static dynamicFixedSlot: string[] = [
    PluginSlot.SLOT_CAPSULE_KEY_MOUSE,
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
    PluginSlot.SLOT_STATUS_LOCATION,
    PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD];

  public static needSeparator: Set<string> = new Set([
    PluginSlot.SLOT_STATUS_SEARCH,
    PluginSlot.SLOT_STATUS_CONTROL_CENTER,
    PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL,
  ]);

  public static DISABLE_DRAG_PLUGIN: Set<string> = new Set([
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
    PluginSlot.SLOT_STATUS_LOCATION,
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
    PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD,
    PluginSlot.SLOT_CAPSULE_KEY_MOUSE,
  ]);

  public static isNeedSeparator(slot: string): boolean {
    if (PluginSlotMappingNew.needSeparator.has(slot)) {
      return true;
    }
    return false;
  }
}
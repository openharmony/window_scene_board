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
import { PluginGroupType, PluginPositionType } from '../../common/PluginConstants';
import { PluginGroupCalculateBase } from '../PluginGroupCalculateBase';
import { MappingGroupCalculate } from '../plugingroupcalculate/MappingGroupCalculate';
import { DefaultGroupCalculate } from '../plugingroupcalculate/DefaultGroupCalculate';
import { DragGroupCalculate } from '../plugingroupcalculate/DragGroupCalculate';
import { PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

export class WinPluginGroupCalculate extends PluginGroupCalculateBase {
  constructor() {
    super();
    /**
     * localgroup对应的name
     */
    this.openPanels = new Map([
      [PluginPositionType.BOTTOM_LEFT, new Map([
        [PluginGroupType.FIRST_GROUP, PluginSlot.SLOT_STATUS_HOS_KEY],
        [PluginGroupType.SECOND_GROUP, PluginSlot.SLOT_STATUS_SEARCH]
      ])],
      [PluginPositionType.BOTTOM_RIGHT, new Map([
        [PluginGroupType.FIRST_GROUP, PluginSlot.SLOT_STATUS_INPUT_PANEL],
        [PluginGroupType.SECOND_GROUP, PluginSlot.SLOT_STATUS_INPUT_METHOD],
        [PluginGroupType.THIRD_GROUP, PluginSlot.SLOT_STATUS_CONTROL_CENTER],
        [PluginGroupType.FOURTH_GROUP, PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL],
      ])],
      ]);

    this.slotInWhereMap = new Map([
      [PluginPositionType.BOTTOM_LEFT, new Map([
        [PluginSlot.SLOT_STATUS_HOS_KEY, PluginGroupType.FIRST_GROUP],
        [PluginSlot.SLOT_STATUS_SEARCH, PluginGroupType.SECOND_GROUP]
      ])
      ],
      [PluginPositionType.BOTTOM_RIGHT, new Map([
        [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT, PluginGroupType.DYNAMIC_LEFT],
        [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE, PluginGroupType.DYNAMIC_LEFT],
        [PluginSlot.SLOT_STATUS_LOCATION, PluginGroupType.DYNAMIC_LEFT],
        [PluginSlot.SLOT_CAPSULE_KEY_MOUSE, PluginGroupType.DYNAMIC_LEFT],
        [PluginSlot.SLOT_STATUS_INPUT_PANEL, PluginGroupType.FIRST_GROUP],
        [PluginSlot.SLOT_STATUS_INPUT_METHOD, PluginGroupType.SECOND_GROUP],
        [PluginSlot.SLOT_STATUS_SOUND_PANEL, PluginGroupType.THIRD_GROUP],
        [PluginSlot.SLOT_STATUS_WIFI_PANEL, PluginGroupType.THIRD_GROUP],
        [PluginSlot.SLOT_STATUS_BATTERY_PANEL, PluginGroupType.THIRD_GROUP],
        [PluginSlot.SLOT_STATUS_CLOCK_PANEL, PluginGroupType.FOURTH_GROUP],
        [PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD, PluginGroupType.DYNAMIC_LEFT],
        [PluginSlot.SLOT_STATUS_CONTROL_CENTER, PluginGroupType.TEMPORARY],
        [PluginSlot.SLOT_STATUS_PERSONAL, PluginGroupType.TEMPORARY],
        [PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL, PluginGroupType.TEMPORARY],
        [PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL, PluginGroupType.TEMPORARY],
        [PluginSlot.SLOT_STATUS_SEPARATOR, PluginGroupType.TEMPORARY],
        [PluginSlot.SLOT_STATUS_IDESK, PluginGroupType.TEMPORARY],
        [PluginSlot.SLOT_STATUS_vpn, PluginGroupType.TEMPORARY],
        [PluginSlot.SLOT_STATUS_ICPM, PluginGroupType.TEMPORARY]
      ])
      ]
    ]);

    this.basePluginGroup = new MappingGroupCalculate(this.slotInWhereMap);
    this.basePluginGroup.addElement(new DragGroupCalculate())?.addElement(
      new DefaultGroupCalculate([PluginPositionType.BOTTOM_RIGHT, PluginGroupType.TRAY]));
  }
}
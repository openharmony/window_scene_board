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
import { LogDomain, LogHelper,
  SingletonHelper } from '@ohos/basicutils';
import {FASlotName } from '@ohos/commonconstants';
import {PluginSlot } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'ControlCenterAccessibilityDataModel';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const WLAN_DEFAULT_LABEL = 'WLAN';

export class ControlCenterAccessibilityDataModel {

  private controlCenterToggleMap: Map<string, Resource | string> = new Map([
    [FASlotName.FOCUS_MODE, $r('app.string.control_center_complex_toggle_focus_mode_title')],
    [FASlotName.RING_MODE, $r('app.string.control_center_complex_toggle_ring_mode_title_on')],
    [FASlotName.LOCATION, $r('app.string.control_center_complex_toggle_location_title')],
    [FASlotName.NFC, $r('app.string.control_center_complex_toggle_nfc_mode_title')],
    [FASlotName.AUTO_ROTATE, $r('app.string.control_center_complex_toggle_auto_rotate_title')],
    [PluginSlot.SLOT_CONTROL_SCREENSHOT, $r('app.string.screen_shot_widget_name')],
    [PluginSlot.SLOT_CONTROL_SCREEN_RECORDER, $r('app.string.screen_recorder_widget_name')],
    [PluginSlot.SLOT_CONTROL_SCANNER, $r('app.string.scanner_widget_name')],
    [PluginSlot.SLOT_CONTROL_MULTI_WINDOW, $r('app.string.multi_window_widget_name')],
    [FASlotName.MULTI_WINDOW, $r('app.string.multi_window_widget_name')],
    [FASlotName.DARK_MODE, $r('app.string.control_center_complex_toggle_dark_mode_title')],
    [FASlotName.AIR_PLANE, $r('app.string.airplane_mode')],
    [FASlotName.HOTSPOT, $r('app.string.control_center_complex_toggle_hotspot_title')],
    [FASlotName.MOBILE_DATA, $r('app.string.control_center_complex_toggle_mobiledata_title')],
    [FASlotName.FLASHLIGHT, $r('app.string.control_center_complex_toggle_flashlight_title')],
    [FASlotName.CAST, $r('app.string.wireless_projection_toggle')],
    [FASlotName.POWER_SAVE, $r('app.string.control_center_complex_toggle_powersaving_title')],
    [FASlotName.NEAR_LINK, $r('app.string.control_center_complex_toggle_nearlink_title')],
    [FASlotName.SUPER_PRIVACY, $r('app.string.super_privacy_toggle')],
    [FASlotName.EYE_COMFORT, $r('app.string.control_center_eye_comfort_toggle_title')],
    [FASlotName.SUPER_HUB, $r('app.string.control_center_complex_toggle_superhub_title')],
    [FASlotName.SOUND, $r('app.string.sound_title')],
    [FASlotName.YOUTH_MODE, $r('app.string.juvenile_mode_toggle')],
    [FASlotName.QUICK_NOTE, $r('app.string.notepad_quick_note_title')]
  ]);

  public set(slot: string | undefined, label: string | Resource | undefined) {
    log.showInfo(`set start slot=${slot}`);
    if (slot === undefined || label === undefined) {
      return;
    }
    this.controlCenterToggleMap.set(slot, label);
  }

  public get(slot: string): string {
    let label = this.controlCenterToggleMap.get(slot);
    if (label === undefined) {
      return '';
    }
    let toggleLabel = '';
    try {
      switch (slot) {
        case FASlotName.WIFI:
        case FASlotName.WIFI_UI_EXTENSION:
          toggleLabel = WLAN_DEFAULT_LABEL;
          break;
        case FASlotName.BLUETOOTH:
        case FASlotName.BLUETOOTH_UI_EXTENSION:
          toggleLabel = ResUtils.getInnerString($r('app.string.cc_accessibility_str_bluetooth_name'));
          break;
        case FASlotName.MOBILE_DATA:
        case FASlotName.MOBILE_DATA_TAGGED:
          toggleLabel = ResUtils.getInnerString($r('app.string.control_center_complex_toggle_mobiledata_title'));
          break;
        default:
          toggleLabel = typeof label === 'string' ? label : ResUtils.getInnerString(label);
          break;
      }
    } catch (e) {
      log.showError(`get slot=${slot}, e=${e}`);
    }
    log.showInfo(`get slot=${slot} toggleLabel=${toggleLabel?.charAt(0) + '***'}`);
    return toggleLabel;
  }

  public static getInstance(): ControlCenterAccessibilityDataModel {
    let accessibilityDataModel: ControlCenterAccessibilityDataModel = SingletonHelper.getInstance(
      ControlCenterAccessibilityDataModel, TAG);
    return accessibilityDataModel;
  }
}

let accessibilityDataModel = SingletonHelper.getInstance(ControlCenterAccessibilityDataModel, TAG);
export default accessibilityDataModel as ControlCenterAccessibilityDataModel;
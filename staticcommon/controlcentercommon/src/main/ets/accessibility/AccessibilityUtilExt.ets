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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { PluginSlot, sSettingsUtil } from '@ohos/frameworkwrapper';
import { FASlotName } from '@ohos/commonconstants';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { audio } from '@kit.AudioKit';
import { ControlCenterAccessibilityDataModel } from './AccessibilityDataModel';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityUtil';
import { ToggleViewData } from '../toggle/vm/ToggleViewData';
import { ToggleBaseViewModel } from '../toggle/vm/ToggleBaseViewModel';

const TAG: string = 'SystemUI-AccessibilityUtilExt';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const WLAN_DEFAULT_LABEL = 'WLAN';
const DND_COUNT = 'dnd_count';
const DND_DISABLE_DIALOG_COUNT = 3;

export class AccessibilityUtilExt {
  public static isSupportVibrate: boolean =
    systemParameterEnhance.getSync('const.vibrator.support_vibrator', 'true') === 'true';
  /**
   * 获取开关无障碍播报文案
   *
   * @param viewData 开关信息
   * @returns 播报文案
   */
  public static getToggleText(toggleId: string, viewData: ToggleViewData | null): string {
    if (!AccessibilityUtil.isAccessibilityMode() || viewData === null) {
      return '';
    }
    let toggleLabel = typeof viewData.label === 'string' ? viewData.label : AccessibilityUtilExt.getResourceStr(viewData.label);
    log.showInfo(`AccessibilityUtilExt getToggleText slot: ${toggleId} label:${toggleLabel}`);

    if (toggleLabel === null) {
      return '';
    }
    if (viewData.isUnavailable) {
      return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_switch'), toggleLabel) +
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_toggle_unavailable'));
    }
    let toggleAccessibilityText = '';
    switch (toggleId) {
      case FASlotName.WIFI:
      case FASlotName.WIFI_UI_EXTENSION:
        toggleAccessibilityText = (viewData.isOn ? ResUtils.getInnerString($r('app.string.cc_accessibility_str_close_action')) : ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_action'))) + ' ' +
        ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_switch'), WLAN_DEFAULT_LABEL);
        break;
      case FASlotName.BLUETOOTH:
      case FASlotName.BLUETOOTH_UI_EXTENSION:
        toggleAccessibilityText = (viewData.isOn ? ResUtils.getInnerString($r('app.string.cc_accessibility_str_close_action')) : ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_action'))) + ' ' +
        ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_switch'), ResUtils.getInnerString($r('app.string.cc_accessibility_str_bluetooth_name')));
        break;
      case FASlotName.RING_MODE:
      case PluginSlot.SLOT_CONTROL_SCREENSHOT:
      case PluginSlot.SLOT_CONTROL_SCANNER:
      case FASlotName.SOUND:
        toggleAccessibilityText = ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_common_button_str'), toggleLabel);
        break;
      default:
        toggleAccessibilityText = (viewData.isOn ? ResUtils.getInnerString($r('app.string.cc_accessibility_str_close_action'))
          : ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_action'))) + ' ' + ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_switch'), toggleLabel);
        break;
    }
    return toggleAccessibilityText;
  }

  /**
   * 获取附带参数的字符串资源，自动处理format
   *
   * @param strRes 字符串资源
   * @returns format后的字符串
   */
  public static getResourceStr(strRes: Resource | undefined): string {
    if (strRes === undefined) {
      return '';
    }
    if (strRes.params === undefined || CheckEmptyUtils.isEmptyArr(strRes.params)) {
      return ResUtils.getInnerString(strRes);
    }
    let paramArr: (string | number)[] = [];
    paramArr = paramArr.concat(...strRes.params);
    return ResUtils.getInnerStringNumS(strRes, ...paramArr);
  }

  /**
   * 开关播报描述文案生成方法
   *
   * @param viewData 开关信息
   * @returns 开关无障碍播报描述
   */
  public static getToggleDescription(toggleId: string, viewModel: ToggleBaseViewModel | undefined): string {
    if (!AccessibilityUtil.isAccessibilityMode() || viewModel == null) {
      return '';
    }
    let viewData: ToggleViewData = viewModel.getViewData();
    let state: number = viewModel.getState();
    let toggleLabel = typeof viewData.label === 'string' ? viewData.label : ResUtils.getInnerString(viewData.label);
    if (toggleLabel === null) {
      return '';
    }
    if (viewData.isUnavailable) {
      return ' ';
    }
    let toggleDescriptionText = '';
    switch (toggleId) {
      case FASlotName.RING_MODE:
        let nextMode = ResUtils.getInnerString($r('app.string.control_center_complex_toggle_ring_mode_title_off'));
        if (state === audio.AudioRingMode.RINGER_MODE_SILENT) {
          nextMode = ResUtils.getInnerString($r('app.string.control_center_complex_toggle_ring_mode_title_on'));
        } else if (state === audio.AudioRingMode.RINGER_MODE_NORMAL) {
          nextMode = AccessibilityUtilExt.isSupportVibrate ?
            ResUtils.getInnerString($r('app.string.control_center_complex_toggle_ring_mode_title_vibration')) :
            ResUtils.getInnerString($r('app.string.control_center_complex_toggle_ring_mode_title_off'));
        } else if (state === audio.AudioRingMode.RINGER_MODE_VIBRATE) {
          nextMode = ResUtils.getInnerString($r('app.string.control_center_complex_toggle_ring_mode_title_off'));
        }
        toggleDescriptionText = ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_ring_mode_click'), nextMode);
        break;
      case FASlotName.EYE_COMFORT:
        if (viewData.isOn) {
          toggleDescriptionText = ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_switch_click'),
            ResUtils.getInnerString($r('app.string.cc_accessibility_str_close_state')));
        } else {
          toggleDescriptionText = ResUtils.getInnerString($r('app.string.cc_accessibility_str_click'));
        }
        break;
      case PluginSlot.SLOT_CONTROL_SCREENSHOT:
      case PluginSlot.SLOT_CONTROL_SCREEN_RECORDER:
      case PluginSlot.SLOT_CONTROL_SCANNER:
      case FASlotName.CAST:
      case FASlotName.YOUTH_MODE:
      case FASlotName.QUICK_NOTE:
        toggleDescriptionText = ResUtils.getInnerString($r('app.string.cc_accessibility_str_click'));
        break;
      default:
        let nextState = viewData.isOn ? ResUtils.getInnerString($r('app.string.cc_accessibility_str_close_state')) :
          ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_state'));
        toggleDescriptionText = ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_switch_click'),
          nextState);
        break;
    }
    // 如果开关存在二级操作及需要播放此文案
    if ((viewModel.openDetailPageFunc || viewModel.startServiceFunc) &&
      viewModel.customCommonData?.isSupportLongClickAction &&
      AccessibilityUtilExt.needReportDescription(toggleId, viewData.isOn)) {
      toggleDescriptionText += ResUtils.getInnerString($r('app.string.cc_accessibility_str_long_click'));
    }
    return toggleDescriptionText;
  }

  private static needReportDescription(toggleId: string, isOn: boolean): boolean {
    if (toggleId === FASlotName.WIFI_UI_EXTENSION || toggleId === FASlotName.BLUETOOTH_UI_EXTENSION) {
      return isOn;
    }
    return true;
  }

  /**
   * 获取开关Label无障碍播报文案
   *
   * @param viewData 开关信息
   * @returns 播报文案
   */
  public static getToggleLabelText(toggleId: string, viewData: ToggleViewData | null): string {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return '';
    }
    if (viewData === null) {
      return '';
    }
    let toggleLabel = '';
    if (typeof viewData.label === 'string') {
      toggleLabel = viewData.label;
    } else {
      toggleLabel = ResUtils.getInnerString(viewData.label);
    }

    let toggleLabelAccessibilityText = '';
    switch (toggleId) {
      case FASlotName.WIFI:
      case FASlotName.WIFI_UI_EXTENSION:
        if (toggleLabel !== WLAN_DEFAULT_LABEL) {
          toggleLabelAccessibilityText = WLAN_DEFAULT_LABEL +
          ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_connect_state'), toggleLabel);
        }
        toggleLabelAccessibilityText += viewData.isOn ? ResUtils.getInnerString($r('app.string.cc_accessibility_str_wifi_list')) : '';
        break;
      case FASlotName.BLUETOOTH:
      case FASlotName.BLUETOOTH_UI_EXTENSION:
        if (toggleLabel !== ResUtils.getInnerString($r('app.string.cc_accessibility_str_bluetooth_name'))) {
          toggleLabelAccessibilityText = ResUtils.getInnerString($r('app.string.cc_accessibility_str_bluetooth_name')) +
          ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_connect_state'), toggleLabel);
        }
        toggleLabelAccessibilityText += viewData.isOn ? ResUtils.getInnerString($r('app.string.cc_accessibility_str_bluetooth_list')) : '';
        break;
      case FASlotName.HOTSPOT_TAGGED:
        toggleLabelAccessibilityText = toggleLabel;
        if (typeof viewData.subLabel === 'string') {
          toggleLabelAccessibilityText += ' ' + viewData.subLabel;
        } else {
          if (viewData.subLabel?.params && viewData.subLabel.params.length > 0) {
            toggleLabelAccessibilityText += ' ' +
              ResUtils.getInnerPluralByResource(viewData.subLabel, viewData.subLabel.params[0]);
          } else {
            toggleLabelAccessibilityText += ' ' + ResUtils.getInnerString(viewData.subLabel);
          }
        }
        break;
      case FASlotName.MOBILE_DATA_TAGGED:
        toggleLabelAccessibilityText = `${typeof viewData.label === 'string' ? viewData.label :
          AccessibilityUtilExt.getResourceStr(viewData.label)} ${typeof viewData.subLabel === 'string' ?
          viewData.subLabel : AccessibilityUtilExt.getResourceStr(viewData.subLabel)}`
        break;
      default:
        toggleLabelAccessibilityText = toggleLabel;
        break;
    }
    return toggleLabelAccessibilityText;
  }

  /**
   * 获取开关点击动作无障碍播报文案
   *
   * @param state 开关信息
   * @returns 点击播报文案
   */
  public static getToggleIconClickText(toggleId: string, model: ToggleBaseViewModel | undefined): string {
    if (!AccessibilityUtil.isAccessibilityMode() || model == null) {
      return '';
    }
    let state: ToggleViewData = model.getViewData();
    if (state == null) {
      return '';
    }
    let toggleAccessibilityText = '';
    if (state.isUnavailable) {
      return ResUtils.getInnerString($r('app.string.cc_accessibility_str_toggle_unavailable'));
    }
    switch (toggleId) {
      case FASlotName.RING_MODE:
        if (model.getState() === audio.AudioRingMode.RINGER_MODE_SILENT) {
          toggleAccessibilityText = ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_ringer_mode_normal'));
        } else if (model.getState() === audio.AudioRingMode.RINGER_MODE_NORMAL) {
          toggleAccessibilityText =
            AccessibilityUtilExt.isSupportVibrate ? ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_ringer_mode_vibrate')) :
            ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_ringer_mode_silent'));
        } else if (model.getState() === audio.AudioRingMode.RINGER_MODE_VIBRATE) {
          toggleAccessibilityText = ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_ringer_mode_silent'));
        }
        break;
      case PluginSlot.SLOT_CONTROL_SCREENSHOT:
      case PluginSlot.SLOT_CONTROL_SCANNER:
      case FASlotName.CAMERA:
      case FASlotName.SOUND:
      case FASlotName.SUPER_PRIVACY:
      case PluginSlot.SLOT_CONTROL_CAST:
      case PluginSlot.SLOT_CONTROL_SHARE:
      case FASlotName.CAST:
      case FASlotName.YOUTH_MODE:
        toggleAccessibilityText = '';
        break;
      case FASlotName.FOCUS_MODE:
        const dndCount: number = Number(sSettingsUtil.getSystemValue(DND_COUNT, '0'));
        let isShowDialog = (!isNaN(dndCount) && dndCount < DND_DISABLE_DIALOG_COUNT);
        toggleAccessibilityText = state.isOn ? ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_action')) :
          isShowDialog ? '' : ResUtils.getInnerString($r('app.string.cc_accessibility_str_close_action'));
        break;
      case FASlotName.MUSIC_SERVICE:
        toggleAccessibilityText = AppStorage.get('lockStatus') === 1 || !state.isOn ? '' : ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_action'));
        break;
      case FASlotName.SUPER_HUB:
        toggleAccessibilityText = AppStorage.get('lockStatus') === 1 || state.isOn ? '' : ResUtils.getInnerString($r('app.string.cc_accessibility_str_close_action'));
        break;
      default:
        if ((toggleId === FASlotName.LOCATION || toggleId === FASlotName.NFC) && (AppStorage.get('lockStatus') === 1)) {
          return '';
        }
        toggleAccessibilityText = state.isOn ? ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_action'))
          : ResUtils.getInnerString($r('app.string.cc_accessibility_str_close_action'));
        break;
    }
    return toggleAccessibilityText;
  }

  /**
   * 获取开关编辑拖动落位时无障碍播报文案
   *
   * @param curLength 当前开关长度
   * @param quickToggleMax 开关数最大限制
   * @param quickToggleMin 开关数最小限制
   * @param toggleColumns 每行开关数
   * @param isAdd 是否添加场景
   * @returns 播报文案
   */
  public static getEditToggleReportText(curLength: number, quickToggleMax: number, quickToggleMin: number,
                                        toggleColumns: number, isAdd: boolean): string {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return '';
    }
    if ((curLength > quickToggleMax && isAdd) || (curLength < quickToggleMin && !isAdd)) {
      return '';
    }
    if (isAdd) {
      let line = Math.floor((curLength - 1) / toggleColumns) + 1;
      let row = curLength % toggleColumns !== 0 ? curLength % toggleColumns : toggleColumns;
      return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_add_toggle_coordinates'), line, row);
    }
    return ResUtils.getInnerString($r('app.string.cc_accessibility_str_edit_remove_toggle_action'));
  }

  /**
   * 获取开关编辑角标按钮无障碍播报文案
   *
   * @param state 开关信息
   * @returns 播报文案
   */
  public static getEditToggleActionText(slot: string): string {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return '';
    }
    let toggleLabel = ControlCenterAccessibilityDataModel.getInstance().get(slot);
    return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_remove_toggle_new'), toggleLabel);
  }

  /**
   * 获取开关编辑无障碍播报文案
   *
   * @param state 开关信息
   * @returns 播报文案
   */
  public static getEditToggleText(slot: string): string {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return '';
    }
    return ControlCenterAccessibilityDataModel.getInstance().get(slot);
  }

  /**
   * 获取备选库开关无障碍播报文案
   *
   * @param state 开关信息
   * @returns 备选库开关播报文案
   */
  public static getEditPreviewToggleText(slot: string): string {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return '';
    }
    let toggleLabel = ControlCenterAccessibilityDataModel.getInstance().get(slot);
    let editPreviewToggleAccessibilityText = ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_add_toggle'), toggleLabel);
    return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_add_toggle'), toggleLabel);
  }

  /**
   * 获取开关编辑拖动排序时无障碍播报文案
   *
   * @param itemColumnNumber 每行开关数量
   * @param toIndex 当前所在位置的index
   * @returns 播报文案
   */
  public static getToggleMoveItemText(itemColumnNumber: number, toIndex: number): string {
    if (!AccessibilityUtil.isAccessibilityMode() || itemColumnNumber <= 0) {
      return '';
    }
    let line = Math.floor((toIndex) / itemColumnNumber) + 1;
    let row = (toIndex + 1) % itemColumnNumber !== 0 ? (toIndex + 1) % itemColumnNumber : itemColumnNumber;
    let toggleMoveItemText = ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_coordinates'), line, row);
    return toggleMoveItemText;
  }

  /**
   * 获取开关编辑拖动排序，松手放置时的无障碍播报文案
   *
   * @param itemColumnNumber 每行开关数量
   * @param defaultIndex 开关当前位置
   * @returns 播报文案
   */
  public static getTogglePlaceItemText(itemColumnNumber: number, defaultIndex: number): string {
    if (!AccessibilityUtil.isAccessibilityMode() || defaultIndex < 0 || itemColumnNumber <= 0) {
      return '';
    }
    let line = Math.floor((defaultIndex) / itemColumnNumber) + 1;
    let row = (defaultIndex + 1) % itemColumnNumber !== 0 ?
      (defaultIndex + 1) % itemColumnNumber : itemColumnNumber;
    let toggleMoveItemText = ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_coordinates'), line, row);
    return toggleMoveItemText;
  }
}



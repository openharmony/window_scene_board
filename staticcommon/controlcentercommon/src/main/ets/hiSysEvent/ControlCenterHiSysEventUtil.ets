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

import hiSysEvent from '@ohos.hiSysEvent';
import { LogDomain, LogHelper, TaskpoolUtil } from '@ohos/basicutils';
import { CCNumberSwitchToast, QuickToggleTristateParams, ReportParams } from './ControlCenterReportParams';
import type {
  CCEditIconClick,
  CCEditExpandLibrary,
  CCEditCollapseLibrary,
  CCEditAddQuickSwitch,
  CCEditRemoveQuickSwitch,
  CCEditClickSuccess,
  CCEditDialogClickSave,
  CCEditDialogClickCancel,
  CCEditMoveSwitch,
  CCNCAutoHide,
  CCClickPrivacySensor,
  CCClickMultimediaSensor,
  CCPrivacySensorShow,
  CCDataClone,
  CCBrightnessClick,
} from './ControlCenterReportParams';

const TAG = 'HiSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 大数据用户行为相关打点工具类
 */
export class ControlCenterHiSysEventUtil {
  private static CONTROLCENTER_UE: string = 'CONTROLCENTER_UE';
  // 点击编辑按钮进入编辑页面
  private static CC_CLICK_EDIT_BUTTON: string = 'CC_CLICK_EDIT_BUTTON';
  // 编辑页展开备选库
  private static CC_EDIT_EXPAND_LIBRARY: string = 'CC_EDIT_EXPAND_LIBRARY';
  // 编辑页收起备选库
  private static CC_EDIT_COLLAPSE_LIBRARY: string = 'CC_EDIT_COLLAPSE_LIBRARY';
  // 编辑页添加快捷开关
  private static CC_EDIT_ADD_QUICK_SWITCH: string = 'CC_EDIT_ADD_QUICK_SWITCH';
  // 编辑页移除快捷开关
  private static CC_EDIT_REMOVE_QUICK_SWITCH: string = 'CC_EDIT_REMOVE_QUICK_SWITCH';
  // 编辑页点击完成按钮
  private static CC_EDIT_CLICK_SUCCESS: string = 'CC_EDIT_CLICK_SUCCESS';
  // 编辑页保存修改弹框点击保存按钮
  private static CC_EXIT_EDIT_DIALOG_CLICK_SAVE: string = 'CC_EXIT_EDIT_DIALOG_CLICK_SAVE';
  // 编辑页保存修改弹框点击不保存按钮
  private static CC_EXIT_EDIT_DIALOG_CLICK_CANCEL: string = 'CC_EXIT_EDIT_DIALOG_CLICK_CANCEL';
  // 编辑页移动快捷开关
  private static CC_EXIT_MOVE_SWITCH: string = 'CC_EXIT_MOVE_SWITCH';
  // 双中心自动收起
  private static CC_NC_AUTO_HIDE: string = 'CC_NC_AUTO_HIDE';
  // 点击隐私指示器
  private static CC_CLICK_PRIVACY_SENSOR: string = 'CC_CLICK_PRIVACY_SENSOR';
  // 显示隐私指示器
  private static CC_PRIVACY_SENSOR_SHOW: string = 'CC_PRIVACY_SENSOR_SHOW';
  // 点击多媒体指示器
  private static CC_CLICK_MULTIMEDIA_SENSOR: string = 'CC_CLICK_MULTIMEDIA_SENSOR';
  // 控制中心克隆打点
  private static CC_DATA_CLONE: string = 'CC_DATA_CLONE';
  // 控制中心编辑快捷开关数量限制toast提示打点
  private static CC_NUMBERSWITCH_TOAST: string = 'CC_NUMBERSWITCH_TOAST';
  // 控制中心点击亮度条打点
  private static CC_BRIGHTNESS_CLICK: string = 'CC_BRIGHTNESS_CLICK';
  // 三态开关 打点
  private static readonly QUICK_TOGGLE_TRISTATE: string = 'QUICK_TOGGLE_TRISTATE';
  // 三态开关 打点
  private static readonly QUICK_TOGGLE_TRISTATE_CLICK: string = 'QUICK_TOGGLE_TRISTATE_CLICK';

  protected constructor() {
  }

  /**
   * 打点基础接口
   *
   * @deprecated
   * @useinstead HiSysReportEvent#reportFault/reportStatistic/reportSecurity/reportBehavior
   * @param domain 事件领域
   * @param name 事件名称
   * @param eventType 事件类型
   * @param params 事件参数
   */
  static report(domain: string, name: string, eventType: hiSysEvent.EventType, params: Object): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: domain,
      name: name,
      eventType: eventType,
      params: params
    };
    TaskpoolUtil.doTask(reportHiSysEvent, sysEventInfo);
  }

  /**
   * 控制中心点击亮度条打点
   *
   * @param params 参考CCBrightnessClick
   */
  static reportCCBrightnessClick(params: CCBrightnessClick): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_BRIGHTNESS_CLICK, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心点击编辑按钮打点
   *
   * @param params 参考CCEditIconClick
   */
  static reportCCEditIconClick(params: CCEditIconClick): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_CLICK_EDIT_BUTTON, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心编辑页点击进入备选库打点
   *
   * @param params 参考CCEditExpandLibrary
   */
  static reportCCEditExpandLibrary(params: CCEditExpandLibrary): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_EDIT_EXPAND_LIBRARY, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心编辑页收起备选库打点
   *
   * @param params 参考CCEditCollapseLibrary
   */
  static reportCCEditCollapseLibrary(params: CCEditCollapseLibrary): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_EDIT_COLLAPSE_LIBRARY, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心编辑页添加快捷开关打点
   *
   * @param params 参考CCEditAddQuickSwitch
   */
  static reportCCEditAddQuickSwitch(params: CCEditAddQuickSwitch): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_EDIT_ADD_QUICK_SWITCH, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心编辑页移除快捷开关打点
   *
   * @param params 参考CCEditRemoveQuickSwitch
   */
  static reportCCEditRemoveQuickSwitch(params: CCEditRemoveQuickSwitch): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_EDIT_REMOVE_QUICK_SWITCH, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心编辑快捷开关数量限制toast提示打点
   *
   * @param UPPER_LOWER_THRESHOLDS_SWITCH_VALUE 开关数量上下限标识
   * @param TOAST_NUMBER_SWITCH_VALUE 弹toast时开关数量
   * @param START_TIME_VALUE 本次进入控制中心的时间戳
   */
  static reportCCNumberSwitchToast(params: CCNumberSwitchToast): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_NUMBERSWITCH_TOAST, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心编辑页点击完成按钮打点
   *
   * @param params 参考CCEditClickSuccess
   */
  static reportCCEditClickSuccess(params: CCEditClickSuccess): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_EDIT_CLICK_SUCCESS, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心编辑页保存修改弹框点击保存按钮打点
   *
   * @param params 参考CCEditDialogClickSave
   */
  static reportCCEditDialogClickSave(params: CCEditDialogClickSave): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_EXIT_EDIT_DIALOG_CLICK_SAVE, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心编辑页保存修改弹框点击不保存按钮打点
   *
   * @param params 参考CCEditDialogClickCancel
   */
  static reportCCEditDialogClickCancel(params: CCEditDialogClickCancel): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_EXIT_EDIT_DIALOG_CLICK_CANCEL, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心编辑页移动快捷开关打点
   *
   * @param params 参考CCEditMoveSwitch
   */
  static reportCCEditMoveSwitch(params: CCEditMoveSwitch): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_EXIT_MOVE_SWITCH, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心双中心自动收起打点
   *
   * @param params 参考CCNCAutoHide
   */
  static reportCCNCAutoHide(params: CCNCAutoHide): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_NC_AUTO_HIDE, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心点击隐私指示器打点
   *
   * @param params 参考CCClickPrivacySensor
   */
  static reportCCClickPrivacySensor(params: CCClickPrivacySensor): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_CLICK_PRIVACY_SENSOR, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心点击多媒体指示器打点
   *
   * @param params 参考CCClickPrivacySensor
   */
  static reportCCClickMultimediaSensor(params: CCClickMultimediaSensor): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_CLICK_MULTIMEDIA_SENSOR, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心显示隐私指示器打点
   *
   * @param params 参考CCPrivacySensorShow
   */
  static reportCCPrivacySensorShow(params: CCPrivacySensorShow): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_PRIVACY_SENSOR_SHOW, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心克隆打点
   *
   * @param params 参考CCDataClone
   */
  static reportCCDataClone(params: CCDataClone): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.CC_DATA_CLONE, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 快捷开关_WIFI,蓝牙三态 打点
   *
   * @param slot 蓝牙或者WIFI
   * @param state 当前状态
   */
  static reportQuickToggleTristateMode(params: QuickToggleTristateParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.QUICK_TOGGLE_TRISTATE, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 快捷开关_WIFI,蓝牙三态 点击打点
   *
   * @param slot 蓝牙或者WIFI
   * @param curState 当前状态
   * @param nextState 下一个状态
   */
  static reportQuickToggleTristateModeClick(params: QuickToggleTristateParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ControlCenterHiSysEventUtil.report(ControlCenterHiSysEventUtil.CONTROLCENTER_UE,
      ControlCenterHiSysEventUtil.QUICK_TOGGLE_TRISTATE_CLICK, hiSysEvent.EventType.BEHAVIOR, params);
  }
}

async function reportHiSysEvent(sysEventInfo: hiSysEvent.SysEventInfo): Promise<void> {
  'use concurrent';
  const TAG = 'HiSysEventUtil';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
  try {
    hiSysEvent.write(sysEventInfo)
      .catch(
        () => {
          log.error('HiSysEventUtil reportHiSysEvent error:');
        }
      )
      .then(
        val => {
          log.showDebug(`HiSysEventUtil reportHiSysEvent ${sysEventInfo.name} success.`);
        });
    log.showDebug(`CCHiSysEventUtil reportHiSysEvent ${sysEventInfo.domain}, ${sysEventInfo.name}, ${sysEventInfo.eventType}, success.`);
  } catch (err) {
    log.error('reportHiSysEvent error:' + err);
  }
}

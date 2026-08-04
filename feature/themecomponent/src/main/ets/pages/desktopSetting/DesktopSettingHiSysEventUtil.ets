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

import { hiSysEvent } from '@kit.PerformanceAnalysisKit';
import { Log } from '../../aigcServiceAbility/IdlService/Log';
import { BaseParams, SettingSwitchParams } from './DesktopSettingReportParams';

const TAG: string = 'DesktopSettingHiSysEventUtil';

/**
 * 设置-桌面和个性设计打点类
 */
export class DesktopSettingHiSysEventUtil {
  private static SCENE_BOARD_UE_DOMAIN: string = 'SCENE_BOARD_UE';
  /**
   * 设置-桌面和个性-桌面设置
   */
  private static SETTING_ENTER_HOME_SCREEN: string = 'SETTING_ENTER_HOME_SCREEN';
  /**
   * 设置-桌面和个性化-桌面设置-负一屏设置
   */
  private static SETTING_ENTER_INTELLIGENT: string = 'SETTING_ENTER_INTELLIGENT';
  /**
   * 桌面-桌面设置-桌面下滑开关
   */
  private static SETTING_VOICE_SEARCH_SWITCH: string = 'SETTING_VOICE_SEARCH_SWITCH';
  /**
   * 桌面设置-桌面布局-自动对齐开关
   */
  private static SETTING_AUTO_ALIGN_SWITCH: string = 'SETTING_AUTO_ALIGN_SWITCH';
  /**
   * 桌面-桌面设置-锁定布局开关
   */
  private static SETTING_LOCK_LAYOUT_SWITCH: string = 'SETTING_LOCK_LAYOUT_SWITCH';

  protected constructor() {
  }

  /**
   * 设置-桌面和壁纸-桌面设置
   */
  static reportSettingEnterHomeScreen(): void {
    Log.debug(TAG, 'reportSettingEnterHomeScreen');
    // HiSysEventUtil.report(DesktopSettingHiSysEventUtil.SCENE_BOARD_UE_DOMAIN,
    //   DesktopSettingHiSysEventUtil.SETTING_ENTER_HOME_SCREEN, hiSysEvent.EventType.BEHAVIOR, new BaseParams());
  }

  /**
   * 设置-桌面和个性化-桌面设置-负一屏设置
   */
  static reportSettingEnterIntelligent(): void {
    Log.debug(TAG, 'reportSettingEnterIntelligent');
    // HiSysEventUtil.report(DesktopSettingHiSysEventUtil.SCENE_BOARD_UE_DOMAIN,
    //   DesktopSettingHiSysEventUtil.SETTING_ENTER_INTELLIGENT, hiSysEvent.EventType.BEHAVIOR, new BaseParams());
  }

  /**
   * 桌面-桌面设置-桌面下滑开关
   */
  static reportSettingVoiceSearchSwitch(isOn: boolean): void {
    Log.debug(TAG, 'reportSettingVoiceSearchSwitch');
    // let params = new SettingSwitchParams();
    // params.IS_ON = isOn ? 1 : 0;
    // HiSysEventUtil.report(DesktopSettingHiSysEventUtil.SCENE_BOARD_UE_DOMAIN,
    //   DesktopSettingHiSysEventUtil.SETTING_VOICE_SEARCH_SWITCH, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 桌面设置-桌面布局-自动对齐开关
   */
  static reportSettingAutoAlignSwitch(isOn: boolean): void {
    Log.debug(TAG, 'reportSettingAutoAlignSwitch');
    // let params = new SettingSwitchParams();
    // params.IS_ON = isOn ? 1 : 0;
    // HiSysEventUtil.report(DesktopSettingHiSysEventUtil.SCENE_BOARD_UE_DOMAIN,
    //   DesktopSettingHiSysEventUtil.SETTING_AUTO_ALIGN_SWITCH, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 桌面-桌面设置-锁定布局开关
   */
  static reportSettingLockLayoutSwitch(isOn: boolean): void {
    Log.debug(TAG, 'reportSettingLockLayoutSwitch');
    // let params = new SettingSwitchParams();
    // params.IS_ON = isOn ? 1 : 0;
    // HiSysEventUtil.report(DesktopSettingHiSysEventUtil.SCENE_BOARD_UE_DOMAIN,
    //   DesktopSettingHiSysEventUtil.SETTING_LOCK_LAYOUT_SWITCH, hiSysEvent.EventType.BEHAVIOR, params);
  }
}


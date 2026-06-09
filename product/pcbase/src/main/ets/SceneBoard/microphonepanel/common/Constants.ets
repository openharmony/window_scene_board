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

export default class Constants {
  static readonly WINDOW_WIDTH: number = 360;
  static readonly WINDOW_HEIGHT: number = 109;
  static readonly HAD_WINDOW_HEIGHT: number = 108;

  static readonly CARD_WIDTH: string = '100%';
  static readonly CARD_DEFAULT_HEIGHT: number = 0;
  static readonly CARD_HEIGHT: number = 81;
  static readonly TITLE_HEIGHT: number = 32;
  static readonly CARD_CALL_HEIGHT: number = 91;
  static readonly CARD_CALL_DEFAULT_HEIGHT: number = 82;
  static readonly CARD_NOISE_HEIGHT: number = 40;
  static readonly CARD_MORE_HEIGHT: number = 42;

  static readonly CARD_CALL_ENHANCEMENT_HEIGHT: number = 82;

  static readonly REQUEST_FOCUS_MENU = 'request_focus_menu_sound';
  static DEFAULT_DEVICE_ID = -1;
  static DELAY_TIME = 500;

  static MICROPHONE_SETTINGS_DEVICES_GAP = 2;
  static MICROPHONE_SETTINGS_HORIZONTAL_MARGIN = 16;
  static MICROPHONE_SETTINGS_TOP_MARGIN = 9;
  static MICROPHONE_SETTINGS_BOTTOM_MARGIN = 7;
  static MICROPHONE_SETTINGS_TEXT_HEIGHT = 24;
  static ENABLE_OPACITY = 1;
  static DISABLE_OPACITY = 0.6;
  static EDGEANTIALIASING_VALUE = 0.4;

  static PCSETTINGS_BUNDLE_NAME = 'com.ohos.pcsettings';

  static CALL_REINFORCE_USER_SELECTION_MULTIPLE = '2';
  static CALL_REINFORCE_USER_SELECTION_SINGLE = '1';
  static CALL_REINFORCE_USER_SELECTION_DEFAULT = '0';

  static VOLUME_PRIVACY_AGREEMENT_AGREE = '1';
  static VOLUME_PRIVACY_AGREEMENT_DISAGREE = '0';
}

export class XmlConstants {
  // Audio Configuring Resources
  static AUDIO_CONFIG_RESOURCE_DIRECTORY = '/sys_prod/etc/audio/sound/';
  static SOUND_XML_CONFIG_RESOURCE = '/sys_prod/etc/audio/sound/sound_config.xml';
  static SOUND_SUPPORT_LOGO = 'SoundLogoSupport';
  static SOUND_SUPPORT_VOCALCANCEL = 'AISS';
  static SOUND_SUPPORT_CALLNOISEREDUCT = 'VoipDownAINR';
  static SOUND_SUPPORT_CALLREINFORCE = 'VoipUPSmartNR';
  static SOUND_SUPPORT_RECORDNOISEREDUCT = 'RecordNR';
  static SOUND_SUPPORT_DEVICESELECT = 'DeviceSelectByAPP';
  static SOUND_SUPPORT_ENABLE = '1';
}

export class SettingsKeyConstants {
  /* 隐私协议签署 */
  static readonly PRIVACY_AGREEMENT_SIGNED: string = 'settings.privacy_agreement.signed';
  /* 隐私协议上次触发时间 */
  static readonly PRIVACY_AGREEMENT_TRIGGER_TIME: string = 'settings.privacy_agreement.trigger_time';
  /* SOUND功能用户选择 */
  static readonly PRIVACY_AGREEMENT_DIALOG_EJECTS: string = 'settings.privacy_agreement.dialog_ejects';
  /* SOUND功能用户选择 */
  static readonly SOUND_USER_SELECTIONS: string = 'settings.sound.user_selection_';
  /* 输出 —— SOUND 声音消除音效选择 */
  static readonly SOUND_AI_AISS_SELECT: string = 'settings.sound_ai_aiss_selection';
  /* 输出 —— SOUND 通话对端降噪音效选择 */
  static readonly SOUND_AI_VOIP_DOWN_SELECT: string = 'settings.sound_ai_voip_down_selection';
  /* 输入 —— SOUND 通话增强音效选择 */
  static readonly SOUND_AI_VOIP_UP_SELECT: string = 'settings.sound_ai_voip_up_selection';
  /* 输入 —— SOUND 录音噪音效选择 */
  static readonly SOUND_AI_RECORD_SELECT: string = 'settings.sound_ai_record_selection';
}

export interface StateChangeListener { onStateChange: Function }
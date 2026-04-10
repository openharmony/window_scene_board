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
import i18n from '@ohos.i18n';
// import { MemoryUtils } from '@ohos/windowscene';

export class SettingsKeyConstants {
  /* 隐私协议签署状态 */
  static readonly PRIVACY_AGREEMENT_SIGNED: string = 'settings.privacy_agreement.signed';
  /* SOUND功能用户选择 */
  static readonly PRIVACY_AGREEMENT_DIALOG: string = 'settings.privacy_agreement.dialog_ejects';
  static readonly SOUND_PERMISSION: string = 'sound_permission';
  static readonly SOUND_PERMISSION_DETAIL: string = 'permission_detail';
}

export class StyleConstants {
  static readonly DEFAULT_DIALOG_HEIGHT = 560;
  static readonly DEFAULT_DIALOG_WIDTH = 480;
  static readonly SUPPORTED_CONTENT_HEIGHT = 333;
  static readonly UNSUPPORTED_CONTENT_HEIGHT = 425;
  static readonly HEARD_MARGIN = 72;
  static readonly SUPPORTED_HEARD_MARGIN = 20;
  static readonly TEXT_PADDING = 24;
  static readonly PRIVACY_MARGIN = 4;
  static readonly PRIVACY_IMAGE_SIZE = 24;
  static readonly DETAIL_IMAGE_SIZE = 32;
  static readonly IC_SIZE = 72;
  static readonly BACK_IC_WIDTH = 10;
  static readonly BACK_IC_HEIGHT = 16;
  static readonly BACK_IC_SIZE = 40;
  static readonly BACK_IC_MARGIN = 16;
  static readonly TEXT_TOP_MARGIN = 17;
  static readonly BUTTON_PADDING_TOP = 8;
  static readonly BUTTON_PADDING_BOTTOM = 8;
  static readonly BUTTON_PADDING_LEFT = 16;
  static readonly BUTTON_PADDING_RIGHT = 16;
  static readonly BUTTON_MARGIN_TOP = 24;
  static readonly BUTTON_MARGIN_BOTTOM = 16;
  static readonly DETAIL_DIALOG_HEIGHT = 488;
  static readonly DETAIL_CONTENT_MARGIN_BOTTOM = 24;
  static readonly DEFAULT_BUTTON_HEIGHT = '40vp';
  static readonly TEXT_LINEHEIGHT = '19vp';
  static readonly TEXT_LIHEIGHT = '19vp';
  static readonly TEXT_MINFONTSIZE = '16fp';
  static readonly TEXT_MAXFONTSIZE = '30fp';
  static readonly DETAIL_TEXT_MAXFONTSIZE = '19fp';
  static readonly DETAIL_TEXT_LINEHEIGHT = '24vp';
  static readonly DETAIL_TEXT_FONTSIZE = '14vp';
  static readonly DETAIL_TITLE_FONTSIZE = '16vp';
  static readonly DETAIL_TITLE_LINEHEIGHT = '29vp';
  static readonly PRIVACYTEXT_MINFONTSIZE = '10fp';
  static readonly PRIVACYTEXT_MAXFONTSIZE = '14fp';
  static readonly TITLE_TEXT_LINEHEIGHT = '40vp';
  static readonly DIALOG_BORDER_RADIUS = '8vp';
  static readonly TEXT_FONTSIZE = '10vp';
  static readonly FIRST_TEXT_LINEHEIGHT = '13vp';
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

export class DataConstants {
  static readonly MSG_CODE = 1;
  static readonly DATA_INT = 3;
  static readonly BUNDLENAME = 'bundleName';
  static readonly BUNDLENAME_DETAIL = 'com.ohos.sceneboard';
  static readonly ABILITYNAME = 'abilityName';
  static readonly ABILITYNAME_DETAIL = 'SoundPermissionAbility';
  static readonly PARAMETERS = 'parameters';
  static readonly YEAR = 2024;
  static readonly MOUTH = 6;
  static readonly DATE = 9;
  static readonly ONE = 1;
  static readonly TWO = 2;
  static readonly THREE = 3;
  static readonly FOUR = 4;
  static readonly FIVE = 5;
}

class TimeUtil {
  public static formatTime(year: number, mouth: number, date: number): string {
    let timeFormat =
      new Intl.DateTimeFormat(i18n.System.getSystemLocale(), { year: 'numeric', month: 'long', day: 'numeric' });
    let formatDate = new Date();
    formatDate.setFullYear(year, mouth, date);
    let result: string = timeFormat.format(formatDate);
    // MemoryUtils.removeNapiWrap(timeFormat, false);
    return result;
  }
}

export { TimeUtil };
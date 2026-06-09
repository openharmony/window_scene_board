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

import { ResUtils } from '@ohos/windowscene';
import { KeyGuardMode } from '@ohos/screenlockcommon';
import { BaseViewData } from '@ohos/screenlockcommon/Index';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { IThemeParam } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import MirrorAniConfig from '@ohos/screenlockcomponent/src/main/ets/onemirror/model/MirrorAnimationConf';

@Observed
export class SpecialModeViewData extends BaseViewData {
  public curMode: KeyGuardMode = KeyGuardMode.DEFAULT;
  public lastModeData: LostModeViewData = new LostModeViewData();
  public thermalSafetyModeViewData: ThermalSafetyModeViewData = new ThermalSafetyModeViewData();
  public powerEmergencyModeViewData: PowerEmergencyModeViewData = new PowerEmergencyModeViewData();
  public isOuterSmallLossMode: boolean = false;
  public lockIconHeight: number = Constants.SCREENLOCK_LOCK_ICON_HEIGHT;
  public loadRemindTextWidth: string = Constants.LOAD_REMIND_TEXT_WIDTH;
  public loadRemindTextMarginBottom: string = Constants.LOAD_REMIND_TEXT_MARGIN_BOTTOM;
  public lockIconMarginTop: number = Constants.SCREENLOCK_LOCK_ICON_MARGIN_TOP;
  public isFoldExpand: boolean = false;
  public themeClockParam: IThemeParam | null = null;
  public clockStyle: AnyClock = new AnyClock();
  public lockIconConf: MirrorAniConfig = new MirrorAniConfig();
  public lockIconScale: number = 1;
  public lockIconOpacity: number = 1;
  public clockOpacity: number = 1;
  public clockScale: number = 1;
  public ntfOpacity: number = 1;
  public blurRatio: number = 0.0;
  public isShowPwdInput: boolean = false;
  public lowPositionConf: MirrorAniConfig = new MirrorAniConfig();
  public isPadPortrait: boolean = false;
  public gridWidth: number = 0;

  getSpecialModeTextInfo(): string {
    if (this.curMode === KeyGuardMode.LOST_MODE) {
      return this.lastModeData.lostModeLockedInfo;
    }
    if (this.curMode === KeyGuardMode.POWER_EMERGENCY) {
      return ResUtils.getInnerString($r('app.string.emergency_mode_title'));
    }
    return '';
  }
}

export class LostModeViewData {
  /**
   * 是否打开丢失模式
   */
  public isLostMode: boolean = false;
  /**
   * 丢失模式提示文案
   */
  public lostModeLockedInfo: string = '';
}

export class ThermalSafetyModeViewData {
}

export class PowerEmergencyModeViewData {
  // 低电量应急模式
  public textInfo: string = '';
}

export class LostModeConstants {
  public static LOCK_STATE_KEY = 'find_device_remote_lock|SECURE_DB';
  public static LOCK_INFO_KEY = 'find_device_remote_lock_info|SECURE_DB';
  public static LOCK_INFO_DEFAULT_VALUE = '';
  public static LOCK_STATE_DEFAULT_VALUE = '0';
  public static LOCK_STATE_OPEN_VALUE = '1';
}
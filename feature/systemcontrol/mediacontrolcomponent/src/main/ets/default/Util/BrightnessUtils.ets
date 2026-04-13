/*
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BrightnessOptionUtils } from '@ohos/systemuicommon/src/main/ets/template/newStyle/BrightnessOptionUtils';
import { HashMap } from '@kit.ArkTS';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';

export enum BrightnessTypeEnum {
  BRIGHTNESS_NONE,
  ICON_BRIGHTNESS_LIGHT,
  ICON_BRIGHTNESS_DARK,
  TEXT_SUB_BRIGHTNESS_LIGHT,
  TEXT_SUB_BRIGHTNESS_DARK,
  DEVICE_SWITCH_DEFAULT_LIGHT,
  DEVICE_SWITCH_DEFAULT_DARK,
  DEVICE_SWITCH_ON_LIGHT,
  DEVICE_SWITCH_ON_DARK,
  DEVICE_SWITCH_BGC_DEFAULT_LIGHT,
  DEVICE_SWITCH_BGC_DEFAULT_DARK,
  DEVICE_SWITCH_BGC_ON_LIGHT,
  DEVICE_SWITCH_BGC_ON_DARK,
}

export default class BrightnessUtils {
  private static instance: BrightnessUtils;
  private mBrightnessHashMap: HashMap<BrightnessTypeEnum, BrightnessOptions> = new HashMap();
  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  constructor() {
    this.mBrightnessHashMap.set(BrightnessTypeEnum.BRIGHTNESS_NONE, undefined);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.ICON_BRIGHTNESS_LIGHT,
      BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.ICON_BRIGHTNESS_DARK,
      BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.TEXT_SUB_BRIGHTNESS_LIGHT,
      BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.TEXT_SUB_BRIGHTNESS_DARK,
      BrightnessOptionUtils.getInstance().foregroundTertiaryDarkOption);

    this.mBrightnessHashMap.set(BrightnessTypeEnum.DEVICE_SWITCH_DEFAULT_LIGHT,
      BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.DEVICE_SWITCH_DEFAULT_DARK,
      BrightnessOptionUtils.getInstance().foregroundPrimaryOptionOnBackgroundDark);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.DEVICE_SWITCH_ON_LIGHT,
      BrightnessOptionUtils.getInstance().foregroundPrimaryOnOptionLight);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.DEVICE_SWITCH_ON_DARK,
      BrightnessOptionUtils.getInstance().foregroundPrimaryOnOptionDark);

    this.mBrightnessHashMap.set(BrightnessTypeEnum.DEVICE_SWITCH_BGC_DEFAULT_LIGHT,
      BrightnessOptionUtils.getInstance().customWifiBg);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.DEVICE_SWITCH_BGC_DEFAULT_DARK,
      BrightnessOptionUtils.getInstance().customWifiBgDark);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.DEVICE_SWITCH_BGC_ON_LIGHT,
      BrightnessOptionUtils.getInstance().customWifiBgOn);
    this.mBrightnessHashMap.set(BrightnessTypeEnum.DEVICE_SWITCH_BGC_ON_DARK,
      BrightnessOptionUtils.getInstance().customWifiBgOnDark);
  }

  public static getInstance(): BrightnessUtils {
    if (BrightnessUtils.instance == null) {
      BrightnessUtils.instance = new BrightnessUtils();
    }
    return BrightnessUtils.instance;
  }

  getBrightnessOptionByType(brightnessEnum: BrightnessTypeEnum): BrightnessOptions | undefined {
    if (!this.mBrightnessHashMap.hasKey(brightnessEnum)) {
      return undefined;
    }
    return this.mBrightnessHashMap.get(brightnessEnum);
  }

  getBrightnessOption(isSystemColor: boolean, sceneType: string, isDarkMode: boolean): BrightnessOptions | undefined {
    if (sceneType === 'liveCard') {
      return this.getBrightnessOptionByType(BrightnessTypeEnum.ICON_BRIGHTNESS_DARK);
    }
    if (isSystemColor) {
      return isDarkMode ? this.getBrightnessOptionByType(BrightnessTypeEnum.ICON_BRIGHTNESS_DARK) :
      this.getBrightnessOptionByType(BrightnessTypeEnum.ICON_BRIGHTNESS_LIGHT);
    }
    return undefined;
  }

  getItemTextBrightnessOption(
    isPrimary: boolean,
    sceneType: string,
    isDarkMode: boolean
  ): BrightnessOptions | undefined {
    if (isPrimary) {
      // 主标题 || device on
      return this.getPrimaryTextBrightnessOption(sceneType, isDarkMode);
    } else {
      return this.getOtherTextBrightnessOption(sceneType, isDarkMode);
    }
  }

  getPrimaryTextBrightnessOption(sceneType: string, isDarkMode: boolean) {
    if (sceneType === 'liveCard') {
      return this.getBrightnessOptionByType(BrightnessTypeEnum.ICON_BRIGHTNESS_DARK);
    }
    if (sceneType === 'liveSwitchBgc') {
      return this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_BGC_ON_DARK);
    }
    if (sceneType === 'liveSwitch') {
      return this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_ON_DARK);
    }
    if (sceneType === 'deviceSwitchBgc') {
      return isDarkMode ? this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_BGC_ON_DARK) :
        this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_BGC_ON_LIGHT);
    }
    if (sceneType === 'deviceSwitch') {
      return isDarkMode ? this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_ON_DARK) :
        this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_ON_LIGHT);
    }
    return isDarkMode ? this.getBrightnessOptionByType(BrightnessTypeEnum.ICON_BRIGHTNESS_DARK) :
      this.getBrightnessOptionByType(BrightnessTypeEnum.ICON_BRIGHTNESS_LIGHT);
  }

  getOtherTextBrightnessOption(sceneType: string, isDarkMode: boolean) {
    if (sceneType === 'liveCard') {
      return this.getBrightnessOptionByType(BrightnessTypeEnum.TEXT_SUB_BRIGHTNESS_DARK);
    }
    if (sceneType === 'liveSwitchBgc') {
      return this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_BGC_DEFAULT_DARK);
    }
    if (sceneType === 'liveSwitch') {
      return this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_DEFAULT_DARK);
    }
    if (sceneType === 'deviceSwitchBgc') {
      return isDarkMode ? this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_BGC_DEFAULT_DARK) :
        this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_BGC_DEFAULT_LIGHT);
    }
    if (sceneType === 'deviceSwitch') {
      return isDarkMode ? this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_DEFAULT_DARK) :
        this.getBrightnessOptionByType(BrightnessTypeEnum.DEVICE_SWITCH_DEFAULT_LIGHT);
    }
    return isDarkMode ? this.getBrightnessOptionByType(BrightnessTypeEnum.TEXT_SUB_BRIGHTNESS_DARK) :
      this.getBrightnessOptionByType(BrightnessTypeEnum.TEXT_SUB_BRIGHTNESS_LIGHT);
  }
}
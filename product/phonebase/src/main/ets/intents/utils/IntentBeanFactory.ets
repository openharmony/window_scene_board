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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import BaseIntentCardInfo from '../beans/BaseIntentCardInfo';
import SwitchIntentCardInfo from '../beans/SwitchIntentCardInfo';
import DesktopSlideCardInfo from '../beans/DesktopSlideCardInfo';
import { IntentItemConstants } from './IntentConstants';
import { IntentNameConstants } from '../IntentCodeConstant';
import data_preferences from '@ohos.data.preferences';
import { contextConstant } from '@kit.AbilityKit';

const TAG: string = 'IntentBeanFactory';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const PREFERENCE_FILE_NAME: string = 'DesktopSetting';

/**
 * Intent framework Bean Factory.
 *
 * @since 2024-05-23
 */
export class IntentBeanFactory {
  private static builder: Map<string, () => BaseIntentCardInfo> = new Map();

  static {
    IntentBeanFactory.builder.set(IntentItemConstants.PIP_SWITCH, IntentBeanFactory.getPiPSwitchCardInfo);
    IntentBeanFactory.builder.set(IntentItemConstants.MULTI_DOCK_SWITCH, IntentBeanFactory.getMultiDockSwitchCardInfo);
    IntentBeanFactory.builder.set(IntentNameConstants.DESKTOP_SLIDE, IntentBeanFactory.getDesktopSlideSwitchCardInfo);
  }

  public static build(itemName: string): BaseIntentCardInfo {
    let func = IntentBeanFactory.builder.get(itemName);
    if (func === null || func === undefined) {
      throw new Error('item not valid: ' + itemName);
    }
    return func();
  }

  private static getPiPSwitchCardInfo(): BaseIntentCardInfo {
    let info = new SwitchIntentCardInfo();
    // BaseCard
    info.type = IntentItemConstants.PIP_SWITCH;
    info.headerTitleColor = $r('sys.color.ohos_id_color_text_primary');
    info.cardBackgroundColor = $r('sys.color.ohos_id_color_card_bg');

    // ToggleCard
    info.switchTitle = $r('app.string.MultiWindow_pip_switch_title');
    info.switchTitleColor = $r('sys.color.ohos_id_color_text_primary');
    info.switchType = ToggleType.Switch;
    let context = AppStorage.get<Context>('intentPageContext')
    info.onChange = (isOn: boolean) => {};
    return info;
  }

  private static getMultiDockSwitchCardInfo(): BaseIntentCardInfo {
    let info = new SwitchIntentCardInfo();
    // BaseCard
    info.type = IntentItemConstants.MULTI_DOCK_SWITCH;
    info.headerTitleColor = $r('sys.color.ohos_id_color_text_primary');
    info.cardBackgroundColor = $r('sys.color.ohos_id_color_card_bg');

    // ToggleCard
    info.switchTitle = $r('app.string.MultiWindow_dock_switch_title');
    info.switchTitleColor = $r('sys.color.ohos_id_color_text_primary');
    info.switchType = ToggleType.Switch;
    let context = AppStorage.get<Context>('intentPageContext')
    info.onChange = (isOn: boolean) => {};
    return info;
  }

  private static getDesktopSlideSwitchCardInfo(): BaseIntentCardInfo {
    let info = new DesktopSlideCardInfo();
    // BaseCard
    info.type = IntentNameConstants.DESKTOP_SLIDE;
    info.headerTitleColor = $r('sys.color.ohos_id_color_text_primary');
    info.cardBackgroundColor = $r('sys.color.ohos_id_color_card_bg');

    // ToggleCard
    info.switchTitle = $r('app.string.Desktop_slide');
    info.switchTitleColor = $r('sys.color.ohos_id_color_text_primary');
    info.switchType = ToggleType.Switch;

    info.isOn = IntentBeanFactory.getDesktopSlideSwitch();
    info.onChange = async (isOn: boolean) => {
      let currentStatus: boolean = IntentBeanFactory.getDesktopSlideSwitch();
      if (isOn !== currentStatus) {
        IntentBeanFactory.putDesktopSlideSwitch(isOn);
      }
      AppStorage.setOrCreate('multiDockSwitchState', isOn);
      log.showInfo(`multiDockSwitchState change: ${isOn}`);
    };
    return info;
  }

  private static getDesktopSlideSwitch(): boolean {
    log.showInfo(`getDesktopSlideSwitch`);
    let context = AppStorage.get<Context>('intentPageContext');
    if (context === null || context === undefined) {
      context = GlobalContext.getContext();
    }

    let options: data_preferences.Options = { name: PREFERENCE_FILE_NAME };
    let applicationContext = context.getApplicationContext();
    let applicationContextArea: contextConstant.AreaMode = applicationContext.area;
    applicationContext.area = contextConstant.AreaMode.EL1;
    data_preferences.removePreferencesFromCache(context, 'DesktopSetting');
    let currentStatus: boolean = true;
    try {
      let preference: data_preferences.Preferences = data_preferences.getPreferencesSync(
        applicationContext, options);
    } catch (e) {
      log.showInfo(`failed getPreferencesSync: [${e.code}]: ${e.message}`);
    }
    applicationContext.area = applicationContextArea;
    return currentStatus;
  }

  private static putDesktopSlideSwitch(isOn: boolean): void {
    log.showInfo(`putDesktopSlideSwitch isOn:%{public}s`, isOn);
    let context = AppStorage.get<Context>('intentPageContext');
    if (context === null || context === undefined) {
      context = GlobalContext.getContext();
    }
    let options: data_preferences.Options = { name: PREFERENCE_FILE_NAME };
    let applicationContext = context.getApplicationContext();
    let applicationContextArea: contextConstant.AreaMode = applicationContext.area;
    applicationContext.area = contextConstant.AreaMode.EL1;
    try {
      let preference: data_preferences.Preferences = data_preferences.getPreferencesSync(
        applicationContext, options);
      preference.flush();
    } catch (e) {
      log.showInfo(`failed SlideSwitch: [${e.code}]: ${e.message}` );
    }
    applicationContext.area = applicationContextArea;
  }
}

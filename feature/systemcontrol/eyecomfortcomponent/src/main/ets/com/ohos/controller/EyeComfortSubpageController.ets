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

import I18n from '@ohos.i18n';
import Intl from '@ohos.intl';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  HiSysEventUtil,
  obtainStartAbilityWithWant,
  PluginClickInfo,
  sEventManager,
  sSettingsUtil
} from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ExtAppConstants, FASlotName, SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import Constants from '../common/Constants';
import {
  MenuEntry,
  SubpageElementInfo
} from '@ohos/systemuicommon/Index';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { EyeComfortToggleController } from './EyeComfortToggleController';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { ScreenStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/ScreenStatusVm';

const TAG = 'Ctrl.EyeComfortSubpageController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SWING_EYE_ITEM_HEIGHT: number = 63;
const MIN_60: number = 60;
const HOUR_24: number = 24;

export class EyeComfortSubpageController {
  private mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';

  /**
   * 拉起护眼模式二级页
   *
   * @param isSupportSwingEyeProtect 是否支持智能护眼
   */
  public openEyeComportSubPanel(isSupportSwingEyeProtect: boolean): void {
    let subpageInfo: SubpageElementInfo = new SubpageElementInfo($r('app.media.ic_eye_comfort_day'),
      $r('app.string.control_center_eye_comfort_toggle_title'), FASlotName.EYE_COMFORT);
    this.buildSubpageInfo(subpageInfo, isSupportSwingEyeProtect);
    // 如果不支持智能护眼模式，减去对应列表的高度
    const windowHeight: number = 327 - (isSupportSwingEyeProtect ? 0 : SWING_EYE_ITEM_HEIGHT);
    sToggleSubWindowController.showCustomSubWindowByClick(FASlotName.EYE_COMFORT, {
      clickType: 'window',
      windowHeight: windowHeight
    } as PluginClickInfo,
      subpageInfo);
    log.showInfo(`openEyeComportSubPanel`);
  }

  private buildSubpageInfo(subpageInfo: SubpageElementInfo, isSupportSwingEyeProtect: boolean): void {
    subpageInfo.onMoreSettingClick = () => {
      EyeComfortToggleController.getInstance().handleGoSettingWithScreenLock((): void => this.goEyeShieldSetting());
    }
    this.buildMenuList(subpageInfo, isSupportSwingEyeProtect);
    subpageInfo.onMenuItemClick = (item: MenuEntry) => {
      log.showInfo(`click itemKey ${item.itemKey}`);
      if (item.isSelected) {
        return;
      }
      // 更新ui勾选状态
      subpageInfo.menuList.forEach(menu => {
        if (menu.itemKey === item.itemKey) {
          menu.isSelected = true;
        } else if (menu.isSelected) {
          menu.isSelected = false;
        }
      })
      // 然后更新状态值
      let newMode: string = this.updateEyeComfortModeInSubPage(item);
      // 更新副标题文字
      this.updateSubTitle(subpageInfo);
      // 切换护眼模式行为打点
      if (!Number.isNaN(Number(newMode))) {
        HiSysEventUtil.reportCCEyeComportChangeEvent({
          LOCKSTATUS: AppStorage.get('lockStatus'),
          TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
          NEWSTATE: Number(newMode)
        });
      }
    };
  }

  /**
   * 初始化列表副标题
   *
   * @param subpageInfo 二级页的列表信息
   */
  private initSubTitle(subpageInfo: SubpageElementInfo): void {
    subpageInfo.menuList.forEach(menu => {
      if (menu.itemKey === Constants.ITEM_OPEN_SCHEDULE) {
        this.updateSubTitleOfSchedule(menu);
      } else if (menu.itemKey === Constants.ITEM_OPEN_SWING) {
        this.updateSubTitleOfSwing(menu);
      }
    })
  }

  /**
   * 更新列表副标题
   *
   * @param subpageInfo 二级页的列表信息
   */
  private updateSubTitle(subpageInfo: SubpageElementInfo): void {
    subpageInfo.menuList.forEach(menu => {
      if (menu.itemKey === Constants.ITEM_OPEN_SCHEDULE) {
        this.updateSubTitleOfSchedule(menu);
      } else if (menu.itemKey === Constants.ITEM_OPEN_SWING) {
        this.updateSubTitleOfSwing(menu, false);
      }
    })
  }

  /**
   * 更新定时开启的子标题
   *
   * @param menu
   */
  private updateSubTitleOfSchedule(menu: MenuEntry): void {
    if (!menu.isSelected) {
      menu.subTitle = undefined;
      return;
    }
    // 查询上一次定时模式值
    const lastScheduledMode: string = sSettingsUtil.getSystemValue(SettingsKeyConstants.LAST_EYE_COMFORT_SCHEDULED_MODE,
      SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SUNSET);
    if (lastScheduledMode === SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SUNSET) {
      menu.subTitle =
        ResUtils.getInnerString($r('app.string.control_center_eye_comfort_scheduled_open_subtitle_sunset'));
    } else {
      menu.subTitle = this.getScheduleTimeframe();
    }
    log.showInfo(`updateSubTitleOfSchedule: ${menu.subTitle}`);
  }

  /**
   * 获取定时开启时间段
   *
   * @returns
   */
  private getScheduleTimeframe(): string {
    const startTime: number = Number(sSettingsUtil.getSystemValue(SettingsKeyConstants.EYE_COMFORT_START_TIME));
    const endTime: number = Number(sSettingsUtil.getSystemValue(SettingsKeyConstants.EYE_COMFORT_END_TIME));
    if (isNaN(startTime) || isNaN(endTime)) {
      return '';
    }
    const startTimeContent: string = this.updateContent(startTime);
    const endTimeContent: string = this.updateContent(endTime);
    log.showInfo(`startTime: ${startTime} -> ${startTimeContent}, endTime: ${endTime} -> ${endTimeContent}`);
    if (endTime / MIN_60 < HOUR_24) {
      return startTimeContent + '-' + endTimeContent;
    } else {
      return ResUtils.getInnerStringNumS($r('app.string.control_center_eye_comfort_scheduled_next_day'),
        `${startTimeContent}`, `${endTimeContent}`);
    }
  }

  /**
   * 将分钟数转化为 上午/下午 hh:mm形式
   *
   * @param minutesNumber 分钟数
   * @returns 上午/下午 hh:mm 时间
   */
  private updateContent(minutesNumber: number): string {
    let hour: number = Math.floor(minutesNumber / MIN_60);
    let minute: number = minutesNumber % MIN_60;
    const currentDate: Date = new Date();
    currentDate.setHours(hour, minute);
    let dateFormat = new Intl.DateTimeFormat(I18n.System.getSystemLanguage(), {
      timeStyle: 'short',
      hour12: !I18n.System.is24HourClock(),
      timeZone: I18n.getTimeZone().getID()
    });
    return dateFormat.format(currentDate);
  }

  /**
   * 更新智能开启的子标题
   *
   * @param menu 智能开启选项信息
   * @param needRequired  是否需要查询护眼使能状态
   */
  private updateSubTitleOfSwing(menu: MenuEntry, needRequired: boolean = true): void {
    if (!menu.isSelected) {
      menu.subTitle = ResUtils.getInnerString($r('app.string.control_center_eye_comfort_smart_open_subtitle_default'));
      log.showInfo(`updateSubTitleOfSwing: ${menu.subTitle}`);
      return;
    }
    // 如果是拉起二级页或者监听护眼模式使能变化，需要查询护眼模式使能状态，否则赋默认值
    if (needRequired) {
      const eyeShieldEnable: string = sSettingsUtil.getSystemValue(SettingsKeyConstants.EYE_SHIELD_ENABLE,
        SettingsConstants.EYE_SHIELD_MODE_CLOSE);
      menu.subTitle = eyeShieldEnable === '1' ?
      ResUtils.getInnerString($r('app.string.control_center_eye_comfort_smart_open_subtitle_active')) :
      ResUtils.getInnerString($r('app.string.control_center_eye_comfort_smart_open_subtitle_normal'));
    } else {
      menu.subTitle = ResUtils.getInnerString($r('app.string.control_center_eye_comfort_smart_open_subtitle_normal'));
    }
    log.showInfo(`updateSubTitleOfSwing: ${menu.subTitle}`);
  }

  /**
   * 护眼模式使能切换时更新列表子标题
   */
  public updateSubTitleByComfortChange(): void {
    // 首先判断当前二级页是否展示
    if (sToggleSubWindowController.getCurrentSubPanelSlot() !== FASlotName.EYE_COMFORT) {
      return;
    }
    // 获取subpageInfo，判断是否勾选了智能开启
    let subpageInfo: SubpageElementInfo | undefined = sToggleSubWindowController.getSubpageElementInfo();
    if (subpageInfo === undefined) {
      return;
    }
    let menuOfSwing = subpageInfo.menuList.find((menu: MenuEntry) => {
      return menu.itemKey === Constants.ITEM_OPEN_SWING && menu.isSelected;
    })
    // 更新子标题
    if (menuOfSwing !== undefined) {
      this.updateSubTitleOfSwing(menuOfSwing);
    }
  }

  /**
   * 在二级页勾选菜单之后，更新护眼模式状态
   *
   * @param menu 勾选中的菜单
   * @returns 切换的新模式
   */
  private updateEyeComfortModeInSubPage(menu: MenuEntry): string {
    let newMode: string = '';
    if (menu.itemKey === Constants.ITEM_OPEN_ALL_DAY) {
      newMode = SettingsConstants.EYE_SHIELD_MODE_OPEN_ALL_DAY;
    } else if (menu.itemKey === Constants.ITEM_OPEN_SCHEDULE) {
      newMode = sSettingsUtil.getSystemValue(SettingsKeyConstants.LAST_EYE_COMFORT_SCHEDULED_MODE,
        SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SUNSET);
    } else if (menu.itemKey === Constants.ITEM_OPEN_SWING) {
      newMode = SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SWING;
    }
    if (!CommonUtils.isEmpty(newMode)) {
      EyeComfortToggleController.getInstance().setEyeComfortMode(newMode);
    }
    log.showInfo(`changeEyeComfortMode to ${newMode}`);
    return newMode;
  }

  /**
   *  构建菜单列表
   */
  private buildMenuList(subpageInfo: SubpageElementInfo, isSupportSwingEyeProtect: boolean): void {
    if (isSupportSwingEyeProtect) {
      // 添加智能开启选项
      subpageInfo.menuList.push(new MenuEntry($r('app.media.ic_eye_comfort_swing'),
        ResUtils.getInnerString($r('app.string.control_center_eye_comfort_smart_open')), Constants.ITEM_OPEN_SWING,
        ResUtils.getInnerString($r('app.string.control_center_eye_comfort_smart_open_subtitle_default'))));
    }
    // 添加全天开启选项
    subpageInfo.menuList.push(new MenuEntry($r('app.media.ic_eye_comfort_day'),
      ResUtils.getInnerString($r('app.string.control_center_eye_comfort_always_on')),
      Constants.ITEM_OPEN_ALL_DAY));

    // 添加定时开启
    subpageInfo.menuList.push(new MenuEntry($r('app.media.ic_eye_comfort_schedule'),
      ResUtils.getInnerString($r('app.string.control_center_eye_comfort_scheduled_open')),
      Constants.ITEM_OPEN_SCHEDULE));
    if (EyeComfortToggleController.getInstance().getEyeComportMode() === SettingsConstants.EYE_SHIELD_MODE_CLOSE) {
      return;
    }
    // 更新勾选状态，根据mode进行更新
    for (let element of subpageInfo.menuList) {
      if (element.itemKey ===
      Constants.modeToSubpageUImap.get(EyeComfortToggleController.getInstance().getEyeComportMode())) {
        element.isSelected = true;
        break;
      }
    }
    this.initSubTitle(subpageInfo);
  }

  /**
   * 跳转设置
   */
  private goEyeShieldSetting(): void {
    log.showInfo('goEyeShieldSetting eye_comfort_mode');
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'eye_comfort_mode',
      moduleName: this.mdName
    }));
    DropDownPanelManager.hideWindowDirectly();
  }
}
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

import { CheckEmptyUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { AccessibilityManager, ContextModifyUtils, GlobalContext, } from '@ohos/frameworkwrapper';
import data_preferences from '@ohos.data.preferences';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { DesktopSettingConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { SwitchType, ToastType } from './PreferenceType';
import contextConstant from '@ohos.app.ability.contextConstant';
import settings from '@ohos.settings';
import { Context } from '@kit.AbilityKit';
import { SCBNaviBarConstants } from '../../SCBNaviBarConstants';
import { FloatingNavigationManager } from '../../proxy/FloatingNavigationManager';
import { Constants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { BusinessError } from '@kit.BasicServicesKit';
import { AccountHelper } from '@ohos/screenlockcommon';
import CommonEventManager from '@ohos.commonEventManager';
import { NaviBarCloneCallbackManager } from '@ohos/launchercommon/src/main/ets/manager/NaviBarCloneCallbackManager';
import { SCBGestureNavSetMgr } from '@ohos/componenthelper';
import { ThreeButtonUpgradeConstants } from '../../ThreeButtonUpgradeConstants';
import { CloneStatusCallbackManager } from '@ohos/launchercommon/src/main/ets/manager/CloneStatusCallbackManager';
import { threeButtonAccessibilityMgr } from './ThreeButtonAccessibilityManager';

const TAG: string = 'NaviBarSettingsDataMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export enum SettingsEventType {
  ohos_CLONE_NEXT = 'ohos_clone_next', // 双克隆单
  NEXT_CLONE_NEXT = 'next_clone_next', // 单克隆单
  ohos_TO_NEXT = 'ohos_to_next', // 系统迁移
}

/**
 * 设置数据工具类
 *
 * @since 2024-08-15
 */
export class NaviBarSettingsDataMgr {
  private completedInit: boolean = false;
  private clickBackStatus: boolean = false;
  private floatingNavSwitchStatus: boolean = false;
  private callBackMap: Map<string, Function> = new Map();
  public readonly naviBarSettingDomain: string = settings.domainName.USER_PROPERTY;
  // 三键关闭底部的避让区高度
  public readonly DELIVER_NAVI_BAR_HOT_HEIGHT: string = '16';
  public readonly SETTINGS_DATA_KEY: string = 'floatingnavigation_exchange_button';
  public readonly ballOn: string = '1';
  public readonly ballOff: string = '0';

  /**
   * 获取单例
   * @returns 返回实例
   */
  static getInstance(): NaviBarSettingsDataMgr {
    return SingletonHelper.getInstance(NaviBarSettingsDataMgr, TAG);
  }

  /**
   * 同步数据，初始化开关
   */
  public async initData(): Promise<void> {
    if (this.completedInit) {
      log.showInfo('completedInit is true');
      return;
    }
    try {
      this.initializeStatus(SwitchType.FLOATING_NAV_STATUS, '1');
      this.initializeStatus(SwitchType.FLOATING_BALL, '0');
      this.initializeStatus(SwitchType.FLOATING_NAV_EXCHANGE_BTN_STATUS,
        SCBNaviBarConstants.BUTTON_POSITION_STYLE_DEFAULT);
      // 优先使用 settingdata 的值，再优先使用 preference 的值，最后使用默认值
      let clickBackData: string = this.getValueSync(SwitchType.CLICK_BACK_STATUS, '');
      log.showInfo(`clickBackData:${clickBackData}`);
      if (!CheckEmptyUtils.isEmpty(clickBackData)) {
        this.clickBackStatus = clickBackData === 'true';
        this.changeClickBackStatus();
        return;
      }
      let preference = await this.getPreference();
      if (!preference) {
        log.showError('preference is null');
        return;
      }
      // clickBackStatus 默认值 false
      this.clickBackStatus = await this.syncPreDataToSetting(preference,
        clickBackData, SwitchType.CLICK_BACK_STATUS, 'false') === 'true';
      this.changeClickBackStatus();
      this.completedInit = true;
      log.showInfo('syncData end');
    } catch (err) {
      log.showError(`syncData has error: code: ${err?.code},${err?.message}`);
    }
  }

  private async syncPreDataToSetting(preference: data_preferences.Preferences,
    settingsValue: string, type: string, defaultValue: string): Promise<string> {
    if (!CheckEmptyUtils.isEmpty(settingsValue)) {
      log.showInfo(`syncData ${type} settingdata is not empty`);
      return settingsValue;
    }
    let preferenceData = await preference?.get(type, null);
    log.showInfo(`syncData preference ${type} is:${preferenceData}`);
    if (!CheckEmptyUtils.isEmpty(preferenceData)) {
      this.putValue(type, preferenceData.toString());
      preference.delete(type);
      return preferenceData.toString();
    } else {
      return defaultValue;
    }
  }

  private async getPreference(): Promise<data_preferences.Preferences | null> {
    let context = GlobalContext.getContext()?.getApplicationContext();
    if (context) {
      let preference: data_preferences.Preferences | null = null;
      let callback: Function = async (contextCallback: Context) => {
        await data_preferences.removePreferencesFromCache(contextCallback, DesktopSettingConstants.PREFERENCES_NAME);
        preference = await data_preferences.getPreferences(contextCallback, DesktopSettingConstants.PREFERENCES_NAME);
      };
      await ContextModifyUtils.modifyTargetContextAsync(context, contextConstant.AreaMode.EL2, callback,
        `${TAG}-getPreference`);
      return preference;
    }
    return null;
  }

  /**
   * 存储数据
   * @param context 上下文
   * @param key 存入的key
   * @param value 存入的值
   */
  public async putValue(key: string, value: string, domain: string = this.naviBarSettingDomain): Promise<void> {
    log.showInfo(`put: ${key}, value is:${value}`);
    try {
      settingsDataManager.setValueWithDomain(key, value, domain);
    } catch (err) {
      log.showError(`put key:${key} has error:${err?.message}`);
    }
  }

  /**
   * 获取存储数据
   * @param context 上下文
   * @param key key
   * @param defaultValue 默认值
   * @returns 获取到的值
   */
  public getValueSync(key: string, defaultValue: string = '', domain: string = this.naviBarSettingDomain): string {
    try {
      let value = settingsDataManager.getValueWithDomain(key, defaultValue, domain);
      log.showInfo(`getValueSync: ${key}, value is:${value}`);
      if (CheckEmptyUtils.checkStrIsEmpty(value)) {
        return defaultValue;
      }
      return value;
    } catch (err) {
      log.showError(`get key:${key} has error:${err.message}`);
      return defaultValue;
    }
  }

  /**
   * 获取存储数据(number)
   * @param context 上下文
   * @param key key
   * @param defaultValue 默认值
   * @returns 获取到的值(number)
   */
  public getNumberValueSync(key: string, defaultValue: string = '0'): number {
    try {
      let value = settingsDataManager.getValueWithDomain(key, defaultValue, this.naviBarSettingDomain);
      log.showInfo(`getNumberValueSync: ${key}, value is:${value}`);
      if (CheckEmptyUtils.checkStrIsEmpty(value) || Number.isNaN(value)) {
        return this.getDefaultValue(defaultValue);
      }
      return Number(value);
    } catch (err) {
      log.showError(`get key:${key} has error:${err?.message}`);
      return this.getDefaultValue(defaultValue);
    }
  }

  private getDefaultValue(defaultValue: string): number {
    if (Number.isNaN(defaultValue)) {
      return 0;
    }
    return Number(defaultValue);
  }

  private changeClickBackStatus(): void {
    this.callBackMap.get(SwitchType.CHANGE_CLICK_BACK_STATUS)?.(this.getClickBackStatus());
  }

  /**
   * 初始化开关布尔变量
   *
   * @param context 上下文
   * @param key 开关的key
   */
  private async initializeStatus(key: string, defaultValue: string = 'false'): Promise<void> {
    try {
      switch (key) {
        case SwitchType.CLICK_BACK_STATUS:
          this.clickBackStatus = this.getValueSync(key, defaultValue) === 'true';
          this.changeClickBackStatus();
          log.showInfo(`clickBackStatus is ${this.clickBackStatus}`);
          break;
        case SwitchType.FLOATING_BALL:
          let floatingBallStatus = this.getValueSync(key, defaultValue) === '1';
          log.showInfo(`floatingBallStatus: ${floatingBallStatus}`);
          if (this.checkFloatingBallStatus(floatingBallStatus)) {
            // 判断三键状态,三键是打开的，重新再打开一次。
            let isOpenThreeKey = await this.isThreeButtonOpen();
            if (isOpenThreeKey) {
              this.openThreeButton();
            }
            return;
          }
          if (floatingBallStatus) {
            // 悬浮球打开关闭三键
            this.closeThreeButton();
          }
          FloatingNavigationManager.getInstance().setFloatingBallStatus(floatingBallStatus);
          if (floatingBallStatus) {
            FloatingNavigationManager.getInstance().connectFloatingNavAbility(true);
            FloatingNavigationManager.getInstance().setShowVerifyImmersiveState();
          }
          break;
        case SwitchType.FLOATING_NAV_STATUS:
          let floatNav: string = this.getValueSync(key, defaultValue);
          this.floatingNavSwitchStatus = floatNav === '0';
          log.showInfo(`FloatingNav: ${this.floatingNavSwitchStatus}`);
          if (this.isSettingsCloning() && this.floatingNavSwitchStatus) {
            NaviBarCloneCallbackManager.getInstance().isCloneToOpenThreeKey = true;
          }

          if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
            // 无障碍期间 三键开启,或者关闭保存状态，下次无障碍打开使用这次状态
            threeButtonAccessibilityMgr.saveFloatNavAccessibilityModeState(floatNav)
          }

          FloatingNavigationManager.getInstance().setSwitchStatus(this.floatingNavSwitchStatus);
          if (this.floatingNavSwitchStatus) {
            FloatingNavigationManager.getInstance().connectFloatingNavAbility();
            let isReset = AccessibilityManager.getInstance().getIsAccessibilityMode() ? true : false;
            FloatingNavigationManager.getInstance().setShowVerifyImmersiveState(isReset);
            let exchangeBtnStatus = this.getValueSync(SwitchType.FLOATING_NAV_EXCHANGE_BTN_STATUS,
              SCBNaviBarConstants.BUTTON_POSITION_STYLE_DEFAULT);
            FloatingNavigationManager.getInstance().setExchangeBtnStatus(exchangeBtnStatus);
            this.closeFloatingBall();
          } else {
            FloatingNavigationManager.getInstance().setExchangeBtnStatus(
              SCBNaviBarConstants.BUTTON_POSITION_STYLE_INVALID);
          }
          this.changeClickBackStatus();
          break;
        case SwitchType.FLOATING_NAV_EXCHANGE_BTN_STATUS:
          let exchangeBtnStatus = this.getValueSync(key, SCBNaviBarConstants.BUTTON_POSITION_STYLE_DEFAULT);
          FloatingNavigationManager.getInstance().setExchangeBtnStatus(exchangeBtnStatus);
          break;
        default:
          log.showInfo(`initializeStatus key is:${key}`);
          break;
      }
    } catch (err) {
      log.showError(`preference error:${err?.message}`);
    }
  }

  /**
   * 关闭悬浮球
   */
  public closeFloatingBall(): void {
    if (GlobalContext.getContext()) {
      try {
        log.showInfo(`closeFloatingBall`);
        settings.setValue(GlobalContext.getContext(), SwitchType.FLOATING_BALL, this.ballOff,
          settings.domainName.USER_PROPERTY);
      } catch (e) {
        log.showError(TAG, `closeFloatingBall ${e?.code}, msg: ${e?.message}`);
      }
    }
  }

  /**
   * 打开悬浮球
   */
  public openFloatingBall(): void {
    if (GlobalContext.getContext()) {
      try {
        log.showInfo(`openFloatingBall`);
        settings.setValue(GlobalContext.getContext(), SwitchType.FLOATING_BALL, this.ballOn,
          settings.domainName.USER_PROPERTY);
      } catch (e) {
        log.showError(TAG, `openFloatingBall ${e?.code}, msg: ${e?.message}`);
      }
    }
  }

  /**
   * 关闭三键
   */
  public closeThreeButton(): void {
    log.showInfo(`closeThreeButton context is: ${GlobalContext.getContext()}`);
    if (GlobalContext.getContext()) {
      try {
        log.showInfo(`closeThreeButton`);
        settings.setValue(GlobalContext.getContext(), SwitchType.FLOATING_NAV_STATUS,
          Constants.SYSTEM_NAVIGATION_GESTURE,
          settings.domainName.USER_PROPERTY);
      } catch (e) {
        log.showError(TAG, `closeThreeButton ${e?.code}, msg: ${e?.message}`);
      }
    }
  }

  /**
   * 打开三键
   */
  public openThreeButton(): void {
    if (GlobalContext.getContext()) {
      try {
        log.showInfo(`openThreeButton`);
        settings.setValue(GlobalContext.getContext(), SwitchType.FLOATING_NAV_STATUS,
          Constants.SYSTEM_NAVIGATION_FLOATING,
          settings.domainName.USER_PROPERTY);
      } catch (e) {
        log.showError(TAG, `openThreeButton ${e?.code}, msg: ${e?.message}`);
      }
    }
  }

  public async setStatus(key: string): Promise<void> {
    try {
      log.showInfo(`setStatus key is:${key}`);
      this.initializeStatus(key);
      this.toastCallBack(key);
    } catch (err) {
      log.showError(`preference error:${err?.message}`);
    }
  }

  private toastCallBack(key: string): void {
    log.showInfo(`toastCallBack key is:${key}`);
  }

  public getClickBackStatus(): boolean {
    if (this.floatingNavSwitchStatus) {
      // 三键打开，设置的开关会关闭，置灰，但是锁屏会显示导航条，也不让点击
      log.showInfo('three key is open no click');
      return false;
    }

    log.showInfo(`get clickBackStatus value is ${this.clickBackStatus}`);
    return this.clickBackStatus;
  }

  /**
   * register GestureEnable Callback
   * @param type
   * @param callback
   */
  registerCallback(type: string, callback: Function): void {
    log.info(`registerCallback type:${type}`);
    if (CheckEmptyUtils.isEmpty(callback) || CheckEmptyUtils.isEmpty(type)) {
      log.showError(`callback or type is null`);
      return;
    }
    this.callBackMap.set(type, callback);
  }

  /**
   *  unregister GestureEnable Callback
   * @param type
   */
  unRegisterCallback(type: string): void {
    if (this.callBackMap.has(type)) {
      this.callBackMap.delete(type);
    } else {
      log.showInfo(`${type} has not registerCallback`);
    }
  }

  /**
   * 注册一个观察者，以便于在指定域名中观察指定的域名。当该键值发生变化时，将调用注册的回调函数
   * @param context 上下文
   */
  public registerKeyObserver(): void {
    log.showInfo('registerKeyObserver');
    settingsDataManager.registerKeyObserverWithDomain(SwitchType.CLICK_BACK_STATUS, () => {
      log.showInfo('receive clickBackStatus change');
      this.setStatus(SwitchType.CLICK_BACK_STATUS);
    }, this.naviBarSettingDomain);
    settingsDataManager.registerKeyObserverWithDomain(SwitchType.FLOATING_NAV_STATUS, () => {
      log.showInfo('receive floatingNavigation change');
      this.setStatus(SwitchType.FLOATING_NAV_STATUS);
      this.setGestureBottomHeight();
    }, this.naviBarSettingDomain);
    settingsDataManager.registerKeyObserverWithDomain(SwitchType.FLOATING_BALL, () => {
      log.showInfo('receive floatingball change');
      this.setStatus(SwitchType.FLOATING_BALL);
    }, this.naviBarSettingDomain);
    settingsDataManager.registerKeyObserverWithDomain(SwitchType.FLOATING_NAV_EXCHANGE_BTN_STATUS, () => {
      log.showInfo('receive floatingnavigation_exchange_button change');
      this.setStatus(SwitchType.FLOATING_NAV_EXCHANGE_BTN_STATUS);
    }, this.naviBarSettingDomain);
    NaviBarCloneCallbackManager.getInstance()
      .registerSettingsDataRestoreFinishCallbacks(TAG, (data: CommonEventManager.CommonEventPublishData) => {
        log.showInfo(`receive SettingsDataRestoreFinish ${data?.data}`);
        if (data?.data === SettingsEventType.ohos_CLONE_NEXT) {
          //setting data 完成
          this.checkFloatingNavigationExchangeButton();
        }
        if (data?.data === SettingsEventType.ohos_CLONE_NEXT || data?.data === SettingsEventType.NEXT_CLONE_NEXT) {
          // 克隆完成
          this.checkFloatingBallAfterClone();
        }
      });
    CloneStatusCallbackManager.getInstance().registerCloneStatusCallbacks(TAG, () => {
      log.showInfo('receive cloneStatus change');
      if (this.isSettingsCloning()) {
        NaviBarCloneCallbackManager.getInstance().isCloneToOpenThreeKey = false;
      }
    });
  }

  /**
   * 进行注销指定域名下对指定键的监视器。
   * @param context 上下文
   */
  public unregisterKeyObserver(): void {
    log.showInfo('unregisterKeyObserver');
    try {
      settingsDataManager.unregisterKeyObserverWithDomain(SwitchType.CLICK_BACK_STATUS, this.naviBarSettingDomain);
      settingsDataManager.unregisterKeyObserverWithDomain(SwitchType.FLOATING_NAV_STATUS, this.naviBarSettingDomain);
      settingsDataManager.unregisterKeyObserverWithDomain(SwitchType.FLOATING_BALL, this.naviBarSettingDomain);
      settingsDataManager.unregisterKeyObserverWithDomain(SwitchType.FLOATING_NAV_EXCHANGE_BTN_STATUS,
        this.naviBarSettingDomain);
      NaviBarCloneCallbackManager.getInstance().unRegisterSettingsDataRestoreFinishCallbacks(TAG);
      settingsDataManager.unregisterKeyObserverWithDomain(SCBNaviBarConstants.SETTING_DATA_DB_CLONE_FLAG,
        settings.domainName.DEVICE_SHARED);
      CloneStatusCallbackManager.getInstance().unRegisterCloneStatusCallbacks(TAG);
    } catch (err) {
      log.showError(`unregisterKeyObserver, try catch err code:${err?.code} msg:${err?.message}`);
    }
  }

  private isSettingsCloning(): boolean {
    try {
      let value = settingsDataManager.getValue(null, SCBNaviBarConstants.SETTING_DATA_DB_CLONE_FLAG, '-1');
      log.showInfo(`clone state is ${value}`);
      return value === SCBNaviBarConstants.SETTING_DATA_DB_CLONE_FLAG_DEFAULT_OPEN_VALUE;
    } catch (err) {
      log.showError(`isSettingsCloning, try catch err code:${err?.code} msg:${err?.message}`);
    }
    return false;
  }

  /**
   * 根据是否是三键，设置热区高度，外settingsData数据同步
   */
  public setGestureBottomHeight(userId: number = AccountHelper.getInstance().currentLocalId): void {
    log.showWarn('setGestureBottomHeight start');
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError('context is undefined or null');
      return;
    }
    if (userId !== AccountHelper.getInstance().currentLocalId) {
      log.showError('Ignore userId is not currentUserId');
      return;
    }
    try {
      settings.getValue(context, SwitchType.FLOATING_NAV_STATUS, this.naviBarSettingDomain)
        .then((value: string) => {
          if (value === Constants.SYSTEM_NAVIGATION_FLOATING) {
            log.showInfo(`floatingNavigation is open :${value}`);
            // 三键打开
            settings.setValue(context, Constants.ohos_GESTURE_BOTTOM_HEIGHT,
              SCBNaviBarConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT + '', settings.domainName.DEVICE_SHARED);
          } else {
            log.showInfo(`floatingNavigation is close :${value}`);
            // 三键关闭
            settings.setValue(context, Constants.ohos_GESTURE_BOTTOM_HEIGHT, this.DELIVER_NAVI_BAR_HOT_HEIGHT,
              settings.domainName.DEVICE_SHARED);
          }
        })
        .catch((err: BusinessError) => {
          log.showError(`setGestureBottomHeight, getValue err code: ${err?.code}, msg: ${err?.message}`);
          settings.setValue(context, Constants.ohos_GESTURE_BOTTOM_HEIGHT, this.DELIVER_NAVI_BAR_HOT_HEIGHT,
            settings.domainName.DEVICE_SHARED);
        });
    } catch (err) {
      log.showError(`setGestureBottomHeight, getValueSync err msg: ${(err as BusinessError)?.message}`);
      settings.setValue(context, Constants.ohos_GESTURE_BOTTOM_HEIGHT, this.DELIVER_NAVI_BAR_HOT_HEIGHT,
        settings.domainName.DEVICE_SHARED);
    }
  }

  /**
   * 三键状态
   */
  public async checkPrivateThreeButtonDataMoving(): Promise<void> {
    if (AccountHelper.getInstance().isDefaultUser() || !SCBGestureNavSetMgr.isSupportFloatNavigation()) {
      log.showInfo('checkPrivateThreeButtonDataMoving, but current space is not privacy!.');
      return;
    }
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError('checkPrivateThreeButtonDataMoving context is undefined or null');
      return;
    }
    try {
      // 获取隐私空间双上三键状态
      let value: string = await settings.getValue(context, ThreeButtonUpgradeConstants.OLD_NAVIGATION_TYPE_KEY,
        settings.domainName.USER_SECURITY);
      log.showInfo(`checkPrivateThreeButtonDataMoving, old nav is:${value}`);
      if (value === '0') {
        // 双上隐私空间三键打开，打开单上隐私空间三键开关
        await settings.setValue(context, SwitchType.FLOATING_NAV_STATUS,
          Constants.SYSTEM_NAVIGATION_FLOATING,
          settings.domainName.USER_PROPERTY);
        this.checkFloatingNavigationExchangeButton();
        settings.setValue(context, ThreeButtonUpgradeConstants.OLD_NAVIGATION_TYPE_KEY, '',
          settings.domainName.USER_SECURITY);
      }
    } catch (err) {
      log.showError(`checkPrivateThreeButtonDataMoving, getValueSync err msg: ${(err as BusinessError)?.message}`);
    }
  }

  /**
   * 检查Back键位置
   */
  public async checkFloatingNavigationExchangeButton(): Promise<void> {
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError('checkExchangeButton context is undefined or null');
      return;
    }
    try {
      let value: string = await settings.getValue(context, SwitchType.FLOATING_NAV_STATUS, this.naviBarSettingDomain);
      if (value === Constants.SYSTEM_NAVIGATION_FLOATING) {
        let direction =
          settings.getValueSync(context, this.SETTINGS_DATA_KEY, '', settings.domainName.USER_PROPERTY);
        log.showInfo(`checkFloatingNavigationExchangeButton :${value} directionis:${direction}`);
        if (CheckEmptyUtils.isEmpty(direction)) {
          // 当前没有位置信息，设置为和双上默认位置一样（左边）
          settings.setValue(context, this.SETTINGS_DATA_KEY, '1', settings.domainName.USER_PROPERTY);
        }
      }
    } catch (err) {
      log.showError(`checkFloatingNavigationExchangeButton, getValueSync err msg: ${(err as BusinessError)?.message}`);
    }
  }


  private async isThreeButtonOpen(): Promise<boolean> {
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError('context is undefined or null');
      return false;
    }
    let isOpen = Constants.SYSTEM_NAVIGATION_GESTURE;
    try {
      isOpen = await settings.getValue(context, SwitchType.FLOATING_NAV_STATUS, settings.domainName.USER_PROPERTY);
    } catch (e) {
      log.showError(`get Three Button error code: ${e?.code}, message: ${e?.message}`);
    }
    return isOpen === Constants.SYSTEM_NAVIGATION_FLOATING;
  }

  private async isFloatBallOpen(): Promise<boolean> {
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError('context is undefined or null');
      return false;
    }
    let isOpen = this.ballOff;
    try {
      isOpen = await settings.getValue(context, SwitchType.FLOATING_BALL, settings.domainName.USER_PROPERTY);
    } catch (e) {
      log.showError(`get ball status error code: ${e?.code}, message: ${e?.message}`);
    }
    return isOpen === this.ballOn;
  }

  private checkFloatingBallStatus(isOpen: boolean): boolean {
    if (isOpen) {
      // 收到悬浮球开启，
      let isAccessibilityOpen = AccessibilityManager.getInstance().getIsAccessibilityMode() ? true : false;
      let isSupportFloatBall = SCBGestureNavSetMgr.isSupportFloatBall();
      log.showInfo(`isAccessibilityOpen :${isAccessibilityOpen} isSupportFloatBall:${isSupportFloatBall}`);
      let isOpenLater = this.isScreenReadingOpenLater();
      if (isAccessibilityOpen || !isSupportFloatBall || (this.isSettingsCloning() && isOpenLater)) {
        // 关闭悬浮球
        this.closeFloatingBall();
        return true;
      }
    }
    return false;
  }

  private async checkFloatingBallAfterClone(): Promise<void> {
    let isThreeButtonOpen = await this.isThreeButtonOpen();
    let isFloatBallOpen = await this.isFloatBallOpen();
    log.showInfo(`isThreeButtonOpen :${isThreeButtonOpen} isFloatBallOpen:${isFloatBallOpen}`);
    if (isThreeButtonOpen && isFloatBallOpen) {
      // 关闭悬浮球
      this.closeFloatingBall();
    }
  }

  /**
   * 屏幕朗读是否会稍后自动打开
   */
  public isScreenReadingOpenLater(): boolean {
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError('context is undefined or null');
      return false;
    }
    try {
      let serviceList =
        settings.getValueSync(context, 'enabled_accessibility_services', '', settings.domainName.USER_SECURITY);
      log.showInfo(`serviceList is :${serviceList}`);
      return serviceList.includes('com.ohos.screenreader/AccessibilityExtAbility');
    } catch (e) {
      log.showError(`ggetServiceList error code: ${e?.code}, message: ${e?.message}`);
    }
    return false;
  }
}

export const naviBarSettingsDataMgr = NaviBarSettingsDataMgr.getInstance();
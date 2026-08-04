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
import fs from '@ohos.file.fs';
import { configPolicy, systemParameterEnhance } from '@kit.BasicServicesKit';
import { GlobalContext, sSettingsUtil, AccessibilityManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import settings from '@ohos.settings';
import { CommonConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { floatingNavigationInfoMgr } from './FloatingNavigationInfoMgr';
import { common, Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'SCBGestureNavSetManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const SCB_GESTURE_NAV_SET_FILE_PATH = 'etc/scb_effect_config/gesture_navigation_setting.json';
const SETTINGS_ENABLE_SEARCH_ITEMS = 2;

interface ExtraType {
  itemList: string[];
}
interface MessageDataType {
  method: string;
  extra: ExtraType;
}
export interface GestureNavigationSet {
  sceneCode: string;
  supportFloatNavigation: string;
  supportFloatBall: string;
  backResponseRegionWidth: number;
  backTimeThreshold: number;
  backBezierThreshold: number;
  backDistanceThreshold: number;
  backMetaBallFollowingDampX: number;
  backMetaBallFollowingDampY: number;
  needBackExtrudeAnim: string;
  navBarLandscapeWindowWidthPercent: number;
  naviBarMarginBottom: number;
  controlVersion: string;
  sceneControlList: Array<SceneControl>;
}

export interface SceneControl {
  reminderSceneType: string;
  reminderType: number;
  remindPlace: string;
  reminderRule: ReminderRule;
}

export interface ReminderRule {
  count: number;
  frequency: string;
  times: number;
  maxCount: number;
}

/**
 * SCBGestureNavSetManager
 *
 * @since 2025-02-24
 */
export class SCBGestureNavSetManager {
  private navBarSet: GestureNavigationSet | undefined;
  private connectId: number = -1;
  private navBarSetOnes: Array<GestureNavigationSet> | undefined;

  /**
   * 获取手势导航相关CCM配置
   *
   * @returns 手势导航相关CCM配置
   */
  public getGestureNavigationSet(): GestureNavigationSet | undefined {
    return this.navBarSet;
  }

  /**
   * 手势导航配置参数初始化
   */
  public init(): void {
    log.showInfo('loadScbVisualEffectConfigs');
    try {
      this.loadScbVisualEffectConfigs();
      this.dealWithFloatingNavigation(true);
    } catch (err) {
      log.showError(`Error on load effects file, error ${err.message}`);
    }
  }

  // 加载CCM数据
  private loadScbVisualEffectConfigs(): void {
    let configFile: string | undefined = configPolicy.getOneCfgFileSync(SCB_GESTURE_NAV_SET_FILE_PATH);
    if (!configFile) {
      log.showWarn('Can not find effect json path');
      return;
    }
    if (!fs.accessSync(configFile)) {
      log.showWarn('Can not access effect json file');
      return;
    }
    const effectJsonText: string = fs.readTextSync(configFile);
    log.showInfo(`gestureNavigationSetText is ${effectJsonText}`);
    if (!effectJsonText) {
      log.showWarn('effectJsonText is empty');
      return;
    }
    this.navBarSetOnes = JSON.parse(effectJsonText) as Array<GestureNavigationSet>;
    for (let navBarSetOnesElement of this.navBarSetOnes) {
      if (navBarSetOnesElement.sceneCode === '0') {
        this.navBarSet = navBarSetOnesElement;
      }
    }
  }

  /**
   * 获取CCM配置解析的数据
   * @returns 解析的数据
   */
  public getGestureNavigationSetList(): Array<GestureNavigationSet> | undefined {
    return this.navBarSetOnes;
  }

  /**
   * CCM配置获取是否支持三键
   * @returns 是否支持三键
   */
  public isSupportFloatNavigation(): boolean {
    if (CheckEmptyUtils.isEmpty(this.navBarSet)) {
      log.showInfo('navBarSet isEmpty');
      this.loadScbVisualEffectConfigs();
    }
    log.showInfo(`supportFloatNavigation is ${this.navBarSet?.supportFloatNavigation}`);
    return this.navBarSet?.supportFloatNavigation !== 'false';
  }

  /**
   * 获取是否支持悬浮导航
   * @returns 是否支持悬浮导航
   */
  public isSupportFloatBall(): boolean {
    if (CheckEmptyUtils.isEmpty(this.navBarSet)) {
      log.showInfo('navBarSet isEmpty');
      this.loadScbVisualEffectConfigs();
    }
    log.showInfo(`isSupportFloatBall is ${this.navBarSet?.supportFloatBall}`);
    return this.navBarSet?.supportFloatBall === 'true';
  }

  /**
   * @param needUpdateSystemParameterEnhance
   *
   * 单窗口单屏，检验是否支持悬浮导航
   */
  public dealWithFloatingNavigation(needUpdateSystemParameterEnhance?: boolean): void {
    log.showInfo(`dealWithFloatingNavigation`);
    if (needUpdateSystemParameterEnhance) {
      this.checkSearchItems();
      if (SCBGestureNavSetMgr.isSupportFloatNavigation()) {
        log.showInfo(`supportFloatNavigation`);
        settings.setValueSync(GlobalContext.getContext(), CommonConstants.FLOATING_NAVIGATION_CCM_KEY,
          CommonConstants.SYSTEM_NAVIGATION_FLOATING, CommonConstants.NAV_SETTING_DOMAIN);
        floatingNavigationInfoMgr.init();
      } else {
        log.showInfo(`not supportFloatNavigation`);
        settings.setValueSync(GlobalContext.getContext(), CommonConstants.FLOATING_NAVIGATION_CCM_KEY,
          CommonConstants.SYSTEM_NAVIGATION_GESTURE, CommonConstants.NAV_SETTING_DOMAIN);
      }
      if (SCBGestureNavSetMgr.isSupportFloatBall()) {
        log.showInfo(`supportFloatBall`);
        settings.setValueSync(GlobalContext.getContext(), CommonConstants.FLOATING_NAVIGATION_BALL_CCM_KEY,
          CommonConstants.SYSTEM_NAVIGATION_FLOATING, CommonConstants.NAV_SETTING_DOMAIN);
        floatingNavigationInfoMgr.init();
      } else {
        log.showInfo(`not supportFloatBall`);
        settings.setValueSync(GlobalContext.getContext(), CommonConstants.FLOATING_NAVIGATION_BALL_CCM_KEY,
          CommonConstants.SYSTEM_NAVIGATION_GESTURE, CommonConstants.NAV_SETTING_DOMAIN);
      }
    }
    // 检查是否支持三键
    this.checkSupportThreeButton();
    // 检查是否支持悬浮球
    this.checkSupportFloatBall();
  }

  /**
   * 检查是否支持三键
   */
  public checkSupportThreeButton(): void {
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError(TAG, 'checkSupportThreeButton context is undefined or null');
      return;
    }
    if (!SCBGestureNavSetMgr.isSupportFloatNavigation()) {
      try {
        settings.setValueSync(context, CommonConstants.FLOATING_NAVIGATION_KEY,
          CommonConstants.SYSTEM_NAVIGATION_GESTURE, settings.domainName.USER_PROPERTY);
      } catch (e) {
        log.showError(TAG, `setValue is error ${e?.message}`);
      }
    }
  }

  /**
   * 检查是否支持悬浮球
   */
  public checkSupportFloatBall(): void {
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError(TAG, 'checkSupportFloatBall context is undefined or null');
      return;
    }
    let isThreeButtonOpen = settings.getValueSync(context, CommonConstants.FLOATING_NAVIGATION_KEY, '1',
      settings.domainName.USER_PROPERTY) === CommonConstants.SYSTEM_NAVIGATION_FLOATING;
    let isScreenReaderEnable = AccessibilityManager.getInstance().getIsAccessibilityMode();
    log.showInfo(`checkSupportFloatBall isScreenReaderEnable: ${isScreenReaderEnable}`);
    if (!SCBGestureNavSetMgr.isSupportFloatBall() || isScreenReaderEnable || isThreeButtonOpen) {
      // 不支持悬浮球关闭掉
      try {
        settings.setValue(context, 'floating_navigation_ball', '0', settings.domainName.USER_PROPERTY);
      } catch (e) {
        log.showError(TAG, `setValue is error ${e?.message}`);
      }
    }
  }

  /**
   * 历史三键用户场景，默认开启悬浮导航
   */
  public dealWithOldUserThreeKeysNavigation(): void {
    // 1:手势导航  非1:三键导航
    let oldNavigationType: string = '0';
    try {
      oldNavigationType =
        settings.getValueSync(GlobalContext.getContext() as Context, CommonConstants.OLD_NAVIGATION_TYPE_KEY, '0');
    } catch (error) {
      log.showError(`isThreeButtonUpgrade error message ${error}`);
    }
    log.showInfo(`oldNavigationType is ${oldNavigationType}`);
    if (oldNavigationType !== '1') {
      try {
        settings.setValueSync(GlobalContext.getContext(), CommonConstants.FLOATING_NAVIGATION_KEY,
          CommonConstants.SYSTEM_NAVIGATION_FLOATING, settings.domainName.USER_PROPERTY);
        log.showInfo(`setValue success`);
      } catch (e) {
        log.showError(`setValue is error ${e?.message}`);
      }
    }
  }

  /**
   * 是否需要搜索项
   */
  private checkSearchItems(): void {
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError('context is undefined or null');
      return;
    }
    try {
      let oldThreeCcmValue = settings.getValueSync(context, CommonConstants.FLOATING_NAVIGATION_CCM_KEY, '0',
        CommonConstants.NAV_SETTING_DOMAIN);
      // 上一次是否支持三键
      let oldThreeSupport: boolean = oldThreeCcmValue === CommonConstants.SYSTEM_NAVIGATION_FLOATING;
      // 当前是否支持三键
      let newThreeSupport: boolean = SCBGestureNavSetMgr.isSupportFloatNavigation();
      log.showInfo(`oldThreeSupport is: ${oldThreeSupport} newThreeSupport is: ${newThreeSupport}`);
      let needThree: boolean | undefined = undefined;
      if (oldThreeSupport !== newThreeSupport) {
        // 上次和当前不同， 根据当前是否支持三键，动态使能搜索项
        needThree = newThreeSupport;
      }

      let oldFloatBallCcmValue = settings.getValueSync(context, CommonConstants.FLOATING_NAVIGATION_BALL_CCM_KEY, '1',
        CommonConstants.NAV_SETTING_DOMAIN);
      // 上一次是否支持悬浮球
      let oldFloatBallSupport: boolean = oldFloatBallCcmValue === CommonConstants.SYSTEM_NAVIGATION_FLOATING;
      // 当前是否支持悬浮球
      let newFloatBallSupport: boolean = SCBGestureNavSetMgr.isSupportFloatBall();
      log.showInfo(`oldFloatBallSupport is: ${oldFloatBallSupport} newFloatBallSupport is: ${newFloatBallSupport}`);
      let needBall: boolean | undefined = undefined;
      if (oldFloatBallSupport !== newFloatBallSupport) {
        // 上次和当前不同， 根据当前是否支持三键，动态使能搜索项
        needBall = newFloatBallSupport;
      }
      this.changeSearchItems(needThree, needBall);

    } catch (err) {
      log.showError(`checkSearchItems, getValueSync err msg: ${err?.message}`);
    }
  }

  /**
   * 动态使能搜索项
   *
   * @param isThreeSupport 当前是否支持三键
   * @param isFloatBallSupport 当前是否支持悬浮球
   */
  public async changeSearchItems(isThreeSupport: boolean | undefined,
    isFloatBallSupport: boolean | undefined): Promise<void> {
    if (!isThreeSupport && !isFloatBallSupport) {
      log.showInfo(`no need changeSearchItems`);
      return;
    }
    const want: Want = {
      bundleName: 'com.ohos.settings',
      abilityName: 'SettingsExtService'
    };
    const options: common.ConnectOptions = {
      onConnect: async (elementName, proxy: rpc.RemoteObject): Promise<void> => {
        log.showInfo(`onConnect ${elementName.bundleName}
         isThreeSupport: ${isThreeSupport} isFloatBallSupport${isFloatBallSupport}`);
        await this.setThreeButtonSearchItem(isThreeSupport, proxy);
        await this.setFloatBallSearchItem(isFloatBallSupport, proxy);
        this.disconnectService();
      },
      onDisconnect: () => {
        log.showInfo(`onDisconnect`);
      },
      onFailed: (code) => {
        log.showInfo(`IDL Connect onFailed ${code}`);
      }
    };
    this.connectId = GlobalContext.getContext().connectServiceExtensionAbility(want, options);
  }

  private async setThreeButtonSearchItem(isThreeSupport: boolean | undefined,
    proxy: rpc.RemoteObject): Promise<void> {
    try {
      if (!isThreeSupport) {
        log.showInfo(`no need setThreeButtonSearchItem`);
        return;
      }
      const itemList: string[] = ['floating_three_button_navigation_new', 'more_settings'];
      const method: string = isThreeSupport ? 'enableSearchItems' : 'disableSearchItems';
      await this.sendMessageRequest(itemList, method, proxy);
    } catch (err) {
      log.showError(`setThreeButtonSearchItem fail, error ${err.message}`);
    }
  }

  private async setFloatBallSearchItem(isFloatBallSupport: boolean | undefined,
    proxy: rpc.RemoteObject): Promise<void> {
    try {
      if (!isFloatBallSupport) {
        log.showInfo(`no need setFloatBallSearchItem`);
        return;
      }
      const method: string = isFloatBallSupport ? 'enableSearchItems' : 'disableSearchItems';
      await this.sendMessageRequest(['floating_navigation_ball_name'], method, proxy);
    } catch (err) {
      log.showError(`setFloatBallSearchItem fail, error ${err.message}`);
    }
  }

  private async sendMessageRequest(itemList: string[], method: string, proxy: rpc.RemoteObject): Promise<void> {
    const option = new rpc.MessageOption();
    const data = new rpc.MessageSequence();
    const reply = new rpc.MessageSequence();
    const messageData: MessageDataType = {
      method,
      extra: { itemList }
    };
    data.writeString(JSON.stringify(messageData));
    try {
      await proxy?.sendMessageRequest(SETTINGS_ENABLE_SEARCH_ITEMS, data, reply, option);
      log.showInfo('RPC: sendMessageRequest ends, reclaim parcel');
    } catch (err) {
      log.showError(`setSearchItem fail, error ${err.message}`);
    } finally {
      data.reclaim();
      reply.reclaim();
    }
  }

  private disconnectService(): void {
    GlobalContext.getContext()?.disconnectServiceExtensionAbility(this.connectId).then(() => {
      log.showInfo('disconnect successd.');
    }).catch((error: BusinessError) => {
      log.showError(`disconnect failed. Error code: ${error.code}`);
    });
  }
}

// 单例
export let SCBGestureNavSetMgr: SCBGestureNavSetManager = SingletonHelper.getInstance(SCBGestureNavSetManager, TAG);
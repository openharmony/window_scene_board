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

import common from '@ohos.app.ability.common';
import dataShare from '@ohos.data.dataShare';
import Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@ohos.base';
import {
  LogDomain,
  LogHelper,
  SingletonHelper,
  // MemoryUtils
} from '@ohos/basicutils';
import {
  GlobalContext,
  PluginClickInfo,
  ConfigurationEvent,
  EventConstants,
  sEventManager,
  EvtBus
} from '@ohos/frameworkwrapper';
import { FASlotName } from '@ohos/commonconstants';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { DataShareUtils } from '@ohos/systemuicommon/src/main/ets/datasharemanager/DataShareUtils';
import Constants, { ScenarioModeData, CallMessage } from '../common/Constants';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import DropDownPanelManager  from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';

const TAG = 'Ctrl.ScenarioModeToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SET_ZEN_MODE = 2;
const SCENARIO_MODE_DEFAULT: string = '0';
const SCENARIO_ICON_DEFAULT: string = 'moon_fill';
const SCENARIO_LABEL_DEFAULT: string = '$string:DND_mode';
const FOCUS_MODE_ENABLE_DEFAULT: string = '0';
const INTELLIGENT_SCENE_ENABLE_REMINDER_FLAG: string = 'intelligent_scene_reminder_flag';
const MODE_NAME_EXCLUDE_LENGTH: number = 8;
const SET_MODE_DELAY: number = 300;
const MODE_TYPE_MAX_ID: number = 50;
const DISCONNECT_TIME: number = 3000;
const MAX_RETRIES: number = 5;
const RETRY_DELAY_TIME: number = 1000;
const UN_CHECKED: string = '0';
const CHECKED: string = '1';
const DEFAULT_SUB_PANEL_HEIGHT: number = 478;

export class ScenarioModeToggleController extends ToggleBaseViewModel {
  private mScenarioModeData: ScenarioModeData = new ScenarioModeData();
  private connectId: number = -1;
  private sceneChangeHelper?: dataShare.DataShareHelper;
  private openMode: string = SCENARIO_MODE_DEFAULT;
  private scenarioMode: string = SCENARIO_MODE_DEFAULT;
  private scenarioModeLabel: string = SCENARIO_LABEL_DEFAULT;
  private systemLanguage: string = '';
  private scenarioModeEventMgr = EvtBus.createEventManager();
  private proxy: rpc.IRemoteObject | undefined | null = null;
  private isLockScenarioMode: boolean = false;
  private defaultLabel: Resource = $r('app.string.control_center_complex_toggle_scenario_mode_title');
  private defaultIcon: Resource = $r('app.media.scenario_mode');
  private disconnectTimeoutId: number = -1;

  public openDetailPageFunc: (() => void) | undefined = () => {
    this.handleOnControlCenterWithScreenLockForUIE((): void => this.openScenarioModeSubPanel(), true);
  }

  constructor() {
    super();
    this.getViewData().label = this.defaultLabel;
    this.getViewData().icon = this.defaultIcon;
    this.onStart();
  }

  public static getInstance(): ScenarioModeToggleController {
    return SingletonHelper.getInstance(ScenarioModeToggleController, TAG);
  }

  public isPersist(): boolean {
    return true;
  }

  decorateStyle(style: ToggleStyle): ToggleStyle | undefined {
    style.toggleParam?.symbolEffect(new BounceSymbolEffect(EffectScope.LAYER, EffectDirection.UP));
    return style;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart')
    // 监听注册监听
    this.registerEvents();

    // 初始化情景模式状态
    this.updateScenarioModeChange();
  }

  updateIconAndLabel(): void {
    this.getViewData().icon = this.mScenarioModeData.isDefaultMode ? this.defaultIcon : $r(`sys.symbol.${this.mScenarioModeData.iconId}`);
    this.getViewData().label =
      this.mScenarioModeData.isDefaultMode ? this.defaultLabel : this.getToggleLabelText(this.scenarioModeLabel);
    this.getViewData().isSymbolIcon = this.mScenarioModeData.isDefaultMode ? false : true;
    this.getViewData().hideIconBackground = this.mScenarioModeData.isDefaultMode ? true : false;
  }

  async registerEvents() {
    this.initSceneChangeHelper();
    this.scenarioModeEventMgr.on(ConfigurationEvent, this.languageChangeListener);
    sEventManager.subscribe(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, this.disconnect);
  }

  private initSceneChangeHelper(): void {
    this.initDataShareHelper(Constants.OPERATE_SCENE_CHANGE, 0, (data) => {
      this.sceneChangeHelper = data;
      this.sceneChangeHelper?.on('dataChange', Constants.OPERATE_SCENE_CHANGE, () => {
        log.showInfo('onSceneChange');
        this.updateScenarioModeChange();
      });
      this.updateScenarioModeChange();
    });
  }

  private async initDataShareHelper(uri: string, retryTime: number,
    callback: (data: dataShare.DataShareHelper) => void): Promise<void> {
    // 超过最大重试次数
    if (retryTime >= MAX_RETRIES) {
      log.showError('Max retries reached. Unable to initialize DataShareHelper.');
      return;
    }

    try {
      await dataShare.createDataShareHelper(GlobalContext.getContext(), uri,
        {isProxy : true}).then((data: dataShare.DataShareHelper) => {
        log.showInfo(`initDataShareHelper success for URI: ${uri}`);
        callback(data);
      });
    } catch (err) {
      log.showError(`initDataShareHelper error code:${err?.code}, message:${err?.message}, Retrying time:${retryTime + 1}`);
      if (retryTime < MAX_RETRIES) {
        setTimeout(() => { this.initDataShareHelper(uri, retryTime + 1, callback); }, RETRY_DELAY_TIME);
      }
    }
  }

  /**
   * 是否有情景模式弹窗提醒
   */
  private isCheckedRemind(): boolean {
    const remindFlag =
      DataShareUtils.getSettingsSecureValueSync(INTELLIGENT_SCENE_ENABLE_REMINDER_FLAG, UN_CHECKED);
    log.showInfo('remindFlag: ' + remindFlag);
    return remindFlag === CHECKED;
  }

  public languageChangeListener = (event: ConfigurationEvent): void => {
    let newLanguage: string = event?.config?.language ?? this.systemLanguage;
    if (newLanguage !== this.systemLanguage) {
      this.systemLanguage = newLanguage;
      log.showInfo(`language changed to: ${this.systemLanguage}`);
      this.updateScenarioModeChange();
    }
  }

  private async updateScenarioModeChange(): Promise<void> {
    this.openMode = DataShareUtils.getSettingsSecureValueSync('focus_mode_profile', SCENARIO_MODE_DEFAULT);
    this.scenarioMode = DataShareUtils.getSettingsSecureValueSync('last_intelligent_scene_id', SCENARIO_MODE_DEFAULT);
    log.showInfo(`openMode:${this.openMode},  this.scenarioMode: ${this.scenarioMode}`);
    if (this.scenarioMode === SCENARIO_MODE_DEFAULT) {
      this.mScenarioModeData.isDefaultMode = true;
      this.updateIconAndLabel();
      return;
    }
    this.mScenarioModeData.isDefaultMode = false;
    this.getViewData().isOn = this.openMode === this.scenarioMode;
    this.scenarioModeLabel = DataShareUtils.getSettingsSecureValueSync('intelligent_scene_name', SCENARIO_LABEL_DEFAULT);
    this.mScenarioModeData.iconId = DataShareUtils.getSettingsSecureValueSync('intelligent_scene_icon', SCENARIO_ICON_DEFAULT);
    this.updateIconAndLabel();
    log.showInfo(`scenarioModeIcon: ${this.mScenarioModeData.iconId}`);
  }

  getToggleLabelText(modeName: string): string {
    if (Number(this.scenarioMode) > MODE_TYPE_MAX_ID) {
      return modeName;
    }
    let labelText: string = '';
    return labelText;
  }

  onStop(): void {
    log.showInfo('onStop');
    try {
      this.sceneChangeHelper?.off('dataChange', Constants.OPERATE_SCENE_CHANGE);
    } catch (err) {
      log.showError(`dataChange off failed, error message: ${err.message} `);
    };
    this.scenarioModeEventMgr.offAll();
    sEventManager.off(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, this.disconnect);
  }

  isAvailable(): boolean {
    return true;
  }

  handleOneClick(): void {
    log.showInfo(`handleClick start old status: ${this.getViewData()?.isOn}`);
    const oldValue: number = this.getViewData().symbolTriggerValue;
    this.getViewData().symbolTriggerValue = oldValue >= 100 ? 1 : oldValue + 1;
    if (this.mScenarioModeData.isDefaultMode) {
      this.handleOnControlCenterWithScreenLockForUIE((): void => this.openScenarioModeSubPanel(), true);
    } else {
      if (this.isLockScenarioMode) {
        return;
      } else {
        setTimeout(() => {
          log.showInfo('Timeout,  reset scenario mode status');
          this.isLockScenarioMode = false;
        }, SET_MODE_DELAY);
        this.isLockScenarioMode = true;
        this.handleOnControlCenterWithScreenLockForUIE((): void => {
          this.handleUpdateState();
          this.onQsPanelClick();
        });
      }
    }
  }

  handleUpdateState(): void {
    // 无弹窗时执行 UI First 逻辑
    if ((this.getViewData().isOn || this.isCheckedRemind())) {
      this.getViewData().isOn = !this.getViewData().isOn;
    }
  }

  private disconnect = (event: boolean): void => {
    log.showInfo('event:' + event);
    if (!this.proxy || !event) {
      return;
    }
    // 收起控制中心后延迟3s断开连接
    if (this.disconnectTimeoutId !== -1) {
      clearTimeout(this.disconnectTimeoutId);
      this.disconnectTimeoutId = -1;
    }
    this.disconnectTimeoutId = setTimeout(() => {
      try {
        GlobalContext.getContext().disconnectServiceExtensionAbility(this.connectId).then(() => {
          this.proxy = null;
          log.showInfo(`disconnect ${this.connectId} successd.`);
        }).catch((error: BusinessError) => {
          log.showError(`disconnect failed. Error code: ${error.code}`);
        });
      } catch (err) {
        log.showError(`destroy connection finally failed: ${err}`);
      }
      this.disconnectTimeoutId = -1;
    }, DISCONNECT_TIME);
  }

  private onQsPanelClick(): void {
    const option = new rpc.MessageOption();
    const data = new rpc.MessageSequence();
    const reply = new rpc.MessageSequence();
    try {
      const want: Want = {
        bundleName: 'com.ohos.intelligentscene',
        abilityName: 'IntelligentSceneServiceExtAbility'
      };
      const callMessage: CallMessage = { method: 'modeManualEnable', extra: { modeId: this.scenarioMode, openType: '1' } };
      const options: common.ConnectOptions = {
        onConnect: (elementName, proxy) => {
          log.showInfo(`onConnect ${elementName}`);
          this.proxy = proxy;
          data.writeInterfaceToken(proxy.getDescriptor());
          data.writeString(JSON.stringify(callMessage));
          proxy.sendMessageRequest(SET_ZEN_MODE, data, reply, option);
        },
        onDisconnect: (elementName) => {
          log.showInfo(`onDisconnect ${elementName}`);
          data.reclaim();
          reply.reclaim();
          this.proxy = null;
        },
        onFailed: (code) => {
          log.showError(`IDL Connect onFailed ${code}`);
          data.reclaim();
          reply.reclaim();
          this.proxy = null;
        }
      };

      if (this.proxy) {
        if (this.disconnectTimeoutId !== -1) {
          clearTimeout(this.disconnectTimeoutId);
          this.disconnectTimeoutId = -1;
        }
        data.writeInterfaceToken(this.proxy.getDescriptor());
        data.writeString(JSON.stringify(callMessage));
        this.proxy.sendMessageRequest(SET_ZEN_MODE, data, reply, option);
      } else {
        this.connectId = GlobalContext.getContext().connectServiceExtensionAbility(want, options);
      }
      log.showInfo(`connectId is: ${this.connectId}`);
    } catch (error) {
      log.showError('QsPanelClick error', error);
    }
  }

  openScenarioModeSubPanel(): void {
    log.showInfo('show scenario mode subpage');
    let windowHeight = DEFAULT_SUB_PANEL_HEIGHT;
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.SCENARIO_MODE, {
      clickType: 'window',
      bundleName: 'com.ohos.intelligentscene',
      abilityName: 'SceneControlUIExtAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: windowHeight
    } as PluginClickInfo);
  }
}